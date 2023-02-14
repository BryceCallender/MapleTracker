import 'package:enum_to_string/enum_to_string.dart';
import 'package:maple_daily_tracker/models/maple-class.dart';

import 'action-section.dart';
import 'action-type.dart';

class Character {
  final int? id;
  final MapleClass? classId;
  final String name;
  final int? order;
  final DateTime createdOn;
  final String subjectId;
  final List<int> hiddenSections;
  Map<ActionType, ActionSection> sections;

  Character(
      {required this.id,
      this.classId,
      required this.name,
      required this.order,
      required this.createdOn,
      required this.subjectId,
      required this.hiddenSections,
      required this.sections});

  Character.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        classId = json['class_id'] == null
            ? null
            : MapleClass.values[json['class_id']],
        name = json['name'],
        order = json['order'],
        createdOn = DateTime.parse(json['created']),
        subjectId = json['subject_id'],
        hiddenSections = json['hidden_sections'] == null
            ? []
            : List<int>.from(json['hidden_sections']),
        sections = {} {
    sections = {
      ActionType.dailies: ActionSection.empty(ActionType.dailies,
          isHidden: hiddenSections.contains(ActionType.dailies.index)),
      ActionType.weeklyBoss: ActionSection.empty(ActionType.weeklyBoss,
          isHidden: hiddenSections.contains(ActionType.weeklyBoss.index)),
      ActionType.weeklyQuest: ActionSection.empty(ActionType.weeklyQuest,
          isHidden: hiddenSections.contains(ActionType.weeklyQuest.index))
    };
  }

  Map<String, dynamic> toMap() => {
        'name': name,
        'order': order,
        'class_id': classId == null ? null : classId!.index,
        'created': createdOn.toIso8601String(),
        'subject_id': subjectId,
        'hidden_sections': hiddenSections
      };

  void hideSections() {
    var actionTypes = ActionType.values;
    for (var i = 0; i < actionTypes.length; i++) {
      sections[actionTypes[i]]?.isActive =
          !hiddenSections.contains(actionTypes[i].index);
    }
  }

  bool hasCompletedActions() {
    int completedSections = 0;
    int visibleSections = 0;

    for (var section in sections.values) {
      if (!section.isActive) {
        continue;
      }

      visibleSections++;
      if (section.percentage() == 1.0) {
        completedSections++;
      }
    }

    return visibleSections > 0 && completedSections == visibleSections;
  }

  @override
  bool operator ==(Object other) =>
      other is Character &&
          other.runtimeType == runtimeType &&
          other.name == name;

  @override
  int get hashCode => name.hashCode;
}
