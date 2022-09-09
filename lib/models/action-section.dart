import 'package:maple_daily_tracker/models/action-type.dart';
import 'package:maple_daily_tracker/models/action.dart';

class ActionSection {
  bool isActive;
  ActionType actionType;
  List<Action> actions;

  ActionSection({required this.isActive, required this.actionType, required this.actions});

  double percentage() {
    double done = 0;

    for (var action in actions) {
      if (action.done) {
        done++;
      }
    }

    return actions.length > 0 ? done / actions.length : 0;
  }

  void reset() {
    for(var action in actions) {
      action.done = false;
    }
  }
}