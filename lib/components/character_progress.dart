import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:maple_daily_tracker/components/stamp.dart';
import 'package:maple_daily_tracker/extensions/enum_extensions.dart';
import 'package:maple_daily_tracker/models/action-section.dart';
import 'package:maple_daily_tracker/models/tracker.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';

import '../models/action-type.dart';
import '../models/character.dart';

class CharacterProgress extends StatelessWidget {
  const CharacterProgress({Key? key, required this.character})
      : super(key: key);

  final double progressHeight = 20.0;
  final Character character;

  @override
  Widget build(BuildContext context) {
    final sections = character.sections;
    final color = Theme.of(context).colorScheme.secondary;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => print('Tapped'),
      child: Stack(
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
            ].animate()
              .fadeIn(),
          ),
          Consumer<TrackerModel>(
            builder: (context, tracker, child) {
              return Visibility(
                visible: tracker.hasCompletedActions(character),
                child: Positioned.fill(child: Stamp()),
              );
            },
          )
        ],
      ),
    );
  }

  Widget trackerProgress(ActionSection section, Color color) {
    var isVisible = section.isActive;
    var completePercentage = section.percentage();

    return AnimatedSwitcher(
      duration: Duration(milliseconds: 500),
      child: isVisible
          ? createProgressIndicator(
              section.actionType.toProperName(), completePercentage, color)
          : SizedBox(),
    );
  }

  Widget createProgressIndicator(String type, double percentage, Color color) {
    return LinearPercentIndicator(
      animation: true,
      animationDuration: 500,
      animateFromLastPercent: true,
      lineHeight: progressHeight,
      padding: EdgeInsets.zero,
      center: Text(
        type,
        style: TextStyle(
            color:
                color.computeLuminance() > 0.5 ? Colors.black : Colors.white),
      ),
      barRadius: Radius.circular(5),
      percent: percentage,
      progressColor: color,
    );
  }
}
