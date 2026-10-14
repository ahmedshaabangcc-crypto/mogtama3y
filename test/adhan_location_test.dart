import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mogtama3y/core/location/location_policy.dart';
import 'package:mogtama3y/core/masjid/prayer_times.dart';
import 'package:mogtama3y/core/masjid_tools/reminder_settings.dart';
import 'package:mogtama3y/features/masjid_tools/prayer_reminder_host.dart' show adhanFromLink;

void main() {
  group('location: ask once, not on every launch', () {
    final now = DateTime.utc(2026, 10, 14, 12);
    final fresh = GeoFix(30.04, 31.23, 25, now.subtract(const Duration(hours: 2)));
    final old = GeoFix(30.04, 31.23, 25, now.subtract(const Duration(hours: 13)));

    test('a fix under 12 h is reused — no browser call, whatever the permission', () {
      for (final p in GeoPermission.values) {
        expect(locationDecision(cached: fresh, now: now, permission: p), LocationDecision.useCached);
        expect(locationDecision(cached: fresh, now: now, permission: p, userAction: true), LocationDecision.useCached);
        expect(locationDecision(cached: fresh, now: now, permission: p, ios: true), LocationDecision.useCached);
      }
    });
    test('opening a screen never prompts: only a known-granted permission is used silently', () {
      expect(locationDecision(cached: old, now: now, permission: GeoPermission.granted), LocationDecision.request);
      expect(locationDecision(cached: null, now: now, permission: GeoPermission.granted), LocationDecision.request);
      expect(locationDecision(cached: old, now: now, permission: GeoPermission.prompt), LocationDecision.needTap);
      expect(locationDecision(cached: null, now: now, permission: GeoPermission.unknown), LocationDecision.needTap);
    });
    test('after a denial: no nagging, just the chip', () {
      expect(locationDecision(cached: null, now: now, permission: GeoPermission.denied), LocationDecision.needTap);
    });
    test('iPhone: never a silent call (it would show the prompt again)', () {
      expect(locationDecision(cached: old, now: now, permission: GeoPermission.granted, ios: true), LocationDecision.needTap);
    });
    test('a tap asks; «حدّث موقعي» (fresh) asks even with a remembered fix', () {
      expect(locationDecision(cached: null, now: now, permission: GeoPermission.prompt, userAction: true), LocationDecision.request);
      expect(locationDecision(cached: fresh, now: now, permission: GeoPermission.granted, userAction: true, fresh: true), LocationDecision.request);
    });
    test('a fix from the future (clock change) is not trusted', () {
      final future = GeoFix(30, 31, 0, now.add(const Duration(hours: 1)));
      expect(locationDecision(cached: future, now: now, permission: GeoPermission.prompt), LocationDecision.needTap);
    });
    test('the saved fix round-trips; junk is ignored', () {
      final back = GeoFix.fromJson(jsonDecode(jsonEncode(fresh.toJson())));
      expect(back!.lat, fresh.lat);
      expect(back.lng, fresh.lng);
      expect(back.accuracy, 25);
      expect(back.at, fresh.at);
      expect(GeoFix.fromJson({'lat': 'x', 'lng': 1, 'at': 1}), isNull);
      expect(GeoFix.fromJson({'lat': 120, 'lng': 1, 'at': 1}), isNull);
      expect(GeoFix.fromJson(null), isNull);
    });
  });

  group('adhan style & voice', () {
    test('defaults: quiet notification, Madinah voice', () {
      const s = ReminderSettings();
      expect(s.style, AdhanStyle.quiet);
      expect(s.voice, 'madinah');
      expect(s.styleFor(Prayer.fajr), AdhanStyle.quiet);
    });
    test('per-prayer choice over the global one; saved and read back', () {
      final s = const ReminderSettings(offsets: {Prayer.fajr: 0, Prayer.asr: 0, Prayer.isha: 10})
          .copyWith(style: AdhanStyle.full, styles: {Prayer.fajr: AdhanStyle.takbir}, voice: 'calm');
      expect(s.styleFor(Prayer.fajr), AdhanStyle.takbir);
      expect(s.styleFor(Prayer.asr), AdhanStyle.full);
      expect(s.stylesJson, {'fajr': 'takbir', 'asr': 'full', 'isha': 'full'});
      final back = ReminderSettings.fromJson(jsonDecode(jsonEncode(s.toJson())) as Map<String, dynamic>);
      expect(back.style, AdhanStyle.full);
      expect(back.styles, {Prayer.fajr: AdhanStyle.takbir});
      expect(back.voice, 'calm');
    });
    test('old saved settings (before 0090) and junk fall back safely', () {
      final old = ReminderSettings.fromJson({'offsets': {'asr': 0}, 'sound': true});
      expect(old.style, AdhanStyle.quiet);
      expect(old.voice, defaultAdhanVoice);
      final junk = ReminderSettings.fromJson({'style': 'loud', 'styles': {'asr': 'x', 'sunrise': 'full'}, 'voice': 'nope'});
      expect(junk.style, AdhanStyle.quiet);
      expect(junk.styles, isEmpty);
      expect(junk.voice, defaultAdhanVoice);
    });
    test('every voice has its full and takbir file in web/adhan/', () {
      for (final v in adhanVoices) {
        for (final st in [AdhanStyle.full, AdhanStyle.takbir]) {
          expect(File('web/${v.url(st)}').existsSync(), isTrue, reason: v.url(st));
        }
      }
      expect(File('web/adhan/CREDITS.txt').existsSync(), isTrue);
    });
  });

  group('tapping the adhan notification', () {
    const cairo = ReminderSettings(offsets: {Prayer.asr: 0}, lat: 30.0444, lng: 31.2357, tz: 'Africa/Cairo');
    DateTime asrAt(DateTime day) => cairo.calculator.compute(day.year, day.month, day.day, cairo.lat, cairo.lng, tz: cairo.zone)[Prayer.asr];
    final asr = asrAt(DateTime(2026, 10, 14));

    test('right after the adhan → plays what the link says', () {
      final w = adhanFromLink(Uri.parse('/masjid/tools/reminders?adhan=asr&style=takbir&voice=short'), cairo, asr.add(const Duration(minutes: 2)));
      expect(w?.prayer, Prayer.asr);
      expect(w?.style, AdhanStyle.takbir);
      expect(w?.voice, 'short');
    });
    test('a quiet notification or an old one tapped later plays nothing', () {
      expect(adhanFromLink(Uri.parse('/masjid/tools/reminders?adhan=asr&style=quiet'), cairo, asr), isNull);
      expect(adhanFromLink(Uri.parse('/masjid/tools/reminders?adhan=asr&style=full'), cairo, asr.add(const Duration(hours: 2))), isNull);
      expect(adhanFromLink(Uri.parse('/masjid/tools/reminders'), cairo, asr), isNull);
      expect(adhanFromLink(Uri.parse('/masjid/tools/reminders?adhan=sunrise&style=full'), cairo, asr), isNull);
    });
    test('missing style/voice in the link → this device\'s choice', () {
      final s = cairo.copyWith(style: AdhanStyle.full, voice: 'calm');
      final w = adhanFromLink(Uri.parse('/masjid/tools/reminders?adhan=asr'), s, asr.add(const Duration(minutes: 1)));
      expect(w?.style, AdhanStyle.full);
      expect(w?.voice, 'calm');
    });
  });
}
