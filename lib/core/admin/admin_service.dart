import 'package:supabase_flutter/supabase_flutter.dart';

/// Real superadmin panel data — see backend/migrations/0024_superadmin.sql.
/// Every method here re-checks `is_super_admin()` server-side; a
/// non-admin calling these just gets a permission exception.
class AdminService {
  AdminService._();

  static SupabaseClient get _client => Supabase.instance.client;

  static Future<Map<String, dynamic>> fetchDashboardStats() async {
    final result = await _client.rpc('fetch_admin_dashboard_stats');
    return Map<String, dynamic>.from(result as Map);
  }

  static Future<List<Map<String, dynamic>>> fetchPendingShopClaims() async {
    final rows = await _client
        .from('shop_claim_requests')
        .select('*, shop:shops(name, address), requester:profiles(full_name, phone)')
        .eq('status', 'pending')
        .order('created_at', ascending: true);
    return List<Map<String, dynamic>>.from(rows as List);
  }

  static Future<void> reviewShopClaim({required String requestId, required bool approve}) async {
    await _client.rpc('review_shop_claim', params: {'p_request_id': requestId, 'p_approve': approve});
  }

  static const _requestColumns = 'id, unit_id, resident_id, technician_id, category, description, status, '
      'quoted_amount, escrow_status, visit_scheduled_at, completed_at, created_at';

  static Future<List<Map<String, dynamic>>> fetchDisputedRequests() async {
    final rows = await _client
        .from('maintenance_requests')
        .select('$_requestColumns, resident:profiles(full_name), unit:units(unit_number)')
        .eq('status', 'disputed')
        .order('created_at', ascending: true);
    return List<Map<String, dynamic>>.from(rows as List);
  }

  static Future<void> resolveDispute({required String requestId, required bool releaseToTechnician}) async {
    await _client.rpc('resolve_maintenance_dispute', params: {'p_request_id': requestId, 'p_release_to_technician': releaseToTechnician});
  }
}
