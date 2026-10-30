import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// «ادفع أونلاين» (migration 0100): the store's own Fawaterak account,
/// through the `payments-checkout` Edge Function. No account needed — the
/// order code + the order's mobile prove it is the customer.
class OnlinePayment {
  OnlinePayment._();

  /// Widget tests: answers the Edge Function without a backend.
  @visibleForTesting
  static Future<Map<String, dynamic>> Function(Map<String, dynamic> body)? debugInvoke;

  static Future<Map<String, dynamic>> _call(Map<String, dynamic> body) async {
    if (debugInvoke != null) return debugInvoke!(body);
    try {
      final r = await Supabase.instance.client.functions.invoke('payments-checkout', body: body);
      return Map<String, dynamic>.from(r.data as Map? ?? const {});
    } on FunctionException catch (e) {
      final d = e.details;
      final msg = d is Map ? d['error'] as String? : null;
      throw PaymentProblem(msg ?? 'مقدرناش نوصل للدفع دلوقتي — جرّب تاني بعد شوية');
    } catch (e) {
      if (e is PaymentProblem) rethrow;
      throw const PaymentProblem('مقدرناش نوصل للدفع دلوقتي — اتأكد من النت');
    }
  }

  static Map<String, dynamic> _ok(Map<String, dynamic> r) {
    final err = r['error'] as String?;
    if (err != null) throw PaymentProblem(err);
    return r;
  }

  /// {redirect_to}: Fawaterak's hosted checkout (the customer picks the
  /// method there), or {paid: true}. The order becomes «أونلاين».
  static Future<Map<String, dynamic>> pay(String code, String phone) async =>
      _ok(await _call({'action': 'pay', 'code': code, 'phone': phone}));

  /// Re-checks with Fawaterak → 'awaiting' | 'paid' | 'failed' | null.
  static Future<String?> refresh(String code, String phone) async {
    try {
      return (await _call({'action': 'status', 'code': code, 'phone': phone}))['payment_status'] as String?;
    } catch (_) {
      return null;
    }
  }

  // The mobile an order was placed with, kept in this browser so the
  // tracking page can check / retry the payment after Fawaterak's page.
  static String _key(String code) => 'order_phone:${code.toUpperCase()}';

  static Future<void> rememberPhone(String code, String phone) async {
    try {
      await (await SharedPreferences.getInstance()).setString(_key(code), phone);
    } catch (_) {}
  }

  static Future<String?> phoneFor(String code) async {
    try {
      return (await SharedPreferences.getInstance()).getString(_key(code));
    } catch (_) {
      return null;
    }
  }
}

/// A refusal to show as is.
class PaymentProblem implements Exception {
  const PaymentProblem(this.message);
  final String message;
  @override
  String toString() => message;
}
