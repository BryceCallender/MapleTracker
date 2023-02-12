import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:maple_daily_tracker/styles.dart';

class LogoTyper extends StatelessWidget {
  const LogoTyper({Key? key}) : super(key: key);

  final List<String> _displayText = const [
    "dailies",
    "weekly bosses",
    "weekly quests"
  ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          "assets/logo/logo.png",
          width: size.width / 3.0,
          height: size.height / 3.0,
        ),
        SizedBox(height: Insets.lg,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Track your ",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(
              child: AnimatedTextKit(
                animatedTexts: _displayText
                    .map(
                      (text) => TypewriterAnimatedText(
                    text,
                    textStyle:
                    Theme.of(context).textTheme.headlineMedium,
                  ),
                )
                    .toList(),
                repeatForever: true,
                pause: const Duration(milliseconds: 2000),
              ),
            )
          ],
        ),
      ],
    );
  }
}
