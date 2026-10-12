import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mogtama3y/core/pwa/install_advice.dart';
import 'package:mogtama3y/core/support/feedback_route_observer.dart';
import 'package:mogtama3y/features/shared/install_app_overlay.dart';
import 'package:mogtama3y/features/support/feedback_fab.dart';

const androidChrome =
    'Mozilla/5.0 (Linux; Android 14; Pixel 8) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/129.0.0.0 Mobile Safari/537.36';
const androidFacebook =
    'Mozilla/5.0 (Linux; Android 14; SM-S918B Build/UP1A.231005.007; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/129.0.6668.81 Mobile Safari/537.36 [FB_IAB/FB4A;FBAV/480.0.0.38.109;]';
const androidFirefox = 'Mozilla/5.0 (Android 14; Mobile; rv:131.0) Gecko/131.0 Firefox/131.0';
const iosSafari =
    'Mozilla/5.0 (iPhone; CPU iPhone OS 17_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.5 Mobile/15E148 Safari/604.1';
const iosChrome =
    'Mozilla/5.0 (iPhone; CPU iPhone OS 17_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/129.0.6668.69 Mobile/15E148 Safari/604.1';
const iosChromeOld =
    'Mozilla/5.0 (iPhone; CPU iPhone OS 16_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/110.0 Mobile/15E148 Safari/604.1';
const iosInstagram =
    'Mozilla/5.0 (iPhone; CPU iPhone OS 17_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 Instagram 345.0.0.34.103 (iPhone14,5; iOS 17_5; ar_EG)';
const desktop =
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/129.0.0.0 Safari/537.36';

class FakeInstallPlatform extends InstallPlatform {
  FakeInstallPlatform(this.userAgent, {this.hasInstallEvent = false, this.isInstalled = false});

  @override
  final String userAgent;
  @override
  bool hasInstallEvent;
  @override
  bool isInstalled;
  @override
  bool justInstalled = false;
  @override
  bool get iPadDesktopMode => false;

  int prompts = 0;
  int chromeOpens = 0;
  final local = <String, String>{};
  final session = <String, String>{};

  @override
  bool prompt() {
    prompts++;
    return true;
  }

  @override
  String? read(String key, {bool session = false}) => (session ? this.session : local)[key];
  @override
  void write(String key, String value, {bool session = false}) => (session ? this.session : local)[key] = value;
  @override
  Future<bool> copyLink() async => true;
  @override
  void openInChrome() => chromeOpens++;
}

