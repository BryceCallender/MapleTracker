import 'package:flutter/material.dart';

class TimerText extends StatelessWidget {
  const TimerText({Key? key, required this.label, required this.timerDisplay}) : super(key: key);

  final String label;
  final String timerDisplay;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 8.0),
        Text(timerDisplay),
      ],
    );
  }
}
