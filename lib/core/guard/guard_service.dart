import 'package:supabase_flutter/supabase_flutter.dart';

import '../auth/auth_service.dart';

/// Real guard console — see backend/migrations/0019_guard_console.sql.
/// A guard is a building_guards row, not a union_role, so appointed
/// staff don't need to be a resident of the building.
class GuardService {
  GuardService._();

  static SupabaseClient get _client => Supabase.instance.client;

  /// The building the caller is an active guard of, with its name
  /// embedded, or null if they're not an active guard anywhere.
  static Future<Map<String, dynamic>?> fetchMyGuardAssignment() async {
    final userId = AuthService.currentUser?.id;
    if (userId == null) return null;
    return _client
        .from('building_guards')
        .select('*, building:buildings(name)')
        .eq('user_id', userId)
        .eq('is_active', true)
        .maybeSingle();
  }

  /// The active guards currently appointed for [buildingId].
  static Future<List<Map<String, dynamic>>> fetchGuardsFor(String buildingId) async {
    final rows = await _client
        .from('building_guards')
        // building_guards has two FKs to profiles (user_id, appointed_by)
        // — an unqualified 'profiles(...)' embed is ambiguous to
        // PostgREST (PGRST201). Name the user_id one explicitly.
        .select('*, profile:profiles!building_guards_user_id_fkey(full_name, phone)')
        .eq('building_id', buildingId)
        .eq('is_active', true);
    return List<Map<String, dynamic>>.from(rows as List);
  }

  static Future<void> appointGuard({required String buildingId, required String userId}) async {
    await _client.rpc('appoint_guard', params: {'p_building_id': buildingId, 'p_user_id': userId});
  }

  static Future<void> revokeGuard({required String buildingId, required String userId}) async {
    await _client.rpc('revoke_guard', params: {'p_building_id': buildingId, 'p_user_id': userId});
  }

  /// Verifies a visitor pass by its printed/spoken code — marks it used
  /// server-side and returns the visitor/unit details to display.
  static Future<Map<String, dynamic>> verifyPass(String qrCode) async {
    final result = await _client.rpc('verify_visitor_pass', params: {'p_qr_code': qrCode});
    return Map<String, dynamic>.from(result as Map);
  }

  static Future<List<Map<String, dynamic>>> fetchRecentPasses(String buildingId) async {
    final rows = await _client.rpc('fetch_guard_recent_passes', params: {'p_building_id': buildingId});
    return List<Map<String, dynamic>>.from(rows as List);
  }

  /// Unresolved "found" items in [buildingId] — the physical custody
  /// the guard is holding until an owner claims them.
  static Future<List<Map<String, dynamic>>> fetchCustodyItems(String buildingId) async {
    final rows = await _client
        .from('lost_found_items')
        .select()
        .eq('building_id', buildingId)
        .eq('type', 'found')
        .eq('is_resolved', false)
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(rows as List);
  }

  static Future<void> markCustodyHandedOver(String itemId) async {
    await _client.from('lost_found_items').update({'is_resolved': true}).eq('id', itemId);
  }
}
