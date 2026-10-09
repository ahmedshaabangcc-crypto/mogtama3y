import 'package:flutter_test/flutter_test.dart';
import 'package:mogtama3y/core/masjid/prayer_times.dart';

/// Reference times: Egyptian General Authority of Survey method
/// (Fajr 19.5°, Isha 17.5°, Asr standard), Africa/Cairo clock incl. summer
/// time — as published by aladhan.com (method 5) for these dates. Our
/// Dhuhr adds the customary +1 minute, all within ±2 minutes.
const _cairo = (30.0444, 31.2357);
const _alexandria = (31.2001, 29.9187);
const _aswan = (24.0889, 32.8998);

int _minutes(String hhmm) {
  final p = hhmm.split(':');
  return int.parse(p[0]) * 60 + int.parse(p[1]);
}

void _expectDay(String label, (double, double) at, int y, int m, int d, List<String> expected) {
  final day = PrayerCalculator.egypt.compute(y, m, d, at.$1, at.$2);
  final order = [Prayer.fajr, Prayer.sunrise, Prayer.dhuhr, Prayer.asr, Prayer.maghrib, Prayer.isha];
  for (var i = 0; i < order.length; i++) {
    final got = day.hhmm(order[i]);
    final diff = (_minutes(got) - _minutes(expected[i])).abs();
    expect(diff, lessThanOrEqualTo(2), reason: '$label $y-$m-$d ${order[i].name}: got $got, expected ${expected[i]}');
  }
}

