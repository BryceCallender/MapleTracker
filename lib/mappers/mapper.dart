import 'package:maple_daily_tracker/constants.dart';
import 'package:maple_daily_tracker/models/action-section.dart';
import 'package:maple_daily_tracker/models/action-type.dart';
import 'package:maple_daily_tracker/models/action.dart';
import 'package:maple_daily_tracker/models/character.dart';
import 'package:maple_daily_tracker/models/maple-class.dart';
import 'package:maple_daily_tracker/models/old-maple-tracker.dart' as OMT;

class Mapper {
  static Character toCharacter(OMT.Character character, MapleClass classType) {
    return Character(
        id: null,
        name: character.name,
        order: character.order,
        classId: classType,
        createdOn: DateTime.now().toUtc(),
        hiddenSections: [],
        sections: {
          ActionType.dailies: ActionSection.empty(ActionType.dailies),
          ActionType.weeklyBoss: ActionSection.empty(ActionType.weeklyBoss),
          ActionType.weeklyQuest: ActionSection.empty(ActionType.weeklyQuest)
        },
        subjectId: supabase.auth.currentUser!.id);
  }

  static List<Action> toActions(OMT.Character character, int characterId) {
    return List.from(character.dailies
        .map((action) => toAction(action, ActionType.dailies, characterId)))
      ..addAll(character.monWeeklies.map(
          (action) => toAction(action, ActionType.weeklyQuest, characterId)))
      ..addAll(character.wedWeeklies.map(
          (action) => toAction(action, ActionType.weeklyBoss, characterId)));
  }

  static Action toAction(OMT.Action action, ActionType type, int characterId) {
    return Action(
        id: null,
        name: action.name,
        order: action.order,
        done: action.done,
        actionType: type,
        createdOn: DateTime.now().toUtc(),
        characterId: characterId,
    );
  }
}
