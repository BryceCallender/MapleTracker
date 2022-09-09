import 'package:flutter/material.dart';
import 'package:maple_daily_tracker/components/section.dart';
import 'package:maple_daily_tracker/components/section_header.dart';
import 'package:maple_daily_tracker/models/tracker.dart';
import 'package:provider/provider.dart';
import 'package:sticky_headers/sticky_headers.dart';

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

  bool _swipeIsInProgress = false;
  bool _tapIsBeingExecuted = false;
  int _selectedIndex = 1;
  int _prevIndex = 1;

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

    // _tabController.animation?.addListener(() {
    //   if (!_tapIsBeingExecuted &&
    //       !_swipeIsInProgress &&
    //       (_tabController.offset >= 0.5 || _tabController.offset <= -0.5)) {
    //     // detects if a swipe is being executed. limits set to 0.5 and -0.5 to make sure the swipe gesture triggered
    //     print("swipe detected");
    //     int newIndex = _tabController.offset > 0 ? _tabController.index + 1 : _tabController.index - 1;
    //     _swipeIsInProgress = true;
    //     _prevIndex = _selectedIndex;
    //     state.character = _characters[newIndex];
    //   } else {
    //     if (!_tapIsBeingExecuted &&
    //         _swipeIsInProgress &&
    //         ((_tabController.offset < 0.5 && _tabController.offset > 0) ||
    //             (_tabController.offset > -0.5 && _tabController.offset < 0))) {
    //       // detects if a swipe is being reversed. the
    //       print("swipe reverse detected");
    //       _swipeIsInProgress = false;
    //       state.character = _characters[_prevIndex];
    //     }
    //   }
    // });
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
                child: Consumer<TrackerModel>(
                  builder: (context, tracker, child) {
                    return TabBar(
                      controller: _tabController,
                      isScrollable: true,
                      tabs: _tabs,
                      onTap: (index) {
                        tracker.character = _characters[index];
                      },
                    );
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
                child: StickyHeader(
                  header: SectionHeader(),
                  content: Column(
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
              ),
            )
            .toList(),
      ),
    );
  }
}
