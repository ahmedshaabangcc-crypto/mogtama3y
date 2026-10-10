import 'package:flutter_test/flutter_test.dart';
import 'package:mogtama3y/core/masjid/prayer_times.dart';
import 'package:mogtama3y/core/masjid/world_time.dart';

/// Reference times from aladhan.com (api.aladhan.com/v1/timings, fetched
/// Oct 2026) with the matching method and latitudeAdjustmentMethod=3
/// (angle based): Fajr, Sunrise, Dhuhr, Asr, Maghrib, Isha — local clock.
/// 15 Jan 2026 (winter), 1 Mar 2026 (Ramadan 1447: Umm al-Qura Isha
/// +120 min), 21 Jun 2026 (summer time in London / New York; London has
/// no astronomical night, so Fajr/Isha use the angle-based portion).
const _refs = <(String, double, double, String, String, Map<String, List<String>>)>[
  ('Dubai', 25.2048, 55.2708, 'uae', 'Asia/Dubai', {
    '2026-01-15': ['05:45', '07:06', '12:31', '15:30', '17:54', '19:12'],
    '2026-03-01': ['05:25', '06:42', '12:34', '15:51', '18:24', '19:38'],
    '2026-06-21': ['03:59', '05:29', '12:24', '15:43', '19:15', '20:43'],
  }),
  ('Riyadh', 24.7136, 46.6753, 'umm_al_qura', 'Asia/Riyadh', {
    '2026-01-15': ['05:17', '06:40', '12:03', '15:05', '17:26', '18:56'],
    '2026-03-01': ['04:58', '06:16', '12:06', '15:26', '17:56', '19:56'],
    '2026-06-21': ['03:33', '05:05', '11:55', '15:16', '18:45', '20:15'],
  }),
  ('Makkah', 21.4225, 39.8262, 'umm_al_qura', 'Asia/Riyadh', {
    '2026-01-15': ['05:41', '07:01', '12:30', '15:37', '17:59', '19:29'],
    '2026-03-01': ['05:25', '06:41', '12:33', '15:54', '18:25', '20:25'],
    '2026-06-21': ['04:11', '05:39', '12:22', '15:42', '19:06', '20:36'],
  }),
  ('Kuwait', 29.3759, 47.9774, 'kuwait', 'Asia/Kuwait', {
    '2026-01-15': ['05:20', '06:43', '11:57', '14:52', '17:12', '18:33'],
    '2026-03-01': ['04:55', '06:14', '12:00', '15:18', '17:47', '19:04'],
    '2026-06-21': ['03:13', '04:49', '11:50', '15:24', '18:51', '20:23'],
  }),
  ('Doha', 25.2854, 51.5310, 'qatar', 'Asia/Qatar', {
    '2026-01-15': ['05:01', '06:21', '11:43', '14:45', '17:05', '18:35'],
    '2026-03-01': ['04:41', '05:57', '11:46', '15:06', '17:36', '19:06'],
    '2026-06-21': ['03:15', '04:44', '11:36', '14:58', '18:27', '19:57'],
  }),
  ('Manama', 26.2285, 50.5860, 'gulf', 'Asia/Bahrain', {
    '2026-01-15': ['04:59', '06:27', '11:47', '14:47', '17:07', '18:37'],
    '2026-06-21': ['03:06', '04:46', '11:39', '15:05', '18:33', '20:03'],
  }),
  ('London', 51.5074, -0.1278, 'mwl', 'Europe/London', {
    '2026-01-15': ['05:59', '08:00', '12:10', '14:00', '16:21', '18:15'],
    '2026-03-01': ['04:55', '06:46', '12:13', '15:03', '17:41', '19:25'],
    '2026-06-21': ['02:31', '04:43', '13:02', '17:25', '21:22', '23:27'],
  }),
  ('New York', 40.7128, -74.0060, 'isna', 'America/New_York', {
    '2026-01-15': ['05:58', '07:18', '12:06', '14:34', '16:53', '18:14'],
    '2026-03-01': ['05:15', '06:30', '12:08', '15:16', '17:47', '19:02'],
    '2026-06-21': ['03:45', '05:25', '12:58', '16:58', '20:31', '22:11'],
  }),
  ('Karachi', 24.8607, 67.0011, 'karachi', 'Asia/Karachi', {
    '2026-01-15': ['05:58', '07:19', '12:41', '15:43', '18:04', '19:24'],
    '2026-06-21': ['04:14', '05:43', '12:34', '15:55', '19:24', '20:53'],
  }),
  ('Istanbul', 41.0082, 28.9784, 'turkey', 'Europe/Istanbul', {
    '2026-01-15': ['06:50', '08:20', '13:18', '15:44', '18:07', '19:32'],
    '2026-06-21': ['03:24', '05:25', '13:11', '17:11', '20:47', '22:38'],
  }),
  ('Jakarta', -6.2088, 106.8456, 'kemenag', 'Asia/Jakarta', {
    '2026-01-15': ['04:25', '05:49', '12:02', '15:27', '18:15', '19:30'],
    '2026-06-21': ['04:38', '06:01', '11:54', '15:16', '17:47', '19:02'],
  }),
  ('Kuala Lumpur', 3.1390, 101.6869, 'jakim', 'Asia/Kuala_Lumpur', {
    '2026-01-15': ['06:01', '07:24', '13:23', '16:46', '19:21', '20:35'],
    '2026-06-21': ['05:41', '07:06', '13:15', '16:42', '19:24', '20:40'],
  }),
  ('Singapore', 1.3521, 103.8198, 'singapore', 'Asia/Singapore', {
    '2026-01-15': ['05:50', '07:12', '13:14', '16:38', '19:16', '20:29'],
  }),
  ('Tehran', 35.6892, 51.3890, 'tehran', 'Asia/Tehran', {
    '2026-01-15': ['05:45', '07:14', '12:14', '14:55', '17:34', '18:24'],
    '2026-06-21': ['03:02', '04:49', '12:06', '15:55', '19:45', '20:44'],
  }),
  ('Cairo', 30.0444, 31.2357, 'egypt', 'Africa/Cairo', {
    '2026-01-15': ['05:21', '06:52', '12:04', '14:57', '17:17', '18:39'],
    '2026-06-21': ['04:08', '05:54', '12:57', '16:32', '19:59', '21:33'],
  }),
];

