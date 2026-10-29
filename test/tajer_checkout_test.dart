import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:go_router/go_router.dart';
import 'package:mogtama3y/core/demo/demo_http_client.dart';
import 'package:mogtama3y/core/demo/demo_store.dart';
import 'package:mogtama3y/core/geo/money.dart';
import 'package:mogtama3y/core/shops/checkout_service.dart';
import 'package:mogtama3y/core/shops/shop_pixels.dart';
import 'package:mogtama3y/core/shops/store_service.dart';
import 'package:mogtama3y/features/merchant/admin/admin_shell.dart' show isTajerAdminPath;
import 'package:mogtama3y/features/merchant/admin/merchant_session.dart';
import 'package:mogtama3y/features/merchant/admin/tajer_routes.dart';
import 'package:mogtama3y/features/merchant/checkout/abandoned_carts_page.dart';
import 'package:mogtama3y/core/shops/online_payment.dart';
import 'package:mogtama3y/features/store/checkout_screen.dart';
import 'package:mogtama3y/features/store/online_payment_screen.dart';
import 'package:mogtama3y/features/store/store_cart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// متجري phase 3 (0099): checkout totals / codes and the admin's
/// discounts form & shipping page, on the demo build's in-memory backend
/// (the same rules as the SQL) through the real Supabase client.
class _MemoryAsyncStorage extends GotrueAsyncStorage {
  final _items = <String, String>{};

  @override
  Future<String?> getItem({required String key}) async => _items[key];

  @override
  Future<void> setItem({required String key, required String value}) async => _items[key] = value;

  @override
  Future<void> removeItem({required String key}) async => _items.remove(key);
}

/// The demo backend of the current role (customer ↔ merchant, same tables).
class _RoleClient extends http.BaseClient {
  _RoleClient(this.current);
  DemoHttpClient current;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) => current.send(request);
}

