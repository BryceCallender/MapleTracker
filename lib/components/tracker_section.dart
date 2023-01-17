import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:maple_daily_tracker/components/character_actions.dart';
import 'package:maple_daily_tracker/components/confirmation_dialog.dart';
import 'package:maple_daily_tracker/components/section.dart';
import 'package:maple_daily_tracker/constants.dart';
import 'package:maple_daily_tracker/providers/tracker.dart';
import 'package:provider/provider.dart';

import '../models/action-type.dart';
import '../models/character.dart';
import 'add_character_dialog.dart';

class TrackerSection extends StatefulWidget {
  const TrackerSection({Key? key, required this.characters}) : super(key: key);

  final List<Character> characters;

  @override
  State<TrackerSection> createState() => _TrackerSectionState();
}

class _TrackerSectionState extends State<TrackerSection>
    with SingleTickerProviderStateMixin {
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
    var themeData = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        flexibleSpace: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: TabBar(
                  controller: _tabController,
                  indicatorColor: themeData.colorScheme.secondary,
                  isScrollable: true,
                  tabs: _buildTabs(widget.characters),
                ),
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
      body: TabBarView(
        controller: _tabController,
        children: widget.characters
            .map(
              (character) => SingleChildScrollView(
                child: CharacterActions(
                  characterId: character.id,
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

    // for (int i = 0; i < 5; i++) {
    //   characters?.add(characters[0]);
    // }

    for (var character in characters ?? []) {
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
                      //add char
                    },
                  ),
                );

                showDialog<void>(
                  context: context,
                  builder: (context) => ConfirmationDialog(
                    onAccept: () {
                      //remove char
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
