import 'package:supabase_flutter/supabase_flutter.dart';

import '../demo/demo_mode.dart';
import 'phone_sms.dart';

/// Verifying the user's mobile number by SMS (migration 0074): Firebase
/// sends and checks the code (web/phone-verify.js), then the verify-phone
/// Edge Function checks Firebase's signed token and marks the number
/// verified on the profile.
class PhoneVerify {
  /// Sends the SMS. Returns null when it's on its way, else a message to show.
  static Future<String?> sendCode(String phone) async {
    if (kDemo) return 'تأكيد الرقم مش متاح في النسخة التجريبية';
    final code = await sendSmsCode(phone);
    return code.isEmpty ? null : _message(code);
  }

  /// Checks the typed code and saves the number as verified. Returns null on
  /// success, else a message to show.
  static Future<String?> confirm(String smsCode) async {
    if (kDemo) return 'تأكيد الرقم مش متاح في النسخة التجريبية';
    final token = await confirmSmsCode(smsCode);
    if (token.startsWith('ERR:')) return _message(token.substring(4));
    try {
      // Deployed under the slug 'smooth-action' (set by the dashboard editor).
      final res = await Supabase.instance.client.functions.invoke('smooth-action', body: {'id_token': token});
      final data = res.data;
      if (data is Map && data['ok'] == true) return null;
      return (data is Map ? data['error'] as String? : null) ?? 'تعذر تأكيد الرقم، جرّب تاني';
    } on FunctionException catch (e) {
      final details = e.details;
      return (details is Map ? details['error'] as String? : null) ?? 'تعذر تأكيد الرقم، جرّب تاني';
    } catch (_) {
      return 'تعذر تأكيد الرقم، اتأكد من النت وجرّب تاني';
    }
  }

  static String _message(String code) => switch (code) {
        'auth/invalid-phone-number' => 'الرقم مش صحيح',
        'auth/invalid-verification-code' => 'الكود غلط، راجعه وجرّب تاني',
        'auth/code-expired' => 'الكود خلص وقته، ابعت كود جديد',
        'auth/too-many-requests' => 'جربت كتير، استنى شوية وجرّب تاني',
        'auth/quota-exceeded' => 'رسايل التأكيد خلصت النهارده، جرّب بكرة',
        'auth/billing-not-enabled' => 'تأكيد الرقم برسالة متوقف مؤقتاً، جرّب تاني بعد شوية ($code)',
        // Firebase's SMS region policy blocks the number's country.
        'auth/operation-not-allowed' || 'auth/unsupported-country-code' => 'التوثيق برسالة مش متاح لبلدك لسه ($code)',
        'auth/captcha-check-failed' || 'auth/internal-error' => 'حصلت مشكلة في التحقق، اعمل تحديث للصفحة وجرّب تاني',
        'unsupported' => 'تأكيد الرقم متاح من الموقع على المتصفح',
        'sdk-load-failed' => 'تعذر التحميل، اتأكد من النت وجرّب تاني',
        // Unknown: show the code so a screenshot tells us what happened.
        _ => 'تعذر إرسال الكود، جرّب تاني ($code)',
      };
}