int _min(String hhmm) {
  final p = hhmm.split(':');
  return int.parse(p[0]) * 60 + int.parse(p[1]);
}

void main() {
  const order = [Prayer.fajr, Prayer.sunrise, Prayer.dhuhr, Prayer.asr, Prayer.maghrib, Prayer.isha];

  group('methods vs aladhan.com (±2 min)', () {
    for (final (city, lat, lng, method, tz, days) in _refs) {
      for (final e in days.entries) {
        test('$city ${e.key} ($method)', () {
          final d = DateTime.parse(e.key);
          final day = PrayerCalculator.of(method).compute(d.year, d.month, d.day, lat, lng, tz: tz);
          for (var i = 0; i < order.length; i++) {
            final got = day.hhmm(order[i]);
            expect((_min(got) - _min(e.value[i])).abs(), lessThanOrEqualTo(2), reason: '$city ${e.key} ${order[i].name}: got $got, aladhan ${e.value[i]}');
          }
        });
      }
    }
  });

  group('method options', () {
    test('Hanafi Asr is later than Shafi\'i', () {
      final s = PrayerCalculator.of('karachi').compute(2026, 1, 15, 24.8607, 67.0011, tz: 'Asia/Karachi');
      final h = PrayerCalculator.of('karachi', asrFactor: 2).compute(2026, 1, 15, 24.8607, 67.0011, tz: 'Asia/Karachi');
      // aladhan school=1 (Hanafi): 16:28.
      expect((_min(h.hhmm(Prayer.asr)) - _min('16:28')).abs(), lessThanOrEqualTo(2), reason: h.hhmm(Prayer.asr));
      expect(h[Prayer.asr].isAfter(s[Prayer.asr]), isTrue);
    });

    test('high latitude rules: one-seventh and middle of the night', () {
      final a = PrayerCalculator.of('mwl').compute(2026, 6, 21, 51.5074, -0.1278, tz: 'Europe/London');
      final s = PrayerCalculator.of('mwl', highLat: HighLatRule.seventh).compute(2026, 6, 21, 51.5074, -0.1278, tz: 'Europe/London');
      final m = PrayerCalculator.of('mwl', highLat: HighLatRule.middle).compute(2026, 6, 21, 51.5074, -0.1278, tz: 'Europe/London');
      // Night 21:22 → 04:43 = 441 min: 1/7 = 63 min, 1/2 = 220 min.
      expect((_min(s.hhmm(Prayer.fajr)) - _min('03:40')).abs(), lessThanOrEqualTo(2), reason: s.hhmm(Prayer.fajr));
      expect((_min(s.hhmm(Prayer.isha)) - _min('22:25')).abs(), lessThanOrEqualTo(2), reason: s.hhmm(Prayer.isha));
      expect(m[Prayer.fajr].isBefore(a[Prayer.fajr]), isTrue);
      expect(m[Prayer.isha].isAfter(a[Prayer.isha]), isTrue);
    });

    test('Umm al-Qura Isha: 90 min, 120 in Ramadan', () {
      final c = PrayerCalculator.of('umm_al_qura');
      final jan = c.compute(2026, 1, 15, 21.4225, 39.8262, tz: 'Asia/Riyadh');
      final ram = c.compute(2026, 3, 1, 21.4225, 39.8262, tz: 'Asia/Riyadh');
      expect(jan[Prayer.isha].difference(jan[Prayer.maghrib]).inMinutes, 90);
      expect(ram[Prayer.isha].difference(ram[Prayer.maghrib]).inMinutes, 120);
      expect(isRamadan(2026, 2, 17), isFalse);
      expect(isRamadan(2026, 2, 18), isTrue);
      expect(isRamadan(2026, 3, 19), isTrue);
      expect(isRamadan(2026, 3, 20), isFalse);
    });

    test('country → method', () {
      expect(methodForCountry('EG').id, 'egypt');
      expect(methodForCountry('SA').id, 'umm_al_qura');
      expect(methodForCountry('AE').id, 'uae');
      expect(methodForCountry('KW').id, 'kuwait');
      expect(methodForCountry('QA').id, 'qatar');
      expect(methodForCountry('US').id, 'isna');
      expect(methodForCountry('PK').id, 'karachi');
      expect(methodForCountry('TR').id, 'turkey');
      expect(methodForCountry('MY').id, 'jakim');
      expect(methodForCountry('ID').id, 'kemenag');
      expect(methodForCountry('GB').id, 'mwl');
      expect(methodForCountry('ZZ').id, 'mwl');
      expect(methodForCountry(null).id, 'mwl');
    });
  });

  group('time zones (rule table, as off the web)', () {
    test('fixed zones', () {
      expect(tzOffsetMinutes('Asia/Dubai', DateTime.utc(2026, 7, 1)), 240);
      expect(tzOffsetMinutes('Asia/Riyadh', DateTime.utc(2026, 1, 1)), 180);
      expect(tzOffsetMinutes('Asia/Tehran', DateTime.utc(2026, 7, 1)), 210);
      expect(tzOffsetMinutes('Asia/Kolkata', DateTime.utc(2026, 7, 1)), 330);
      expect(tzOffsetMinutes('Etc/GMT-4', DateTime.utc(2026, 7, 1)), 240);
      expect(tzOffsetMinutes('UTC', DateTime.utc(2026, 7, 1)), 0);
    });

    test('London: last Sunday of March 01:00 UTC → last Sunday of October 01:00 UTC', () {
      expect(tzOffsetMinutes('Europe/London', DateTime.utc(2026, 3, 29, 0, 59)), 0);
      expect(tzOffsetMinutes('Europe/London', DateTime.utc(2026, 3, 29, 1, 0)), 60);
      expect(tzOffsetMinutes('Europe/London', DateTime.utc(2026, 10, 25, 0, 59)), 60);
      expect(tzOffsetMinutes('Europe/London', DateTime.utc(2026, 10, 25, 1, 0)), 0);
      expect(tzOffsetMinutes('Europe/Paris', DateTime.utc(2026, 7, 1)), 120);
    });

    test('New York: 2nd Sunday of March → 1st Sunday of November', () {
      expect(tzOffsetMinutes('America/New_York', DateTime.utc(2026, 3, 8, 6, 59)), -300);
      expect(tzOffsetMinutes('America/New_York', DateTime.utc(2026, 3, 8, 7, 0)), -240);
      expect(tzOffsetMinutes('America/New_York', DateTime.utc(2026, 11, 1, 5, 59)), -240);
      expect(tzOffsetMinutes('America/New_York', DateTime.utc(2026, 11, 1, 6, 0)), -300);
      expect(tzOffsetMinutes('America/Los_Angeles', DateTime.utc(2026, 7, 1)), -420);
    });

    test('Sydney (southern hemisphere)', () {
      expect(tzOffsetMinutes('Australia/Sydney', DateTime.utc(2026, 1, 15)), 660);
      expect(tzOffsetMinutes('Australia/Sydney', DateTime.utc(2026, 7, 15)), 600);
    });

    test('Cairo keeps Egypt\'s summer time', () {
      expect(tzOffsetMinutes('Africa/Cairo', DateTime.utc(2026, 7, 1)), 180);
      expect(tzOffsetMinutes('Africa/Cairo', DateTime.utc(2026, 1, 1)), 120);
      expect(egyptWallClock(DateTime.utc(2025, 4, 24, 22, 0)), DateTime.utc(2025, 4, 25, 1, 0));
    });

    test('today and wall clock in a zone', () {
      final at = DateTime.utc(2026, 1, 15, 21, 30); // 01:30 on the 16th in Dubai
      expect(todayIn('Asia/Dubai', at), DateTime.utc(2026, 1, 16));
      expect(todayIn('America/New_York', at), DateTime.utc(2026, 1, 15));
      expect(wallClockIn(at, 'Asia/Kolkata'), DateTime.utc(2026, 1, 16, 3, 0));
    });

    test('next prayer in the mosque\'s zone', () {
      // 10:00 in Dubai = 06:00 UTC → Dhuhr at ~12:31.
      final n = nextPrayer(25.2048, 55.2708, now: DateTime.utc(2026, 1, 15, 6, 0), calc: PrayerCalculator.of('uae'), tz: 'Asia/Dubai');
      expect(n.prayer, Prayer.dhuhr);
      expect(n.left.inMinutes, inInclusiveRange(149, 152));
      // After Isha in New York → tomorrow's Fajr.
      final ny = nextPrayer(40.7128, -74.0060, now: DateTime.utc(2026, 1, 16, 2, 0), calc: PrayerCalculator.of('isna'), tz: 'America/New_York');
      expect(ny.prayer, Prayer.fajr);
      expect(wallClockIn(ny.at, 'America/New_York').day, 16);
    });

    test('labels and unknown zones', () {
      expect(tzLabelAr('Asia/Dubai'), 'بتوقيت دبي');
      expect(utcOffsetLabel(330), 'UTC+5:30');
      expect(utcOffsetLabel(-300), 'UTC−5');
      expect(resolveTimeZone('Mars/Olympus', lng: 55.3), 'Etc/GMT-4');
      expect(resolveTimeZone('Asia/Dubai'), 'Asia/Dubai');
      expect(resolveTimeZone(null), 'Africa/Cairo');
    });

    test('device zone override and default place', () {
      debugDeviceTimeZone = 'Asia/Dubai';
      expect(deviceTimeZone, 'Asia/Dubai');
      expect(defaultPlace().$1, 'دبي');
      expect(differsFromDevice('Africa/Cairo', at: DateTime.utc(2026, 1, 1)), isTrue);
      expect(differsFromDevice('Asia/Muscat', at: DateTime.utc(2026, 1, 1)), isFalse);
      debugDeviceTimeZone = 'Europe/Nowhere';
      expect(defaultPlace().$1, 'القاهرة');
      debugDeviceTimeZone = null;
    });
  });

  group('countries & currency', () {
    test('country of a point', () {
      expect(countryAt(30.0444, 31.2357), 'EG'); // Cairo
      expect(countryAt(31.2001, 29.9187), 'EG'); // Alexandria
      expect(countryAt(24.0889, 32.8998), 'EG'); // Aswan
      expect(countryAt(27.9158, 34.3300), 'EG'); // Sharm El Sheikh
      expect(countryAt(29.5020, 34.8900), 'EG'); // Taba
      expect(countryAt(31.1316, 33.7984), 'EG'); // El Arish
      expect(countryAt(25.2048, 55.2708), 'AE'); // Dubai
      expect(countryAt(24.4539, 54.3773), 'AE'); // Abu Dhabi
      expect(countryAt(23.5880, 58.3829), 'OM'); // Muscat
      expect(countryAt(24.7136, 46.6753), 'SA'); // Riyadh
      expect(countryAt(21.4225, 39.8262), 'SA'); // Makkah
      expect(countryAt(29.3759, 47.9774), 'KW');
      expect(countryAt(25.2854, 51.5310), 'QA');
      expect(countryAt(26.2285, 50.5860), 'BH');
      expect(countryAt(31.5017, 34.4668), 'PS'); // Gaza
      expect(countryAt(32.8872, 13.1913), 'LY'); // Tripoli
      expect(countryAt(31.7600, 25.0900), 'LY'); // Bardia (west of Sallum)
      expect(countryAt(15.5007, 32.5599), 'SD'); // Khartoum
      expect(countryAt(51.5074, -0.1278), 'GB');
      expect(countryAt(40.7128, -74.0060), 'US');
      expect(countryAt(43.6532, -79.3832), 'CA'); // Toronto
      expect(countryAt(49.2827, -123.1207), 'CA'); // Vancouver
      expect(countryAt(42.3601, -71.0589), 'US'); // Boston
      expect(countryAt(47.6062, -122.3321), 'US'); // Seattle
      expect(countryAt(24.8607, 67.0011), 'PK');
      expect(countryAt(41.0082, 28.9784), 'TR');
      expect(countryAt(-6.2088, 106.8456), 'ID');
      expect(countryAt(3.1390, 101.6869), 'MY');
      expect(countryAt(1.3521, 103.8198), 'SG');
      expect(countryAt(48.8566, 2.3522), 'FR');
      expect(countryAt(52.5200, 13.4050), 'DE');
      expect(countryAt(-30.0, -140.0), isNull); // open Pacific
    });

    test('time zone → country', () {
      expect(countryOfTimeZone('Asia/Dubai'), 'AE');
      expect(countryOfTimeZone('Europe/London'), 'GB');
      expect(countryOfTimeZone('Africa/Cairo'), 'EG');
      expect(countryOfTimeZone('Pacific/Nowhere'), isNull);
    });

    test('currency of a country and its label', () {
      expect(currencyOfCountry('EG'), 'EGP');
      expect(currencyOfCountry('AE'), 'AED');
      expect(currencyOfCountry('SA'), 'SAR');
      expect(currencyOfCountry('GB'), 'GBP');
      expect(currencyOfCountry('FR'), 'EUR');
      expect(currencyOfCountry(null), 'EGP');
      expect(currencyOfCountry('ZZ'), 'USD');
      expect(currencyLabel('EGP'), 'ج.م');
      expect(currencyLabel('AED'), 'د.إ');
      expect(currencyLabel('SAR'), 'ر.س');
      expect(currencyLabel('KWD'), 'د.ك');
      expect(currencyLabel('QAR'), 'ر.ق');
      expect(currencyLabel('BHD'), 'د.ب');
      expect(currencyLabel('OMR'), 'ر.ع');
      expect(currencyLabel('JOD'), 'د.أ');
      expect(currencyLabel('USD'), r'$');
      expect(currencyLabel('EUR'), '€');
      expect(currencyLabel('GBP'), '£');
      expect(currencyLabel('PKR'), 'PKR');
      expect(currencyLabel(null), 'ج.م');
    });
  });
}
