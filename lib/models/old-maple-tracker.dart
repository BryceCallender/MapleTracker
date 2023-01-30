import 'package:maple_daily_tracker/extensions/datetime_extensions.dart';

class MapleTracker {
  late List<Character> characters;
  late bool closedWelcome;
  DateTime? lastOpened;
  DateTime? nextDailyReset;
  DateTime? nextMonWeeklyReset;
  DateTime? nextWedWeeklyReset;

  MapleTracker({
    required this.characters,
    required this.closedWelcome,
    required this.lastOpened,
    required this.nextDailyReset,
    required this.nextMonWeeklyReset,
    required this.nextWedWeeklyReset});

  MapleTracker.fromJson(Map<String, dynamic> json) {
    closedWelcome = json['closedWelcome'];
    lastOpened = DateTimeUtils.parseQtTime(json['lastOpened']);
    nextDailyReset = DateTimeUtils.parseQtTime(json['nextDailyReset']);
    nextMonWeeklyReset = DateTimeUtils.parseQtTime(json['nextMonWeeklyReset']);
    nextWedWeeklyReset = DateTimeUtils.parseQtTime(json['nextWedWeeklyReset']);
    characters = [];

    if (json['characters'] != null) {
      json['characters'].forEach((v) {
        characters.add(Character.fromJson(v));
      });
    }
  }
}

class Character {
  late List<Action> dailies;
  late List<Action> monWeeklies;
  late List<Action> wedWeeklies;
  late String name;
  late int order;

  Character({
    required this.dailies,
    required this.monWeeklies,
    required this.wedWeeklies,
    required this.name,
    required this.order});

  Character.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    order = json['order'];
    dailies = [];
    monWeeklies = [];
    wedWeeklies = [];

    if (json['dailies'] != null) {
      json['dailies'].forEach((v) {
        dailies.add(Action.fromJson(v));
      });
    }
    if (json['monWeeklies'] != null) {
      json['monWeeklies'].forEach((v) {
        monWeeklies.add(Action.fromJson(v));
      });
    }

    if (json['wedWeeklies'] != null) {
      json['wedWeeklies'].forEach((v) {
        wedWeeklies.add(Action.fromJson(v));
      });
    }
  }
}

class Action {
  bool done;
  bool isTemporary;
  String name;
  int order;
  DateTime? removalTime;

  Action({
    required this.done,
    required this.isTemporary,
    required this.name,
    required this.order,
    required this.removalTime});

  Action.fromJson(Map<String,dynamic> json)
    : done = json['done'],
      isTemporary = json['isTemporary'],
      name = json['name'],
      order = json['order'],
      removalTime = DateTimeUtils.parseQtTime(json['removalTime']);
}


