import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// The super-admin console's data (migration 0106). Every RPC re-checks
/// `is_super_admin()` server-side and raises 42501 for anyone else.
class AdminConsoleService {
  AdminConsoleService._();

  /// Widget tests: answers every RPC of this service without a backend.
  @visibleForTesting
  static Future<Object?> Function(String fn, Map<String, dynamic> params)? debugRpc;

  static Future<Object?> _rpc(String fn, [Map<String, dynamic> params = const {}]) =>
      debugRpc != null ? debugRpc!(fn, params) : Supabase.instance.client.rpc(fn, params: params);

  static Map<String, dynamic> _map(Object? r) => Map<String, dynamic>.from(r as Map? ?? const {});

  static Future<Map<String, dynamic>> overview() async => _map(await _rpc('admin_overview'));

  /// One row per day: {day, signups, orders, tokens}.
  static Future<List<Map<String, dynamic>>> series({int days = 30}) async =>
      [for (final r in (await _rpc('admin_series', {'p_days': days})) as List? ?? const []) Map<String, dynamic>.from(r as Map)];

  /// {total, rows}.
  static Future<Map<String, dynamic>> users({String? query, int offset = 0, int limit = 50}) async =>
      _map(await _rpc('admin_users', {'p_q': query, 'p_offset': offset, 'p_limit': limit}));

  /// {total, approved_sum, rows}.
  static Future<Map<String, dynamic>> tokenPayments({String? status, int offset = 0, int limit = 50}) async =>
      _map(await _rpc('admin_token_payments', {'p_status': status, 'p_offset': offset, 'p_limit': limit}));

  /// Suspends (needs a reason, sent to the owner) or restores a store (0107).
  static Future<void> setShopSuspended(String shopId, {required bool suspend, String? reason}) =>
      _rpc('admin_set_shop_suspended', {'p_shop': shopId, 'p_suspend': suspend, 'p_reason': reason});

  /// {total, rows}.
  static Future<Map<String, dynamic>> shops({String? query, int offset = 0, int limit = 50}) async =>
      _map(await _rpc('admin_shops', {'p_q': query, 'p_offset': offset, 'p_limit': limit}));

  /// «اربط مع مُجتمعي» applications (0108), pending first, with documents
  /// (private storage paths) and each store's balance.
  static Future<List<Map<String, dynamic>>> platformPayList({String? status}) async =>
      [for (final r in (await _rpc('admin_platform_pay_list', {'p_status': status})) as List? ?? const []) Map<String, dynamic>.from(r as Map)];

  /// [action]: approve | reject | suspend — a note is required unless approving.
  static Future<void> platformPayReview(String shopId, String action, {String? note}) =>
      _rpc('admin_platform_pay_review', {'p_shop': shopId, 'p_action': action, 'p_note': note});

  /// A manual transfer sent to the merchant → the new balance.
  static Future<Map<String, dynamic>> recordPayout(String shopId, num amount, {String? method, String? reference, String? note}) async =>
      _map(await _rpc('admin_record_payout', {'p_shop': shopId, 'p_amount': amount, 'p_method': method, 'p_reference': reference, 'p_note': note}));
}

/// Not a super admin (the RPC said 42501).
bool isAdminDenied(Object e) => e is PostgrestException && e.code == '42501';
