import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/supabase/supabase_config.dart';
import 'integrations_rules.dart';

/// Edge Function slugs (backend/functions/README.md). If the dashboard gave
/// a function another slug, change it here.
abstract final class IntegrationSlugs {
  static const paymentsConnect = 'payments-connect';
  static const paymentsWebhook = 'payments-webhook';
  static const domainsVerify = 'domains-verify';
}

/// get_shop_integrations() of one shop (0097) — never contains secrets.
class ShopIntegrations {
  ShopIntegrations(this.raw);
  final Map<String, dynamic> raw;

  String get shopId => raw['shop_id'] as String? ?? '';
  String get slug => raw['slug'] as String? ?? '';
  String get country => raw['country'] as String? ?? 'EG';
  Map<String, dynamic> get _payments => (raw['payments'] as Map?)?.cast<String, dynamic>() ?? const {};
  bool get codEnabled => _payments['cod_enabled'] != false;
  Map<String, dynamic> get manual => (_payments['manual'] as Map?)?.cast<String, dynamic>() ?? const {};
  Map<String, dynamic> manualOf(String k) => (manual[k] as Map?)?.cast<String, dynamic>() ?? const {};
  bool manualOn(String k) => manualOf(k)['enabled'] == true;
  List<String> get available => [for (final g in (_payments['available'] as List? ?? const [])) g as String];
  List<Map<String, dynamic>> get gateways => [for (final g in (_payments['gateways'] as List? ?? const [])) (g as Map).cast<String, dynamic>()];
  Map<String, dynamic>? gateway(String id) => gateways.where((g) => g['provider'] == id).firstOrNull;
  Map<String, dynamic>? get domain => (raw['domain'] as Map?)?.cast<String, dynamic>();
  Map<String, dynamic> get tracking => (raw['tracking'] as Map?)?.cast<String, dynamic>() ?? const {};

  /// How many ways to pay are on (COD + manual + connected gateways).
  int get paymentMethodsOn =>
      (codEnabled ? 1 : 0) +
      ['instapay', 'wallet', 'bank'].where(manualOn).length +
      gateways.where((g) => g['status'] == 'connected' && g['enabled'] != false).length;
  bool get anyGatewayError => gateways.any((g) => g['status'] == 'error');
  int get pixelsOn => activePixels(tracking).length;
}

class IntegrationsService {
  IntegrationsService._();
  static SupabaseClient get _db => Supabase.instance.client;

  static ShopIntegrations _wrap(Object? r) => ShopIntegrations((r as Map).cast<String, dynamic>());

  /// Widget tests: answers [load] without a backend.
  @visibleForTesting
  static Future<ShopIntegrations> Function(String shopId)? debugLoad;

  static Future<ShopIntegrations> load(String shopId) async =>
      debugLoad != null ? debugLoad!(shopId) : _wrap(await _db.rpc('get_shop_integrations', params: {'p_shop': shopId}));

  static Future<ShopIntegrations> savePayments(String shopId, {required bool cod, required Map<String, dynamic> manual}) async =>
      _wrap(await _db.rpc('set_shop_payment_settings', params: {'p_shop': shopId, 'p_cod': cod, 'p_manual': manual}));

  /// Secrets left empty keep what is saved; they are never read back.
  static Future<ShopIntegrations> saveGateway(String shopId, String provider,
          {required Map<String, String> public, required Map<String, String> secret, required String mode}) async =>
      _wrap(await _db.rpc('set_shop_gateway', params: {
        'p_shop': shopId,
        'p_provider': provider,
        'p_public': public,
        'p_secret': secret,
        'p_mode': mode,
      }));

  static Future<ShopIntegrations> disconnectGateway(String shopId, String provider) async =>
      _wrap(await _db.rpc('disconnect_shop_gateway', params: {'p_shop': shopId, 'p_provider': provider}));

  /// «اختبر الاتصال» on the server → (ok, message).
  static Future<(bool, String)> testGateway(String shopId, String provider) =>
      _invoke(IntegrationSlugs.paymentsConnect, {'action': 'test', 'shop': shopId, 'provider': provider});

  static Future<ShopIntegrations> addDomain(String shopId, String hostname) async =>
      _wrap(await _db.rpc('add_shop_domain', params: {'p_shop': shopId, 'p_hostname': hostname}));

  static Future<ShopIntegrations> removeDomain(String shopId) async => _wrap(await _db.rpc('remove_shop_domain', params: {'p_shop': shopId}));

  /// «تحقق دلوقتي» → (verified, message).
  static Future<(bool, String)> verifyDomain(String shopId) => _invoke(IntegrationSlugs.domainsVerify, {'shop': shopId});

  static Future<ShopIntegrations> saveTracking(String shopId, Map<String, String> tracking) async =>
      _wrap(await _db.rpc('set_shop_tracking', params: {'p_shop': shopId, 'p_tracking': tracking}));

  static String webhookUrl(String shopId, String provider) =>
      paymentsWebhookUrl(SupabaseConfig.url, shopId, provider, slug: IntegrationSlugs.paymentsWebhook);

  static Future<(bool, String)> _invoke(String slug, Map<String, dynamic> body) async {
    try {
      final r = await _db.functions.invoke(slug, body: body);
      final data = (r.data as Map?)?.cast<String, dynamic>() ?? const {};
      final ok = data['ok'] == true || data['status'] == 'verified' || data['status'] == 'active';
      return (ok, (data['message'] ?? data['error'] ?? '') as String);
    } on FunctionException catch (e) {
      final d = e.details;
      final msg = d is Map && d['error'] is String ? d['error'] as String : 'الخدمة مش متاحة دلوقتي — جرّب تاني بعد شوية';
      return (false, msg);
    } catch (_) {
      return (false, 'مقدرناش نوصل للخدمة — اتأكد من النت وجرّب تاني');
    }
  }
}

String integrationsError(Object e) => e is PostgrestException ? e.message : 'حصلت مشكلة، جرّب تاني';
