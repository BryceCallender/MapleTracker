import 'package:flutter/material.dart';

class User {
  final String userId;
  final DateTime createdOn;
  final DateTime? updatedOn;
  final DateTime? nextDailyReset;
  final DateTime? nextWeeklyBossReset;
  final DateTime? nextWeeklyQuestReset;
  final Color? primary;
  final Color? secondary;

  User(
      {required this.userId,
      required this.createdOn,
      required this.updatedOn,
      required this.nextDailyReset,
      required this.nextWeeklyBossReset,
      required this.nextWeeklyQuestReset,
      required this.primary,
      required this.secondary});

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
            : DateTime.parse(json['next_weekly_quest_reset']),
        primary = Color(json['primary']),
        secondary = Color(json['secondary']);

  User copyWith({Color? primary, Color? secondary, DateTime? nextDailyReset, DateTime? nextWeeklyBossReset, DateTime? nextWeeklyQuestReset }) {
    return User(
      userId: userId,
      createdOn: createdOn,
      updatedOn: updatedOn,
      nextDailyReset: nextDailyReset ?? this.nextDailyReset,
      nextWeeklyBossReset: nextWeeklyBossReset ?? this.nextWeeklyBossReset,
      nextWeeklyQuestReset: nextWeeklyQuestReset ?? this.nextWeeklyQuestReset,
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary
    );
  }
}
