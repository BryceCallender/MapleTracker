import 'dart:io';
import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:maple_daily_tracker/components/preferences_dialog.dart';
import 'package:maple_daily_tracker/models/old-maple-tracker.dart' as OMT;
import 'package:maple_daily_tracker/components/import_characters_dialog.dart';
import 'package:maple_daily_tracker/models/profile.dart';
import 'package:maple_daily_tracker/providers/tracker.dart';
import 'package:maple_daily_tracker/services/authentication_service.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

class MenuEntry {
  const MenuEntry(
      {required this.label, this.shortcut, this.onPressed, this.menuChildren})
      : assert(menuChildren == null || onPressed == null,
            'onPressed is ignored if menuChildren are provided');
  final String label;

  final MenuSerializableShortcut? shortcut;
  final VoidCallback? onPressed;
  final List<MenuEntry>? menuChildren;

  static List<Widget> build(List<MenuEntry> selections) {
    Widget buildSelection(MenuEntry selection) {
      if (selection.menuChildren != null) {
        return SubmenuButton(
          menuChildren: MenuEntry.build(selection.menuChildren!),
          child: Text(selection.label),
        );
      }
      return MenuItemButton(
        shortcut: selection.shortcut,
        onPressed: selection.onPressed,
        child: Text(selection.label),
      );
    }

    return selections.map<Widget>(buildSelection).toList();
  }

  static Map<MenuSerializableShortcut, Intent> shortcuts(
      List<MenuEntry> selections) {
    final Map<MenuSerializableShortcut, Intent> result =
        <MenuSerializableShortcut, Intent>{};
    for (final MenuEntry selection in selections) {
      if (selection.menuChildren != null) {
        result.addAll(MenuEntry.shortcuts(selection.menuChildren!));
      } else {
        if (selection.shortcut != null && selection.onPressed != null) {
          result[selection.shortcut!] =
              VoidCallbackIntent(selection.onPressed!);
        }
      }
    }
    return result;
  }
}

class Menubar extends StatefulWidget {
  const Menubar({Key? key}) : super(key: key);

  @override
  _MenubarState createState() => _MenubarState();
}

class _MenubarState extends State<Menubar> {
  ShortcutRegistryEntry? _shortcutsEntry;
  String appVersion = '';
  Profile? profile;

  @override
  void initState() {
    super.initState();
    getAppVersion();
  }

  @override
  void dispose() {
    _shortcutsEntry?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    profile = context.watch<TrackerModel>().profile;
    return _platformMenuBar();
  }

