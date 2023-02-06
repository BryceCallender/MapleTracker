import 'package:flutter/material.dart';
import 'package:maple_daily_tracker/components/add_character_dialog.dart';
import 'package:maple_daily_tracker/components/character_actions.dart';
import 'package:maple_daily_tracker/components/confirmation_dialog.dart';
import 'package:maple_daily_tracker/extensions/snackbar_extensions.dart';
import 'package:reorderable_tabbar/reorderable_tabbar.dart';
import 'package:maple_daily_tracker/helpers/image_helper.dart';
import 'package:maple_daily_tracker/models/character.dart';
import 'package:maple_daily_tracker/models/old-maple-tracker.dart' as OMT;
import 'package:maple_daily_tracker/providers/tracker.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

class TrackerSection extends StatefulWidget {
  const TrackerSection({Key? key, required this.characters}) : super(key: key);

  final List<Character> characters;

  @override
  State<TrackerSection> createState() => _TrackerSectionState();
}

class _TrackerSectionState extends State<TrackerSection>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        initialIndex: 0, length: widget.characters.length, vsync: this);

    Provider.of<TrackerModel>(context, listen: false)
        .setTabController(_tabController);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var tracker = Provider.of<TrackerModel>(context);
    var characters = context.watch<TrackerModel>().characters;
    _tabController = TabController(
        initialIndex: _tabController.index,
        length: characters.length,
        vsync: this,
    );
    tracker.setTabController(_tabController);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        flexibleSpace: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: ReorderableTabBar(
                    controller: _tabController,
                    isScrollable: true,
                    tabs: _buildTabs(widget.characters),
                    tabBorderRadius: BorderRadius.circular(5.0),
                    onReorder: (oldIndex, newIndex) {
                      final tabCharacter = characters[oldIndex];
                      final swappingChar = characters[newIndex];
                      setState(() {
                        widget.characters.swap(oldIndex, newIndex);
                        tracker.changeCharacterOrder(tabCharacter.id!,
                            swappingChar.id!, oldIndex, newIndex);
                      });
                    }),
              ),
            ),
            Container(
              width: 50,
              height: 50,
              child: IconButton(
                onPressed: () => _dialogBuilder(context),
                icon: Icon(Icons.add),
              ),
            )
          ],
        ),
      ),
      body: widget.characters.isEmpty
          ? SizedBox.expand(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RichText(
                      text: TextSpan(
                          text: "Welcome to the Maple Tracker!\n",
                          children: [
                            TextSpan(
                                text: "It seems you have no characters!\n"),
                            TextSpan(text: "")
                          ]),
                    )
                  ]),
            )
          : TabBarView(
              controller: _tabController,
              children: widget.characters
                  .map(
                    (character) => SingleChildScrollView(
                      child: CharacterActions(
                        characterId: character.id!,
                        sections: character.sections,
                      ),
                    ),
                  )
                  .toList(),
            ),
    );
  }

  List<Widget> _buildTabs(List<Character>? characters) {
    var tabs = <Widget>[];

    for (var character in characters ?? <Character>[]) {
      final classImage = ImageHelper.classToImage(character.classId);
      tabs.add(Tab(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (classImage.isNotEmpty) ...[
              Image.asset(classImage),
              const SizedBox(
                width: 8.0,
              ),
            ],
            Text(character.name),
            const SizedBox(
              width: 8.0,
            ),
            IconButton(
              onPressed: () {
                showDialog<void>(
                  context: context,
                  builder: (context) => ConfirmationDialog(
                    onAccept: () {
                      //remove char
                      context.read<TrackerModel>().removeCharacter(character);
                      context.showSnackBar(
                          message: 'Removed ${character.name}');
                    },
                    onReject: () {},
                    removalText: character.name,
                  ),
                );
              },
              icon: Icon(Icons.close),
            )
          ],
        ),
      ));
    }

    return tabs;
  }

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AddCharacterDialog();
      },
    );
  }
}
