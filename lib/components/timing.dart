import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:maple_daily_tracker/components/timer_text.dart';
import 'package:maple_daily_tracker/extensions/duration_extensions.dart';
import 'package:maple_daily_tracker/helpers/reset_helper.dart';
import 'package:maple_daily_tracker/models/action-type.dart';
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
  late bool resetFromOpen;

  Duration? dailyReset;
  Duration? weeklyBossReset;
  Duration? weeklyQuestReset;

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    resetFromOpen = false;

    var tracker = Provider.of<TrackerModel>(context, listen: false);
    checkUserResetTime(tracker);

    utcNow = DateTime.now().toUtc();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        utcNow = DateTime.now().toUtc();
        dailyReset = ResetHelper.calcResetTime();
        weeklyBossReset = ResetHelper.calcWeeklyResetTime();
        weeklyQuestReset =
            ResetHelper.calcWeeklyResetTime(resetDay: DateTime.monday);

        if (tracker.user == null)
          return;
        
        if (dailyReset! < Duration(seconds: 1)) {
          tracker.resetActions(tracker.user!.userId, ActionType.dailies);
        }

        if (weeklyBossReset! < Duration(seconds: 1)) {
          tracker.resetActions(tracker.user!.userId, ActionType.weeklyBoss);
        }

        if (weeklyQuestReset! < Duration(seconds: 1)) {
          tracker.resetActions(tracker.user!.userId, ActionType.weeklyQuest);
        }

        tracker.deleteTempActions();
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

  void checkUserResetTime(TrackerModel tracker) {
    var user = tracker.user;
    var now = DateTime.now().toUtc();

    if (user == null || resetFromOpen) {
      return;
    }

    if (user.nextDailyReset != null && now.isAfter(user.nextDailyReset!)) {
      tracker.resetActions(user.userId, ActionType.dailies);
    }

    if (user.nextWeeklyBossReset != null && now.isAfter(user.nextWeeklyBossReset!)) {
      tracker.resetActions(user.userId, ActionType.weeklyBoss);
    }

    if (user.nextWeeklyQuestReset != null && now.isAfter(user.nextWeeklyQuestReset!)) {
      tracker.resetActions(user.userId, ActionType.weeklyQuest);
    }

    resetFromOpen = true;
  }
}
