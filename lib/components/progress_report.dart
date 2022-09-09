import 'package:flutter/material.dart';
import 'package:maple_daily_tracker/components/character_progress.dart';
import 'package:maple_daily_tracker/models/tracker.dart';
import 'package:provider/provider.dart';

class ProgressReport extends StatelessWidget {
  const ProgressReport({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Consumer<TrackerModel>(
            builder: (context, tracker, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var character in tracker.characters) ...[
                    CharacterProgress(character: character,),
                    SizedBox(height: 12.0,)
                  ]
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
