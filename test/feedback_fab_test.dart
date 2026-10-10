import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mogtama3y/core/support/feedback_route_observer.dart';
import 'package:mogtama3y/features/support/feedback_fab.dart';

/// The floating «كلّمنا» button (features/support/feedback_fab.dart).
void main() {
  late FeedbackRouteObserver observer;
  late GoRouter router;

  Future<void> pumpApp(WidgetTester tester, String initial) async {
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
            GoRoute(path: 'chat/:id', builder: (_, _) => const Scaffold(body: Text('chat'))),
          ],
        ),
      ],
    );
    await tester.pumpWidget(MaterialApp.router(
      routerConfig: router,
      builder: (context, child) => Directionality(
        textDirection: TextDirection.rtl,
        child: FeedbackFabHost(router: router, observer: observer, child: child!),
      ),
    ));
    await tester.pumpAndSettle();
  }

  final fab = find.byKey(const ValueKey('feedback-fab'));

  setUp(() => FeedbackFabHost.hiddenForSession.value = false);

  testWidgets('shows on a normal screen, on the right (start) side in RTL', (tester) async {
    await pumpApp(tester, '/marketplace');
    expect(find.text('market'), findsOneWidget);
    expect(fab, findsOneWidget);
    final box = tester.getRect(fab);
    expect(box.center.dx, greaterThan(tester.view.physicalSize.width / tester.view.devicePixelRatio / 2));
  });

  testWidgets('is lifted above the bottom nav on the home shell', (tester) async {
    await pumpApp(tester, '/');
    final screenH = tester.view.physicalSize.height / tester.view.devicePixelRatio;
    expect(screenH - tester.getRect(fab).bottom, greaterThanOrEqualTo(150));
  });

  testWidgets('is hidden on a chat route', (tester) async {
    await pumpApp(tester, '/chat/0d5b6c3e-1111-2222-3333-444455556666');
    expect(find.text('chat'), findsOneWidget);
    expect(fab, findsNothing);
    router.go('/marketplace');
    await tester.pumpAndSettle();
    expect(fab, findsOneWidget);
  });

  testWidgets('is hidden while a dialog is open', (tester) async {
    await pumpApp(tester, '/marketplace');
    showDialog<void>(context: observer.navigator!.context, builder: (_) => const AlertDialog(content: Text('d')));
    await tester.pumpAndSettle();
    expect(fab, findsNothing);
  });

  testWidgets('long-press → «إخفاء» hides it for the session', (tester) async {
    await pumpApp(tester, '/marketplace');
    await tester.longPress(fab);
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('feedback-fab-hide')));
    await tester.pumpAndSettle();
    expect(fab, findsNothing);
    router.go('/');
    await tester.pumpAndSettle();
    expect(fab, findsNothing);
  });

  testWidgets('tap opens the «كلّمنا» sheet with the three choices', (tester) async {
    await pumpApp(tester, '/marketplace');
    await tester.tap(fab);
    await tester.pumpAndSettle();
    expect(find.text('كلّمنا'), findsOneWidget);
    expect(find.text('اقترح قسم أو فكرة جديدة'), findsOneWidget);
    expect(find.text('بلّغ عن مشكلة'), findsOneWidget);
    expect(find.text('سؤال أو استفسار'), findsOneWidget);
    expect(find.byKey(const ValueKey('feedback-contact')), findsOneWidget); // guest
    // Too short → refused before anything is sent.
    await tester.tap(find.text('بلّغ عن مشكلة'));
    await tester.enterText(find.byKey(const ValueKey('feedback-body')), 'قصير');
    await tester.tap(find.text('إرسال'));
    await tester.pump();
    expect(find.text('اكتب رسالتك في 10 حروف على الأقل'), findsOneWidget);
  });

  test('short user agent', () {
    expect(
      shortUserAgent('Mozilla/5.0 (Linux; Android 14; SM-A546E) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/129.0.0.0 Mobile Safari/537.36'),
      'Chrome 129 · Android',
    );
    expect(
      shortUserAgent('Mozilla/5.0 (iPhone; CPU iPhone OS 17_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.5 Mobile/15E148 Safari/604.1'),
      'Safari 17 · iOS',
    );
  });
}
