import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mogtama3y/core/places/directory_service.dart';
import 'package:mogtama3y/features/discover/report_place_sheet.dart';

/// «بلّغ عن محل غلط» (features/discover/report_place_sheet.dart, 0095).
void main() {
  late List<(String, String?, Map<String, String>?)> sent;
  bool? popped;

  Future<void> pump(WidgetTester tester, {Future<void> Function()? fail}) async {
    sent = [];
    popped = null;
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(MaterialApp(
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () async {
                  popped = await showModalBottomSheet<bool>(
                    context: context,
                    isScrollControlled: true,
                    builder: (_) => ReportPlaceSheet(
                      placeName: 'بقالة النخيل',
                      category: 'سوبر ماركت وبقالة',
                      onSubmit: (reason, note, suggestion) async {
                        if (fail != null) return fail();
                        sent.add((reason, note, suggestion));
                      },
                    ),
                  );
                },
                child: const Text('open'),
              ),
            ),
          ),
        ),
      ),
    ));
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
  }

  ElevatedButton submit(WidgetTester tester) => tester.widget<ElevatedButton>(find.byKey(const ValueKey('report-submit')));

  testWidgets('shows all six reasons; send is disabled until one is picked', (tester) async {
    await pump(tester);
    for (final label in DirectoryService.reportReasons.values) {
      expect(find.text(label), findsOneWidget);
    }
    expect(find.text('بقالة النخيل'), findsOneWidget);
    expect(submit(tester).onPressed, isNull);
    expect(find.byKey(const ValueKey('report-note')), findsNothing);
  });

  testWidgets('«المحل مقفول نهائياً» with a note is sent and closes the sheet', (tester) async {
    await pump(tester);
    await tester.tap(find.byKey(const ValueKey('report-reason-closed')));
    await tester.pump();
    expect(find.byKey(const ValueKey('report-suggest-name')), findsNothing);
    await tester.enterText(find.byKey(const ValueKey('report-note')), '  قفل من شهرين  ');
    await tester.tap(find.byKey(const ValueKey('report-submit')));
    await tester.pumpAndSettle();
    expect(sent, hasLength(1));
    expect(sent.single.$1, 'closed');
    expect(sent.single.$2, 'قفل من شهرين');
    expect(sent.single.$3, isNull);
    expect(popped, isTrue);
  });

  testWidgets('«الاسم أو الرقم غلط» shows the suggestion fields and sends them', (tester) async {
    await pump(tester);
    await tester.tap(find.byKey(const ValueKey('report-reason-wrong_info')));
    await tester.pump();
    await tester.enterText(find.byKey(const ValueKey('report-suggest-name')), 'بقالة النخيل الجديدة');
    await tester.enterText(find.byKey(const ValueKey('report-suggest-phone')), '0501112233');
    await tester.tap(find.byKey(const ValueKey('report-submit')));
    await tester.pumpAndSettle();
    expect(sent.single.$1, 'wrong_info');
    expect(sent.single.$2, isNull);
    expect(sent.single.$3, {'name': 'بقالة النخيل الجديدة', 'phone': '0501112233'});
  });

  testWidgets('«حاجة تانية» needs a note; the note is capped at 500', (tester) async {
    await pump(tester);
    await tester.tap(find.byKey(const ValueKey('report-reason-other')));
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('report-submit')));
    await tester.pump();
    expect(sent, isEmpty);
    expect(find.text('اكتب لنا إيه الغلط'), findsOneWidget);
    final field = tester.widget<TextField>(find.byKey(const ValueKey('report-note')));
    expect(field.maxLength, ReportPlaceSheet.maxNote);
    await tester.enterText(find.byKey(const ValueKey('report-note')), 'ده محل أحذية مش بقالة');
    await tester.tap(find.byKey(const ValueKey('report-submit')));
    await tester.pumpAndSettle();
    expect(sent.single.$1, 'other');
  });

  testWidgets('a failed send keeps the sheet open with an error', (tester) async {
    await pump(tester, fail: () async => throw Exception('offline'));
    await tester.tap(find.byKey(const ValueKey('report-reason-fake')));
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('report-submit')));
    await tester.pumpAndSettle();
    expect(find.text('مقدرناش نبعت البلاغ — جرّب تاني'), findsOneWidget);
    expect(popped, isNull);
    expect(find.byKey(const ValueKey('report-submit')), findsOneWidget);
  });
}
