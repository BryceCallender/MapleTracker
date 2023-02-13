import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:maple_daily_tracker/components/menubar.dart';
import 'package:maple_daily_tracker/components/progress_report.dart';
import 'package:maple_daily_tracker/components/timing.dart';
import 'package:maple_daily_tracker/components/tracker_section.dart';
import 'package:maple_daily_tracker/constants.dart';
import 'package:maple_daily_tracker/models/character.dart';
import 'package:maple_daily_tracker/providers/tracker.dart';
import 'package:maple_daily_tracker/screens/onboarding_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Stream<List<Character>>? _characters;
  late SharedPreferences prefs;
  bool hasOnboarded = false;

  @override
  void initState() {
    super.initState();
    fetchSharedPreferenceData();
    final tracker = Provider.of<TrackerModel>(context, listen: false);
    final subject = supabase.auth.currentUser!.id;
    tracker.fetchUserInfo(subject);
    _characters = tracker.listenToCharacters(subject);
  }

  void fetchSharedPreferenceData() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      hasOnboarded = prefs.getBool('onboarded') ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return !hasOnboarded
        ? OnboardingScreen(
            onFinish: () {
              setState(() {
                hasOnboarded = true;
              });
            },
          )
        : StreamBuilder<List<Character>>(
            stream: _characters,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: Menubar(),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: SizedBox.expand(
                                child: TrackerSection(
                                  characters: snapshot.data!,
                                ),
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
                                    child: ProgressReport(
                                      characters: snapshot.data!,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                return Center(
                  child: LoadingAnimationWidget.twoRotatingArc(
                    color: Colors.blueAccent,
                    size: size.height / 4.0,
                  ),
                );
              }
            },
          );
  }
}
