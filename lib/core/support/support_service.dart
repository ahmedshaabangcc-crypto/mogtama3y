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
