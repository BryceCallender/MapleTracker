import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:maple_daily_tracker/models/character.dart';

import '../models/action-type.dart';
import '../models/action.dart' as Maple;

class TrackerModel extends ChangeNotifier {
  final List<Character> _characters = [];
  late Character _character;

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
    _character = character;
    notifyListeners();
  }

  void remove(Character character) {
    _characters.remove(character);

    //downshift if they are on the character they deleted
    if (_character == character && _characters.length > 0) {
      _character = _characters[_characters.length - 1];
    }

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
    actions[action.name] = action;
    notifyListeners();
  }

  void updateAction(ActionType type, Maple.Action action) {
    var currentSection = character.sections[type]!;
    var actions = currentSection.actions;
    var oldAction = actions.values.firstWhere((a) => a.name == action.name);
    actions[oldAction.name] = oldAction.copy(done: action.done);

    notifyListeners();
  }

  bool isNameAvailable(String name) {
    return _characters.where((c) => c.name == name).isEmpty;
  }

  bool isActionAvailable(String? name, ActionType type) {
    return _character.sections[type]?.actions.values.where((a) => a.name == name).isEmpty ?? true;
  }

  void clear () {
    _characters.clear();
  }

  void resetDailies() {
    for(var character in characters) {
      character.resetSection(ActionType.dailies);
    }
    notifyListeners();
  }

  void resetWeeklyBosses() {
    for(var character in characters) {
      character.resetSection(ActionType.weeklyBoss);
    }
    notifyListeners();
  }

  void resetWeeklyQuests() {
    for(var character in characters) {
      character.resetSection(ActionType.weeklyQuest);
    }
    notifyListeners();
  }

  void setActiveCharacter(int index) {
    _character = _characters[index];
    notifyListeners();
  }

  void subscribeToData() {
    // var uid = FirebaseAuth.instance.currentUser?.uid;
    // var charactersRef = FirebaseDatabase.instance.ref('users/$uid');
    // charactersRef.onValue.listen((DatabaseEvent event) {
    //   final map = Map<String, dynamic>.from(event.snapshot.value as Map<dynamic, dynamic>);
    //   for (var character in map.values) {
    //     final characterMap = Map<String, dynamic>.from(character);
    //     _characters.add(Character.fromJson(characterMap));
    //   }
    //   _character = _characters.first;
    // });
  }
}