class _TestSession extends MerchantSession {
  _TestSession(Map<String, dynamic> shop) {
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
  late DemoStore store;
  late _RoleClient client;

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    store = DemoStore.boot(role: 'customer', flavor: 'tajer', persist: false);
    await Supabase.initialize(
      url: 'http://demo.invalid',
      publishableKey: 'test-key',
      httpClient: client = _RoleClient(DemoHttpClient(store)),
      authOptions: FlutterAuthClientOptions(
        localStorage: const EmptyLocalStorage(),
        pkceAsyncStorage: _MemoryAsyncStorage(),
        detectSessionInUri: false,
        autoRefreshToken: false,
      ),
    );
  });

  Map<String, dynamic> shop() {
    final s = Map<String, dynamic>.from(store.t('shops').firstWhere((s) => s['id'] == DemoTajer.shopId));
    s['logo_url'] = null;
    s['cover_image_url'] = null;
    return s;
  }

  Map<String, dynamic> product(int n) {
    final p = Map<String, dynamic>.from(store.t('shop_products').firstWhere((p) => p['id'] == DemoTajer.productId(n)));
    p['images'] = <String>[];
    p['image_url'] = null;
    return p;
  }

  Future<void> settle(WidgetTester tester) async {
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 250));
    }
    await tester.pumpAndSettle();
  }

  Widget app(Widget home) => MaterialApp(
        locale: const Locale('ar'),
        supportedLocales: const [Locale('ar')],
        localizationsDelegates: const [GlobalMaterialLocalizations.delegate, GlobalWidgetsLocalizations.delegate, GlobalCupertinoLocalizations.delegate],
        home: home,
      );

  group('pure', () {
    test('pixel payloads carry shipping, discount and the code', () {
      final p = pixelPayload(const [PixelItem(id: 'a', name: 'x', price: 100, quantity: 2)], currency: 'SAR', value: 195, shipping: 15, discount: 20, coupon: 'SAVE10');
      expect(p, {
        'currency': 'SAR',
        'value': 195,
        'contents': [{'id': 'a', 'name': 'x', 'price': 100.0, 'quantity': 2}],
        'shipping': 15,
        'discount': 20,
        'coupon': 'SAVE10',
      });
      expect(pixelPayload(const [], value: 1).containsKey('discount'), isFalse);
    });

    test('store currencies: 22 Arab + USD/EUR/GBP, all labelled', () {
      expect(storeCurrencies, containsAll(['EGP', 'SAR', 'ILS', 'MRU', 'KMF', 'USD', 'EUR', 'GBP']));
      expect(storeCurrencies.length, 25);
      for (final c in storeCurrencies) {
        expect(currencyLabel(c), isNot(c), reason: c);
        expect(currencyNames[c], isNotNull, reason: c);
      }
      expect(money(12.5, 'USD'), r'12.5 $');
      expect(money(1.2346, 'KWD'), '1.235 د.ك');
    });

    test('admin paths', () {
      for (final p in ['/discounts', '/discounts/new', '/discounts/${DemoTajer.shopId}', '/orders/abandoned', '/settings/shipping']) {
        expect(isTajerAdminPath(p), isTrue, reason: p);
      }
      expect(isTajerAdminPath('/discounts/x'), isFalse);
    });

    test('the «كمّل طلبك» message has the restore link', () {
      final m = recoverMessage(shopName: 'محلي', name: 'سارة', link: CheckoutService.cartUrl('my-shop', 'abc'));
      expect(m, contains('سارة'));
      expect(m, contains('https://mogtama3y.com/#/s/my-shop?cart=abc'));
    });

    test('a cart restores saved lines (unknown / sold-out products skipped, stock respected)', () {
      final cart = StoreCart();
      final a = {'id': 'a', 'name': 'A', 'price': 10, 'stock': 2};
      final b = {'id': 'b', 'name': 'B', 'price': 5, 'stock': 0};
      cart.restore([
        {'product_id': 'a', 'quantity': 5, 'options': 'L'},
        {'product_id': 'b', 'quantity': 1},
        {'product_id': 'gone', 'quantity': 1},
      ], [a, b]);
      expect(cart.lines.length, 1);
      expect(cart.lines.single.quantity, 2);
      expect(cart.lines.single.options, 'L');
      expect(cart.total, 20);
    });
  });

  group('checkout', () {
    testWidgets('server totals: zone shipping, a code, the summary lines', (tester) async {
      tester.view.physicalSize = const Size(420, 1800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      final cart = StoreCart()..add(product(1), quantity: 4); // 4 × 15 = 60
      await tester.pumpWidget(app(CheckoutScreen(shop: shop(), cart: cart)));
      await settle(tester);

      // No governorate yet: «باقي المناطق» = the shop's flat fee (15).
      expect(find.text(money(75)), findsWidgets);
      expect(find.textContaining('شاي بالنعناع'), findsWidgets); // summary line
      expect(find.text('عندك كود خصم؟'), findsOneWidget);

      await tester.tap(find.text('عندك كود خصم؟'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(const ValueKey('checkout-code')), 'shai10');
      await tester.tap(find.text('تطبيق'));
      await settle(tester);
      expect(find.byKey(const ValueKey('checkout-code-chip')), findsOneWidget);
      expect(find.byKey(const ValueKey('checkout-discount')), findsOneWidget);
      expect(find.text('−${money(6)}'), findsOneWidget);
      expect(find.byKey(const ValueKey('checkout-total')), findsOneWidget);
      expect((tester.widget<Text>(find.byKey(const ValueKey('checkout-total')))).data, money(69));

      // A wrong code: a message, no discount.
      tester.widget<InputChip>(find.byKey(const ValueKey('checkout-code-chip'))).onDeleted!();
      await settle(tester);
      await tester.enterText(find.byKey(const ValueKey('checkout-code')), 'NOPE');
      await tester.tap(find.text('تطبيق'));
      await settle(tester);
      expect(find.text('الكود ده مش صحيح'), findsOneWidget);
      expect((tester.widget<Text>(find.byKey(const ValueKey('checkout-total')))).data, money(75));
    });

    testWidgets('blocking errors: under the minimum order the button is off', (tester) async {
      tester.view.physicalSize = const Size(420, 1800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      final cart = StoreCart()..add(product(1)); // 15 < the demo minimum 30
      await tester.pumpWidget(app(CheckoutScreen(shop: shop(), cart: cart)));
      await settle(tester);
      expect(find.textContaining('أقل طلب'), findsOneWidget);
      final button = tester.widget<ElevatedButton>(find.widgetWithText(ElevatedButton, 'تأكيد الطلب — ${money(30)}'));
      expect(button.onPressed, isNull);
    });

    testWidgets('0100: a store with Fawaterak offers «ادفع أونلاين» next to cash', (tester) async {
      tester.view.physicalSize = const Size(420, 4000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      var cod = true;
      CheckoutService.debugRpc = (fn, p) async {
        if (fn == 'shop_checkout_methods') return {'cod': cod, 'online': [{'provider': 'fawaterak', 'mode': 'test'}]};
        return await Supabase.instance.client.rpc(fn, params: p);
      };
      addTearDown(() => CheckoutService.debugRpc = null);
      final cart = StoreCart()..add(product(1), quantity: 4);
      await tester.pumpWidget(app(CheckoutScreen(shop: shop(), cart: cart)));
      await settle(tester);
      expect(find.byKey(const ValueKey('pay-online')), findsOneWidget);
      expect(find.byKey(const ValueKey('pay-cod')), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'تأكيد الطلب — ${money(75)}'), findsOneWidget); // cash by default
      await tester.ensureVisible(find.byKey(const ValueKey('pay-online')));
      await tester.tap(find.byKey(const ValueKey('pay-online')));
      await tester.pump();
      expect(find.widgetWithText(ElevatedButton, 'كمّل للدفع — ${money(75)}'), findsOneWidget);

      // Cash on delivery off: online is the only way.
      cod = false;
      await tester.pumpWidget(app(CheckoutScreen(key: UniqueKey(), shop: shop(), cart: cart)));
      await settle(tester);
      expect(find.byKey(const ValueKey('pay-cod')), findsNothing);
      expect(find.widgetWithText(ElevatedButton, 'كمّل للدفع — ${money(75)}'), findsOneWidget);
    });

    testWidgets('0100: the payment page lists Fawaterak methods and shows a Fawry code', (tester) async {
      tester.view.physicalSize = const Size(420, 1600);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      final calls = <Map<String, dynamic>>[];
      OnlinePayment.debugInvoke = (body) async {
        calls.add(body);
        return switch (body['action']) {
          'methods' => {
              'order': {'code': 'TABC2345', 'total': 75, 'currency': 'EGP', 'shop_name': 'محل'},
              'methods': [
                {'id': 2, 'name_ar': 'فيزا -ماستر كارد', 'redirect': true},
                {'id': 3, 'name_ar': 'فوري', 'redirect': false},
              ],
            },
          _ => {'codes': {'fawryCode': '981234567'}, 'expire_date': '2026-11-02'},
        };
      };
      addTearDown(() => OnlinePayment.debugInvoke = null);
      await tester.pumpWidget(app(const OnlinePaymentScreen(code: 'TABC2345', phone: '01011112222')));
      await settle(tester);
      expect((tester.widget<Text>(find.byKey(const ValueKey('pay-total')))).data, money(75));
      expect(find.text('فيزا -ماستر كارد'), findsOneWidget);
      expect(find.text('هتاخد كود تدفع بيه'), findsOneWidget);
      await tester.tap(find.byKey(const ValueKey('pay-method-3')));
      await settle(tester);
      expect(calls.last, {'action': 'pay', 'code': 'TABC2345', 'phone': '01011112222', 'method_id': 3});
      expect((tester.widget<Text>(find.byKey(const ValueKey('pay-code')))).data, '981234567');
      expect(find.text('كود فوري'), findsOneWidget);
    });
  });

  group('admin', () {
    Future<GoRouter> pumpAdmin(WidgetTester tester, double width, String location) async {
      tester.view.physicalSize = Size(width, 1600);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      // The admin runs as the merchant on the same tables.
      client.current = DemoHttpClient(store.asRole('merchant'));
      addTearDown(() => client.current = DemoHttpClient(store.asRole('customer')));
      MerchantSession.debugInstance = _TestSession(shop());
      StoreService.merchantCurrency = 'EGP';
      addTearDown(() => MerchantSession.debugInstance = null);
      final router = GoRouter(initialLocation: location, routes: [tajerAdminRoutes()]);
      addTearDown(router.dispose);
      await tester.pumpWidget(MaterialApp.router(
        routerConfig: router,
        locale: const Locale('ar'),
        supportedLocales: const [Locale('ar')],
        localizationsDelegates: const [GlobalMaterialLocalizations.delegate, GlobalWidgetsLocalizations.delegate, GlobalCupertinoLocalizations.delegate],
      ));
      await settle(tester);
      return router;
    }

    testWidgets('discounts: the list, then the form validates and saves a new code', (tester) async {
      final router = await pumpAdmin(tester, 1300, '/discounts');
      expect(find.text(DemoTajerCheckout.codeTen), findsOneWidget);
      expect(find.text('خصم 15% على الطلبات فوق 300 ج.م'), findsOneWidget);
      expect(find.textContaining('متوقف', findRichText: true), findsOneWidget); // RAMADAN

      await tester.tap(find.byKey(const ValueKey('new-discount')));
      await settle(tester);
      expect(router.routeInformationProvider.value.uri.path, '/discounts/new');

      await tester.enterText(find.byKey(const ValueKey('discount-code')), 'a');
      await tester.enterText(find.byKey(const ValueKey('discount-value')), '25');
      await tester.ensureVisible(find.byKey(const ValueKey('save-discount')));
      await tester.tap(find.byKey(const ValueKey('save-discount')));
      await settle(tester);
      expect(find.byKey(const ValueKey('discount-error')), findsOneWidget);
      expect(find.textContaining('من 3 لـ 30'), findsOneWidget);

      await tester.enterText(find.byKey(const ValueKey('discount-code')), 'eid25');
      await tester.enterText(find.byKey(const ValueKey('discount-value')), '250');
      await tester.tap(find.byKey(const ValueKey('save-discount')));
      await settle(tester);
      expect(find.textContaining('من 1 لـ 100'), findsOneWidget);

      await tester.enterText(find.byKey(const ValueKey('discount-value')), '25');
      await tester.enterText(find.byKey(const ValueKey('discount-min')), '150');
      await tester.tap(find.byKey(const ValueKey('save-discount')));
      await settle(tester);
      expect(router.routeInformationProvider.value.uri.path, '/discounts');
      expect(find.text('EID25'), findsOneWidget);
      final row = store.t('shop_discounts').firstWhere((d) => d['code'] == 'EID25');
      expect(row['value'], 25);
      expect(row['min_subtotal'], 150);
      expect(row['type'], 'percent');
    });

    testWidgets('shipping: zones, pickup and the save', (tester) async {
      await pumpAdmin(tester, 1300, '/settings/shipping');
      expect(find.text('القاهرة والجيزة'), findsOneWidget);
      expect(find.text('الإسكندرية'), findsOneWidget);
      await tester.tap(find.byKey(const ValueKey('add-zone')));
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(const ValueKey('zone-name')), 'الصعيد');
      await tester.tap(find.widgetWithText(FilterChip, 'أسوان'));
      await tester.tap(find.widgetWithText(FilterChip, 'الأقصر'));
      await tester.enterText(find.byKey(const ValueKey('zone-fee')), '70');
      await tester.tap(find.byKey(const ValueKey('zone-done')));
      await tester.pumpAndSettle();
      expect(find.text('الصعيد'), findsOneWidget);
      await tester.scrollUntilVisible(find.byKey(const ValueKey('save-shipping')), 400, scrollable: find.byType(Scrollable).first);
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('save-shipping')));
      await settle(tester);
      final z = store.t('shop_shipping_zones').firstWhere((z) => z['name'] == 'الصعيد');
      expect(z['areas'], ['الأقصر', 'أسوان']);
      expect(z['fee'], 70);
    });

    testWidgets('abandoned carts: older than an hour, with «كمّل طلبك»', (tester) async {
      await pumpAdmin(tester, 1300, '/orders/abandoned');
      expect(find.text('نورهان سعيد'), findsOneWidget);
      expect(find.text('مريم خالد'), findsOneWidget);
      expect(find.text('يوسف عادل'), findsNothing); // 20 minutes: not abandoned yet
      expect(find.text('كمّل طلبك'), findsNWidgets(3));
      expect(find.textContaining('اتبعتله تذكير', findRichText: true), findsOneWidget);
    });
  });
}
