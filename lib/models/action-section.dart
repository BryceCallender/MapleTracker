import 'package:enum_to_string/enum_to_string.dart';
import 'package:maple_daily_tracker/models/action-type.dart';
import 'package:maple_daily_tracker/models/action.dart';

class ActionSection {
  bool isActive;
  ActionType actionType;
  Map<String, Action> actions;

  ActionSection({required this.isActive, required this.actionType, required this.actions});

  static ActionSection empty(ActionType actionType) {
    return ActionSection(
        isActive: true,
        actionType: actionType,
        actions: {}
    );
  }

  double percentage() {
    double done = 0;

    for (var action in actions.values) {
      if (action.done) {
        done++;
      }
    }

    return actions.length > 0 ? done / actions.length : 0;
  }

  void reset() {
    for(var action in actions.values) {
      action.done = false;
    }
  }

  ActionSection.fromJson(Map<String, dynamic> json)
      : isActive = json['isActive'],
        actionType = EnumToString.fromString(ActionType.values, json['actionType'])!,
        actions = toActions(json['actions']);

  Map<String, dynamic> toJson() => {
    'isActive': isActive,
    'actionType': actionType.name,
    'actions': convertActions()
  };

  Map<String, dynamic> convertActions () {
    Map<String, dynamic> map = {};

    actions.forEach((key, value) {
      map[key] = value.toJson();
    });

    return map;
  }

  static Map<String, Action> toActions (dynamic actions) {
    if (actions == null) {
      return {};
    }

    var mapTest = Map<String, dynamic>.from(actions);
    var mappedSections = Map<String, Action>();

    for (var section in mapTest.entries) {
      mappedSections[section.key] = Action.fromJson(Map<String, dynamic>.from(section.value));
    }

    return mappedSections;
  }
}