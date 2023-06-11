import 'package:maple_daily_tracker/models/character.dart';

extension CharacterUtils on Character {
  Character copyWith({
    int? id,
    String? name,
    int? order,
    String? subjectId,
    List<int>? hiddenSections
  }) {
    return Character(
      id: id ?? this.id,
      name: name ?? this.name,
      order: order ?? this.order,
      classId: this.classId,
      subjectId: subjectId ?? this.subjectId,
      createdOn: this.createdOn,
      hiddenSections: hiddenSections ?? this.hiddenSections,
      sections: this.sections
    );
  }
}