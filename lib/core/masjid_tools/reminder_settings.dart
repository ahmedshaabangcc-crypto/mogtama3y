import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../masjid/prayer_prefs.dart';
import '../masjid/prayer_times.dart';
import '../masjid/world_time.dart';
import 'platform/kv_store.dart';

/// «تنبيه الصلاة» settings, kept on this device (and mirrored to the
/// server for push when the user is signed in — see
/// backend/migrations/0082_masjid_tools.sql and 0087 for anywhere on Earth).
/// Times use the method of the place's country (or the user's choice,
/// PrayerPrefs) on the clock of [zone].
class ReminderSettings {
  const ReminderSettings({
    this.offsets = const {},
    this.source = 'current',
    this.lat = 30.0444,
    this.lng = 31.2357,
    this.label = 'القاهرة',
    this.sound = true,
    this.push = false,
    this.tz,
  });

  /// Minutes before the adhan per enabled prayer (0/5/10/15). A prayer
  /// missing from the map is off.
  final Map<Prayer, int> offsets;

  /// 'current' | 'mosque' | 'city'.
  final String source;
  final double lat;
  final double lng;
  final String label;
  final bool sound;

  /// The user asked for phone notifications with the app closed.
  final bool push;

  /// IANA zone of the place (a picked city's); null = the device's.
  final String? tz;

  /// The zone the times are shown in.
  String get zone => resolveTimeZone(tz ?? deviceTimeZone, lng: lng);

  /// Country of the place (→ default method).
  String? get country => countryAt(lat, lng) ?? countryOfTimeZone(zone);

  PrayerCalculator get calculator => PrayerPrefs.current.value.calculatorFor(country);

  static const allowedOffsets = [0, 5, 10, 15];

  bool get anyOn => offsets.isNotEmpty;

  /// [tz]: pass '' to go back to the device's zone.
  ReminderSettings copyWith({Map<Prayer, int>? offsets, String? source, double? lat, double? lng, String? label, bool? sound, bool? push, String? tz}) => ReminderSettings(
        offsets: offsets ?? this.offsets,
        source: source ?? this.source,
        lat: lat ?? this.lat,
        lng: lng ?? this.lng,
        label: label ?? this.label,
        sound: sound ?? this.sound,
        push: push ?? this.push,
        tz: tz == null ? this.tz : (tz.isEmpty ? null : tz),
      );

  /// The JSON the server RPC takes: {"fajr": 10, "isha": 0}.
  Map<String, int> get offsetsJson => {for (final e in offsets.entries) e.key.name: e.value};

  Map<String, dynamic> toJson() => {
        'offsets': offsetsJson,
        'source': source,
        'lat': lat,
        'lng': lng,
        'label': label,
        'sound': sound,
        'push': push,
        if (tz != null) 'tz': tz,
      };

  factory ReminderSettings.fromJson(Map<String, dynamic> j) {
    final raw = (j['offsets'] as Map?) ?? const {};
    final offsets = <Prayer, int>{};
    for (final p in fivePrayers) {
      final v = raw[p.name];
      if (v is num && allowedOffsets.contains(v.toInt())) offsets[p] = v.toInt();
    }
    return ReminderSettings(
      offsets: offsets,
      source: const ['current', 'mosque', 'city'].contains(j['source']) ? j['source'] as String : 'current',
      lat: (j['lat'] as num?)?.toDouble() ?? 30.0444,
      lng: (j['lng'] as num?)?.toDouble() ?? 31.2357,
      label: (j['label'] as String?) ?? 'القاهرة',
      sound: j['sound'] != false,
      push: j['push'] == true,
      tz: j['tz'] is String ? j['tz'] as String : null,
    );
  }

  // ------------------------------------------------------------ storage
  static const _key = 'mt.reminders.v1';

  /// The current settings; screens and the in-app alert host listen.
  static final current = ValueNotifier<ReminderSettings?>(null);

  static Future<ReminderSettings> load() async {
    if (current.value != null) return current.value!;
    final d = defaultPlace();
    var s = ReminderSettings(lat: d.$2, lng: d.$3, label: d.$1, tz: d.$4 == deviceTimeZone ? null : d.$4);
    try {
      final raw = await kvGet(_key);
      if (raw != null) s = ReminderSettings.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {}
    current.value = s;
    return s;
  }

  static Future<void> save(ReminderSettings s) async {
    current.value = s;
    try {
      await kvSet(_key, jsonEncode(s.toJson()));
    } catch (_) {}
  }
}

/// One alert the app should show: [prayer] at [adhan], [minutesBefore]
/// minutes early (0 = it's the adhan time).
class PrayerAlert {
  const PrayerAlert(this.prayer, this.adhan, this.minutesBefore, [this.tz = cairoTz]);
  final Prayer prayer;

  /// Zone of the place (for the time shown).
  final String tz;
  final DateTime adhan;
  final int minutesBefore;

  /// Unique per prayer per day — so an alert fires once.
  String get key => '${prayer.name}@${adhan.toUtc().toIso8601String()}';

  DateTime get alertAt => adhan.subtract(Duration(minutes: minutesBefore));

  String get title => minutesBefore == 0 ? 'حان الآن موعد أذان ${prayerNames[prayer]}' : '${prayerNames[prayer]} بعد ${_mins(minutesBefore)}';

  String get body => 'أذان ${prayerNames[prayer]} ${format12(wallClockIn(adhan, tz))}';

  static String _mins(int m) => m <= 10 ? '$m دقايق' : '$m دقيقة';
}

/// Alerts that are due at [now]: their alert time passed less than
/// [window] ago and they weren't already shown ([shown] keys).
List<PrayerAlert> dueAlerts(ReminderSettings s, DateTime now, Set<String> shown, {Duration window = const Duration(minutes: 3)}) {
  if (!s.anyOn) return const [];
  final instant = now.toUtc();
  final zone = s.zone;
  final calc = s.calculator;
  final today = todayIn(zone, instant);
  final out = <PrayerAlert>[];
  for (final d in [today.subtract(const Duration(days: 1)), today, today.add(const Duration(days: 1))]) {
    final day = calc.compute(d.year, d.month, d.day, s.lat, s.lng, tz: zone);
    for (final e in s.offsets.entries) {
      final a = PrayerAlert(e.key, day[e.key], e.value, zone);
      final since = instant.difference(a.alertAt);
      if (!since.isNegative && since < window && !shown.contains(a.key)) out.add(a);
    }
  }
  return out;
}

/// The next alert after [now] (for the settings screen's «التنبيه الجاي»).
PrayerAlert? nextAlert(ReminderSettings s, DateTime now) {
  if (!s.anyOn) return null;
  final instant = now.toUtc();
  final zone = s.zone;
  final calc = s.calculator;
  final today = todayIn(zone, instant);
  PrayerAlert? best;
  for (final d in [today, today.add(const Duration(days: 1))]) {
    final day = calc.compute(d.year, d.month, d.day, s.lat, s.lng, tz: zone);
    for (final e in s.offsets.entries) {
      final a = PrayerAlert(e.key, day[e.key], e.value, zone);
      if (a.alertAt.isAfter(instant) && (best == null || a.alertAt.isBefore(best.alertAt))) best = a;
    }
  }
  return best;
}
