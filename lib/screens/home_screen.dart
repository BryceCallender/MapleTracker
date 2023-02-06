import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_window_close/flutter_window_close.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:maple_daily_tracker/components/menubar.dart';
import 'package:maple_daily_tracker/components/progress_report.dart';
import 'package:maple_daily_tracker/components/timing.dart';
import 'package:maple_daily_tracker/components/tracker_section.dart';
import 'package:maple_daily_tracker/constants.dart';
import 'package:maple_daily_tracker/models/character.dart';
import 'package:maple_daily_tracker/providers/tracker.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Stream<List<Character>>? _characters;

  @override
  void initState() {
    super.initState();
    final tracker = Provider.of<TrackerModel>(context, listen: false);
    final subject = supabase.auth.currentUser!.id;
    tracker.fetchUserInfo(subject);
    _characters = tracker.listenToCharacters(subject);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: StreamBuilder<List<Character>>(
        stream: _characters,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: [
                Menubar(),
                Expanded(
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
              ],
            );
          } else {
            return LoadingAnimationWidget.twoRotatingArc(
              color: Colors.blueAccent,
              size: 50.0,
            );
          }
        },
      ),
    );
  }
}
