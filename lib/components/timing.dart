import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:maple_daily_tracker/components/timer_text.dart';
import 'package:maple_daily_tracker/extensions/duration_extensions.dart';
import 'package:maple_daily_tracker/helpers/reset_helper.dart';

class Timing extends StatefulWidget {
  const Timing({Key? key}) : super(key: key);

  @override
  State<Timing> createState() => _TimingState();
}

class _TimingState extends State<Timing> {
  late DateTime utcNow;
  late Timer timer;

  @override
  void initState() {
    super.initState();

    utcNow = DateTime.now().toUtc();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        utcNow = DateTime.now().toUtc();
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
            Text(
              "Timing",
              style: Theme.of(context).textTheme.subtitle1,
            ),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
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
                      timerDisplay:
                          ResetHelper().calcResetTime().toDisplayFormat(),
                    ),
                    TimerText(
                        label: "Weekly Reset",
                      timerDisplay:
                      ResetHelper().calcWeeklyResetTime().toDisplayFormat(),
                    ),
                    TimerText(
                        label: "Monday Weekly Reset",
                      timerDisplay:
                      ResetHelper().calcWeeklyResetTime(resetDay: DateTime.monday).toDisplayFormat(),
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
