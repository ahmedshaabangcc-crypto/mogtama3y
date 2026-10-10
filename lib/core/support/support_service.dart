import 'package:supabase_flutter/supabase_flutter.dart';

import '../auth/auth_service.dart';
import '../union/union_service.dart';

/// Real support tickets — see backend/migrations/0015_support_tickets.sql.
class SupportService {
  SupportService._();

  static SupabaseClient get _client => Supabase.instance.client;

  static Future<void> submitTicket({
    required String category,
    required String subject,
    required String body,
  }) async {
    final userId = AuthService.currentUser?.id;
    if (userId == null) throw Exception('يجب تسجيل الدخول أولاً');
    final membership = await UnionService.fetchMyMembership();
    await _client.from('support_tickets').insert({
      'user_id': userId,
      if (membership?['unit_id'] != null) 'unit_id': membership!['unit_id'],
      'category': category,
      'subject': subject,
      'body': body,
    });
  }
}

/// What the user picked in the «كلّمنا» sheet (migration 0088).
enum FeedbackKind { suggestion, bug, question }

/// The floating «كلّمنا» button — backend/migrations/0088_feedback_button.sql.
/// Works for guests too (the RPC rate-limits them); signed-in users get the
/// admin's reply as a notification.
class FeedbackService {
  FeedbackService._();

  static Future<void> submit({
    required FeedbackKind kind,
    required String body,
    String? contact,
    required Map<String, String> source,
  }) async {
    await Supabase.instance.client.rpc('submit_feedback', params: {
      'p_kind': kind.name,
      'p_body': body,
      'p_contact': (contact == null || contact.trim().isEmpty) ? null : contact.trim(),
      'p_source': source,
    });
  }
}
