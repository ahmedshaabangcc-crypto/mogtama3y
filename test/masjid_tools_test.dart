import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mogtama3y/core/masjid/prayer_times.dart';
import 'package:mogtama3y/core/masjid_tools/dhikr_counter.dart';
import 'package:mogtama3y/core/masjid_tools/hijri.dart';
import 'package:mogtama3y/core/masjid_tools/inflate.dart';
import 'package:mogtama3y/core/masjid_tools/qibla.dart';
import 'package:mogtama3y/core/masjid_tools/quran_meta.dart';
import 'package:mogtama3y/core/masjid_tools/quran_text.dart';
import 'package:mogtama3y/core/masjid_tools/reminder_settings.dart';
import 'package:mogtama3y/features/masjid_tools/adhkar_data.dart';

void main() {
  group('qibla', () {
    test('Cairo ≈ 136°', () => expect(qiblaBearing(30.0444, 31.2357), closeTo(136.1, 0.5)));
    test('other cities', () {
      expect(qiblaBearing(31.2001, 29.9187), closeTo(136.3, 1)); // Alexandria
      expect(qiblaBearing(24.0889, 32.8998), closeTo(111.3, 1)); // Aswan
      expect(qiblaBearing(51.5074, -0.1278), closeTo(119.0, 1)); // London
      expect(qiblaBearing(40.7128, -74.0060), closeTo(58.5, 1)); // New York
      expect(qiblaBearing(-6.2088, 106.8456), closeTo(295.1, 1)); // Jakarta
    });
    test('distance Cairo → Makkah ≈ 1,280 km', () => expect(distanceToKaabaKm(30.0444, 31.2357), closeTo(1280, 25)));
    test('compass helpers', () {
      expect(compassPointAr(136), 'الجنوب الشرقي');
      expect(compassPointAr(359), 'الشمال');
      expect(headingFromAlpha(90), 270);
      expect(headingFromAlpha(0), 0);
      expect(turnToQibla(136, 100), closeTo(36, 1e-9));
      expect(turnToQibla(10, 350), closeTo(20, 1e-9));
      expect(turnToQibla(350, 10), closeTo(-20, 1e-9));
    });
  });

  group('hijri', () {
    test('julian day round trip', () {
      expect(gregorianToJdn(1999, 4, 17), 2451286);
      expect(gregorianToJdn(2000, 1, 1), 2451545);
      for (var j = 2400000; j < 2500000; j += 997) {
        final g = jdnToGregorian(j);
        expect(gregorianToJdn(g.year, g.month, g.day), j);
      }
    });

    // Reference: .NET System.Globalization.UmAlQuraCalendar.
    const umAlQura = {
      '2026-10-09': HijriDate(1448, 4, 28),
      '2024-03-11': HijriDate(1445, 9, 1),
      '2025-03-01': HijriDate(1446, 9, 1),
      '2026-02-18': HijriDate(1447, 9, 1),
      '2026-02-19': HijriDate(1447, 9, 2),
      '2023-07-19': HijriDate(1445, 1, 1),
      '2000-01-01': HijriDate(1420, 9, 24),
      '2030-01-01': HijriDate(1451, 8, 26),
      '2026-05-26': HijriDate(1447, 12, 9),
      '2026-05-27': HijriDate(1447, 12, 10),
    };
    test('Gregorian → Hijri (Umm al-Qura)', () {
      umAlQura.forEach((g, h) => expect(toHijri(DateTime.parse(g)), h, reason: g));
    });
    test('Hijri → Gregorian (Umm al-Qura)', () {
      umAlQura.forEach((g, h) => expect(toGregorian(h.year, h.month, h.day), DateTime.parse('${g}T00:00:00Z'), reason: g));
    });
    test('tabular (Kuwaiti) outside the table', () {
      expect(toHijri(DateTime(1990, 6, 15)), const HijriDate(1410, 11, 22)); // .NET HijriCalendar
    });
    test('every day 1999–2077 round-trips', () {
      for (var j = gregorianToJdn(1999, 4, 17); j < gregorianToJdn(2077, 11, 16); j++) {
        final h = jdnToHijri(j);
        expect(h.day, inInclusiveRange(1, 30));
        expect(hijriToJdn(h.year, h.month, h.day), j);
      }
      for (var y = 1420; y <= 1500; y++) {
        for (var m = 1; m <= 12; m++) {
          expect(hijriMonthLength(y, m), anyOf(29, 30));
        }
      }
    });
    test('adjustment shifts by days', () {
      expect(toHijri(DateTime(2026, 2, 18), adjustDays: -1), const HijriDate(1447, 8, 29));
      expect(toGregorian(1447, 9, 1, adjustDays: -1), DateTime.utc(2026, 2, 19));
    });
    test('next occasions', () {
      final today = DateTime.utc(2026, 10, 9);
      final ramadan = nextOccasion(hijriOccasions[0], today);
      expect(ramadan.hijri, const HijriDate(1448, 9, 1));
      expect(ramadan.date, toGregorian(1448, 9, 1));
      expect(ramadan.daysLeft, ramadan.date.difference(today).inDays);
      final onTheDay = nextOccasion(hijriOccasions[0], DateTime.utc(2026, 2, 18));
      expect(onTheDay.daysLeft, 0);
      expect(daysLeftText(0), 'النهارده');
      expect(daysLeftText(15), 'باقي ١٥ يوم');
      expect(formatHijri(const HijriDate(1448, 4, 28)), '٢٨ ربيع الآخر ١٤٤٨ هـ');
    });
  });

  group('adhkar counter', () {
    test('tap until done, then ignore', () {
      final c = DhikrCounter([3, 1]);
      expect(c.tap(0), false);
      expect(c.tap(0), false);
      expect(c.tap(0), true);
      expect(c.isDone(0), true);
      expect(c.tap(0), false);
      expect(c.count(0), 3);
      expect(c.nextPending, 1);
      expect(c.overallProgress, closeTo(0.75, 1e-9));
      expect(c.tap(1), true);
      expect(c.allDone, true);
      c.resetOne(0);
      expect(c.count(0), 0);
      expect(c.doneCount, 1);
      c.resetAll();
      expect(c.doneCount, 0);
    });
    test('restore clamps and ignores a changed list', () {
      final c = DhikrCounter([3, 100]);
      c.restore([5, 40]);
      expect(c.count(0), 3);
      expect(c.count(1), 40);
      c.restore([1]);
      expect(c.count(1), 40);
      expect(c.toJson(), [3, 40]);
    });
    test('tasbeeh rounds and target', () {
      final t = Tasbeeh(target: 33);
      var rounds = 0;
      for (var i = 0; i < 70; i++) {
        if (t.tap()) rounds++;
      }
      expect(rounds, 2);
      expect(t.count, 4);
      expect(t.rounds, 2);
      t.setTarget(100);
      expect(t.count, 70);
      final back = Tasbeeh.fromJson(t.toJson());
      expect((back.target, back.count, back.total), (100, 70, 70));
      t.reset();
      expect((t.count, t.total), (0, 0));
      expect(Tasbeeh.fromJson({'target': 0, 'count': 99}).target, 33);
    });
    test('adhkar data is complete', () {
      expect(adhkarCategories.map((c) => c.id), ['morning', 'evening', 'prayer', 'sleep', 'waking']);
      for (final c in adhkarCategories) {
        expect(c.items, isNotEmpty);
        for (final d in c.items) {
          expect(d.text.trim(), isNotEmpty);
          expect(d.source.trim(), isNotEmpty);
          expect(d.count, greaterThanOrEqualTo(1));
        }
      }
    });
  });

  group('quran text', () {
    late QuranText q;
    setUpAll(() {
      final raw = gzip.decode(File('assets/quran/quran-uthmani.txt.gz').readAsBytesSync());
      q = QuranText.parse(utf8.decode(raw));
    });
    test('all 6236 ayahs and the Tanzil notice', () {
      expect(q.complete, true);
      expect([for (var s = 1; s <= 114; s++) q.ayahCount(s)].fold<int>(0, (a, b) => a + b), 6236);
      expect(q.notice, contains('Tanzil Quran Text'));
      expect(q.notice, contains('Creative Commons Attribution 3.0'));
      expect(q.ayah(1, 1), basmalaUthmani);
    });
    test('basmala is split off the first ayah for display', () {
      final s = splitBasmala(2, 1, q.ayah(2, 1));
      expect(s.basmala, basmalaUthmani);
      expect(s.text, startsWith('الٓمٓ'));
      expect(splitBasmala(9, 1, q.ayah(9, 1)).basmala, isNull);
      expect(splitBasmala(1, 1, q.ayah(1, 1)).basmala, isNull);
      for (var s = 2; s <= 114; s++) {
        if (s == 9) continue;
        expect(splitBasmala(s, 1, q.ayah(s, 1)).basmala, isNotNull, reason: 'surah $s');
      }
    });
    test('pure-Dart inflate matches dart:io', () {
      final bytes = File('assets/quran/quran-uthmani.txt.gz').readAsBytesSync();
      expect(gunzipBytes(bytes), gzip.decode(bytes));
      final rnd = math.Random(7);
      for (final level in [0, 1, 6, 9]) {
        final data = Uint8List.fromList(List.generate(70000, (i) => i % 3 == 0 ? rnd.nextInt(256) : (i ~/ 7) % 256));
        final z = GZipCodec(level: level).encode(data);
        expect(gunzipBytes(Uint8List.fromList(z)), data, reason: 'level $level');
      }
    });
    test('metadata', () {
      expect(surahData.length, 114);
      expect(surahData.fold<int>(0, (a, s) => a + s.$2), 6236);
      expect(juzStarts.length, 30);
      expect(juzOf(1, 1), 1);
      expect(juzOf(2, 141), 1);
      expect(juzOf(2, 142), 2);
      expect(juzOf(114, 6), 30);
    });
    test('surah search', () {
      expect(searchSurahs('البقرة'), [2]);
      expect(searchSurahs('سورة يس'), [36]);
      expect(searchSurahs('٣٦'), [36]);
      expect(searchSurahs('18'), [18]);
      expect(searchSurahs('الكهف'), [18]);
      expect(searchSurahs('كهف'), [18]);
      expect(searchSurahs('kahf'), [18]);
      expect(searchSurahs('').length, 114);
      expect(searchSurahs('xyz'), isEmpty);
      expect(normalizeArabic('إِبْرَاهِيم'), 'ابراهيم');
    });
  });

  group('prayer reminders (in-app)', () {
    const cairo = ReminderSettings(offsets: {Prayer.fajr: 10, Prayer.isha: 0});
    final day = PrayerCalculator.egypt.compute(2026, 1, 15, 30.0444, 31.2357);

    test('due 10 minutes before fajr, once', () {
      final at = day[Prayer.fajr].subtract(const Duration(minutes: 10)).add(const Duration(seconds: 30));
      final due = dueAlerts(cairo, at, {});
      expect(due.map((a) => a.prayer), [Prayer.fajr]);
      expect(due.single.title, 'الفجر بعد 10 دقايق');
      expect(dueAlerts(cairo, at, {due.single.key}), isEmpty);
      expect(dueAlerts(cairo, at.subtract(const Duration(minutes: 1)), {}), isEmpty);
      expect(dueAlerts(cairo, at.add(const Duration(minutes: 5)), {}), isEmpty);
    });
    test('at the adhan for isha; next alert', () {
      final due = dueAlerts(cairo, day[Prayer.isha].add(const Duration(seconds: 5)), {});
      expect(due.single.title, 'حان الآن موعد أذان العشاء');
      final next = nextAlert(cairo, day[Prayer.isha].add(const Duration(minutes: 1)));
      expect(next?.prayer, Prayer.fajr);
      expect(next!.adhan.isAfter(day[Prayer.isha]), true);
    });
    test('off = nothing', () {
      expect(dueAlerts(const ReminderSettings(), day[Prayer.fajr], {}), isEmpty);
      expect(nextAlert(const ReminderSettings(), day[Prayer.fajr]), isNull);
    });
    test('json round trip drops invalid offsets', () {
      final s = ReminderSettings.fromJson({
        ...cairo.copyWith(source: 'city', label: 'أسوان', lat: 24.1, lng: 32.9, push: true).toJson(),
        'offsets': {'fajr': 10, 'isha': 0, 'asr': 7, 'sunrise': 0},
      });
      expect(s.offsets, {Prayer.fajr: 10, Prayer.isha: 0});
      expect((s.source, s.label, s.lat, s.push), ('city', 'أسوان', 24.1, true));
      expect(s.offsetsJson, {'fajr': 10, 'isha': 0});
    });
  });
}

