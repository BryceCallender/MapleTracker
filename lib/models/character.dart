import 'package:maple_daily_tracker/models/action-section.dart';
import 'package:maple_daily_tracker/models/action-type.dart';

class Character {
  final String? name;
  final int? order;
  final Map<ActionType, ActionSection>? sections;

  Character({this.name, this.order, this.sections});
}