import 'package:supabase_flutter/supabase_flutter.dart';

import '../auth/contact_phones.dart';

/// Interim manual wallet top-ups / withdrawals through the platform
/// owner's mobile wallet — see
/// backend/migrations/0045_manual_wallet_topup_withdrawal.sql. Every step
/// is a server-side function; the app never writes balances.
class WalletService {
  WalletService._();

  static SupabaseClient get _client => Supabase.instance.client;

  /// The wallet number users transfer to (same as token top-ups).
  static Future<String?> fetchTransferPhone() async {
    final row = await _client.from('ad_token_settings').select('topup_phone').eq('id', 1).maybeSingle();
    return row?['topup_phone'] as String?;
  }

  static Future<double> fetchAvailableBalance() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return 0;
    final row = await _client.from('wallets').select('available_balance').eq('user_id', userId).maybeSingle();
    return (row?['available_balance'] as num?)?.toDouble() ?? 0;
  }

  static Future<void> requestTopup({required double amount, required String proofNote}) async {
    await _client.rpc('request_wallet_topup', params: {'p_amount': amount, 'p_proof_note': proofNote});
  }

  static Future<void> requestWithdrawal({required double amount, required String payoutPhone}) async {
    await _client.rpc('request_wallet_withdrawal', params: {'p_amount': amount, 'p_payout_phone': payoutPhone});
  }

  // ---- super admin ----

  static Future<List<Map<String, dynamic>>> fetchPendingTopups() async {
    final rows = await _client
        .from('wallet_topup_requests')
        // two FKs to profiles (user_id, reviewed_by) — name the user one.
        .select('*, requester:profiles!wallet_topup_requests_user_id_fkey(full_name)')
        .eq('status', 'pending')
        .order('created_at', ascending: true);
    final requests = List<Map<String, dynamic>>.from(rows as List);
    await ContactPhones.attach(requests, userIdKey: 'user_id', profileKey: 'requester');
    return requests;
  }

  static Future<List<Map<String, dynamic>>> fetchPendingWithdrawals() async {
    final rows = await _client
        .from('wallet_withdrawal_requests')
        .select('*, requester:profiles!wallet_withdrawal_requests_user_id_fkey(full_name)')
        .eq('status', 'pending')
        .order('created_at', ascending: true);
    return List<Map<String, dynamic>>.from(rows as List);
  }

  static Future<void> reviewTopup({required String requestId, required bool approve}) async {
    await _client.rpc('review_wallet_topup', params: {'p_request_id': requestId, 'p_approve': approve});
  }

  static Future<void> reviewWithdrawal({required String requestId, required bool paid}) async {
    await _client.rpc('review_wallet_withdrawal', params: {'p_request_id': requestId, 'p_paid': paid});
  }
}
