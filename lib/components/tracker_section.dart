import 'package:flutter/material.dart';
import 'package:maple_daily_tracker/components/section.dart';
import 'package:maple_daily_tracker/components/section_header.dart';

class TrackerSection extends StatefulWidget {
  const TrackerSection({Key? key}) : super(key: key);

  @override
  State<TrackerSection> createState() => _TrackerSectionState();
}

class _TrackerSectionState extends State<TrackerSection> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: const [
          SectionHeader(),
          Section(title: "Dailies"),
          Section(title: "Weekly Bosses"),
          Section(title: "Weekly Quests")
        ],
      ),
    );
  }
}
