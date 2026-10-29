import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mogtama3y/core/shops/shop_pixels.dart';
import 'package:mogtama3y/features/merchant/admin/admin_shell.dart' show isTajerAdminPath;
import 'package:mogtama3y/features/merchant/admin/merchant_session.dart';
import 'package:mogtama3y/features/merchant/integrations/domain_settings_screen.dart';
import 'package:mogtama3y/features/merchant/integrations/integrations_hub_screen.dart';
import 'package:mogtama3y/features/merchant/integrations/integrations_rules.dart';
import 'package:mogtama3y/features/merchant/integrations/integrations_service.dart';
import 'package:mogtama3y/features/merchant/integrations/payments_settings_screen.dart';
import 'package:mogtama3y/features/merchant/integrations/tracking_settings_screen.dart';
import 'package:mogtama3y/features/store/store_cart.dart';

/// A loaded merchant session without a backend.
class _Session extends MerchantSession {
  _Session(Map<String, dynamic> shop) {
    shops = [shop];
    loading = false;
  }

  @override
  Future<void> load() async {}

  @override
  Future<void> refreshOrders({bool alert = false}) async {}

  @override
  void resume() {}
}

void main() {
  group('domains', () {
    test('normalizes what the merchant pastes', () {
      expect(normalizeHostname(' https://Shop.Example.com/products?x=1 '), 'shop.example.com');
      expect(normalizeHostname('www.example.com.'), 'www.example.com');
    });

    test('punycode (RFC 3492) for Arabic labels', () {
      expect(punycodeEncode('مثال'), 'mgbh0fb');
      expect(punycodeEncode('إختبار'), 'kgbechtv');
      expect(normalizeHostname('متجر.مثال.com'), startsWith('xn--'));
      expect(normalizeHostname('مثال.إختبار'), 'xn--mgbh0fb.xn--kgbechtv');
    });

    test('rejects IPs, mogtama3y.com, local names, ports, bad labels', () {
      for (final h in ['1.2.3.4', 'mogtama3y.com', 'x.mogtama3y.com', 'localhost', 'shop.local', 'a..b.com', '-a.com', 'com', 'shop.example.com:8080']) {
        expect(hostnameProblem(normalizeHostname(h)), isNotEmpty, reason: h);
      }
      for (final h in ['shop.example.com', 'example.com', 'mystore.com.eg', 'xn--mgbh0fb.xn--kgbechtv']) {
        expect(hostnameProblem(h), isEmpty, reason: h);
      }
    });

    test('root domains and the CNAME host label', () {
      expect(isApexDomain('example.com'), isTrue);
      expect(isApexDomain('mystore.com.eg'), isTrue);
      expect(isApexDomain('shop.example.com'), isFalse);
      expect(cnameHostLabel('shop.example.com'), 'shop');
      expect(cnameHostLabel('a.b.example.com.eg'), 'a.b');
      expect(cnameHostLabel('example.com'), '@');
    });
  });

  group('payments', () {
    test('IBAN checksum', () {
      expect(ibanValid('EG38 0019 0005 0000 0000 2631 8000 2'), isTrue);
      expect(ibanValid('SA03 8000 0000 6080 1016 7519'), isTrue);
      expect(ibanValid('EG380019000500000000263180003'), isFalse);
      expect(ibanValid('123'), isFalse);
    });

    test('InstaPay address', () {
      expect(normalizeInstapay(' Ahmed.Shop '), 'ahmed.shop@instapay');
      expect(normalizeInstapay('https://ipn.eg/S/ahmed/instapay/ABC'), 'https://ipn.eg/S/ahmed/instapay/ABC');
      expect(normalizeInstapay('x y'), isNull);
    });

    test('gateways by country', () {
      List<String> ids(String c) => gatewaySpecs.where((g) => g.availableIn(c)).map((g) => g.id).toList();
      expect(ids('EG'), ['fawaterak', 'paymob', 'kashier', 'tap']);
      expect(ids('SA'), ['paymob', 'tap', 'moyasar']);
      expect(ids('KW'), ['tap']);
      expect(ids('MA'), isEmpty);
    });

    test('gateway field checks (required, formats, test vs live)', () {
      final tap = gatewaySpec('tap')!;
      expect(gatewayProblem(tap, {'publishable_key': 'pk_test_abcdefghijk', 'secret_key': 'sk_test_abcdefghijk'}, 'test'), isEmpty);
      expect(gatewayProblem(tap, {'publishable_key': 'pk_test_abcdefghijk'}, 'test'), contains('Secret'));
      expect(gatewayProblem(tap, {'publishable_key': 'pk_test_abcdefghijk'}, 'test', hasSecret: true), isEmpty);
      expect(gatewayProblem(tap, {'publishable_key': 'pk_live_abcdefghijk', 'secret_key': 'sk_live_abcdefghijk'}, 'test'), contains('حقيقي'));
      expect(gatewayProblem(gatewaySpec('kashier')!, {'merchant_id': 'MID-1', 'api_key': 'a' * 20, 'secret_key': 'b' * 20}, 'test'), contains('Merchant'));
    });

    test('webhook URL for the gateway dashboard', () {
      expect(paymentsWebhookUrl('https://p.supabase.co', 'abc', 'paymob'), 'https://p.supabase.co/functions/v1/payments-webhook?shop=abc&provider=paymob');
    });

    test('integrations summary (never secrets in the model)', () {
      final d = ShopIntegrations({
        'shop_id': 's1',
        'country': 'SA',
        'payments': {
          'cod_enabled': true,
          'manual': {'bank': {'enabled': true}},
          'available': ['paymob', 'tap', 'moyasar'],
          'gateways': [
            {'provider': 'moyasar', 'status': 'connected', 'has_secret': true, 'secret_hint': {'secret_key': '…abcd'}},
            {'provider': 'tap', 'status': 'error'},
          ],
        },
        'domain': null,
        'tracking': {'ga4': 'G-ABC1234XYZ', 'fb_domain_verification': 'abcdefghij0123456789abcdefghij'},
      });
      expect(d.paymentMethodsOn, 3);
      expect(d.anyGatewayError, isTrue);
      expect(d.pixelsOn, 1);
      expect(d.gateway('moyasar')?['secret_hint'], {'secret_key': '…abcd'});
    });
  });

  group('tracking', () {
    test('extracts IDs from pasted snippets', () {
      expect(normalizeTracking('meta_pixel', "fbq('init', '123456789012345');"), '123456789012345');
      expect(normalizeTracking('tiktok_pixel', "ttq.load('c4abcdefghij1234567k');"), 'C4ABCDEFGHIJ1234567K');
      expect(normalizeTracking('ga4', '<script async src="https://www.googletagmanager.com/gtag/js?id=G-ABC1234XYZ"></script>'), 'G-ABC1234XYZ');
      expect(normalizeTracking('gtm', 'gtm-ab12cd3'), 'GTM-AB12CD3');
      expect(normalizeTracking('google_ads', 'aw-1234567890 / AbC_dEf12'), 'AW-1234567890/AbC_dEf12');
      expect(normalizeTracking('snap_pixel', 'A1B2C3D4-0000-4000-8000-1234567890AB'), 'a1b2c3d4-0000-4000-8000-1234567890ab');
      expect(normalizeTracking('fb_domain_verification', '<meta name="facebook-domain-verification" content="ABCDEFGHIJ0123456789abcdefghij" />'),
          'abcdefghij0123456789abcdefghij');
    });

    test('validates formats', () {
      expect(trackingProblem('meta_pixel', 'abc'), contains('Meta'));
      expect(trackingProblem('ga4', 'UA-12345-1'), isNotEmpty);
      expect(trackingProblem('gtm', 'GTM-AB12CD3'), isEmpty);
      expect(trackingProblem('meta_pixel', ''), isEmpty);
      expect(activePixels({'meta_pixel': '123456789012345', 'ga4': 'bad', 'fb_domain_verification': 'abcdefghij0123456789abcdefghij'}), {'meta_pixel': '123456789012345'});
    });
  });

  group('pixel events', () {
    test('payload: value, currency, contents, order id — no customer data', () {
      final p = pixelPayload(
        [
          PixelItem.fromProduct({'id': 'p1', 'name': 'تيشيرت', 'price': 100, 'currency': 'EGP'}, 2),
          PixelItem.fromProduct({'id': 'p2', 'name': 'شنطة', 'price': 50.5}, 1),
        ],
        currency: 'EGP',
        orderId: 'T1234567',
      );
      expect(p['value'], 250.5);
      expect(p['currency'], 'EGP');
      expect(p['order_id'], 'T1234567');
      expect((p['contents'] as List).first, {'id': 'p1', 'name': 'تيشيرت', 'price': 100.0, 'quantity': 2});
      expect(p.keys.toSet(), {'currency', 'value', 'contents', 'order_id'});
    });

    test('payload: explicit value (with delivery), unknown currency → EGP, no order id', () {
      final p = pixelPayload([PixelItem.fromProduct({'id': 'x', 'price': 10}, 0)], currency: 'egp', value: 35);
      expect(p['value'], 35.0);
      expect(p['currency'], 'EGP');
      expect(p.containsKey('order_id'), isFalse);
      expect((p['contents'] as List).single['quantity'], 1);
    });

    test('the cart turns into pixel items; events are a no-op without pixels', () {
      final cart = StoreCart()..add({'id': 'p1', 'name': 'a', 'price': 5}, quantity: 3);
      expect(cart.toPixelItems().single.toJson(), {'id': 'p1', 'name': 'a', 'price': 5.0, 'quantity': 3});
      expect(ShopPixels.active, isFalse);
      ShopPixels.purchase('T1', cart.toPixelItems(), value: 15); // must not throw
    });
  });

  group('screens (phone and desktop widths)', () {
    final sample = ShopIntegrations({
      'shop_id': '11111111-1111-4111-8111-111111111111',
      'slug': 'demo-shop',
      'country': 'SA',
      'currency': 'SAR',
      'payments': {
        'cod_enabled': true,
        'manual': {
          'bank': {'enabled': true, 'bank_name': 'الراجحي', 'account_name': 'محل', 'iban': 'SA0380000000608010167519'},
        },
        'available': ['paymob', 'tap', 'moyasar'],
        'gateways': [
          {'provider': 'moyasar', 'mode': 'test', 'status': 'connected', 'has_secret': true, 'public': {'publishable_key': 'pk_test_x'}, 'secret_hint': {'secret_key': '…abcd'}, 'webhook_token': 'f' * 32},
        ],
      },
      'domain': {'hostname': 'shop.example.com', 'is_apex': false, 'status': 'pending', 'verify_token': 'mogtama3y-verify=${'a' * 32}', 'last_error': 'لسه مش لاقيين سجل الـ TXT'},
      'tracking': {'meta_pixel': '123456789012345'},
    });

    setUp(() {
      IntegrationsService.debugLoad = (_) async => sample;
    });
    tearDown(() => IntegrationsService.debugLoad = null);

    Future<void> pumpAt(WidgetTester tester, Widget screen, double width) async {
      tester.view.physicalSize = Size(width, 1600);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      final session = _Session({'id': sample.shopId, 'name': 'محل', 'slug': 'demo-shop', 'country': 'SA', 'currency': 'SAR'});
      await tester.pumpWidget(MaterialApp(
        home: Directionality(textDirection: TextDirection.rtl, child: MerchantScope(session: session, child: screen)),
      ));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));
    }

    for (final width in [375.0, 1280.0]) {
      testWidgets('hub at $width', (tester) async {
        await pumpAt(tester, const IntegrationsHubScreen(), width);
        expect(find.text('طرق الدفع'), findsOneWidget);
        expect(find.text('3 طرق دفع شغالة'), findsOneWidget);
        expect(find.text('مستني التحقق'), findsOneWidget);
        expect(find.text('أداة واحدة شغالة'), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('payments at $width: Saudi gateways, the connected one, no secrets', (tester) async {
        await pumpAt(tester, const PaymentsSettingsScreen(), width);
        expect(find.text('Moyasar'), findsOneWidget);
        expect(find.text('Tap Payments'), findsOneWidget);
        expect(find.text('Kashier'), findsNothing);
        expect(find.text('مربوط'), findsOneWidget);
        expect(find.text('اختبر الاتصال'), findsOneWidget);
        expect(find.textContaining('payments-webhook?shop='), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('domain at $width: DNS records', (tester) async {
        await pumpAt(tester, const DomainSettingsScreen(), width);
        expect(find.text('_mogtama3y-verify.shop'), findsOneWidget);
        expect(find.text(domainCnameTarget), findsOneWidget);
        expect(find.text('تحقق دلوقتي'), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('tracking at $width', (tester) async {
        await pumpAt(tester, const TrackingSettingsScreen(), width);
        expect(find.text('123456789012345'), findsWidgets);
        expect(find.text('Google Tag Manager'), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    }
  });

  test('admin routes include the integrations pages', () {
    for (final p in ['/settings/integrations', '/settings/payments', '/settings/domain', '/settings/tracking', '/settings']) {
      expect(isTajerAdminPath(p), isTrue, reason: p);
    }
    expect(isTajerAdminPath('/settings/other'), isFalse);
  });
}
