import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mogtama3y/features/auth/auth_landing_screen.dart';

void main() {
  for (final size in const [Size(320, 480), Size(375, 667), Size(430, 932)]) {
    testWidgets('sign-in landing fits a ${size.width.toInt()}x${size.height.toInt()} screen, Google first', (tester) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(const MaterialApp(
        home: Directionality(textDirection: TextDirection.rtl, child: AuthLandingScreen()),
      ));
      await tester.pump();

      expect(tester.takeException(), isNull); // no RenderFlex overflow
      final google = find.text('المتابعة بحساب جوجل');
      final login = find.text('تسجيل الدخول');
      expect(google, findsOneWidget);
      expect(login, findsOneWidget);
      // Google sits above the email buttons.
      expect(tester.getTopLeft(google).dy, lessThan(tester.getTopLeft(login).dy));
      // Every button is reachable (scrolling if the screen is short).
      await tester.scrollUntilVisible(find.text('إنشاء حساب جديد'), 50, scrollable: find.byType(Scrollable).first);
      expect(find.text('إنشاء حساب جديد').hitTestable(), findsOneWidget);
    });
  }
}
