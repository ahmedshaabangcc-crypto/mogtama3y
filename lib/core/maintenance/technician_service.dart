import 'package:supabase_flutter/supabase_flutter.dart';

import '../auth/auth_service.dart';

/// Real technicians directory + escrow-backed maintenance bookings —
/// see backend/migrations/0022_technicians_maintenance.sql.
///
/// IMPORTANT: `maintenance_requests` only has a column-level GRANT on a
/// specific column list (handshake_otp is deliberately excluded, kept
/// secret from both sides except through the RPCs below). Postgres
/// expands a bare `select('*')` to every column and then fails the
/// whole query with a permission error if any one of them isn't
/// granted — so every select against this table below MUST list
/// columns explicitly, never `*`.
const _requestColumns = 'id, unit_id, resident_id, technician_id, category, description, status, '
    'quoted_amount, escrow_status, visit_scheduled_at, completed_at, created_at';

// technicians has a column-level GRANT that deliberately excludes
// id_card_url/verification_video_url (see
// backend/migrations/0027_storage_and_verification.sql) — a bare
// select('*') fails outright for the same reason maintenance_requests'
// does, so every select against this table lists columns explicitly.
const _technicianColumns = 'id, user_id, category, bio, rating, rating_count, is_verified, '
    'escrow_supported, service_area, created_at, verification_status';

class TechnicianService {
  TechnicianService._();

  static SupabaseClient get _client => Supabase.instance.client;

  static Future<List<Map<String, dynamic>>> fetchTechnicians({String? category}) async {
    var query = _client.from('technicians').select('$_technicianColumns, profile:profiles(full_name, phone)');
    if (category != null && category.isNotEmpty) {
      query = query.eq('category', category);
    }
    final rows = await query.order('rating', ascending: false);
    return List<Map<String, dynamic>>.from(rows as List);
  }

  static Future<List<Map<String, dynamic>>> fetchMyTechnicianProfiles() async {
    final userId = AuthService.currentUser?.id;
    if (userId == null) return [];
    final rows = await _client.from('technicians').select(_technicianColumns).eq('user_id', userId);
    return List<Map<String, dynamic>>.from(rows as List);
  }

  static Future<String> registerAsTechnician({
    required String category,
    required String bio,
    required String serviceArea,
  }) async {
    final result = await _client.rpc('register_technician', params: {
      'p_category': category,
      'p_bio': bio,
      'p_service_area': serviceArea,
    });
    return result as String;
  }

  static Future<void> updateTechnicianProfile({
    required String technicianId,
    required String category,
    required String bio,
    required String serviceArea,
  }) async {
    await _client.rpc('update_technician_profile', params: {
      'p_technician_id': technicianId,
      'p_category': category,
      'p_bio': bio,
      'p_service_area': serviceArea,
    });
  }

  static Future<String> bookService({
    required String technicianId,
    required String category,
    required String description,
    required double inspectionFee,
  }) async {
    final result = await _client.rpc('book_maintenance_service', params: {
      'p_technician_id': technicianId,
      'p_category': category,
      'p_description': description,
      'p_inspection_fee': inspectionFee,
    });
    return result as String;
  }

  static Future<List<Map<String, dynamic>>> fetchMyRequests() async {
    final userId = AuthService.currentUser?.id;
    if (userId == null) return [];
    final rows = await _client
        .from('maintenance_requests')
        .select('$_requestColumns, technician:technicians(id, category, profile:profiles(full_name))')
        .eq('resident_id', userId)
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(rows as List);
  }

  static Future<List<Map<String, dynamic>>> fetchAssignedRequests(String technicianId) async {
    final rows = await _client
        .from('maintenance_requests')
        .select('$_requestColumns, resident:profiles(full_name), unit:units(unit_number, floor_label)')
        .eq('technician_id', technicianId)
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(rows as List);
  }

  static Future<void> updateRequestStatus({
    required String requestId,
    required String status,
    double? quotedAmount,
    DateTime? visitScheduledAt,
  }) async {
    await _client.rpc('update_request_status', params: {
      'p_request_id': requestId,
      'p_status': status,
      'p_quoted_amount': quotedAmount,
      'p_visit_scheduled_at': visitScheduledAt?.toUtc().toIso8601String(),
    });
  }

  static Future<void> requestEscrowRelease(String requestId) async {
    await _client.rpc('request_escrow_release', params: {'p_request_id': requestId});
  }

  static Future<void> confirmCompletionAndRelease({required String requestId, required String otp}) async {
    await _client.rpc('confirm_completion_and_release', params: {'p_request_id': requestId, 'p_otp': otp});
  }

  static Future<void> cancelRequest(String requestId) async {
    await _client.rpc('cancel_maintenance_request', params: {'p_request_id': requestId});
  }

  static Future<void> flagDispute({required String requestId, required String reason}) async {
    await _client.rpc('flag_maintenance_dispute', params: {'p_request_id': requestId, 'p_reason': reason});
  }

  /// [idCardStoragePath]/[videoStoragePath] are private-documents bucket
  /// paths from UploadService.uploadPrivateDocument, not public URLs —
  /// see backend/migrations/0027_storage_and_verification.sql.
  static Future<void> submitVerification({
    required String technicianId,
    required String idCardStoragePath,
    required String videoStoragePath,
  }) async {
    await _client.rpc('submit_technician_verification', params: {
      'p_technician_id': technicianId,
      'p_id_card_url': idCardStoragePath,
      'p_verification_video_url': videoStoragePath,
    });
  }

  static Future<Map<String, dynamic>> fetchVerification(String technicianId) async {
    final result = await _client.rpc('fetch_technician_verification', params: {'p_technician_id': technicianId});
    return Map<String, dynamic>.from(result as Map);
  }

  static Future<List<Map<String, dynamic>>> fetchMessages(String requestId) async {
    final rows = await _client
        .from('maintenance_messages')
        .select('*, sender:profiles(full_name)')
        .eq('request_id', requestId)
        .order('created_at', ascending: true);
    return List<Map<String, dynamic>>.from(rows as List);
  }

  static Future<void> sendMessage({required String requestId, required String body}) async {
    final userId = AuthService.currentUser?.id;
    if (userId == null) throw Exception('يجب تسجيل الدخول أولاً');
    await _client.from('maintenance_messages').insert({
      'request_id': requestId,
      'sender_id': userId,
      'body': body,
    });
  }
}
