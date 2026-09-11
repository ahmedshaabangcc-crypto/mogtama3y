import 'package:supabase_flutter/supabase_flutter.dart';

import '../auth/auth_service.dart';
import '../union/union_service.dart';

/// Real SOS emergency alerts, scoped to the triggerer's own unit — see
/// backend/migrations/0009_sos_alerts.sql.
class SosService {
  SosService._();

  static SupabaseClient get _client => Supabase.instance.client;

  /// Triggers a real alert for the caller's own unit. Throws if they
  /// haven't joined/founded a building yet.
  static Future<String> triggerAlert({required String type}) async {
    final userId = AuthService.currentUser?.id;
    if (userId == null) throw Exception('يجب تسجيل الدخول أولاً');
    final membership = await UnionService.fetchMyMembership();
    final unitId = membership?['unit_id'] as String?;
    if (unitId == null) throw Exception('يجب الانضمام لعمارتك أولاً قبل إرسال نداء استغاثة');

    final row = await _client
        .from('sos_alerts')
        .insert({
          'unit_id': unitId,
          'triggered_by': userId,
          'type': type,
          'status': 'active',
        })
        .select('id')
        .single();
    return row['id'] as String;
  }

  /// Cancels a triggered alert (marks it a false alarm).
  static Future<void> cancelAlert(String alertId) async {
    await _client.from('sos_alerts').update({'status': 'false_alarm'}).eq('id', alertId);
  }
}
