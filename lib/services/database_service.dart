import 'dart:typed_data';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

class DatabaseService {
  final SupabaseClient client;

  DatabaseService(this.client);

  Stream listenToCharacters() {
    return client.from("characters").stream(primaryKey: ['id']);
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
}
