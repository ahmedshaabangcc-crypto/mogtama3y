import 'package:supabase_flutter/supabase_flutter.dart';

import '../auth/auth_service.dart';
import '../union/union_service.dart';

/// Real union dues (maintenance subscriptions) paid from the in-app
/// wallet — see backend/migrations/0014_union_dues.sql. Creating dues
/// and paying them both go through SECURITY DEFINER RPCs so the money
/// movement is always atomic and the caller can never issue dues for a
/// building they don't preside over.
class DuesService {
  DuesService._();

  static SupabaseClient get _client => Supabase.instance.client;

  /// The caller's own most recent unpaid due, or null if there isn't
  /// one (either none were ever issued, or they're all settled).
  static Future<Map<String, dynamic>?> fetchMyOutstandingDue() async {
    final userId = AuthService.currentUser?.id;
    if (userId == null) return null;
    final membership = await UnionService.fetchMyMembership();
    final unitId = membership?['unit_id'] as String?;
    if (unitId == null) return null;
    return _client
        .from('union_dues')
        .select()
        .eq('unit_id', unitId)
        .eq('is_paid', false)
        .order('due_date', ascending: true)
        .limit(1)
        .maybeSingle();
  }

  /// Whether the caller can issue dues for their building (president or
  /// board member) — used to show/hide the "issue dues" action.
  static Future<bool> canIssueDues() async {
    final membership = await UnionService.fetchMyMembership();
    final role = membership?['role'] as String?;
    return role == 'president' || role == 'board_member';
  }

  /// Issues [amount] EGP due for [periodLabel] to every unit in the
  /// caller's building. Returns how many units were charged.
  static Future<int> issueDuesForBuilding({
    required String periodLabel,
    required double amount,
    required DateTime dueDate,
  }) async {
    final result = await _client.rpc('create_union_due', params: {
      'p_period_label': periodLabel,
      'p_amount': amount,
      'p_due_date': dueDate.toIso8601String().split('T').first,
    });
    return result as int;
  }

  static Future<void> payDue(String dueId) async {
    await _client.rpc('pay_union_due', params: {'p_due_id': dueId});
  }
}
