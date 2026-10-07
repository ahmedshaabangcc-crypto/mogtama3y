import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../storage/upload_service.dart';

/// The building fund (صندوق العمارة), the treasurer and who-paid / who-
/// didn't — see backend/migrations/0076_union_fund_treasurer.sql.
///
/// The fund is managed by the treasurer when the building has one,
/// otherwise by the president. President/board/treasurer see the balance
/// and ledger; residents only get the collection percentage. Every money
/// movement is a server-side function — the app never writes balances.
class FundService {
  FundService._();

  static SupabaseClient get _client => Supabase.instance.client;

  /// Whether the caller manages [buildingId]'s fund right now.
  static Future<bool> isManager(String buildingId) async {
    final r = await _client.rpc('is_union_fund_manager', params: {'p_building_id': buildingId});
    return r == true;
  }

  /// Whether the caller may see the balance / ledger (manager, president, board).
  static Future<bool> canView(String buildingId) async {
    final r = await _client.rpc('can_view_union_fund', params: {'p_building_id': buildingId});
    return r == true;
  }

  /// Ledger totals + recent expenses (manager/board only). [since] limits
  /// the totals to that period; the balance is always the live one.
  static Future<Map<String, dynamic>> fetchSummary(String buildingId, {DateTime? since}) async {
    final r = await _client.rpc('union_fund_summary', params: {
      'p_building': buildingId,
      'p_since': since?.toUtc().toIso8601String(),
    });
    return Map<String, dynamic>.from(r as Map);
  }

  static Future<List<Map<String, dynamic>>> fetchLedger(String buildingId, {int limit = 100}) async {
    final rows = await _client
        .from('union_fund_transactions')
        .select('*, unit:units(unit_number), creator:profiles!union_fund_transactions_created_by_fkey(full_name)')
        .eq('building_id', buildingId)
        .order('created_at', ascending: false)
        .limit(limit);
    return List<Map<String, dynamic>>.from(rows as List);
  }

  static Future<List<Map<String, dynamic>>> fetchWithdrawalRequests(String buildingId) async {
    final rows = await _client
        .from('union_fund_withdrawal_requests')
        .select()
        .eq('building_id', buildingId)
        .order('created_at', ascending: false)
        .limit(20);
    return List<Map<String, dynamic>>.from(rows as List);
  }

  static Future<void> markDuePaidCash(String dueId, {String? note}) async {
    await _client.rpc('mark_due_paid_cash', params: {'p_due_id': dueId, 'p_note': note});
  }

  /// Uploads the optional receipt photo to private-documents
  /// (`{uid}/union-receipts/…` — the only folder the server accepts) and
  /// records the expense.
  static Future<void> recordExpense({
    required String buildingId,
    required double amount,
    required String note,
    XFile? receipt,
  }) async {
    String? path;
    if (receipt != null) {
      path = await UploadService.uploadPrivateDocument(purpose: 'union-receipts', file: receipt);
    }
    await _client.rpc('record_union_expense', params: {
      'p_building': buildingId,
      'p_amount': amount,
      'p_note': note,
      'p_receipt_path': path,
    });
  }

  /// No [payoutPhone] = into the manager's own مُجتمعي wallet.
  static Future<void> requestWithdrawal({
    required String buildingId,
    required double amount,
    required String note,
    String? payoutPhone,
  }) async {
    await _client.rpc('request_fund_withdrawal', params: {
      'p_building': buildingId,
      'p_amount': amount,
      'p_note': note,
      'p_payout_phone': payoutPhone,
    });
  }

  static Future<String> receiptUrl(String path) => UploadService.createPrivateSignedUrl(path);

  // ---- dues status ----

  /// Every unit with its due for [period] (default: the latest issued)
  /// and status 'paid' | 'unpaid' | 'overdue' | 'none'.
  static Future<List<Map<String, dynamic>>> fetchDuesStatus(String buildingId, {String? period}) async {
    final rows = await _client.rpc('union_dues_status', params: {'p_building': buildingId, 'p_period': period});
    return List<Map<String, dynamic>>.from(rows as List);
  }

  static Future<List<Map<String, dynamic>>> fetchDuePeriods(String buildingId) async {
    final rows = await _client.rpc('union_due_periods', params: {'p_building': buildingId});
    return List<Map<String, dynamic>>.from(rows as List);
  }

  /// {period_label, total_units, paid_units, pct} for the current period,
  /// or null when no dues were issued yet. Any verified member.
  static Future<Map<String, dynamic>?> fetchCollectionRate(String buildingId) async {
    final rows = await _client.rpc('union_collection_rate', params: {'p_building': buildingId});
    final list = rows as List;
    return list.isEmpty ? null : Map<String, dynamic>.from(list.first as Map);
  }

  /// «فكّر الكل» — returns how many people were notified.
  static Future<int> remindUnpaid(String buildingId) async {
    final r = await _client.rpc('remind_unpaid_dues', params: {'p_building': buildingId});
    return (r as num?)?.toInt() ?? 0;
  }

  // ---- treasurer ----

  static Future<Map<String, dynamic>?> fetchTreasurer(String buildingId) {
    return _client
        .from('union_treasurers')
        .select('*, profile:profiles!union_treasurers_user_id_fkey(full_name)')
        .eq('building_id', buildingId)
        .maybeSingle();
  }

  static Future<void> appointTreasurer({required String buildingId, required String userId}) async {
    await _client.rpc('appoint_union_treasurer', params: {'p_building': buildingId, 'p_user_id': userId});
  }

  static Future<void> removeTreasurer(String buildingId) async {
    await _client.rpc('remove_union_treasurer', params: {'p_building': buildingId});
  }

  // ---- invite code ----

  static Future<String> fetchInviteCode(String buildingId) async {
    return await _client.rpc('get_building_invite_code', params: {'p_building': buildingId}) as String;
  }

  static Future<String> rotateInviteCode(String buildingId) async {
    return await _client.rpc('rotate_building_invite_code', params: {'p_building': buildingId}) as String;
  }

  // ---- super admin ----

  static Future<List<Map<String, dynamic>>> fetchPendingWithdrawalsForAdmin() async {
    final rows = await _client.rpc('admin_list_union_fund_withdrawals');
    return List<Map<String, dynamic>>.from(rows as List);
  }

  static Future<void> reviewWithdrawal({required String requestId, required bool paid}) async {
    await _client.rpc('review_union_fund_withdrawal', params: {'p_request_id': requestId, 'p_paid': paid});
  }
}

/// Share text + wa.me link for a building or tenant invite code.
Uri inviteWhatsAppUri(String text) => Uri.parse('https://wa.me/?text=${Uri.encodeComponent(text)}');

String buildingInviteMessage(String code, {String? buildingName}) =>
    'أهلاً يا جيران 👋\n'
    'عمارتنا${buildingName == null ? '' : ' «$buildingName»'} بقى ليها اتحاد ملاك على تطبيق «اتحاد الملاك» — '
    'الإعلانات والمستحقات والصيانة كلها في مكان واحد.\n'
    'ادخل من هنا: https://ittihad.mogtama3y.com\n'
    'واختار «عندي كود دعوة من الرئيس» واكتب الكود ده: $code';

String tenantInviteMessage(String code) =>
    'أهلاً 👋 ده كود دخولك كساكن في شقتي على تطبيق «اتحاد الملاك».\n'
    'ادخل من هنا: https://ittihad.mogtama3y.com\n'
    'واختار «أنا مستأجر ومعايا كود من المالك» واكتب الكود: $code\n'
    '(الكود صالح 7 أيام)';
