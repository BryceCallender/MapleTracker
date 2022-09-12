import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:maple_daily_tracker/components/checkbox_section.dart';
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
    var textTheme = Theme.of(context).textTheme;
    return Consumer<TrackerModel>(
      builder: (context, tracker, child) {
        var section = tracker.character.sections[type];
        return trackerCard(textTheme, tracker, section!);
      },
    );
  }

  Widget trackerCard(TextTheme textTheme, TrackerModel tracker, ActionSection section) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      tracker.toggleSection(section.actionType);
                    },
                    icon: section.isActive
                        ? Icon(CupertinoIcons.eye_fill)
                        : Icon(CupertinoIcons.eye_slash_fill),
                ),
                Text(
                  title,
                  style: textTheme.bodyText1,
                ),
              ],
            ),
            Visibility(
              visible: section.isActive,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CheckboxSection(
                    label: "Unfinished",
                    type: type,
                    canAdd: true,
                    items: section.actions.where((a) => !a.done).toList(),
                  ),
                  CheckboxSection(
                    label: "Finished",
                    type: type,
                    items: section.actions.where((a) => a.done).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
