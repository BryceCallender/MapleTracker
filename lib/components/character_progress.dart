import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:maple_daily_tracker/components/stamp.dart';
import 'package:maple_daily_tracker/extensions/enum_extensions.dart';
import 'package:maple_daily_tracker/models/action-section.dart';
import 'package:maple_daily_tracker/providers/tracker.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';

import '../models/action-type.dart';
import '../models/character.dart';

class CharacterProgress extends StatelessWidget {
  const CharacterProgress(
      {Key? key, required this.character, required this.index})
      : super(key: key);

  final int index;
  final double progressHeight = 20.0;
  final Character character;

  @override
  Widget build(BuildContext context) {
    final sections = character.sections;
    final color = Theme.of(context).colorScheme.secondary;
    final tracker = Provider.of<TrackerModel>(context);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => {tracker.changeTab(index)},
      child: Consumer<TrackerModel>(
        builder: (context, tracker, child) {
          return Stack(
            fit: StackFit.loose,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(character.name),
                  SizedBox(
                    height: 8.0,
                  ),
                  trackerProgress(
                    sections[ActionType.dailies]!,
                    color,
                  ),
                  SizedBox(
                    height: 6.0,
                  ),
                  trackerProgress(
                    sections[ActionType.weeklyBoss]!,
                    color,
                  ),
                  SizedBox(
                    height: 6.0,
                  ),
                  trackerProgress(
                    sections[ActionType.weeklyQuest]!,
                    color,
                  ),
                ].animate().fadeIn(),
              ),
              Visibility(
                visible: character.hasCompletedActions(),
                child: Positioned.fill(child: Stamp()),
              )
            ],
          );
        },
      ),
    );
  }

  Widget trackerProgress(ActionSection section, Color color) {
    var isVisible = section.isActive;
    var completePercentage = section.percentage();

    return createProgressIndicator(section.actionType.toProperName(),
        completePercentage, color, isVisible);
  }

  Widget createProgressIndicator(
      String type, double percentage, Color color, bool isVisible) {
    return LinearPercentIndicator(
      animation: true,
      animationDuration: 500,
      animateFromLastPercent: true,
      lineHeight: progressHeight,
      padding: EdgeInsets.zero,
      center: Text(
        type,
        style: TextStyle(
            decoration:
                isVisible ? TextDecoration.none : TextDecoration.lineThrough,
            color:
                color.computeLuminance() > 0.5 ? Colors.black : Colors.white),
      ),
      barRadius: Radius.circular(5),
      percent: percentage,
      progressColor: color,
    );
  }
}
