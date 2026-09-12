import 'package:supabase_flutter/supabase_flutter.dart';

import '../auth/auth_service.dart';

/// Real upcoming periodic-maintenance schedule for a building's owners'
/// union — see backend/migrations/0031_maintenance_schedule.sql.
class MaintenanceScheduleService {
  MaintenanceScheduleService._();

  static SupabaseClient get _client => Supabase.instance.client;

  /// Upcoming (not-yet-past) scheduled items for [buildingId], soonest first.
  static Future<List<Map<String, dynamic>>> fetchUpcoming(String buildingId) async {
    final rows = await _client
        .from('union_maintenance_schedule')
        .select()
        .eq('building_id', buildingId)
        .gte('scheduled_for', DateTime.now().toUtc().toIso8601String())
        .order('scheduled_for', ascending: true);
    return List<Map<String, dynamic>>.from(rows as List);
  }

  /// Only succeeds server-side if the caller is a verified president/
  /// board_member of [buildingId].
  static Future<void> addItem({
    required String buildingId,
    required String title,
    String? vendor,
    required DateTime scheduledFor,
    bool isUrgent = false,
  }) async {
    final userId = AuthService.currentUser?.id;
    if (userId == null) throw Exception('يجب تسجيل الدخول أولاً');
    await _client.from('union_maintenance_schedule').insert({
      'building_id': buildingId,
      'title': title,
      'vendor': vendor,
      'scheduled_for': scheduledFor.toUtc().toIso8601String(),
      'is_urgent': isUrgent,
      'created_by': userId,
    });
  }

  static Future<void> removeItem(String id) async {
    await _client.from('union_maintenance_schedule').delete().eq('id', id);
  }
}
