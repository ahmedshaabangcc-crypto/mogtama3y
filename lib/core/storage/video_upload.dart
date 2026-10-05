import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Short report videos go to our VPS (dalil.mogtama3y.com/media/…) —
/// Supabase's free tier can't carry video. The server checks the user's
/// Supabase session, the type and the 25 MB limit (seo/dalil/server.mjs).
class VideoUpload {
  VideoUpload._();

  static const maxBytes = 25 * 1024 * 1024;
  static final _endpoint = Uri.parse('https://dalil.mogtama3y.com/media/upload');

  static Future<XFile?> pick() => ImagePicker().pickVideo(source: ImageSource.gallery, maxDuration: const Duration(seconds: 60));

  /// Uploads [file] and returns its public URL. Throws a message the user
  /// can read (Arabic) when the server refuses it.
  static Future<String> upload(XFile file) async {
    final size = await file.length();
    if (size > maxBytes) throw 'الفيديو أكبر من 25 ميجا — قصّره أو حط لينكه من تيك توك';
    final token = Supabase.instance.client.auth.currentSession?.accessToken;
    if (token == null) throw 'سجّل دخول الأول';
    final name = file.name.toLowerCase();
    final type = file.mimeType ??
        (name.endsWith('.webm') ? 'video/webm' : (name.endsWith('.mov') ? 'video/quicktime' : 'video/mp4'));
    final res = await http.post(
      _endpoint,
      headers: {'Authorization': 'Bearer $token', 'Content-Type': type},
      body: await file.readAsBytes(),
    );
    final body = res.body.isEmpty ? const {} : jsonDecode(res.body) as Map;
    if (res.statusCode != 200 || body['url'] is! String) throw (body['error'] as String?) ?? 'تعذر رفع الفيديو';
    return body['url'] as String;
  }
}
