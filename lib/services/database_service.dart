import 'dart:typed_data';
import 'package:flutter/material.dart' show Color;
import 'package:maple_daily_tracker/helpers/reset_helper.dart';
import 'package:maple_daily_tracker/models/action.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

import '../models/character.dart';

class DatabaseService {
  final SupabaseClient client;

  DatabaseService(this.client);

  String get uuid => client.auth.currentUser!.id;

  Stream<List<dynamic>> listenToCharacters() {
    return client
        .from("characters")
        .stream(primaryKey: ['id']).order("order", ascending: true);
  }

  Stream<List<dynamic>> listenToActions(int characterId) {
    return client
        .from("actions")
        .stream(primaryKey: ['id']).eq("character_id", characterId);
  }

  Stream<List<dynamic>> listenToUser() {
    return client.from("users").stream(primaryKey: ['id']).eq('id', uuid);
  }

  Future<Map<String, dynamic>> fetchUser() async {
    return await client.from("users").select().eq("id", uuid).single();
  }

  Future<Map<String, dynamic>> addCharacter(Character character) async {
    return await client
        .from("characters")
        .insert(character.toMap())
        .select()
        .single();
  }

  Future<void> updateUserTheme(
      {required Color primary, required Color secondary}) async {
    await client
        .from("users")
        .update({'primary': primary.value, 'secondary': secondary.value}).match(
            {'id': uuid});
  }

  Future<void> updateUserResetTimes() async {
    final dailyReset = ResetHelper.calcResetTime();
    final weeklyBossReset = ResetHelper.calcWeeklyResetTime();
    final weeklyQuestReset =
        ResetHelper.calcWeeklyResetTime(resetDay: DateTime.monday);

    await client.from("users").update({
      'updated': DateTime.now().toUtc().toIso8601String(),
      'next_daily_reset':
          zeroOutTime(DateTime.now().toUtc().add(dailyReset)).toIso8601String(),
      'next_weekly_boss_reset':
          zeroOutTime(DateTime.now().toUtc().add(weeklyBossReset))
              .toIso8601String(),
      'next_weekly_quest_reset':
          zeroOutTime(DateTime.now().toUtc().add(weeklyQuestReset))
              .toIso8601String()
    }).match({'id': uuid});
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
    return await client.from("actions").insert(action.toMap()).select();
  }

  Future<List<dynamic>> upsertActions(List<Action> actions) async {
    return await client
        .from("actions")
        .upsert(actions.map((a) => a.toMap()).toList())
        .select();
  }

  Future<List<dynamic>> upsertCharacters(List<Character> characters) async {
    return await client
        .from("characters")
        .upsert(characters.map((c) => c.toMap()).toList())
        .select();
  }

  Future<List<dynamic>> upsertCharactersOrder(
      List<Character> characters) async {
    return await client
        .from("characters")
        .upsert(characters.map((c) => c.toCompleteMap()).toList(),
            onConflict: 'id')
        .select();
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

  Future<void> deleteActions(int characterId) async {
    await client.from("actions").delete().match({'character_id': characterId});
  }

  Future<void> deleteActionList(List<int> actionIds) async {
    await client.from("actions").delete().in_('id', actionIds);
  }

  Future<void> resetActions(int actionType) async {
    await client.rpc("clear_actions_of_type",
        params: {'subject': uuid, 'action_type_id': actionType});
  }

  Future<List<dynamic>> getPercentages() async {
    return await client.rpc('calc_percentages', params: {'subject': uuid});
  }

  Future<Map<String, dynamic>> getProfile() async {
    return await client.from('profiles').select().eq('id', uuid).single()
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

  Future<List<Character>> fetchCharacters() async {
    final data = await client
        .from("characters")
        .select('*,actions(*)')
        .eq("subject_id", uuid)
        .order("order") as List<dynamic>;

    return data.map((character) => Character.fromJson(character)).toList();
  }
}
