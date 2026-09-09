import 'package:flutter_test/flutter_test.dart';

import 'package:mogtama3y/main.dart';

void main() {
  testWidgets('Home screen renders the guest landing content', (WidgetTester tester) async {
    await tester.pumpWidget(const MogtamayApp());
    await tester.pump();

    expect(find.text('مُجتمعي'), findsOneWidget);
    expect(find.text('أقسام الحي والخدمات'), findsOneWidget);
  });
}
