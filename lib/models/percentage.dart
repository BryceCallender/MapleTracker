import 'package:maple_daily_tracker/models/action-type.dart';

class Percentage {
  final int id;
  final ActionType type;
  final num percentage;

  Percentage({required this.id, required this.type, required this.percentage});

  Percentage.fromJson(Map<String, dynamic> json):
      id = json['id'],
      type = ActionType.values[json['type']],
      percentage = json['percentage'] / 100.0;
}