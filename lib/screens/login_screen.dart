import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:maple_daily_tracker/screens/home_screen.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  final List<String> _displayText = const [
    "dailies",
    "weekly bosses",
    "weekly quests"
  ];

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<User?>(context);
    bool isLoggedIn = user != null;

    if (isLoggedIn) {
      return HomeScreen();
    }

    return Center(
      child: Container(
        child: SignInScreen(
          sideBuilder: (context, constraints) {
            return Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/logo/logo.png",
                    width: constraints.maxWidth / 2,
                    height: constraints.maxHeight / 2,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Track your ", style: Theme.of(context).textTheme.headlineMedium,),
                      SizedBox(
                        child: AnimatedTextKit(
                          animatedTexts: _displayText
                              .map(
                                (text) => TypewriterAnimatedText(
                              text,
                              textStyle: Theme.of(context).textTheme.headlineMedium,
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
              )
            );
          },
          providerConfigs: [EmailProviderConfiguration()],
        ),
      ),
    );
  }
}
