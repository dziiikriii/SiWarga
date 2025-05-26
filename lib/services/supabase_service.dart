import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static Future<String?> uploadImage(String filePath, String fileName) async {
    final supabase = Supabase.instance.client;
    final fileBytes = await File(filePath).readAsBytes();

    try {
      final response = await supabase.storage
          .from('foto-profil') // nama bucket
          .uploadBinary(
            fileName,
            fileBytes,
            fileOptions: FileOptions(upsert: true),
          );

      // Jika upload sukses, response berisi path file di bucket
      if (response.isNotEmpty) {
        // Dapatkan public url yang benar (akses .data)
        final publicUrlResponse = supabase.storage
            .from('foto-profil')
            .getPublicUrl(fileName);

        final publicUrl = publicUrlResponse;
        return publicUrl;
      } else {
        print('Upload gagal, response kosong');
        return null;
      }
    } catch (e) {
      print('Error upload image: $e');
      return null;
    }
  }
}