void main() {
  group('Egypt clock', () {
    test('summer time: last Friday of April → last Thursday of October (2023+)', () {
      // 2025: starts Fri 25 April, ends after Thu 30 October.
      expect(egyptDstOn(2025, 4, 24), isFalse);
      expect(egyptDstOn(2025, 4, 25), isTrue);
      expect(egyptDstOn(2025, 7, 15), isTrue);
      expect(egyptDstOn(2025, 10, 30), isTrue);
      expect(egyptDstOn(2025, 10, 31), isFalse);
      expect(egyptDstOn(2025, 1, 15), isFalse);
      // 2026: Fri 24 April → Thu 29 October.
      expect(egyptDstOn(2026, 4, 23), isFalse);
      expect(egyptDstOn(2026, 4, 24), isTrue);
      expect(egyptDstOn(2026, 10, 29), isTrue);
      expect(egyptDstOn(2026, 10, 30), isFalse);
      // Suspended 2015–2022.
      expect(egyptDstOn(2020, 7, 1), isFalse);
    });

    test('wall clock around the changes', () {
      // Spring forward: 22:00 UTC Thu 24 Apr 2025 = 01:00 Fri (+3).
      expect(egyptWallClock(DateTime.utc(2025, 4, 24, 21, 30)), DateTime.utc(2025, 4, 24, 23, 30));
      expect(egyptWallClock(DateTime.utc(2025, 4, 24, 22, 0)), DateTime.utc(2025, 4, 25, 1, 0));
      // Fall back: 21:00 UTC Thu 30 Oct 2025 = 23:00 Thu (+2).
      expect(egyptWallClock(DateTime.utc(2025, 10, 30, 20, 30)), DateTime.utc(2025, 10, 30, 23, 30));
      expect(egyptWallClock(DateTime.utc(2025, 10, 30, 21, 0)), DateTime.utc(2025, 10, 30, 23, 0));
      expect(egyptWallClock(DateTime.utc(2025, 1, 15, 10, 0)), DateTime.utc(2025, 1, 15, 12, 0));
      expect(egyptWallClock(DateTime.utc(2025, 7, 15, 10, 0)), DateTime.utc(2025, 7, 15, 13, 0));
    });
  });

  group('prayer times (Egyptian survey method) within ±2 min', () {
    test('Cairo — winter', () => _expectDay('Cairo', _cairo, 2025, 1, 15, ['05:21', '06:52', '12:05', '14:58', '17:18', '18:39']));
    test('Cairo — summer time (21 June)', () => _expectDay('Cairo', _cairo, 2025, 6, 21, ['04:08', '05:54', '12:57', '16:32', '19:59', '21:33']));
    test('Cairo — 1 October (still summer time)', () => _expectDay('Cairo', _cairo, 2025, 10, 1, ['05:22', '06:48', '12:45', '16:09', '18:40', '19:58']));
    test('Cairo — November (standard time)', () => _expectDay('Cairo', _cairo, 2025, 11, 15, ['04:50', '06:20', '11:40', '14:39', '16:59', '18:19']));
    test('Alexandria — March', () => _expectDay('Alexandria', _alexandria, 2025, 3, 10, ['04:49', '06:16', '12:11', '15:32', '18:05', '19:23']));
    test('Alexandria — July (summer time)', () => _expectDay('Alexandria', _alexandria, 2025, 7, 15, ['04:22', '06:07', '13:06', '16:46', '20:06', '21:38']));
    test('Aswan — December', () => _expectDay('Aswan', _aswan, 2025, 12, 21, ['04:59', '06:27', '11:47', '14:46', '17:06', '18:25']));
    test('Aswan — 1 May (summer time)', () => _expectDay('Aswan', _aswan, 2025, 5, 1, ['04:46', '06:14', '12:45', '16:11', '19:17', '20:36']));

    test('times are in order', () {
      final d = PrayerCalculator.egypt.compute(2026, 3, 20, _cairo.$1, _cairo.$2);
      final seq = [Prayer.fajr, Prayer.sunrise, Prayer.dhuhr, Prayer.asr, Prayer.maghrib, Prayer.isha].map((p) => d[p]).toList();
      for (var i = 1; i < seq.length; i++) {
        expect(seq[i].isAfter(seq[i - 1]), isTrue);
      }
    });
  });

  group('next prayer & countdown', () {
    test('mid-morning → Dhuhr', () {
      // 10:00 Cairo summer time = 07:00 UTC.
      final n = nextPrayer(_cairo.$1, _cairo.$2, now: DateTime.utc(2025, 6, 21, 7, 0));
      expect(n.prayer, Prayer.dhuhr);
      expect(n.left.inMinutes, inInclusiveRange(176, 180)); // Dhuhr ≈ 12:57–12:58
    });

    test('after Isha → tomorrow\'s Fajr', () {
      // 23:00 Cairo (summer) = 20:00 UTC.
      final n = nextPrayer(_cairo.$1, _cairo.$2, now: DateTime.utc(2025, 6, 21, 20, 0));
      expect(n.prayer, Prayer.fajr);
      expect(egyptWallClock(n.at).day, 22);
      expect(n.left.inMinutes, inInclusiveRange(305, 312)); // ~04:08 next day
    });

    test('right before Maghrib', () {
      final day = PrayerCalculator.egypt.compute(2025, 1, 15, _cairo.$1, _cairo.$2);
      final n = nextPrayer(_cairo.$1, _cairo.$2, now: day[Prayer.maghrib].subtract(const Duration(minutes: 5)));
      expect(n.prayer, Prayer.maghrib);
      expect(n.left, const Duration(minutes: 5));
    });

    test('countdown text', () {
      expect(formatCountdown(const Duration(seconds: 30)), 'دلوقتي');
      expect(formatCountdown(const Duration(minutes: 1)), 'باقي دقيقة');
      expect(formatCountdown(const Duration(minutes: 2)), 'باقي دقيقتين');
      expect(formatCountdown(const Duration(minutes: 7)), 'باقي 7 دقايق');
      expect(formatCountdown(const Duration(minutes: 25)), 'باقي 25 دقيقة');
      expect(formatCountdown(const Duration(hours: 1)), 'باقي ساعة');
      expect(formatCountdown(const Duration(hours: 2, minutes: 5)), 'باقي ساعتين و5 دقايق');
      expect(formatCountdown(const Duration(hours: 3, minutes: 40)), 'باقي 3 ساعات و40 دقيقة');
      // Partial minutes round up (59m30s left reads as an hour).
      expect(formatCountdown(const Duration(minutes: 59, seconds: 30)), 'باقي ساعة');
      expect(formatClock(const Duration(hours: 1, minutes: 5, seconds: 9)), '01:05:09');
      expect(format12(DateTime.utc(2025, 1, 1, 16, 32)), '4:32 م');
      expect(format12(DateTime.utc(2025, 1, 1, 0, 5)), '12:05 ص');
    });
  });
}
