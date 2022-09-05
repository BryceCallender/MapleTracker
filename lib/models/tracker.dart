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
            ActionType.daily: ActionSection(
              isActive: true,
              actionType: ActionType.daily,
              actions: [Maple.Action(name: 'VJ', order: 0, done: false)],
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
            ActionType.daily: ActionSection(
              isActive: false,
              actionType: ActionType.daily,
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

  bool get completion => _character.hasCompletedActions();

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

  void toggleSection(ActionType type, bool isActive) {
    var currentSection = character.sections[type];
    if (currentSection != null) {
      currentSection.isActive = isActive;
      notifyListeners();
    }
  }

  void resetAllProgress() {
    notifyListeners();
  }
}
