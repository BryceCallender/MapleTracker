import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:maple_daily_tracker/models/action-type.dart';
import 'package:maple_daily_tracker/models/character.dart';
import 'package:maple_daily_tracker/models/action.dart' as Maple;
import 'package:maple_daily_tracker/services/database_service.dart';

class TrackerModel extends ChangeNotifier {
  final List<Character> _characters = [];
  late DatabaseService dbService;

  int _tabIndex = 0;
  late TabController _tabController;

  TrackerModel({required this.dbService});

  /// An unmodifiable view of the items in the cart.
  UnmodifiableListView<Character> get characters =>
      UnmodifiableListView(_characters);

  int get tabIndex => _tabIndex;

  Future<List<Character>> getCharacters(String subject) async {
    return dbService.fetchCharacters(subject);
  }

  Stream<List<Character>> listenToCharacters(String subject) {
    return dbService.listenToCharacters().map((maps) {
      _characters.clear();
      return maps.map((ch) {
        final character = Character.fromJson(ch);
        _characters.add(character);
        return character;
      }).toList();
    });
  }

  Stream<List<Maple.Action>> listenToActions(int characterId) {
    return dbService.listenToActions(characterId).map((maps) => maps.map((a) {
          final action = Maple.Action.fromJson(a);
          var character =
              _characters.where((c) => c.id == action.characterId).single;
          character.sections[action.actionType]?.addAction(action);
          return action;
        }).toList());
  }

  void resetActions(ActionType actionType) {
    _characters.forEach((character) async {
      var actions = character.sections[actionType]!.actionList;
      await dbService.resetActions(actions);
    });
  }

  void toggleAction(Maple.Action action) async {
    await dbService.updateAction(action);
  }

  void toggleSection(int characterId, ActionType type) async {
    var character = _characters.where((c) => c.id == characterId).single;
    var hiddenActions = character.hiddenSections;

    if (hiddenActions.contains(type.index)) {
      hiddenActions.remove(type.index);
    } else {
      hiddenActions.add(type.index);
    }

    await dbService.updateHiddenSections(
        characterId, hiddenActions.toSet().toList());
  }

  void saveResetTimes(String subject) async {
    await dbService.updateUserResetTimes(subject);
  }

  void setTabController(TabController tabController) {
    _tabController = tabController;
  }

  void changeTab(int index) {
    _tabController.animateTo(index);
  }
}
