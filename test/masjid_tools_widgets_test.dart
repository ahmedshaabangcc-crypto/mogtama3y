import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mogtama3y/core/masjid_tools/quran_text.dart';
import 'package:mogtama3y/features/masjid_tools/adhkar_data.dart';
import 'package:mogtama3y/features/masjid_tools/adhkar_screens.dart';
import 'package:mogtama3y/features/masjid_tools/hijri_screen.dart';
import 'package:mogtama3y/features/masjid_tools/prayer_reminder_host.dart';
import 'package:mogtama3y/features/masjid_tools/qibla_screen.dart';
import 'package:mogtama3y/features/masjid_tools/quran_screens.dart';
import 'package:mogtama3y/features/masjid_tools/tutor_screens.dart';
import 'package:shared_preferences/shared_preferences.dart';

Widget _app(Widget child) => MaterialApp(
      builder: (context, c) => Directionality(textDirection: TextDirection.rtl, child: PrayerReminderHost(child: c!)),
      home: child,
    );

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets('adhkar: tap to count, done after the target', (tester) async {
    final morning = adhkarCategories.first;
    await tester.pumpWidget(_app(AdhkarListScreen(category: morning)));
    await tester.pump();
    final i = morning.items.indexWhere((d) => d.count == 3);
    expect(find.text('٠/٣'), findsWidgets);
    final card = find.text(morning.items[i].text);
    await tester.ensureVisible(card);
    for (var n = 0; n < 3; n++) {
      await tester.tap(card);
      await tester.pump(const Duration(milliseconds: 300));
    }
    expect(find.byIcon(Icons.check_rounded), findsOneWidget);
    await tester.pump(const Duration(seconds: 1));
  });

  testWidgets('tasbeeh counts', (tester) async {
    await tester.pumpWidget(_app(const TasbeehScreen()));
    await tester.pump();
    await tester.tap(find.text('دوس هنا'));
    await tester.pump(const Duration(milliseconds: 200));
    await tester.tap(find.text('دوس هنا'));
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.text('٢'), findsOneWidget);
    expect(find.textContaining('الإجمالي: ٢'), findsOneWidget);
  });

  testWidgets('adhkar home, hijri and qibla screens render', (tester) async {
    await tester.pumpWidget(_app(const AdhkarHomeScreen()));
    expect(find.text('أذكار الصباح'), findsOneWidget);

    await tester.pumpWidget(_app(const HijriCalendarScreen()));
    await tester.pump();
    expect(find.text('عيد الأضحى'), findsOneWidget);
    await tester.scrollUntilVisible(find.textContaining('حسب الحساب الفلكي'), 300);
    expect(find.textContaining('حسب الحساب الفلكي'), findsOneWidget);

    await tester.pumpWidget(_app(const QiblaScreen()));
    await tester.pump(const Duration(seconds: 4));
    expect(find.textContaining('القبلة على ١٣٦°'), findsOneWidget);
    expect(find.textContaining('البوصلة مش متاحة'), findsOneWidget);
    await tester.pump(const Duration(seconds: 20)); // geolocator's 15 s time limit
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('quran index and reader', (tester) async {
    await tester.pumpWidget(_app(const QuranHomeScreen()));
    await tester.pump();
    expect(find.text('سورة الفاتحة'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'يس');
    await tester.pump();
    expect(find.text('سورة يس'), findsOneWidget);

    await tester.runAsync(() async {
      await tester.pumpWidget(_app(const SurahReaderScreen(surah: 112)));
      for (var i = 0; i < 20 && find.byType(CircularProgressIndicator).evaluate().isNotEmpty; i++) {
        await Future<void>.delayed(const Duration(milliseconds: 100));
        await tester.pump();
      }
    });
    await tester.pump();
    expect(find.text('سورة الإخلاص'), findsWidgets);
    expect(find.byType(AyahMarker), findsNWidgets(4));
    expect((await QuranPrefs.lastRead()), (112, 1));
  });

  testWidgets('tutor: opt-in screen explains the download and the limits', (tester) async {
    await tester.pumpWidget(_app(const QuranTutorScreen()));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.textContaining('أول مرة بس'), findsOneWidget);
    expect(find.textContaining('مساعد للمراجعة مش بديل عن المحفّظ'), findsOneWidget);
    // No browser engine in tests → the screen says so instead of offering the download.
    expect(find.text('حمّل المحفّظ وابدأ'), findsNothing);
    expect(find.textContaining('المتصفح ده مش بيدعم'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('everyayah.com'), 300);
    expect(find.textContaining('Apache-2.0'), findsOneWidget);
  });

  testWidgets('tutor: session shows the ayah, hides it in test mode', (tester) async {
    final quran = QuranText.parse(utf8.decode(gzip.decode(File('assets/quran/quran-uthmani.txt.gz').readAsBytesSync())));
    await tester.pumpWidget(_app(TutorSessionScreen(surah: 112, from: 1, to: 4, quran: quran)));
    await tester.pump();
    expect(find.textContaining('قُلْ هُوَ'), findsOneWidget);
    expect(find.textContaining('بِسْمِ'), findsNothing); // the basmala isn't part of 112:1
    expect(find.text('المحفّظ لسه بيتحمّل…'), findsOneWidget);
    await tester.tap(find.text('اختبر نفسك'));
    await tester.pump();
    expect(find.textContaining('النص مخفي'), findsOneWidget);
    await tester.tap(find.text('اختبر نفسك'));
    await tester.pump();
    await tester.tap(find.text('٢'));
    await tester.pump();
    expect(find.text('آية ٢'), findsOneWidget);
  });
}
