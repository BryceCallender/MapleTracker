import 'package:flutter/material.dart';
import 'package:maple_daily_tracker/components/checkbox_section.dart';
import 'package:maple_daily_tracker/components/custom_labeled_checkbox.dart';
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
        return AnimatedSwitcher(
          duration: Duration(milliseconds: 500),
          child:
              section!.isActive ? trackerCard(textTheme, section) : SizedBox(),
        );
      },
    );
  }

  Widget trackerCard(TextTheme textTheme, ActionSection section) {
    return Visibility(
      visible: section.isActive,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: textTheme.bodyText1,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CheckboxSection(
                    label: "Unfinished",
                    items: section.actions.where((a) => !a.done).toList(),
                  ),
                  CheckboxSection(
                    label: "Finished",
                    items: section.actions.where((a) => a.done).toList(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
