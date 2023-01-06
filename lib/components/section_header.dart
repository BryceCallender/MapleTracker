import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:maple_daily_tracker/extensions/color_extensions.dart';
import 'package:maple_daily_tracker/extensions/enum_extensions.dart';
import 'package:maple_daily_tracker/providers/tracker.dart';
import 'package:provider/provider.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var activeColor = colorScheme.secondary;
    var backgroundColor = colorScheme.background;

    return Container(
      padding: const EdgeInsets.all(8.0),
      color: colorScheme.background,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Consumer<TrackerModel>(
            builder: (context, tracker, child) {
              return Row(
                children: [
                  for (var section in tracker.character.sections.values) ...[
                    ActionChip(
                      avatar: stateToIcon(section.isActive, activeColor),
                      label: Text(
                        section.actionType.toProperName(),
                        style: TextStyle(
                          color:
                              (section.isActive ? activeColor : backgroundColor)
                                  .toLuminanceColor(),
                        ),
                      ),
                      backgroundColor: section.isActive ? activeColor : null,
                      onPressed: () {
                        tracker.toggleSection(section.actionType);
                      },
                    ),
                    SizedBox(
                      width: 4.0,
                    ),
                  ],
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Icon stateToIcon(bool isActive, Color activeColor) {
    IconData data =
        isActive ? CupertinoIcons.eye_fill : CupertinoIcons.eye_slash_fill;
    return Icon(
      data,
      color: isActive ? activeColor.toLuminanceColor() : Colors.white,
    );
  }
}
