import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mogtama3y/core/demo/demo_http_client.dart';
import 'package:mogtama3y/core/demo/demo_store.dart';
import 'package:mogtama3y/core/shops/store_service.dart';
import 'package:mogtama3y/features/merchant/admin/admin_shell.dart';
import 'package:mogtama3y/features/merchant/admin/merchant_session.dart';
import 'package:mogtama3y/features/merchant/admin/tajer_routes.dart';
import 'package:mogtama3y/features/merchant/order_detail.dart';
import 'package:mogtama3y/features/merchant/order_print.dart';
import 'package:mogtama3y/features/merchant/orders_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// متجري's admin (phase 1): the responsive shell at phone / tablet /
/// desktop widths, and the orders table → order detail, driven by the
/// demo build's in-memory backend through the real StoreService.
class _MemoryAsyncStorage extends GotrueAsyncStorage {
  final _items = <String, String>{};

  @override
  Future<String?> getItem({required String key}) async => _items[key];

  @override
  Future<void> setItem({required String key, required String value}) async => _items[key] = value;

  @override
  Future<void> removeItem({required String key}) async => _items.remove(key);
}

/// The demo shop, loaded up front (no Realtime, no polling timers).
class _TestSession extends MerchantSession {
  _TestSession(Map<String, dynamic> shop) {
    shops = [shop];
    loading = false;
    newOrders = 2;
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

  setUpAll(() async {
    store = DemoStore.boot(role: 'merchant', flavor: 'tajer', persist: false);
    await Supabase.initialize(
      url: 'http://demo.invalid',
      publishableKey: 'test-key',
      httpClient: DemoHttpClient(store),
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
    // No network images in widget tests.
    s['logo_url'] = null;
    s['cover_image_url'] = null;
    return s;
  }

  /// The demo backend answers after 140 ms timers: let them all run.
  Future<void> settle(WidgetTester tester) async {
    for (var i = 0; i < 8; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    await tester.pumpAndSettle();
  }

  Future<void> scrollDetailTo(WidgetTester tester, Finder target) async {
    await tester.scrollUntilVisible(target, 250,
        scrollable: find.descendant(of: find.byType(OrderDetailView), matching: find.byType(Scrollable)).first);
    await tester.pumpAndSettle();
  }

  Future<GoRouter> pumpAdmin(WidgetTester tester, double width, String location) async {
    tester.view.physicalSize = Size(width, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
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

  group('responsive shell', () {
    testWidgets('phone (< 600): bottom bar with the four tabs and the badge', (tester) async {
      await pumpAdmin(tester, 400, '/customers');
      expect(find.byType(NavigationBar), findsOneWidget);
      expect(find.byType(NavigationRail), findsNothing);
      expect(find.text('شوف متجرك'), findsNothing);
      for (final l in ['الرئيسية', 'المنتجات', 'الطلبات', 'متجري']) {
        expect(find.descendant(of: find.byType(NavigationBar), matching: find.text(l)), findsOneWidget);
      }
      expect(find.descendant(of: find.byType(NavigationBar), matching: find.text('2')), findsOneWidget);
      expect(find.text('قريباً'), findsOneWidget); // the page itself
    });

    testWidgets('tablet (600–1024): NavigationRail with every destination', (tester) async {
      await pumpAdmin(tester, 800, '/customers');
      expect(find.byType(NavigationRail), findsOneWidget);
      expect(find.byType(NavigationBar), findsNothing);
      for (final d in adminDestinations) {
        expect(find.descendant(of: find.byType(NavigationRail), matching: find.text(d.label)), findsOneWidget);
      }
    });

    testWidgets('desktop (≥ 1024): sidebar with shop, nav, view store, account', (tester) async {
      final router = await pumpAdmin(tester, 1300, '/customers');
      expect(find.byType(NavigationRail), findsNothing);
      expect(find.byType(NavigationBar), findsNothing);
      expect(find.text('شوف متجرك'), findsOneWidget);
      expect(find.text(DemoTajer.shopName), findsOneWidget);
      expect(find.text('الخصومات'), findsOneWidget);
      expect(find.text('قريباً'), findsNWidgets(2)); // the «العملاء» sidebar pill + the page (الخصومات is live since 0099)
      await tester.tap(find.text('الخصومات'));
      await settle(tester);
      expect(router.routerDelegate.currentConfiguration.uri.path, '/discounts');
    });
  });

  testWidgets('desktop dashboard keeps the sidebar once the numbers load', (tester) async {
    await pumpAdmin(tester, 1300, '/dashboard');
    expect(find.text('مبيعات النهارده'), findsOneWidget);
    expect(find.text('شوف متجرك'), findsOneWidget);
  });

  group('orders', () {
    testWidgets('desktop: table → master–detail with the timeline', (tester) async {
      final router = await pumpAdmin(tester, 1300, '/orders');
      expect(find.byType(OrdersTable), findsOneWidget);
      for (final h in ['الكود', 'التاريخ', 'الزبون', 'الإجمالي', 'الحالة', 'الدفع']) {
        expect(find.descendant(of: find.byType(OrdersTable), matching: find.text(h)), findsOneWidget);
      }
      expect(find.text(DemoTajer.orderPlaced), findsOneWidget);
      expect(find.text('الكل (8)'), findsOneWidget);
      expect(find.text('جديدة (2)'), findsOneWidget);

      // Status filter (server-side): cancelled only, then back to all.
      await tester.ensureVisible(find.text('ملغية (1)'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('ملغية (1)'));
      await settle(tester);
      expect(find.text(DemoTajer.orderCancelled), findsOneWidget);
      expect(find.text(DemoTajer.orderPlaced), findsNothing);
      await tester.ensureVisible(find.text('الكل (8)'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('الكل (8)'));
      await settle(tester);

      await tester.tap(find.text(DemoTajer.orderDelivering));
      await settle(tester);
      expect(router.routerDelegate.currentConfiguration.uri.path, startsWith('/orders/'));
      expect(find.byType(OrdersTable), findsNothing); // compact list beside the order
      expect(find.byType(OrderDetailView), findsOneWidget);
      expect(find.text('عمر طارق'), findsWidgets);
      expect(find.text('نسكافيه باللبن'), findsOneWidget); // snapshot line
      expect(find.text('الحجم: وسط'), findsOneWidget);
      await scrollDetailTo(tester, find.text('الزبون عمل الطلب'));
      expect(find.text('سجل الطلب'), findsOneWidget);
      expect(find.textContaining('الطيار أحمد'), findsWidgets); // internal note
    });

    testWidgets('phone: cards → the order alone with a back arrow', (tester) async {
      final router = await pumpAdmin(tester, 400, '/orders');
      expect(find.byType(OrdersTable), findsNothing);
      expect(find.byType(OrderCard), findsWidgets);
      await tester.tap(find.textContaining('طلب ${DemoTajer.orderPlaced}'));
      await settle(tester);
      expect(find.byType(OrderDetailView), findsOneWidget);
      expect(find.text('تفاصيل الطلب'), findsOneWidget);
      expect(find.text('شاي بالنعناع'), findsOneWidget);
      await tester.tap(find.byTooltip('رجوع'));
      await settle(tester);
      expect(router.routerDelegate.currentConfiguration.uri.path, '/orders');
      expect(find.byType(OrderCard), findsWidgets);
    });

    testWidgets('a status change from the detail is written to the timeline', (tester) async {
      await pumpAdmin(tester, 1300, '/orders');
      await tester.tap(find.text(DemoTajer.orderPlaced2));
      await settle(tester);
      await tester.tap(find.text('ابدأ التجهيز').last);
      await settle(tester);
      await scrollDetailTo(tester, find.textContaining('الحالة بقت «بيتجهّز»'));
      expect(find.textContaining('الحالة بقت «بيتجهّز»'), findsOneWidget);
    });
  });

  group('invoice & CSV', () {
    final order = {
      'order_code': 'T7K4M2QX',
      'created_at': '2026-10-17T10:00:00Z',
      'status': 'placed',
      'customer_name': 'منى <script>alert(1)</script>',
      'customer_phone': '01000000301',
      'delivery_address': 'شارع 9، المعادي',
      'note': '=HYPERLINK("x")',
      'total_amount': 89,
      'delivery_fee': 15,
      'currency': 'EGP',
      'items': [
        {'product_name': 'شاي بالنعناع', 'variant_label': null, 'quantity': 2, 'unit_price': 15, 'image_url': 'javascript:alert(1)'},
        {'product_name': 'بسبوسة "بالقشطة"', 'variant_label': 'كبير', 'quantity': 2, 'unit_price': 22, 'image_url': 'https://x.test/b.jpg'},
      ],
    };
    final s = {'name': 'بيت الشاي', 'logo_url': 'https://x.test/logo.jpg', 'currency': 'EGP'};

    test('invoice: escaped, totals, QR to the tracking link', () {
      final html = ordersPrintHtml(shop: s, orders: [order]);
      expect(html, isNot(contains('<script>alert')));
      expect(html, contains('&lt;script&gt;'));
      expect(html, isNot(contains('javascript:')));
      expect(html, contains('https://x.test/b.jpg'));
      expect(html, contains('فاتورة'));
      expect(html, contains('<svg'));
      expect(html, contains('كاش عند الاستلام'));
      expect(html, contains('size:A5'));
    });

    test('packing slip: no prices', () {
      final html = ordersPrintHtml(shop: s, orders: [order, order], packingSlip: true);
      expect(html, contains('قائمة تجهيز'));
      expect(html, isNot(contains('الإجمالي')));
      expect(RegExp('class="doc"').allMatches(html).length, 2);
    });

    test('CSV: BOM, header, quoting, no formulas', () {
      final csv = ordersCsv([order]);
      expect(csv.startsWith('﻿"الكود"'), isTrue);
      final lines = csv.split('\r\n');
      expect(lines.length, 3); // header, row, trailing
      expect(lines[1], contains('"T7K4M2QX"'));
      expect(lines[1], contains('بسبوسة ""بالقشطة"" (كبير) × 2'));
      expect(lines[1], contains('"\'=HYPERLINK(""x"")"'));
      expect(lines[1], contains('"89"'));
    });

    test('timeline text', () {
      expect(OrderTimeline.describe({'kind': 'cancel', 'actor_role': 'merchant', 'body': 'طلب مكرر'}), contains('السبب: طلب مكرر'));
      expect(OrderTimeline.describe({'kind': 'status', 'to_status': 'delivering', 'actor_role': 'merchant', 'actor_name': 'حسن'}), 'الحالة بقت «في الطريق» — المحل (حسن)');
    });
  });
}
