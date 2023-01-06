import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:maple_daily_tracker/models/action-section.dart';
import 'package:maple_daily_tracker/providers/tracker.dart';
import 'package:provider/provider.dart';

import '../models/action-type.dart';
import '../models/character.dart';

class AddCharacterDialog extends StatefulWidget {
  const AddCharacterDialog({Key? key}) : super(key: key);

  @override
  State<AddCharacterDialog> createState() => _AddCharacterDialog();
}

class _AddCharacterDialog extends State<AddCharacterDialog> {
  TextEditingController _nameController = TextEditingController();
  int _currentStep = 0;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width * 0.50;
    var height = MediaQuery.of(context).size.height * 0.50;

    return AlertDialog(
      title: const Text('Add Character'),
      content: Container(
        height: height,
        width: width,
        child: Stepper(
          currentStep: _currentStep,
          onStepCancel: () {
            if (_currentStep > 0) {
              setState(() {
                _currentStep -= 1;
              });
            }
          },
          onStepContinue: () {
            if (_currentStep <= 0) {
              setState(() {
                _currentStep += 1;
              });
            }
          },
          onStepTapped: (int index) {
            setState(() {
              _currentStep = index;
            });
          },
          steps: [
            Step(
              title: const Text('Name the character'),
              content: Container(
                padding: EdgeInsets.all(8.0),
                alignment: Alignment.centerLeft,
                child: TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Character name'),
                ),
              ),
              isActive: _currentStep >= 0,
            ),
            Step(
              title: const Text('Details'),
              content: Container(
                padding: EdgeInsets.all(8.0),
                alignment: Alignment.centerLeft,
                child: Container(),
              ),
              isActive: _currentStep >= 1,
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            var tracker = Provider.of<TrackerModel>(context, listen: false);
            tracker.add(
              Character(
                name: _nameController.text.trim(),
                sections: {
                  ActionType.dailies: ActionSection.empty(ActionType.dailies),
                  ActionType.weeklyBoss: ActionSection.empty(ActionType.weeklyBoss),
                  ActionType.weeklyQuest: ActionSection.empty(ActionType.weeklyQuest)
                }
              ),
            );
            Navigator.of(context).pop();
          },
          child: const Text('Add'),
        )
      ],
    );
  }
}
