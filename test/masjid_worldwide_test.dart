import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mogtama3y/core/masjid/masjid_service.dart';
import 'package:mogtama3y/core/masjid/osm_mosques.dart';
import 'package:mogtama3y/core/masjid/prayer_prefs.dart';
import 'package:mogtama3y/core/masjid/prayer_times.dart';
import 'package:mogtama3y/core/masjid/world_time.dart';
import 'package:mogtama3y/core/masjid_tools/reminder_settings.dart';
import 'package:mogtama3y/core/masjid_tools/world_cities.dart';

void main() {
  tearDown(() => debugDeviceTimeZone = null);

  group('money in the mosque currency', () {
    test('amounts and progress', () {
      expect(masjidAmount(1500, 'AED'), '1,500 د.إ');
      expect(masjidAmount(1500, null), '1,500 ج.م');
      expect(masjidAmount(20, 'USD'), r'20 $');
      expect(masjidAmount(20, 'PKR'), '20 PKR');
      expect(needProgressText(500, 1000, 'SAR'), 'اتدفع 500 من 1,000 — باقي 500 ر.س');
      expect(needProgressText(500, 1000), 'اتدفع 500 من 1,000 — باقي 500 ج.م');
      expect(needProgressText(1200, 1000, 'KWD'), endsWith('د.ك'));
    });

    test('WhatsApp links', () {
      expect(waDigits('01001234567'), '201001234567');
      expect(waDigits('+971501234567'), '971501234567');
    });
  });

  group('OpenStreetMap', () {
    test('query', () {
      expect(overpassQuery(25.2048, 55.2708, 1500),
          '[out:json][timeout:20];nwr[amenity=place_of_worship][religion=muslim](around:1500,25.20480,55.27080);out center 50;');
    });

    test('parse: nodes and ways (center), Arabic name first, unnamed → «مسجد»', () {
      final r = parseOverpass({
        'elements': [
          {'type': 'node', 'id': 1, 'lat': 25.2, 'lon': 55.27, 'tags': {'name': 'Al Farooq Mosque', 'name:ar': 'مسجد الفاروق'}},
          {'type': 'way', 'id': 2, 'center': {'lat': 25.21, 'lon': 55.28}, 'tags': {'name': 'Jumeirah Mosque'}},
          {'type': 'node', 'id': 3, 'lat': 25.22, 'lon': 55.29},
          {'type': 'node', 'id': 4}, // no position → skipped
        ],
      });
      expect(r.map((m) => m.name), ['مسجد الفاروق', 'Jumeirah Mosque', 'مسجد']);
      expect(r[1].type, 'way');
      expect(r[1].lat, 25.21);
    });

    test('merge: drops what we already have within 40 m, nearest first', () {
      final osm = [
        const OsmMosque(type: 'node', id: 1, name: 'A', lat: 25.2000, lng: 55.2700),
        const OsmMosque(type: 'node', id: 2, name: 'B', lat: 25.2100, lng: 55.2700),
        const OsmMosque(type: 'node', id: 3, name: 'C', lat: 25.2050, lng: 55.2700),
      ];
      final ours = [
        {'lat': 25.20002, 'lng': 55.27002}, // ~3 m from A
      ];
      final r = osmNotInOurs(osm, ours, 25.2, 55.27);
      expect(r.map((m) => m.id), [3, 2]);
      expect(r.first.distanceM, closeTo(556, 5));
    });

    test('near(): fetches once, then serves the device cache (and completes)', () async {
      SharedPreferences.setMockInitialValues({});
      OsmMosques.debugResetRateLimit();
      var calls = 0;
      final client = MockClient((req) async {
        calls++;
        expect(req.url.toString(), OsmMosques.endpoint);
        expect(req.bodyFields['data'], contains('religion=muslim'));
        return http.Response.bytes(utf8.encode(jsonEncode({
          'elements': [
            {'type': 'node', 'id': 7, 'lat': 25.21, 'lon': 55.28, 'tags': {'name': 'مسجد الحي'}},
          ],
        })), 200);
      });
      final a = await OsmMosques.near(25.2048, 55.2708, radiusM: 1200, client: client).timeout(const Duration(seconds: 5));
      final b = await OsmMosques.near(25.2048, 55.2708, radiusM: 1200, client: client).timeout(const Duration(seconds: 5));
      expect(a.single.name, 'مسجد الحي');
      expect(b.single.id, 7);
      expect(calls, 1);
    });

    test('near(): concurrent calls for one area share one request', () async {
      SharedPreferences.setMockInitialValues({});
      OsmMosques.debugResetRateLimit();
      var calls = 0;
      final client = MockClient((req) async {
        calls++;
        await Future<void>.delayed(const Duration(milliseconds: 50));
        return http.Response.bytes(utf8.encode(jsonEncode({'elements': []})), 200);
      });
      await Future.wait([for (var i = 0; i < 5; i++) OsmMosques.near(-33.86, 151.2, radiusM: 900, client: client)]);
      expect(calls, 1);
    });

    test('distance', () {
      expect(distanceMeters(30.0444, 31.2357, 30.0444, 31.2357), 0);
      expect(distanceMeters(25.2048, 55.2708, 24.4539, 54.3773) / 1000, closeTo(123, 3)); // Dubai → Abu Dhabi
    });

    test('cache key: ~1 km cells per radius', () {
      expect(OsmMosques.cacheKey(25.2048, 55.2708, 1500), OsmMosques.cacheKey(25.2031, 55.2712, 1500));
      expect(OsmMosques.cacheKey(25.2048, 55.2708, 1500) == OsmMosques.cacheKey(25.2048, 55.2708, 3000), isFalse);
    });

    test('mosque JSON round trip (the device cache)', () {
      const m = OsmMosque(type: 'way', id: 42, name: 'مسجد', lat: 25.2, lng: 55.3);
      final back = OsmMosque.fromJson(m.toJson(), fromLat: 25.2, fromLng: 55.3)!;
      expect([back.type, back.id, back.name, back.lat, back.lng, back.distanceM], ['way', 42, 'مسجد', 25.2, 55.3, 0]);
      expect(OsmMosque.fromJson({'type': 'node'}), isNull);
    });
  });

  group('prayer settings & reminders anywhere', () {
    test('auto method follows the country, a fixed one wins', () {
      const auto = PrayerPrefs();
      expect(auto.methodFor('AE').id, 'uae');
      expect(auto.methodFor('EG').id, 'egypt');
      const fixed = PrayerPrefs(method: 'isna', asr: 2, highLat: HighLatRule.seventh);
      expect(fixed.methodFor('EG').id, 'isna');
      expect(fixed.serverParams('EG'), {'p_method': 'isna', 'p_asr': 2, 'p_high_lat': 'seventh'});
      expect(PrayerPrefs.fromJson(fixed.toJson()).highLat, HighLatRule.seventh);
      expect(const PrayerPrefs(method: 'nope').isAuto, isTrue);
    });

    test('reminders in Dubai: Dubai clock, UAE method', () {
      debugDeviceTimeZone = 'Africa/Cairo';
      const s = ReminderSettings(offsets: {Prayer.fajr: 10}, lat: 25.2048, lng: 55.2708, label: 'دبي', tz: 'Asia/Dubai');
      expect(s.zone, 'Asia/Dubai');
      expect(s.country, 'AE');
      expect(s.calculator.method.id, 'uae');
      // 01:00 UTC on 15 Jan = 05:00 Dubai → next is Fajr at 05:45 (aladhan), alert 05:35.
      final n = nextAlert(s, DateTime.utc(2026, 1, 15, 1, 0))!;
      expect(n.prayer, Prayer.fajr);
      expect(wallClockIn(n.adhan, 'Asia/Dubai').hour, 5);
      expect(n.body, startsWith('أذان الفجر 5:4'));
      final round = ReminderSettings.fromJson(s.toJson());
      expect(round.tz, 'Asia/Dubai');
      expect(s.copyWith(tz: '').tz, isNull);
    });

    test('without a zone the device clock is used', () {
      debugDeviceTimeZone = 'Europe/London';
      const s = ReminderSettings(offsets: {Prayer.isha: 0}, lat: 51.5074, lng: -0.1278, label: 'لندن');
      expect(s.zone, 'Europe/London');
      expect(s.calculator.method.id, 'mwl');
    });
  });

  group('city picker', () {
    test('the device country first; Egypt and the world included', () {
      debugDeviceTimeZone = 'Asia/Dubai';
      final c = pickerCities();
      expect(c.first.iso, 'AE');
      expect(c.any((x) => x.name == 'القاهرة' && x.tz == 'Africa/Cairo'), isTrue);
      expect(c.any((x) => x.name == 'لندن' && x.tz == 'Europe/London'), isTrue);
      expect(c.any((x) => x.name == 'مكة المكرمة'), isTrue);
      expect(c.length, greaterThan(100));
      expect(searchCities(c, 'الإمارات').every((x) => x.iso == 'AE'), isTrue);
      expect(c.firstWhere((x) => x.name == 'دبي').label, 'دبي — الإمارات');
    });
  });
}
