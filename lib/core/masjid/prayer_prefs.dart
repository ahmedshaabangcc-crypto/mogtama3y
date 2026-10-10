import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../masjid_tools/platform/kv_store.dart';
import 'prayer_times.dart';

/// The user's prayer-time settings, kept on this device: the method
/// ('auto' = the usual one of the place's country), Asr (1 Shafi'i /
/// 2 Hanafi) and the high-latitude rule.
@immutable
class PrayerPrefs {
  const PrayerPrefs({this.method = 'auto', this.asr = 1, this.highLat = HighLatRule.angle});

  final String method;
  final int asr;
  final HighLatRule highLat;

  bool get isAuto => method == 'auto' || !prayerMethods.any((m) => m.id == method);

  /// The method used for a place in [country].
  PrayerMethod methodFor(String? country) => isAuto ? methodForCountry(country) : prayerMethodById(method);

  PrayerCalculator calculatorFor(String? country) => PrayerCalculator(method: methodFor(country), asrFactor: asr, highLat: highLat);

  PrayerPrefs copyWith({String? method, int? asr, HighLatRule? highLat}) =>
      PrayerPrefs(method: method ?? this.method, asr: asr ?? this.asr, highLat: highLat ?? this.highLat);

  Map<String, dynamic> toJson() => {'method': method, 'asr': asr, 'high_lat': highLat.name};

  factory PrayerPrefs.fromJson(Map<String, dynamic> j) => PrayerPrefs(
        method: j['method'] is String ? j['method'] as String : 'auto',
        asr: j['asr'] == 2 ? 2 : 1,
        highLat: HighLatRule.values.firstWhere((r) => r.name == j['high_lat'], orElse: () => HighLatRule.angle),
      );

  static const _key = 'mt.prayer_prefs.v1';

  /// Current settings; the prayer cards listen.
  static final current = ValueNotifier<PrayerPrefs>(const PrayerPrefs());
  static bool _loaded = false;

  static Future<PrayerPrefs> load() async {
    if (_loaded) return current.value;
    _loaded = true;
    try {
      final raw = await kvGet(_key);
      if (raw != null) current.value = PrayerPrefs.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {}
    return current.value;
  }

  static Future<void> save(PrayerPrefs p) async {
    current.value = p;
    _loaded = true;
    try {
      await kvSet(_key, jsonEncode(p.toJson()));
    } catch (_) {}
  }

  /// The settings as the server's set_prayer_reminders takes them (0087).
  Map<String, dynamic> serverParams(String? country) => {
        'p_method': methodFor(country).id,
        'p_asr': asr,
        'p_high_lat': highLat.name,
      };
}
