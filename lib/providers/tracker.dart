import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:maple_daily_tracker/constants.dart';
import 'package:maple_daily_tracker/mappers/mapper.dart';
import 'package:maple_daily_tracker/models/action-type.dart';
import 'package:maple_daily_tracker/models/character.dart';
import 'package:maple_daily_tracker/models/action.dart' as Maple;
import 'package:maple_daily_tracker/models/maple-class.dart';
import 'package:maple_daily_tracker/models/old-maple-tracker.dart' as OMT;
import 'package:maple_daily_tracker/models/profile.dart';
import 'package:maple_daily_tracker/models/user.dart';
import 'package:maple_daily_tracker/services/database_service.dart';
import 'package:collection/collection.dart';
import 'package:maple_daily_tracker/extensions/character_extensions.dart';

class TrackerModel extends ChangeNotifier {
  final List<Character> _characters = [];
  late DatabaseService dbService;
  User? user;
  Profile? profile;

  int _tabIndex = 0;
  late TabController _tabController;

  TrackerModel({required this.dbService});

  /// An unmodifiable view of the items in the cart.
  UnmodifiableListView<Character> get characters =>
      UnmodifiableListView(_characters);

  int get tabIndex => _tabIndex;
  Character get character => _characters[_tabIndex];

  Future<void> fetchUserInfo(String subject) async {
    user = User.fromJson(await dbService.fetchUser(subject));
    notifyListeners();
  }

  Future<void> fetchProfileInfo(String subject) async {
    profile = Profile.fromJson(await dbService.getProfile(subject));

    if (profile != null) {
      profile!.email = supabase.auth.currentUser!.email;
    }

    notifyListeners();
  }

  Future<List<Character>> getCharacters(String subject) async {
    return dbService.fetchCharacters(subject);
  }

  Stream<List<Character>> listenToCharacters(String subject) {
    return dbService.listenToCharacters().map((maps) {
      return maps.map((ch) {
        final character = Character.fromJson(ch);
        final existingCharacter = _characters
            .firstWhereOrNull((element) => element.id == character.id);

        if (existingCharacter != null) {
          existingCharacter.copyWith(
              name: character.name,
              hiddenSections: character.hiddenSections,
              order: character.order);
          existingCharacter.hideSections();
          return existingCharacter;
        }
        _characters.add(character);
        return character;
      }).toList();
    });
  }

  Stream<List<Maple.Action>> listenToActions(int characterId) {
    return dbService.listenToActions(characterId).map((maps) {
      notifyListeners();
      return maps.map((a) {
        final action = Maple.Action.fromJson(a);
        var character =
            _characters.where((c) => c.id == action.characterId).single;
        character.sections[action.actionType]?.addAction(action);
        return action;
      }).toList();
    });
  }

  void resetActions(String subject, ActionType actionType) async {
    await dbService.resetActions(subject, actionType.index);
  }

  void toggleAction(Maple.Action action) async {
    await dbService.updateAction(action);
    notifyListeners();
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
    notifyListeners();
  }

  Future<void> addCharacter(Character character, {List<Maple.Action>? actions}) async {
    final createdCharacter = Character.fromJson(await dbService.addCharacter(character));

    if (actions != null) {
      List<Maple.Action> newActions = [];
      actions.forEach((action) {
        newActions.add(action.copyWith(characterId: createdCharacter.id!));
      });

      await dbService.upsertActions(newActions);
    }
  }

  void upsertActions(List<Maple.Action> actions) async {
    var actionType = actions.first.actionType;
    var section = character.sections[actionType];
    var createdActions = await dbService.upsertActions(actions);

    createdActions.map((a) {
      var createdAction = Maple.Action.fromJson(a);
      section?.actions[createdAction.id!] = createdAction;
    });
  }

  void removeAction(Maple.Action action) async {
    var section = character.sections[action.actionType];
    await dbService.deleteAction(action.id!);
    section?.actions.remove(action.id!);
  }

  void removeCharacter(Character character) async {
    await dbService.deleteActions(character.id!);
    await dbService.deleteCharacter(character.id!);

    if (_tabController.index == _characters.length - 1) {
      _tabController.animateTo(_tabController.index - 1);
    }
    
    _characters.removeWhere((c) => c.id == character.id);
  }

  Future<void> saveResetTimes(String? subject) async {
    if (subject != null)
      await dbService.updateUserResetTimes(subject);
  }

  void setTabController(TabController tabController) {
    _tabController = tabController;
  }

  void changeCharacterOrder(int characterId, int otherCharacterId, int oldOrder, int newOrder) async {
    await dbService.updateCharacterOrder(characterId, otherCharacterId);
  }

  void changeTab(int index) {
    _tabController.animateTo(index);
  }

  void clear() {
    _characters.clear();
    user = null;
    profile = null;
  }

  void importFromOldSave(
      OMT.MapleTracker oldMapleTrackerData, List<MapleClass> classes) async {
    // Character saving
    final characters = oldMapleTrackerData.characters
        .mapIndexed(
            (index, character) => Mapper.toCharacter(character, classes[index]))
        .toList();

    var createdCharacters = await dbService.upsertCharacters(characters);
    var mappedCharacters =
        createdCharacters.map((ch) => Character.fromJson(ch)).toList();

    // Action saving
    var actions = mappedCharacters
        .mapIndexed((index, character) => Mapper.toActions(
            oldMapleTrackerData.characters[index], character.id!))
        .flattened
        .toList();

    await dbService.upsertActions(actions);

    notifyListeners();
  }

  void setProfileUrl(String url) {
    profile?.avatarUrl = url;
    notifyListeners();
  }
}
