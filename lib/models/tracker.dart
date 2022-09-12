import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:maple_daily_tracker/models/character.dart';

import 'action-section.dart';
import 'action-type.dart';
import 'action.dart' as Maple;

class TrackerModel extends ChangeNotifier {
  final List<Character> _characters = [];
  late Character _character;

  TrackerModel() {
    _characters.addAll(
      [
        Character(
          name: "Starcraft",
          sections: {
            ActionType.dailies: ActionSection(
              isActive: true,
              actionType: ActionType.dailies,
              actions: [
                Maple.Action(name: 'VJ', order: 0, done: false),
                Maple.Action(name: 'ChuChu', order: 1, done: true)
              ],
            ),
            ActionType.weeklyBoss: ActionSection(
              isActive: true,
              actionType: ActionType.weeklyBoss,
              actions: [],
            ),
            ActionType.weeklyQuest: ActionSection(
              isActive: false,
              actionType: ActionType.weeklyQuest,
              actions: [],
            )
          },
        ),
        Character(
          name: "Zephyr",
          sections: {
            ActionType.dailies: ActionSection(
              isActive: false,
              actionType: ActionType.dailies,
              actions: [],
            ),
            ActionType.weeklyBoss: ActionSection(
              isActive: true,
              actionType: ActionType.weeklyBoss,
              actions: [],
            ),
            ActionType.weeklyQuest: ActionSection(
              isActive: false,
              actionType: ActionType.weeklyQuest,
              actions: [],
            )
          },
        ),
      ],
    );

    _character = _characters.first;
  }

  Character get character => _character;
  set character(Character character) {
    _character = character;
    notifyListeners();
  }

  bool hasCompletedActions(Character character) {
    return character.hasCompletedActions();
  }

  /// An unmodifiable view of the items in the cart.
  UnmodifiableListView<Character> get characters =>
      UnmodifiableListView(_characters);

  void add(Character character) {
    _characters.add(character);
    notifyListeners();
  }

  void remove(Character character) {
    _characters.remove(character);
    notifyListeners();
  }

  void toggleSection(ActionType type) {
    var currentSection = character.sections[type]!;
    currentSection.isActive = !currentSection.isActive;
    notifyListeners();
  }

  void addAction(ActionType type, Maple.Action action) {
    var currentSection = character.sections[type]!;
    var actions = currentSection.actions;

    action.order = actions.length;
    actions.add(action);
    notifyListeners();
  }

  void updateAction(ActionType type, Maple.Action action) {
    var currentSection = character.sections[type]!;
    var actions = currentSection.actions;
    var oldAction = actions.firstWhere((a) => a.name == action.name);
    var replaceIndex = actions.indexOf(oldAction);
    actions[replaceIndex] = oldAction.copy(done: action.done);

    notifyListeners();
  }

  bool isNameAvailable(String name) {
    return _characters.where((c) => c.name == name).isEmpty;
  }
}
