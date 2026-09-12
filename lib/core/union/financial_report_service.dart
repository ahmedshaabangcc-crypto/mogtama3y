import 'package:supabase_flutter/supabase_flutter.dart';

/// Real quarterly financial report for a building's owners' union — see
/// backend/migrations/0030_union_financial_reports.sql.
class FinancialReportService {
  FinancialReportService._();

  static SupabaseClient get _client => Supabase.instance.client;

  /// The most recently published report for [buildingId], with its
  /// expense line items and the approving board member's name embedded,
  /// or null if the union hasn't published one yet.
  static Future<Map<String, dynamic>?> fetchLatestReport(String buildingId) {
    return _client
        .from('union_financial_reports')
        .select('*, expense_items:union_expense_items(*), approved:profiles(full_name)')
        .eq('building_id', buildingId)
        .order('published_at', ascending: false)
        .limit(1)
        .maybeSingle();
  }
}
