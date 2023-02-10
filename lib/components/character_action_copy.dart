import 'package:flutter/material.dart';
import 'package:maple_daily_tracker/components/custom_labeled_checkbox.dart';
import 'package:maple_daily_tracker/models/action-section.dart';
import 'package:maple_daily_tracker/models/action-type.dart';
import 'package:maple_daily_tracker/models/character.dart';
import 'package:maple_daily_tracker/models/action.dart' as Maple;
import 'package:maple_daily_tracker/extensions/enum_extensions.dart';
import 'package:maple_daily_tracker/styles.dart';

class CharacterActionCopy extends StatefulWidget {
  const CharacterActionCopy(
      {Key? key,
      required this.character,
      required this.onAdd,
      required this.onRemove})
      : super(key: key);

  final Character character;
  final Function(List<Maple.Action>) onAdd;
  final Function(List<Maple.Action>) onRemove;

  @override
  _CharacterActionCopyState createState() => _CharacterActionCopyState();
}

class _CharacterActionCopyState extends State<CharacterActionCopy> {
  Map<ActionType, List<Maple.Action>> copyActions = {};

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${widget.character.name}\'s Actions',
            style: TextStyles.h2,
          ),
          const SizedBox(
            height: 8,
          ),
          for (ActionSection section in widget.character.sections.values)
            ExpansionTile(
              initiallyExpanded: true,
              title: Text(section.actionType.name.toTitleCase()),
              leading: Checkbox(
                value: getSectionTristate(section),
                onChanged: (value) => checkAllBySection(section, value),
                tristate: true,
              ),
              children: section.actionList
                  .map(
                    (action) => CustomLabeledCheckbox(
                      label: action.name,
                      value:
                          copyActions[section.actionType]?.contains(action) ??
                              false,
                      onChanged: (value) =>
                          checkAction(section.actionType, action, value),
                      checkboxType: CheckboxType.Child,
                    ),
                  )
                  .toList(),
            )
        ],
      ),
    );
  }

  void checkAllBySection(ActionSection section, bool? isChecked) {
    if (isChecked == null) {
      setState(() {
        widget.onRemove(section.actionList);
        copyActions.remove(section.actionType);
      });
      return;
    }

    if (!isChecked) {
      setState(() {
        widget.onRemove(section.actionList);
        copyActions.remove(section.actionType);
      });
      return;
    }

    setState(() {
      copyActions[section.actionType] = section.actionList;
      widget.onAdd(section.actionList);
    });
  }

  void checkAction(ActionType type, Maple.Action action, bool? isChecked) {
    if (isChecked == null) return;

    if (copyActions[type] == null) {
      copyActions[type] = [];
    }

    setState(() {
      if (isChecked) {
        Maple.Action addAction = action.copyWithNoId();
        copyActions[type]!.add(addAction);
        widget.onAdd([addAction]);
      } else {
        copyActions[type]!.remove(action);
        widget.onRemove([action]);
      }
    });
  }

  bool? getSectionTristate(ActionSection section) {
    if (!copyActions.containsKey(section.actionType) ||
        copyActions[section.actionType]!.length == 0) {
      return false;
    }

    if (copyActions[section.actionType]!.length != section.actions.length) {
      return null;
    }

    return true;
  }
}
