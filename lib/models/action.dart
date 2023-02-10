import 'package:maple_daily_tracker/models/action-type.dart';

class Action {
  final int? id;
  String name;
  int order;
  bool done;
  bool? isTemp;
  DateTime? removalTime;
  DateTime createdOn;
  DateTime? updatedOn;
  final ActionType actionType;
  final int characterId;

  Action(
      {required this.id,
      required this.name,
      required this.order,
      required this.done,
      required this.createdOn,
      required this.actionType,
      required this.characterId,
      this.updatedOn,
      this.isTemp,
      this.removalTime});

  Action.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        order = json['order'],
        done = json['done'],
        isTemp = json['is_temp'],
        removalTime = json['removal_time'] == null
            ? null
            : DateTime.parse(json['removal_time']),
        createdOn = DateTime.parse(json['created']),
        updatedOn =
            json['updated'] == null ? null : DateTime.parse(json['updated']),
        actionType = ActionType.values[json['action_type']],
        characterId = json['character_id'];

  Map<String, dynamic> toMap() {
    var data = {
      'id': id,
      'name': name,
      'order': order,
      'done': done,
      'is_temp': isTemp,
      'removal_time': removalTime?.toIso8601String(),
      'created': createdOn.toIso8601String(),
      'updated': DateTime.now().toUtc().toIso8601String(),
      'action_type': actionType.index,
      'character_id': characterId
    };

    if (id == null) {
      data.remove('id');
    }

    return data;
  }

  Action copyWith({int? order, int? id, int? characterId}) {
    return Action(
        id: id ?? this.id,
        name: name,
        done: done,
        order: order ?? this.order,
        isTemp: isTemp,
        removalTime: removalTime,
        createdOn: createdOn,
        updatedOn: updatedOn,
        actionType: actionType,
        characterId: characterId ?? this.characterId,
    );
  }

  Action copyWithNoId({int? order, int? characterId}) {
    return Action(
      id: null,
      name: name,
      done: done,
      order: order ?? this.order,
      isTemp: isTemp,
      removalTime: removalTime,
      createdOn: createdOn,
      updatedOn: updatedOn,
      actionType: actionType,
      characterId: characterId ?? this.characterId,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is Action &&
          other.runtimeType == runtimeType &&
          other.name == name;

  @override
  int get hashCode => name.hashCode;
}
