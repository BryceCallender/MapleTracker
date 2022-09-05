import 'package:flutter/material.dart';
import 'package:maple_daily_tracker/models/action-section.dart';
import 'package:maple_daily_tracker/models/action-type.dart';
import 'package:maple_daily_tracker/models/tracker.dart';
import 'package:provider/provider.dart';

class Section extends StatelessWidget {
  const Section({Key? key, required this.title, required this.type})
      : super(key: key);

  final String title;
  final ActionType type;

  @override
  Widget build(BuildContext context) {
    return Consumer<TrackerModel>(
      builder: (context, tracker, child) {
        var section = tracker.character.sections[type];
        return AnimatedSwitcher(
          duration: Duration(milliseconds: 500),
          child: section!.isActive
              ? trackerCard(section)
              : SizedBox(),
        );
      },
    );
  }

  Widget trackerCard(ActionSection section) {
    return Visibility(
      visible: section.isActive,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [],
              ),
            ],
          ),
        ),
      ),
    )
  }
}
