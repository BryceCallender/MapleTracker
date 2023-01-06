import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:maple_daily_tracker/components/timer_text.dart';
import 'package:maple_daily_tracker/extensions/duration_extensions.dart';
import 'package:maple_daily_tracker/helpers/reset_helper.dart';
import 'package:maple_daily_tracker/providers/tracker.dart';
import 'package:provider/provider.dart';

class Timing extends StatefulWidget {
  const Timing({Key? key}) : super(key: key);

  @override
  State<Timing> createState() => _TimingState();
}

class _TimingState extends State<Timing> {
  late DateTime utcNow;
  late Timer timer;

  Duration? dailyReset;
  Duration? weeklyBossReset;
  Duration? weeklyQuestReset;

  @override
  void initState() {
    super.initState();

    var tracker = Provider.of<TrackerModel>(context, listen: false);

    utcNow = DateTime.now().toUtc();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        utcNow = DateTime.now().toUtc();
        dailyReset = ResetHelper().calcResetTime();
        weeklyBossReset = ResetHelper().calcWeeklyResetTime();
        weeklyQuestReset =
            ResetHelper().calcWeeklyResetTime(resetDay: DateTime.monday);

        if (dailyReset! <= Duration(seconds: 2)) {
          print('daily resetting!');
          tracker.resetDailies();
        }

        if (weeklyBossReset! <= Duration(seconds: 2)) {
          print('weekly bosses resetting!');
          tracker.resetWeeklyBosses();
        }

        if (weeklyQuestReset! <= Duration(seconds: 2)) {
          print('weekly quest resetting!');
          tracker.resetWeeklyQuests();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Text(
                "Timing",
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TimerText(
                        label: "Current Server Time",
                        timerDisplay:
                            DateFormat('EEE MMMM d hh:mm:ss a').format(utcNow)),
                    TimerText(
                      label: "Daily Reset",
                      timerDisplay: dailyReset.toDisplayFormat(),
                    ),
                    TimerText(
                      label: "Weekly Reset",
                      timerDisplay: weeklyBossReset.toDisplayFormat(),
                    ),
                    TimerText(
                      label: "Monday Weekly Reset",
                      timerDisplay: weeklyQuestReset.toDisplayFormat(),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
