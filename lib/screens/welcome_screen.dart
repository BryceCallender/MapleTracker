import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  final List<String> _displayText = const [
    "dailies",
    "weekly bosses",
    "weekly quests"
  ];

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/logo/logo.png",
              width: size.width * 0.50,
              height: size.height * 0.50,
            ),
            SizedBox(
              height: 32,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Track your ",
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                SizedBox(
                  width: 400,
                  child: AnimatedTextKit(
                    animatedTexts: _displayText
                        .map(
                          (text) => TypewriterAnimatedText(
                            text,
                            textStyle: Theme.of(context).textTheme.displaySmall,
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
        ),
      ),
    );
  }
}
