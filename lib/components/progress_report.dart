import 'package:flutter/material.dart';
import 'package:maple_daily_tracker/components/character_progress.dart';
import 'package:maple_daily_tracker/models/character.dart';
import 'package:maple_daily_tracker/providers/tracker.dart';
import 'package:provider/provider.dart';

class ProgressReport extends StatelessWidget {
  const ProgressReport({Key? key, required this.characters}) : super(key: key);

  final List<Character> characters;

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
                  for (var i = 0; i < characters.length; i++) ...[
                    CharacterProgress(character: characters[i], index: i,),
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
