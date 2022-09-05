import 'package:flutter/material.dart';
import 'package:maple_daily_tracker/components/section.dart';
import 'package:maple_daily_tracker/components/section_header.dart';
import 'package:maple_daily_tracker/models/tracker.dart';
import 'package:provider/provider.dart';

import '../models/action-type.dart';
import '../models/character.dart';

class TrackerSection extends StatefulWidget {
  const TrackerSection({Key? key}) : super(key: key);

  @override
  State<TrackerSection> createState() => _TrackerSectionState();
}

class _TrackerSectionState extends State<TrackerSection>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late List<Tab> _tabs = [];
  late List<Character> _characters = [];

  @override
  void initState() {
    super.initState();
    var state = Provider.of<TrackerModel>(context, listen: false);
    _characters = state.characters;
    _tabs = _characters
        .map((Character character) => Tab(
              text: character.name,
            ))
        .toList();
    _tabController = TabController(length: _characters.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        flexibleSpace: new Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  tabs: _tabs,
                  onTap: (index) {
                    var tracker = Provider.of<TrackerModel>(context, listen: false);
                    tracker.character = _characters[index];
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _characters
            .map(
              (Character character) => SingleChildScrollView(
                child: Column(
                  children: [
                    SectionHeader(),
                    Section(
                      title: "Dailies",
                      type: ActionType.daily,
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
    );
  }
}
