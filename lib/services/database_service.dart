import 'dart:typed_data';
import 'package:maple_daily_tracker/helpers/reset_helper.dart';
import 'package:maple_daily_tracker/models/action.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

import '../models/character.dart';

class DatabaseService {
  final SupabaseClient client;

  DatabaseService(this.client);

  Stream<List<dynamic>> listenToCharacters() {
    return client
        .from("characters")
        .stream(primaryKey: ['id']).order("order", ascending: true);
  }

  Stream<List<dynamic>> listenToActions(int characterId) {
    return client
        .from("actions")
        .stream(primaryKey: ['id'])
        .eq("character_id", characterId);
  }

  Future<Map<String, dynamic>> fetchUser(String subject) async {
    return await client.from("users").select().eq("id", subject).single();
  }

  Future<void> addCharacter(Character character) async {
    await client.from("characters").insert(character);
  }

  Future<void> updateUserResetTimes(String subject) async {
    final dailyReset = ResetHelper().calcResetTime();
    final weeklyBossReset = ResetHelper().calcWeeklyResetTime();
    final weeklyQuestReset =
        ResetHelper().calcWeeklyResetTime(resetDay: DateTime.monday);

    await client.from("users").update({
      'next_daily_reset':
          zeroOutTime(DateTime.now().toUtc().add(dailyReset)).toIso8601String(),
      'next_weekly_boss_reset':
          zeroOutTime(DateTime.now().toUtc().add(weeklyBossReset))
              .toIso8601String(),
      'next_weekly_quest_reset':
          zeroOutTime(DateTime.now().toUtc().add(weeklyQuestReset))
              .toIso8601String()
    }).match({'id': subject});
  }

  DateTime zeroOutTime(DateTime reset) {
    return DateTime(reset.year, reset.month, reset.day, 0, 0, 0);
  }

  Future<void> updateHiddenSections(
      int characterId, List<int>? hiddenSections) async {
    await client
        .from("characters")
        .update({'hidden_sections': hiddenSections}).match({'id': characterId});
  }

  Future<Map<String, dynamic>> addAction(Action action) async {
    return await client.from("actions").insert(action).select();
  }

  Future<void> updateAction(Action action) async {
    await client.from("actions").update({
      'name': action.name,
      'done': action.done,
      'updated': DateTime.now().toUtc().toIso8601String(),
      'order': action.order
    }).match({'id': action.id});
  }

  Future<void> deleteCharacter(int characterId) async {
    await client.from("characters").delete().match({'id': characterId});
  }

  Future<void> deleteAction(int actionId) async {
    await client.from("actions").delete().match({'id': actionId});
  }

  Future<void> resetActions(String subject, int actionType) async {
    await client.rpc("clear_actions_of_type", params: {
      'subject': subject,
      'action_type_id': actionType
    });
  }

  Future<Map<String, dynamic>> getProfile(String userId) async {
    return await client.from('profiles').select().eq('id', userId).single()
        as Map<String, dynamic>;
  }

  Future<void> upsertProfile(String userId, String? avatarUrl) async {
    await client.from('profiles').upsert({
      'id': userId,
      'avatar_url': avatarUrl,
    });
  }

  Future<void> uploadBinary(
      String fileName, Uint8List bytes, String? mimeType) async {
    await client.storage.from('avatars').uploadBinary(
          fileName,
          bytes,
          fileOptions: FileOptions(contentType: mimeType),
        );
  }

  Future<String> createdSignedImageUrl(String fileName) async {
    return await client.storage
        .from('avatars')
        .createSignedUrl(fileName, 60 * 60 * 24 * 365 * 10);
  }

  Future<List<Character>> fetchCharacters(String subject) async {
    final data = await client
        .from("characters")
        .select('*,actions(*)')
        .eq("subject_id", subject)
        .order("order") as List<dynamic>;

    return data.map((character) => Character.fromJson(character)).toList();
  }
}
