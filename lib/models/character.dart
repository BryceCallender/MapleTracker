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

    for(var section in sections.values) {
      if (section.percentage() == 1.0) {
        completedSections++;
      }
    }

    return completedSections == sections.length;
  }
}