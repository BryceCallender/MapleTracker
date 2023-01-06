import 'package:enum_to_string/enum_to_string.dart';

import 'action-section.dart';
import 'action-type.dart';

class Character {
  final String name;
  final int? order;
  final Map<ActionType, ActionSection> sections;

  Character({required this.name, this.order, required this.sections});

  @override
  int get hashCode => name.hashCode;

  @override
  bool operator ==(Object other) => other is Character && other.name == name;

  bool hasCompletedActions() {
    int completedSections = 0;
    int visibleSections = 0;

    for(var section in sections.values) {
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

  void resetSection(ActionType action) {
    sections[action]!.reset();
  }

  Character.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        order = json['order'],
        sections = toActionSections(json['sections']);

  Map<String, dynamic> toJson() => {
    'name': name,
    'order': order,
    'sections': convertSections()
  };

  Map<String, dynamic> convertSections () {
    Map<String, dynamic> map = {};

    sections.forEach((key, value) {
      map[key.name] = value.toJson();
    });

    return map;
  }

  static Map<ActionType, ActionSection> toActionSections (dynamic sections) {
    final mapTest = Map<String, dynamic>.from(sections);
    final mappedSections = Map<ActionType, ActionSection>();

    for (var section in mapTest.entries) {
      var actionType = EnumToString.fromString(ActionType.values, section.key);
      mappedSections[actionType!] = ActionSection.fromJson(Map<String, dynamic>.from(section.value));
    }

    return mappedSections;
  }
}