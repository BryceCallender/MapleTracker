import 'dart:io';
import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:maple_daily_tracker/components/preferences_dialog.dart';
import 'package:maple_daily_tracker/models/old-maple-tracker.dart' as OMT;
import 'package:maple_daily_tracker/components/import_characters_dialog.dart';

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

  @override
  void dispose() {
    _shortcutsEntry?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _platformMenuBar();
  }

  Widget _platformMenuBar() {
    if (Platform.isMacOS) {
      return PlatformMenuBar(
        menus: [
          PlatformMenu(
            label: "Maple Daily Tracker",
            menus: [
              if (PlatformProvidedMenuItem.hasMenu(
                  PlatformProvidedMenuItemType.about))
                const PlatformProvidedMenuItem(
                    type: PlatformProvidedMenuItemType.about),
              PlatformMenuItem(
                  label: 'Settings',
                  onSelected: () async {
                    _showSettingsDialog(context);
                  },
                  shortcut: const SingleActivator(LogicalKeyboardKey.comma,
                      meta: true)),
              if (PlatformProvidedMenuItem.hasMenu(
                  PlatformProvidedMenuItemType.quit))
                const PlatformProvidedMenuItem(
                    type: PlatformProvidedMenuItemType.quit),
            ],
          ),
          PlatformMenu(
            label: "File",
            menus: [
              PlatformMenuItem(
                label: 'Import',
                onSelected: importData,
                shortcut:
                    const SingleActivator(LogicalKeyboardKey.keyO, meta: true),
              )
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
    // (Re-)register the shortcuts with the ShortcutRegistry so that they are
    // available to the entire application, and update them if they've changed.
    _shortcutsEntry?.dispose();
    _shortcutsEntry =
        ShortcutRegistry.of(context).addAll(MenuEntry.shortcuts(result));
    return result;
  }

  void about() {
    showAboutDialog(
      context: context,
      applicationName: 'Maple Daily Tracker',
      applicationVersion: '1.0.0',
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
}
