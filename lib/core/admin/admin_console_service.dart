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

  /// {total, rows}.
  static Future<Map<String, dynamic>> shops({String? query, int offset = 0, int limit = 50}) async =>
      _map(await _rpc('admin_shops', {'p_q': query, 'p_offset': offset, 'p_limit': limit}));
}

/// Not a super admin (the RPC said 42501).
bool isAdminDenied(Object e) => e is PostgrestException && e.code == '42501';
