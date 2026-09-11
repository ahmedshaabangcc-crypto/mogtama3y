import 'dart:math';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../auth/auth_service.dart';
import '../union/union_service.dart';

/// Real visitor QR passes, scoped to the issuer's own unit — see
/// backend/migrations/0006_visitor_passes.sql.
class VisitorPassService {
  VisitorPassService._();

  static SupabaseClient get _client => Supabase.instance.client;

  /// The caller's currently-active pass (if any), newest first.
  static Future<Map<String, dynamic>?> fetchActivePass() async {
    final userId = AuthService.currentUser?.id;
    if (userId == null) return null;
    return _client
        .from('visitor_passes')
        .select()
        .eq('issued_by', userId)
        .eq('status', 'active')
        .gt('valid_until', DateTime.now().toUtc().toIso8601String())
        .order('created_at', ascending: false)
        .limit(1)
        .maybeSingle();
  }

  static Future<int> fetchPassCount() async {
    final userId = AuthService.currentUser?.id;
    if (userId == null) return 0;
    final rows = await _client.from('visitor_passes').select('id').eq('issued_by', userId);
    return (rows as List).length;
  }

  /// Issues a new pass for the caller's own unit (resolved via
  /// UnionService — the RLS policy re-checks this server-side too).
  static Future<Map<String, dynamic>> issuePass({
    required String visitorName,
    required String passType,
    required Duration validFor,
  }) async {
    final userId = AuthService.currentUser?.id;
    if (userId == null) throw Exception('يجب تسجيل الدخول أولاً');
    final membership = await UnionService.fetchMyMembership();
    final unitId = membership?['unit_id'] as String?;
    if (unitId == null) throw Exception('يجب الانضمام لعمارتك أولاً قبل إصدار تصريح');

    final code = 'PASS-${_randomHex(6)}';
    final now = DateTime.now();
    final row = await _client
        .from('visitor_passes')
        .insert({
          'unit_id': unitId,
          'issued_by': userId,
          'visitor_name': visitorName,
          'pass_type': passType,
          'qr_code': code,
          'valid_from': now.toUtc().toIso8601String(),
          'valid_until': now.add(validFor).toUtc().toIso8601String(),
          'status': 'active',
        })
        .select()
        .single();
    return row;
  }

  static Future<void> revokePass(String passId) async {
    await _client.from('visitor_passes').update({'status': 'revoked'}).eq('id', passId);
  }

  static String _randomHex(int length) {
    const chars = '0123456789ABCDEF';
    final rand = Random.secure();
    return List.generate(length, (_) => chars[rand.nextInt(chars.length)]).join();
  }
}
