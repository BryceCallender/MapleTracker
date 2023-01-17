import 'package:flutter/material.dart';
import 'package:maple_daily_tracker/models/action-type.dart';
import 'package:maple_daily_tracker/models/character.dart';
import 'package:maple_daily_tracker/models/action.dart' as Maple;
import 'package:maple_daily_tracker/models/user.dart';
import 'package:maple_daily_tracker/services/database_service.dart';
import 'package:collection/collection.dart';
import 'package:maple_daily_tracker/extensions/character_extensions.dart';

class TrackerModel extends ChangeNotifier {
  final List<Character> _characters = [];
  late DatabaseService dbService;
  User? user;

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

  Future<List<Character>> getCharacters(String subject) async {
    return dbService.fetchCharacters(subject);
  }

  Stream<List<Character>> listenToCharacters(String subject) {
    return dbService.listenToCharacters().map((maps) {
      return maps.map((ch) {
        final character = Character.fromJson(ch);
        final existingCharacter = _characters.firstWhereOrNull((element) => element.id == character.id);

        if (existingCharacter != null) {
          existingCharacter.copyWith(
            name: character.name,
            hiddenSections: character.hiddenSections,
            order: character.order
          );
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
  }

  void addAction(Maple.Action action) async {
    var section = character.sections[action.actionType];
    var createdAction = Maple.Action.fromJson(await dbService.addAction(action));
    section?.actions[action.name] = createdAction;
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