void main() {
  group('decideInstallAdvice', () {
    InstallAdvice d(String ua, {bool event = false, bool installed = false, bool dismissed = false}) =>
        decideInstallAdvice(userAgent: ua, hasInstallEvent: event, isInstalled: installed, isDismissed: dismissed);

    test('Android with beforeinstallprompt → one-tap install', () {
      expect(d(androidChrome, event: true), InstallAdvice.androidPrompt);
    });
    test('Android without the event → browser menu steps', () {
      expect(d(androidChrome), InstallAdvice.androidMenu);
      expect(d(androidFirefox), InstallAdvice.androidMenu);
    });
    test('Android in-app browser → open in Chrome', () {
      expect(d(androidFacebook), InstallAdvice.androidInApp);
    });
    test('iOS Safari → Share steps', () {
      expect(d(iosSafari), InstallAdvice.iosSafari);
    });
    test('iOS Chrome 16.4+ → Share steps from its own button; older → Safari', () {
      expect(d(iosChrome), InstallAdvice.iosOtherBrowser);
      expect(d(iosChromeOld), InstallAdvice.iosInApp);
    });
    test('iOS webview → open in Safari first', () {
      expect(d(iosInstagram), InstallAdvice.iosInApp);
    });
    test('iPadOS in desktop mode counts as iOS', () {
      const mac =
          'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.5 Safari/605.1.15';
      expect(decideInstallAdvice(userAgent: mac, hasInstallEvent: false, isInstalled: false, isDismissed: false),
          InstallAdvice.none);
      expect(
          decideInstallAdvice(
              userAgent: mac, hasInstallEvent: false, isInstalled: false, isDismissed: false, iPadDesktopMode: true),
          InstallAdvice.iosSafari);
    });
    test('installed / dismissed / desktop / Lighthouse → nothing', () {
      expect(d(androidChrome, event: true, installed: true), InstallAdvice.none);
      expect(d(iosSafari, dismissed: true), InstallAdvice.none);
      expect(d(desktop, event: true), InstallAdvice.none);
      expect(d('$androidChrome Chrome-Lighthouse'), InstallAdvice.none);
    });
  });

  group('InstallAppOverlay (inside the «كلّمنا» host)', () {
    late FeedbackRouteObserver observer;
    late GoRouter router;

    Future<void> pumpApp(WidgetTester tester, String initial, FakeInstallPlatform p) async {
      observer = FeedbackRouteObserver();
      router = GoRouter(
        initialLocation: initial,
        observers: [observer],
        routes: [
          GoRoute(
            path: '/',
            builder: (_, _) => const Scaffold(body: Text('home')),
            routes: [
              GoRoute(path: 'marketplace', builder: (_, _) => const Scaffold(body: Text('market'))),
              GoRoute(path: 'login', builder: (_, _) => const Scaffold(body: Text('login'))),
              GoRoute(path: 'chat/:id', builder: (_, _) => const Scaffold(body: Text('chat'))),
            ],
          ),
        ],
      );
      await tester.pumpWidget(MaterialApp.router(
        routerConfig: router,
        builder: (context, child) => Directionality(
          textDirection: TextDirection.rtl,
          child: FeedbackFabHost(router: router, observer: observer, installPlatform: p, child: child!),
        ),
      ));
      await tester.pumpAndSettle();
    }

    final card = find.byKey(const ValueKey('install-card'));
    final fab = find.byKey(const ValueKey('feedback-fab'));

    setUp(() => FeedbackFabHost.hiddenForSession.value = false);

    testWidgets('Android with the event: appears after ~5 s, «نزّله» prompts', (tester) async {
      final p = FakeInstallPlatform(androidChrome, hasInstallEvent: true);
      await pumpApp(tester, '/marketplace', p);
      expect(card, findsNothing);
      await tester.pump(const Duration(seconds: 5));
      await tester.pump();
      expect(card, findsOneWidget);
      expect(p.session[installShownKey], '1');
      // Beside the «كلّمنا» button, not on top of it.
      expect(tester.getRect(card).overlaps(tester.getRect(fab)), isFalse);
      await tester.tap(find.byKey(const ValueKey('install-now')));
      await tester.pump();
      expect(p.prompts, 1);
      expect(card, findsNothing);
    });

    testWidgets('Android without the event shows the menu hint, upgrades when the event arrives', (tester) async {
      final p = FakeInstallPlatform(androidChrome);
      await pumpApp(tester, '/marketplace', p);
      await tester.pump(const Duration(seconds: 5));
      await tester.pump();
      expect(find.textContaining('تثبيت التطبيق'), findsOneWidget);
      expect(find.byKey(const ValueKey('install-now')), findsNothing);
      p.hasInstallEvent = true;
      await tester.pump(const Duration(seconds: 2));
      await tester.pump();
      expect(find.byKey(const ValueKey('install-now')), findsOneWidget);
    });

    testWidgets('Android in-app browser: «افتح في Chrome»', (tester) async {
      final p = FakeInstallPlatform(androidFacebook);
      await pumpApp(tester, '/marketplace', p);
      await tester.pump(const Duration(seconds: 5));
      await tester.pump();
      await tester.tap(find.byKey(const ValueKey('install-open-chrome')));
      expect(p.chromeOpens, 1);
      expect(find.byKey(const ValueKey('install-copy')), findsOneWidget);
    });

    testWidgets('iOS Safari: «إزاي؟» opens the 3 steps', (tester) async {
      final p = FakeInstallPlatform(iosSafari);
      await pumpApp(tester, '/marketplace', p);
      await tester.pump(const Duration(seconds: 5));
      await tester.pump();
      await tester.tap(find.byKey(const ValueKey('install-how')));
      await tester.pumpAndSettle();
      expect(find.textContaining('إضافة إلى الشاشة الرئيسية'), findsOneWidget);
      expect(find.textContaining('دوس «إضافة»'), findsOneWidget);
      expect(card, findsNothing); // a sheet is on top
    });

    testWidgets('iOS webview: open in Safari + copy link', (tester) async {
      final p = FakeInstallPlatform(iosInstagram);
      await pumpApp(tester, '/marketplace', p);
      await tester.pump(const Duration(seconds: 5));
      await tester.pump();
      expect(find.textContaining('Safari'), findsOneWidget);
      expect(find.byKey(const ValueKey('install-copy')), findsOneWidget);
      expect(find.byKey(const ValueKey('install-how')), findsNothing);
    });

    testWidgets('✕ hides it for 7 days (shared key)', (tester) async {
      final p = FakeInstallPlatform(iosSafari);
      await pumpApp(tester, '/marketplace', p);
      await tester.pump(const Duration(seconds: 5));
      await tester.pump();
      await tester.tap(find.byKey(const ValueKey('install-dismiss')));
      await tester.pump();
      expect(card, findsNothing);
      final until = int.parse(p.local[installDismissKey]!);
      final days = DateTime.fromMillisecondsSinceEpoch(until).difference(DateTime.now()).inHours / 24;
      expect(days, closeTo(7, 0.1));
    });

    testWidgets('not shown when dismissed, installed, on desktop, or already shown this session', (tester) async {
      final cases = [
        FakeInstallPlatform(iosSafari)
          ..local[installDismissKey] = '${DateTime.now().add(const Duration(days: 3)).millisecondsSinceEpoch}',
        FakeInstallPlatform(androidChrome, hasInstallEvent: true, isInstalled: true),
        FakeInstallPlatform(desktop, hasInstallEvent: true),
        FakeInstallPlatform(androidChrome, hasInstallEvent: true)..session[installShownKey] = '1',
      ];
      for (final p in cases) {
        await pumpApp(tester, '/marketplace', p);
        await tester.pump(const Duration(seconds: 6));
        await tester.pump();
        expect(card, findsNothing, reason: p.userAgent);
        await tester.pumpWidget(const SizedBox());
      }
    });

    testWidgets('stays away from sign-in and chats, comes back on a normal screen', (tester) async {
      final p = FakeInstallPlatform(androidChrome, hasInstallEvent: true);
      await pumpApp(tester, '/login', p);
      await tester.pump(const Duration(seconds: 5));
      await tester.pump();
      expect(card, findsNothing);
      expect(p.session[installShownKey], isNull);
      router.go('/chat/0d5b6c3e-1111-2222-3333-444455556666');
      await tester.pumpAndSettle();
      expect(card, findsNothing);
      router.go('/marketplace');
      await tester.pumpAndSettle();
      expect(card, findsOneWidget);
    });

    testWidgets('appinstalled → thank-you, then gone', (tester) async {
      final p = FakeInstallPlatform(androidChrome, hasInstallEvent: true);
      await pumpApp(tester, '/marketplace', p);
      await tester.pump(const Duration(seconds: 5));
      await tester.pump();
      p.justInstalled = true;
      await tester.pump(const Duration(seconds: 2));
      await tester.pump();
      expect(find.textContaining('شكراً'), findsOneWidget);
      await tester.pump(const Duration(seconds: 4));
      await tester.pump();
      expect(card, findsNothing);
    });
  });
}
