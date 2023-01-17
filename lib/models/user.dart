class User {
  final String userId;
  final DateTime createdOn;
  final DateTime? updatedOn;
  final DateTime? nextDailyReset;
  final DateTime? nextWeeklyBossReset;
  final DateTime? nextWeeklyQuestReset;

  User(
      {required this.userId,
      required this.createdOn,
      required this.updatedOn,
      required this.nextDailyReset,
      required this.nextWeeklyBossReset,
      required this.nextWeeklyQuestReset});

  User.fromJson(Map<String, dynamic> json)
      : userId = json['id'],
        createdOn = DateTime.parse(json['created']),
        updatedOn =
            json['updated'] == null ? null : DateTime.parse(json['updated']),
        nextDailyReset = json['next_daily_reset'] == null
            ? null
            : DateTime.parse(json['next_daily_reset']),
        nextWeeklyBossReset = json['next_weekly_boss_reset'] == null
            ? null
            : DateTime.parse(json['next_weekly_boss_reset']),
        nextWeeklyQuestReset = json['next_weekly_quest_reset'] == null
            ? null
            : DateTime.parse(json['next_weekly_quest_reset']);
}
