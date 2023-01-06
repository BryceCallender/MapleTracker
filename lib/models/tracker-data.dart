import 'package:maple_daily_tracker/models/character.dart';
import 'package:maple_daily_tracker/models/timer.dart';

class TrackerData {
  final Map<String, Character>? characters;
  final Timer? timer;

  TrackerData({this.characters, this.timer});
}