  Widget _platformMenuBar() {
    if (Platform.isMacOS) {
      return PlatformMenuBar(
        menus: [
          PlatformMenu(
            label: "Maple Daily Tracker",
            menus: [
              PlatformMenuItemGroup(
                members: [
                  if (PlatformProvidedMenuItem.hasMenu(
                      PlatformProvidedMenuItemType.about))
                    const PlatformProvidedMenuItem(
                        type: PlatformProvidedMenuItemType.about),
                ],
              ),
              if (profile != null)
                PlatformMenuItemGroup(
                  members: [
                    PlatformMenuItem(
                      label: 'Settings',
                      onSelected: () async {
                        _showSettingsDialog(context);
                      },
                      shortcut: const SingleActivator(LogicalKeyboardKey.comma,
                          meta: true),
                    ),
                  ],
                ),
              PlatformMenuItemGroup(
                members: [
                  if (PlatformProvidedMenuItem.hasMenu(
                      PlatformProvidedMenuItemType.servicesSubmenu))
                    const PlatformProvidedMenuItem(
                        type: PlatformProvidedMenuItemType.servicesSubmenu),
                ],
              ),
              PlatformMenuItemGroup(
                members: [
                  if (PlatformProvidedMenuItem.hasMenu(
                      PlatformProvidedMenuItemType.hide))
                    const PlatformProvidedMenuItem(
                        type: PlatformProvidedMenuItemType.hide),
                  if (PlatformProvidedMenuItem.hasMenu(
                      PlatformProvidedMenuItemType.hideOtherApplications))
                    const PlatformProvidedMenuItem(
                        type:
                            PlatformProvidedMenuItemType.hideOtherApplications),
                  if (PlatformProvidedMenuItem.hasMenu(
                      PlatformProvidedMenuItemType.showAllApplications))
                    const PlatformProvidedMenuItem(
                        type: PlatformProvidedMenuItemType.showAllApplications),
                ],
              ),
              PlatformMenuItemGroup(members: [
                if (PlatformProvidedMenuItem.hasMenu(
                    PlatformProvidedMenuItemType.quit))
                  const PlatformProvidedMenuItem(
                      type: PlatformProvidedMenuItemType.quit),
              ]),
            ],
          ),
          if (profile != null)
            PlatformMenu(
              label: "File",
              menus: [
                PlatformMenuItem(
                  label: 'Import',
                  onSelected: importData,
                  shortcut: const SingleActivator(LogicalKeyboardKey.keyO,
                      meta: true),
                )
              ],
            ),
          PlatformMenu(
            label: 'View',
            menus: [
              PlatformMenuItemGroup(
                members: [
                  if (PlatformProvidedMenuItem.hasMenu(PlatformProvidedMenuItemType.toggleFullScreen))
                    const PlatformProvidedMenuItem(type: PlatformProvidedMenuItemType.toggleFullScreen),
                ],
              ),
            ],
          ),
          PlatformMenu(
            label: 'Window',
            menus: [
              PlatformMenuItemGroup(
                members: [
                  if (PlatformProvidedMenuItem.hasMenu(PlatformProvidedMenuItemType.minimizeWindow))
                    const PlatformProvidedMenuItem(type: PlatformProvidedMenuItemType.minimizeWindow),
                  if (PlatformProvidedMenuItem.hasMenu(PlatformProvidedMenuItemType.zoomWindow))
                    const PlatformProvidedMenuItem(type: PlatformProvidedMenuItemType.zoomWindow),
                ],
              ),
              PlatformMenuItemGroup(
                members: [
                  if (PlatformProvidedMenuItem.hasMenu(PlatformProvidedMenuItemType.arrangeWindowsInFront))
                    const PlatformProvidedMenuItem(type: PlatformProvidedMenuItemType.arrangeWindowsInFront),
                ],
              ),
            ],
          ),
        ],
      );
    }

    return MenuBar(
      children: MenuEntry.build(_getMenus()),
    );
  }

  List<MenuEntry> _getMenus() {
    final List<MenuEntry> result = <MenuEntry>[
      MenuEntry(
        label: 'File',
        menuChildren: <MenuEntry>[
          MenuEntry(label: 'About', onPressed: about),
          MenuEntry(
            label: 'Import',
            onPressed: importData,
            shortcut:
                const SingleActivator(LogicalKeyboardKey.keyO, control: true),
          ),
          MenuEntry(
            label: 'Settings',
            onPressed: () => _showSettingsDialog(context),
            // shortcut:
            //   const SingleActivator(LogicalKeyboardKey.keyS, )
          ),
          MenuEntry(label: 'Exit', onPressed: () => exit(0))
        ],
      ),
    ];
    _shortcutsEntry?.dispose();
    _shortcutsEntry =
        ShortcutRegistry.of(context).addAll(MenuEntry.shortcuts(result));
    return result;
  }

  void about() {
    showAboutDialog(
      context: context,
      applicationName: 'Maple Daily Tracker',
      applicationVersion: appVersion,
    );
  }

  void importData() async {
    var result = await FilePicker.platform.pickFiles(
      withData: true,
      type: FileType.custom,
      allowedExtensions: ['json'],
    );

    if (result != null) {
      var file = result.files.first;
      if (file.bytes?.isNotEmpty ?? false) {
        var content = utf8.decode(file.bytes!);
        var jsonData = jsonDecode(content);
        final oldTracker = OMT.MapleTracker.fromJson(jsonData);
        _showImportCharacterDialog(context, oldTracker);
      }
    }
  }

  Future<void> _showImportCharacterDialog(
      BuildContext context, OMT.MapleTracker tracker) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return ImportCharactersDialog(
          tracker: tracker,
        );
      },
    );
  }

  Future<void> _showSettingsDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return PreferencesDialog();
      },
    );
  }

  void getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      appVersion = packageInfo.version;
    });
  }
}
