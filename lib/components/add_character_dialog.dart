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
import 'package:maple_daily_tracker/models/action.dart' as Maple;
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
  TextEditingController _characterController = TextEditingController();

  List<MapleClass> sortedClassTypes = [];
  MapleClass classType = MapleClass.None;
  Character? inheritCharacter;
  List<Maple.Action> inheritedActions = [];

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _classController.dispose();
    _characterController.dispose();
    super.dispose();
  }

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
      title: const Text('Create Character'),
      content: Container(
        height: height,
        width: width,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Character name'),
                  validator: (name) {
                    if (name == null || name.isEmpty) {
                      return 'Please enter a name';
                    }

                    return null;
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                DropdownMenu<MapleClass>(
                  initialSelection: MapleClass.None,
                  controller: _classController,
                  label: const Text('Class'),
                  menuHeight: height - 100.0,
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
                const SizedBox(
                  height: 16,
                ),
                DropdownMenu<Character?>(
                  initialSelection: null,
                  controller: _characterController,
                  label: const Text('Inherit From'),
                  dropdownMenuEntries: [
                    DropdownMenuEntry(value: null, label: "None")
                  ]..addAll(
                      context.watch<TrackerModel>().characters.map(
                            (c) => DropdownMenuEntry(value: c, label: c.name),
                          ).toList(),
                  ),
                  onSelected: (Character? character) {
                    setState(() {
                      inheritCharacter = character;
                    });
                  },
                ),
                if (inheritCharacter != null)
                  CharacterActionCopy(
                    character: inheritCharacter!,
                    onAdd: (actions) {
                      inheritedActions.addAll(actions);
                    },
                    onRemove: (actions) {
                      actions.forEach((action) {
                        inheritedActions.remove(action);
                      });
                    },
                  )
              ],
            ),
          ),
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
            if (_formKey.currentState!.validate()) {
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
                actions: inheritedActions
              );
              context.showSnackBar(
                  message: 'Added character ${_nameController.text}');
              Navigator.of(context).pop();
            }
          },
          child: const Text('Create'),
        )
      ],
    );
  }
}
