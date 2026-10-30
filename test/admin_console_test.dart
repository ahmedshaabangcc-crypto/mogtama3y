import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mogtama3y/core/admin/admin_console_service.dart';
import 'package:mogtama3y/features/admin/console/admin_console_screen.dart';
import 'package:mogtama3y/features/admin/console/console_widgets.dart';
import 'package:mogtama3y/features/admin/console/overview_page.dart';

/// The super-admin console (0106): sidebar on a computer, live KPI
/// overview, users / payments / stores tables — on a fake backend.
void main() {
  setUpAll(() => initializeDateFormatting('ar'));

  final calls = <String>[];
  var suspended = false;
  String? lastReason;
  var ppStatus = 'pending';
  Map<String, dynamic>? lastPayout;
  setUp(() {
    calls.clear();
    suspended = false;
    lastReason = null;
    ppStatus = 'pending';
    lastPayout = null;
    final today = DateTime.now();
    AdminConsoleService.debugRpc = (fn, p) async {
      calls.add(fn);
      switch (fn) {
        case 'admin_overview':
          return {
            'users': {'total': 1234, 'today': 7, 'week': 40, 'month': 150, 'active_24h': 88, 'verified_phone': 900, 'by_country': [{'country': 'EG', 'n': 1200}, {'country': 'SA', 'n': 34}]},
            'shops': {'total': 47, 'with_owner': 12, 'with_products': 9, 'online_payments': 1, 'orders_today': 3, 'orders_month': 61, 'sales_month': [{'currency': 'EGP', 'total': 15400}]},
            'community': {'buildings': 2, 'presidents': 1, 'members': 5, 'reports_month': 4, 'held_escrow': 0},
            'tokens': {'revenue_today': 45, 'revenue_month': 300, 'online_month': 45, 'awaiting_online': 1, 'balance_total': 20, 'online_enabled': true},
            'queues': {'token_topups': 2, 'wallet_topups': 0, 'withdrawals': 1, 'fund_withdrawals': 0, 'shop_claims': 0, 'disputes': 0, 'reports_new': 1, 'place_reports': 0, 'tickets': 0},
          };
        case 'admin_series':
          return [
            for (var i = 29; i >= 0; i--)
              {'day': today.subtract(Duration(days: i)).toIso8601String().substring(0, 10), 'signups': i % 5, 'orders': i % 3, 'tokens': i == 0 ? 45 : 0},
          ];
        case 'admin_users':
          return {
            'total': 2,
            'rows': [
              {'id': 'u1', 'full_name': 'منى أحمد', 'phone': '01011112222', 'country': 'EG', 'role': 'user', 'phone_verified': true, 'created_at': today.toIso8601String(), 'last_sign_in_at': today.toIso8601String(), 'shops': 1, 'ad_token_balance': 3},
              {'id': 'u2', 'full_name': 'أحمد شعبان', 'phone': '01000000000', 'country': 'EG', 'role': 'super_admin', 'phone_verified': false, 'created_at': today.toIso8601String(), 'last_sign_in_at': null, 'shops': 0, 'ad_token_balance': 0},
            ],
          };
        case 'admin_token_payments':
          return {
            'total': 1,
            'approved_sum': 300,
            'rows': [
              {'id': 't1', 'tokens_requested': 3, 'amount_egp': 45, 'status': p['p_status'] ?? 'awaiting_payment', 'method': 'online', 'created_at': today.toIso8601String(), 'full_name': 'منى أحمد', 'phone': '01011112222'},
            ],
          };
        case 'admin_set_shop_suspended':
          suspended = p['p_suspend'] == true;
          lastReason = p['p_reason'] as String?;
          return {'id': p['p_shop'], 'suspended': suspended};
        case 'admin_platform_pay_list':
          return [
            {
              'shop_id': 's1', 'shop_name': 'محل الشاي', 'owner_name': 'منى أحمد', 'owner_phone': '01011112222', 'status': ppStatus,
              'entity': 'individual', 'legal_name': 'منى أحمد علي', 'id_number': '29001011234567', 'documents': ['u1/platform_pay/a.jpg', 'u1/platform_pay/b.jpg'],
              'payout': {'method': 'instapay', 'handle': 'mona@instapay'}, 'submitted_at': today.toIso8601String(),
              'balance': {'orders': 2, 'gross': 1000, 'fees': 27.5, 'commission': 0, 'paid_out': 0, 'due': 972.5, 'currency': 'EGP'},
            },
          ];
        case 'admin_platform_pay_review':
          ppStatus = p['p_action'] == 'approve' ? 'approved' : p['p_action'] == 'reject' ? 'rejected' : 'suspended';
          return null;
        case 'admin_record_payout':
          lastPayout = p;
          return {'due': 0};
        case 'admin_shops':
          return {
            'total': 1,
            'rows': [
              {'id': 's1', 'name': 'محل الشاي', 'slug': 'tea', 'category': 'مشروبات', 'country': 'EG', 'currency': 'EGP', 'owner_name': 'منى أحمد', 'owner_phone': '01011112222', 'products': 12, 'orders': 30, 'sales': 4500, 'gateway': 'fawaterak', 'last_order_at': today.toIso8601String(), 'created_at': today.toIso8601String(), 'suspended_at': suspended ? today.toIso8601String() : null, 'suspended_reason': suspended ? lastReason : null},
            ],
          };
      }
      return null;
    };
  });
  tearDown(() => AdminConsoleService.debugRpc = null);

  Widget app(Widget home) => MaterialApp(
        locale: const Locale('ar'),
        supportedLocales: const [Locale('ar')],
        localizationsDelegates: const [GlobalMaterialLocalizations.delegate, GlobalWidgetsLocalizations.delegate, GlobalCupertinoLocalizations.delegate],
        home: home,
      );

  Future<void> desktop(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1440, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
  }

  testWidgets('a computer gets the sidebar and the live KPI overview', (tester) async {
    await desktop(tester);
    await tester.pumpWidget(app(const AdminConsoleScreen()));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('console-nav-overview')), findsOneWidget);
    expect(find.byKey(const ValueKey('console-nav-shops')), findsOneWidget);
    expect(find.byType(Drawer), findsNothing);
    expect(find.text('إجمالي المشتركين'), findsOneWidget);
    expect(find.text(fmtCount(1234)), findsOneWidget);
    expect(find.text('+${fmtCount(7)} النهارده'), findsOneWidget);
    expect(find.text('دخلوا آخر 24 ساعة'), findsOneWidget);
    expect(find.text('طلبات النهارده'), findsOneWidget);
    expect(find.text('إيراد الشهر'), findsOneWidget);
    expect(find.byType(DailyBars), findsNWidgets(3));
    expect(find.byKey(const ValueKey('console-live')), findsOneWidget);
    expect(calls, containsAll(['admin_overview', 'admin_series']));
  });

  testWidgets('the overview refreshes itself (لحظة بلحظة)', (tester) async {
    await desktop(tester);
    await tester.pumpWidget(app(Scaffold(body: AdminOverviewPage(onOpen: (_) {}, refreshEvery: const Duration(seconds: 2)))));
    await tester.pumpAndSettle();
    final before = calls.where((c) => c == 'admin_overview').length;
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();
    expect(calls.where((c) => c == 'admin_overview').length, before + 1);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('the sidebar opens users, payments and stores tables', (tester) async {
    await desktop(tester);
    await tester.pumpWidget(app(const AdminConsoleScreen()));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('console-nav-users')));
    await tester.pumpAndSettle();
    expect((tester.widget<Text>(find.byKey(const ValueKey('console-title')))).data, 'المشتركين');
    expect(find.text('منى أحمد'), findsOneWidget);
    expect(find.text('أدمن'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('console-nav-payments')));
    await tester.pumpAndSettle();
    expect(find.text('أونلاين (فواتيرك)'), findsOneWidget);
    expect(find.text('مستني الدفع'), findsWidgets);
    await tester.tap(find.widgetWithText(ChoiceChip, 'اتدفع'));
    await tester.pumpAndSettle();
    expect(calls.last, 'admin_token_payments');

    await tester.tap(find.byKey(const ValueKey('console-nav-shops')));
    await tester.pumpAndSettle();
    expect(find.text('محل الشاي'), findsOneWidget);
    expect(find.text('فواتيرك'), findsOneWidget);

    // A KPI card on the overview jumps to its page.
    await tester.tap(find.byKey(const ValueKey('console-nav-overview')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('المتاجر').last);
    await tester.pumpAndSettle();
    expect((tester.widget<Text>(find.byKey(const ValueKey('console-title')))).data, 'المتاجر');
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('0107: the admin suspends a store with a reason, then restores it', (tester) async {
    await desktop(tester);
    await tester.pumpWidget(app(const AdminConsoleScreen(initialPage: 'shops')));
    await tester.pumpAndSettle();
    expect(find.text('شغال'), findsOneWidget);
    tester.widget<TextButton>(find.byKey(const ValueKey('shop-toggle-s1'))).onPressed!(); // the last column may be scrolled off
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const ValueKey('suspend-reason')), 'منتجات مقلّدة');
    await tester.tap(find.text('أوقف المتجر'));
    await tester.pumpAndSettle();
    expect(lastReason, 'منتجات مقلّدة');
    expect(find.text('موقوف'), findsOneWidget);
    tester.widget<TextButton>(find.byKey(const ValueKey('shop-toggle-s1'))).onPressed!(); // the last column may be scrolled off
    await tester.pumpAndSettle();
    expect(suspended, isFalse);
    expect(find.text('شغال'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('0108: the admin reviews «اربط مع مُجتمعي» papers, approves, and records a payout', (tester) async {
    await desktop(tester);
    await tester.pumpWidget(app(const AdminConsoleScreen(initialPage: 'platform_pay')));
    await tester.pumpAndSettle();
    expect(find.text('منى أحمد علي'), findsOneWidget);
    expect(find.text('29001011234567'), findsOneWidget);
    expect(find.text('ورقة 2'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('pp-approve-s1')));
    await tester.pumpAndSettle();
    expect(ppStatus, 'approved');
    await tester.tap(find.widgetWithText(ChoiceChip, 'الكل'));
    await tester.pumpAndSettle();
    expect(find.textContaining('المستحق'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('pp-payout-s1')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('سجّل التحويل'));
    await tester.pumpAndSettle();
    expect(lastPayout?['p_amount'], 972.5);
    expect(lastPayout?['p_method'], 'instapay');
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('a phone gets a drawer instead of the sidebar', (tester) async {
    tester.view.physicalSize = const Size(400, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(app(const AdminConsoleScreen()));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('console-nav-users')), findsNothing);
    await tester.tap(find.byIcon(Icons.menu_rounded));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('console-nav-users')));
    await tester.pumpAndSettle();
    expect(find.text('منى أحمد'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });
}
