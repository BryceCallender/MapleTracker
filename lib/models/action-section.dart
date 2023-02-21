import 'package:maple_daily_tracker/models/action-type.dart';
import 'package:maple_daily_tracker/models/action.dart';

class ActionSection {
  bool isActive;
  ActionType actionType;
  Map<int, Action> actions;
  double? completionPercentage;

  List<Action> get actionList => actions.values.toList();

  ActionSection({required this.isActive, required this.actionType, required this.actions});

  static ActionSection empty(ActionType actionType, { bool isHidden = false }) {
    return ActionSection(
        isActive: !isHidden,
        actionType: actionType,
        actions: {}
    );
  }

  void addAction(Action action) {
    actions[action.id!] = action;
  }

  double percentage() {
    if (actionList.isEmpty && completionPercentage != null) {
      return completionPercentage!;
    }

    double done = 0;

    for (var action in actionList) {
      if (action.done) {
        done++;
      }
    }

    return actions.length > 0 ? done / actions.length : 0;
  }
}