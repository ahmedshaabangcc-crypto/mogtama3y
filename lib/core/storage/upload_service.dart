import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../auth/auth_service.dart';
import '../demo/demo_mode.dart';
import '../demo/demo_platform.dart';
import '../demo/demo_store.dart';

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

  static String _pathFor(String purpose, String ext) {
    final userId = AuthService.currentUser!.id;
    // Random suffix: several photos uploaded together share a millisecond.
    return '$userId/$purpose/${DateTime.now().millisecondsSinceEpoch}_${_rand.nextInt(0x7fffffff).toRadixString(36)}.$ext';
  }

  /// The real type of [bytes] from its first bytes, as (mime, extension).
  /// The buckets only accept known types (0068), and the file name a phone
  /// hands over can be anything (".jfif", no extension, ".HEIC" holding a
  /// JPEG after resizing), so the name is never trusted.
  static (String, String)? _sniff(List<int> b) {
    bool at(int offset, List<int> sig) => b.length >= offset + sig.length && [for (var i = 0; i < sig.length; i++) b[offset + i] == sig[i]].every((x) => x);
    if (at(0, [0xFF, 0xD8, 0xFF])) return ('image/jpeg', 'jpg');
    if (at(0, [0x89, 0x50, 0x4E, 0x47])) return ('image/png', 'png');
    if (at(0, [0x52, 0x49, 0x46, 0x46]) && at(8, [0x57, 0x45, 0x42, 0x50])) return ('image/webp', 'webp');
    if (at(0, [0x25, 0x50, 0x44, 0x46])) return ('application/pdf', 'pdf');
    if (at(4, [0x66, 0x74, 0x79, 0x70])) {
      final brand = String.fromCharCodes(b.sublist(8, 12));
      if (brand.startsWith('heic') || brand.startsWith('heix') || brand.startsWith('mif1') || brand.startsWith('msf1')) return ('image/heic', 'heic');
      if (brand.startsWith('qt')) return ('video/quicktime', 'mov');
      return ('video/mp4', 'mp4');
    }
    return null;
  }

  static Future<(String, Uint8List, String)> _prepare(String purpose, XFile file) async {
    final bytes = await file.readAsBytes();
    final type = _sniff(bytes);
    if (type == null) throw Exception('نوع الملف ده مش مدعوم، جرّب صورة JPG أو PNG');
    return (_pathFor(purpose, type.$2), bytes, type.$1);
  }

  /// Uploads to the public bucket and returns a directly-loadable URL.
  static Future<String> uploadPublicPhoto({required String purpose, required XFile file}) async {
    if (AuthService.currentUser == null) throw Exception('يجب تسجيل الدخول أولاً');
    final (path, bytes, mime) = await _prepare(purpose, file);
    // Demo build: the photo never leaves the browser.
    if (kDemo) return 'data:$mime;base64,${base64Encode(bytes)}';
    await _client.storage.from('public-photos').uploadBinary(path, bytes, fileOptions: FileOptions(upsert: true, contentType: mime));
    return _client.storage.from('public-photos').getPublicUrl(path);
  }

  /// Uploads to the private bucket and returns the storage PATH (not a
  /// public URL) — resolve it to something viewable with
  /// [createPrivateSignedUrl] only when the viewer is authorized.
  static Future<String> uploadPrivateDocument({required String purpose, required XFile file}) async {
    if (AuthService.currentUser == null) throw Exception('يجب تسجيل الدخول أولاً');
    final (path, bytes, mime) = await _prepare(purpose, file);
    if (kDemo) {
      DemoStore.instance.files[path] = (bytes, mime);
      return path;
    }
    await _client.storage.from('private-documents').uploadBinary(path, bytes, fileOptions: FileOptions(upsert: true, contentType: mime));
    return path;
  }

  static Future<String> createPrivateSignedUrl(String path, {int expiresInSeconds = 3600}) async {
    if (kDemo) {
      final file = DemoStore.instance.files[path];
      if (file == null) throw Exception('الملف مش متاح في النسخة التجريبية');
      return demoBlobUrl(file.$1, file.$2);
    }
    return _client.storage.from('private-documents').createSignedUrl(path, expiresInSeconds);
  }
}
