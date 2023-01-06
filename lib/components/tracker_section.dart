import 'package:flutter/material.dart';
import 'package:maple_daily_tracker/components/confirmation_dialog.dart';
import 'package:maple_daily_tracker/components/section.dart';
import 'package:maple_daily_tracker/providers/tracker.dart';
import 'package:provider/provider.dart';

import '../models/action-type.dart';
import '../models/character.dart';
import 'add_character_dialog.dart';

class TrackerSection extends StatefulWidget {
  const TrackerSection({Key? key}) : super(key: key);

  @override
  State<TrackerSection> createState() => _TrackerSectionState();
}

class _TrackerSectionState extends State<TrackerSection>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TrackerModel>(builder: (context, tracker, child) {
      var themeData = Theme.of(context);

      return DefaultTabController(
        initialIndex: 0,
        length: tracker.characters.length,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            flexibleSpace: TabBar(
              indicatorColor: themeData.colorScheme.secondary,
              isScrollable: true,
              tabs: _buildTabs(tracker),
              onTap: (index) {
                tracker.setActiveCharacter(index);
              },
            ),
            actions: [
              IconButton(
                onPressed: () => _dialogBuilder(context),
                icon: Icon(Icons.add),
              )
            ],
          ),
          body: TabBarView(
            children: tracker.characters
                .map(
                  (Character character) => SingleChildScrollView(
                    child: Column(
                      children: [
                        Section(
                          title: "Dailies",
                          type: ActionType.dailies,
                        ),
                        Section(
                          title: "Weekly Bosses",
                          type: ActionType.weeklyBoss,
                        ),
                        Section(
                          title: "Weekly Quests",
                          type: ActionType.weeklyQuest,
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      );
    });
  }

  List<Widget> _buildTabs(TrackerModel tracker) {
    var tabs = <Widget>[];

    for (var character in tracker.characters) {
      tabs.add(Tab(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(character.name),
            const SizedBox(
              width: 8.0,
            ),
            IconButton(
              onPressed: () {
                final snackBar = SnackBar(
                  content: Text('Removed ${character.name}'),
                  action: SnackBarAction(
                    label: 'Undo',
                    onPressed: () {
                      tracker.add(character);
                    },
                  ),
                );

                showDialog<void>(
                  context: context,
                  builder: (context) => ConfirmationDialog(
                    onAccept: () {
                      tracker.remove(character);
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
