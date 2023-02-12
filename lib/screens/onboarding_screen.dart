import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:maple_daily_tracker/providers/theme_settings.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key, required this.onFinish}) : super(key: key);

  final Function onFinish;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final introductionPages = [
    PageViewModel(
      title: 'Welcome to the app!',
      body: 'This is used for tracking your maple dailies/weeklies. Check the following pages on how to use the app.',
      image: Padding(
        padding: const EdgeInsets.only(top: 32.0),
        child: Center(child: Image.asset("assets/logo/logo.png")),
      ),
    ),
    PageViewModel(
      title: 'Adding a Character',
      image: const Center(
        child: Icon(Icons.person_add, size: 175.0),
      ),
      bodyWidget: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text("Click on "),
          Icon(Icons.add),
          Text(
              " in the tab bar to create a character. You can pick its class and if you want to copy actions from an existing character."),
        ],
      ),
    ),
    PageViewModel(
      title: 'Adding an action to track',
      image: const Center(
        child: Icon(Icons.add_task, size: 175.0),
      ),
      bodyWidget: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text("Click on "),
          Icon(Icons.add),
          Text(
              " in the appropriate section you wish to create the action. You can create permanent actions or temporary ones."),
        ],
      ),
    ),
    PageViewModel(
        title: 'Importing from old tracker',
        image: const Center(
          child: Icon(Icons.import_contacts, size: 175.0),
        ),
        body:
            'Since this is a rewrite of a previous app you can import old data!\nUsing the menubar go to File -> Import. Select the SaveData.json file from the old tracker. Go through each character and selects its class to get the new improved tabs.')
  ];

  @override
  Widget build(BuildContext context) {
    ThemeSettings themeSettings = context.read<ThemeSettings>();
    return IntroductionScreen(
      pages: introductionPages,
      showSkipButton: true,
      next: const Text("Next"),
      skip: const Text("Skip"),
      done: const Text("Done"),
      onSkip: onOnboardingFinish,
      onDone: onOnboardingFinish,
      dotsDecorator: DotsDecorator(
        size: const Size.square(10.0),
        activeSize: const Size(20.0, 10.0),
        activeColor: themeSettings.secondary,
        color: Colors.white,
        spacing: const EdgeInsets.symmetric(horizontal: 3.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
      ),
    );
  }

  void onOnboardingFinish() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarded', true);
    widget.onFinish();
  }
}
