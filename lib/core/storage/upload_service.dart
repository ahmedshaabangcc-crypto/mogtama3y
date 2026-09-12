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

  static Future<XFile?> pickImage({required ImageSource source}) {
    return _picker.pickImage(source: source, imageQuality: 85);
  }

  static Future<XFile?> pickVideo({required ImageSource source}) {
    return _picker.pickVideo(source: source);
  }

  static String _pathFor(String purpose, XFile file) {
    final userId = AuthService.currentUser!.id;
    final ext = file.name.contains('.') ? file.name.split('.').last : 'jpg';
    return '$userId/$purpose/${DateTime.now().millisecondsSinceEpoch}.$ext';
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
