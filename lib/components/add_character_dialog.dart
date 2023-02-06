import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:maple_daily_tracker/components/character_action_copy.dart';
import 'package:maple_daily_tracker/extensions/snackbar_extensions.dart';
import 'package:maple_daily_tracker/extensions/enum_extensions.dart';
import 'package:maple_daily_tracker/models/action-section.dart';
import 'package:maple_daily_tracker/models/action-type.dart';
import 'package:maple_daily_tracker/models/character.dart';
import 'package:maple_daily_tracker/models/maple-class.dart';
import 'package:maple_daily_tracker/providers/tracker.dart';
import 'package:provider/provider.dart';

class AddCharacterDialog extends StatefulWidget {
  const AddCharacterDialog({Key? key}) : super(key: key);

  @override
  State<AddCharacterDialog> createState() => _AddCharacterDialog();
}

class _AddCharacterDialog extends State<AddCharacterDialog> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _classController = TextEditingController();
  List<MapleClass> sortedClassTypes = [];
  MapleClass classType = MapleClass.None;

  @override
  void initState() {
    super.initState();
    sortedClassTypes = List.from(MapleClass.values);
    sortedClassTypes.sort((MapleClass a, MapleClass b) {
      return a.name.compareTo(b.name);
    });

    sortedClassTypes.remove(MapleClass.None);
    sortedClassTypes.insert(0, MapleClass.None);
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width * 0.50;
    var height = MediaQuery.of(context).size.height * 0.50;

    return AlertDialog(
        title: const Text('Add Character'),
        content: Container(
          height: height,
          width: width,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Character name'),
              ),
              DropdownMenu<MapleClass>(
                initialSelection: MapleClass.None,
                controller: _classController,
                label: const Text('Class'),
                dropdownMenuEntries: sortedClassTypes
                    .map(
                      (value) => DropdownMenuEntry<MapleClass>(
                        value: value,
                        label: value.name,
                      ),
                    )
                    .toList(),
                onSelected: (MapleClass? pickedClass) {
                  setState(() {
                    classType = pickedClass!;
                  });
                },
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
          FilledButton(
            onPressed: () {
              var tracker = Provider.of<TrackerModel>(context, listen: false);
              tracker.addCharacter(
                Character(
                  id: null,
                  classId: classType,
                  subjectId: tracker.user!.userId,
                  name: _nameController.text.trim(),
                  order: tracker.characters.length,
                  createdOn: DateTime.now().toUtc(),
                  hiddenSections: [],
                  sections: {
                    ActionType.dailies: ActionSection.empty(ActionType.dailies),
                    ActionType.weeklyBoss:
                        ActionSection.empty(ActionType.weeklyBoss),
                    ActionType.weeklyQuest:
                        ActionSection.empty(ActionType.weeklyQuest)
                  },
                ),
              );
              context.showSnackBar(
                  message: 'Added character ${_nameController.text}');
              Navigator.of(context).pop();
            },
            child: const Text('Add'),
          )
        ],
    );
    //   child: Stepper(
    //     type: StepperType.horizontal,
    //     currentStep: _currentStep,
    //     onStepCancel: () {
    //       if (_currentStep > 0) {
    //         setState(() {
    //           _currentStep -= 1;
    //         });
    //       }
    //     },
    //     onStepContinue: () {
    //       if (_currentStep < 2) {
    //         setState(() {
    //           _currentStep += 1;
    //         });
    //       }
    //     },
    //     onStepTapped: (int index) {
    //       setState(() {
    //         _currentStep = index;
    //       });
    //     },
    //     steps: [
    //       Step(
    //         title: const Text('Name the character'),
    //         state: StepState.editing,
    //         content: Container(
    //           padding: EdgeInsets.all(8.0),
    //           alignment: Alignment.centerLeft,
    //           child: TextFormField(
    //             controller: _nameController,
    //             decoration: InputDecoration(labelText: 'Character name'),
    //           ),
    //         ),
    //         isActive: _currentStep >= 0,
    //       ),
    //       Step(
    //           title: const Text('Pick the class'),
    //           content: Container(
    //             padding: EdgeInsets.all(8.0),
    //             alignment: Alignment.centerLeft,
    //             child: DropdownButton<MapleClass>(
    //               value: classType,
    //               items: sortedClassTypes
    //                   .map<DropdownMenuItem<MapleClass>>((value) {
    //                 return DropdownMenuItem(
    //                   value: value,
    //                   child: Text(value.name),
    //                 );
    //               }).toList(),
    //               onChanged: (MapleClass? pickedClass) {
    //                 setState(() {
    //                   classType = pickedClass!;
    //                 });
    //               },
    //             ),
    //           ),
    //         isActive: _currentStep >= 1,
    //       ),
    //       Step(
    //         title: const Text('Details'),
    //         content: Container(
    //           padding: EdgeInsets.all(8.0),
    //           alignment: Alignment.centerLeft,
    //           child: Container(
    //             child: Column(
    //               children: [
    //                 CharacterActionCopy()
    //               ],
    //             ),
    //           ),
    //         ),
    //         isActive: _currentStep >= 2,
    //       ),
    //     ],
    //   ),
    // ),
    // actions: <Widget>[
    //   TextButton(
    //     onPressed: () {
    //       Navigator.of(context).pop();
    //     },
    //     child: const Text('Cancel'),
    //   ),
    //   FilledButton(
    //     onPressed: () {
    //       var tracker = Provider.of<TrackerModel>(context, listen: false);
    //       tracker.addCharacter(
    //         Character(
    //             id: null,
    //             classId: classType,
    //             subjectId: tracker.user!.userId,
    //             name: _nameController.text.trim(),
    //             order: tracker.characters.length,
    //             createdOn: DateTime.now().toUtc(),
    //             hiddenSections: [],
    //             sections: {
    //               ActionType.dailies: ActionSection.empty(ActionType.dailies),
    //               ActionType.weeklyBoss:
    //                   ActionSection.empty(ActionType.weeklyBoss),
    //               ActionType.weeklyQuest:
    //                   ActionSection.empty(ActionType.weeklyQuest)
    //             },
    //         ),
    //       );
    //       context.showSnackBar(
    //           message: 'Added character ${_nameController.text}');
    //       Navigator.of(context).pop();
    //     },
    //     child: const Text('Add'),
    //   )
    // ],
    // );
  }
}
