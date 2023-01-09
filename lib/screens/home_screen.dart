import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_window_close/flutter_window_close.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:maple_daily_tracker/components/progress_report.dart';
import 'package:maple_daily_tracker/components/timing.dart';
import 'package:maple_daily_tracker/components/tracker_section.dart';
import 'package:maple_daily_tracker/constants.dart';
import 'package:maple_daily_tracker/models/action-type.dart';
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
    _characters = tracker.listenToCharacters(supabase.auth.currentUser!.id);

    if (kIsWeb) {
      return;
    }

    FlutterWindowClose.setWindowShouldCloseHandler(() async {
      tracker.saveResetTimes(supabase.auth.currentUser!.id);
      return true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: StreamBuilder<List<Character>>(
        stream: _characters,
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: [
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
