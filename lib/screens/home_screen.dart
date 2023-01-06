import 'package:flutter/material.dart';
import '../components/progress_report.dart';
import '../components/timing.dart';
import '../components/tracker_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: SizedBox.expand(
                    child: TrackerSection(),
                  ),
                ),
                Column(
                  children: [
                    Expanded(
                      child: Container(
                        height: double.infinity,
                        width: 275,
                        child: Timing(),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: double.infinity,
                        width: 275,
                        child: ProgressReport(),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
