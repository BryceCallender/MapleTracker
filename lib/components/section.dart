import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:maple_daily_tracker/components/checkbox_section.dart';
import 'package:maple_daily_tracker/models/action-section.dart';
import 'package:maple_daily_tracker/providers/tracker.dart';
import 'package:provider/provider.dart';

class Section extends StatelessWidget {
  const Section({Key? key, required this.title, required this.characterId, required this.section})
      : super(key: key);

  final String title;
  final int characterId;
  final ActionSection section;

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return Consumer<TrackerModel>(
      builder: (context, tracker, child) {
        return trackerCard(textTheme, tracker);
      },
    );
  }

  Widget trackerCard(TextTheme textTheme, TrackerModel tracker) {
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
                      tracker.toggleSection(characterId, section.actionType);
                    },
                    icon: section.isActive
                        ? Icon(CupertinoIcons.eye_fill)
                        : Icon(CupertinoIcons.eye_slash_fill),
                ),
                Text(
                  title,
                  style: textTheme.bodyLarge,
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
                    type: section.actionType,
                    canAdd: true,
                    items: section.actionList.where((a) => !a.done).toList(),
                  ),
                  CheckboxSection(
                    label: "Finished",
                    type: section.actionType,
                    items: section.actionList.where((a) => a.done).toList(),
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
