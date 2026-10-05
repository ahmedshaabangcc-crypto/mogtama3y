import 'dart:math';

import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../auth/auth_service.dart';

/// Real file/photo/video upload — see
/// backend/migrations/0027_storage_and_verification.sql. Every upload
/// lives under `{userId}/{purpose}/{filename}` in one of two buckets:
///  * public-photos — anyone can read (listings, lost & found).
///  * private-documents — only the uploader and a super_admin can ever
///    read it (ID cards, verification videos, shop-claim proof).
class UploadService {
  UploadService._();

  static SupabaseClient get _client => Supabase.instance.client;
  static final ImagePicker _picker = ImagePicker();
  static final _rand = Random();

  // Phone photos come in at 3–4 MB; shrinking them before upload keeps the
  // pages fast and the storage/bandwidth bill (Supabase free tier) small.
  static const _maxSide = 1280.0;
  static const _quality = 80;

  static Future<XFile?> pickImage({required ImageSource source}) {
    return _picker.pickImage(source: source, maxWidth: _maxSide, maxHeight: _maxSide, imageQuality: _quality);
  }

  /// Several photos from the gallery in one go (up to [limit]).
  static Future<List<XFile>> pickImages({int limit = 6}) async {
    final files = await _picker.pickMultiImage(maxWidth: _maxSide, maxHeight: _maxSide, imageQuality: _quality, limit: limit < 2 ? 2 : limit);
    return files.take(limit).toList();
  }

  static Future<XFile?> pickVideo({required ImageSource source}) {
    return _picker.pickVideo(source: source);
  }

  static String _pathFor(String purpose, XFile file) {
    final userId = AuthService.currentUser!.id;
    final ext = file.name.contains('.') ? file.name.split('.').last : 'jpg';
    // Random suffix: several photos uploaded together share a millisecond.
    return '$userId/$purpose/${DateTime.now().millisecondsSinceEpoch}_${_rand.nextInt(0x7fffffff).toRadixString(36)}.$ext';
  }

  /// Uploads to the public bucket and returns a directly-loadable URL.
  static Future<String> uploadPublicPhoto({required String purpose, required XFile file}) async {
    if (AuthService.currentUser == null) throw Exception('يجب تسجيل الدخول أولاً');
    final path = _pathFor(purpose, file);
    final bytes = await file.readAsBytes();
    await _client.storage.from('public-photos').uploadBinary(path, bytes, fileOptions: const FileOptions(upsert: true));
    return _client.storage.from('public-photos').getPublicUrl(path);
  }

  /// Uploads to the private bucket and returns the storage PATH (not a
  /// public URL) — resolve it to something viewable with
  /// [createPrivateSignedUrl] only when the viewer is authorized.
  static Future<String> uploadPrivateDocument({required String purpose, required XFile file}) async {
    if (AuthService.currentUser == null) throw Exception('يجب تسجيل الدخول أولاً');
    final path = _pathFor(purpose, file);
    final bytes = await file.readAsBytes();
    await _client.storage.from('private-documents').uploadBinary(path, bytes, fileOptions: const FileOptions(upsert: true));
    return path;
  }

  static Future<String> createPrivateSignedUrl(String path, {int expiresInSeconds = 3600}) {
    return _client.storage.from('private-documents').createSignedUrl(path, expiresInSeconds);
  }
}
