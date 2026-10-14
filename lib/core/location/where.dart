import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

import '../masjid_tools/platform/kv_store.dart';
import 'location_policy.dart';

export 'location_policy.dart' show GeoFix, GeoPermission, LocationDecision, locationMaxAge;

/// The user's position, shared by every screen. The last good fix is kept
/// on the device for 12 hours (see location_policy.dart), so the browser —
/// and the iPhone's location prompt — is asked once, not on every launch.
///
/// * [current]: for a tap («حدّد مكاني») — reuses a fix under 12 h old,
///   else asks the browser (the prompt is fine: the user asked).
///   `fresh: true` («حدّث موقعي») always asks.
/// * [quiet]: for screens opening — never shows the prompt. A remembered
///   fix, or a silent one when the permission is known granted (not on
///   iPhone), or null → show a «فعّل الموقع» chip.
/// Places that need a precise new fix every time (the report form, the
/// e-address form) call Geolocator directly.
class Where {
  Where._();

  static const _key = 'm3.where.v1';
  static GeoFix? _last;
  static bool _loaded = false;

  /// The browser refused the location (shown as a small chip, no nagging).
  static final denied = ValueNotifier<bool>(false);

  static Future<void> _load() async {
    if (_loaded) return;
    _loaded = true;
    try {
      final raw = await kvGet(_key);
      if (raw != null) _last ??= GeoFix.fromJson(jsonDecode(raw));
    } catch (_) {}
  }

  static Position _toPosition(GeoFix f) => Position(
        latitude: f.lat,
        longitude: f.lng,
        timestamp: f.at,
        accuracy: f.accuracy,
        altitude: 0,
        altitudeAccuracy: 0,
        heading: 0,
        headingAccuracy: 0,
        speed: 0,
        speedAccuracy: 0,
      );

  /// A fix under 12 hours old, or null (memory only — call [quiet] first
  /// on a cold start to read the saved one).
  static Position? get cached => _last != null && _last!.freshAt(DateTime.now(), locationMaxAge) ? _toPosition(_last!) : null;

  /// The last fix of any age (e.g. to show while asking for a new one).
  static Future<GeoFix?> lastKnown() async {
    await _load();
    return _last;
  }

  static Future<GeoPermission> permission() async {
    try {
      final p = await Geolocator.checkPermission();
      switch (p) {
        case LocationPermission.always:
        case LocationPermission.whileInUse:
          return GeoPermission.granted;
        case LocationPermission.deniedForever:
          return GeoPermission.denied;
        case LocationPermission.denied:
          // On the web this is the «prompt» state (not asked yet).
          return kIsWeb ? GeoPermission.prompt : GeoPermission.denied;
        case LocationPermission.unableToDetermine:
          return GeoPermission.unknown;
      }
    } catch (_) {
      return GeoPermission.unknown;
    }
  }

  static bool get _ios => defaultTargetPlatform == TargetPlatform.iOS;

  static Future<Position> _ask() async {
    final settings = kIsWeb
        ? WebSettings(accuracy: LocationAccuracy.medium, maximumAge: const Duration(minutes: 2), timeLimit: const Duration(seconds: 15))
        : const LocationSettings(accuracy: LocationAccuracy.medium, timeLimit: Duration(seconds: 15));
    try {
      final p = await Geolocator.getCurrentPosition(locationSettings: settings);
      _last = GeoFix(p.latitude, p.longitude, p.accuracy, DateTime.now().toUtc());
      denied.value = false;
      try {
        await kvSet(_key, jsonEncode(_last!.toJson()));
      } catch (_) {}
      return p;
    } catch (e) {
      if (e is PermissionDeniedException || (await permission()) == GeoPermission.denied) denied.value = true;
      rethrow;
    }
  }

  /// For a user's tap. [fresh]: skip the remembered fix.
  static Future<Position> current({bool fresh = false}) async {
    await _load();
    final d = locationDecision(cached: _last, now: DateTime.now(), permission: GeoPermission.unknown, userAction: true, fresh: fresh);
    if (d == LocationDecision.useCached) return _toPosition(_last!);
    return _ask();
  }

  /// For a screen opening: never shows the browser's prompt. Null = needs a
  /// tap (see [denied] for whether the browser blocked it).
  static Future<Position?> quiet() async {
    await _load();
    final now = DateTime.now();
    if (_last != null && _last!.freshAt(now, locationMaxAge)) return _toPosition(_last!);
    final perm = await permission();
    if (perm == GeoPermission.denied) denied.value = true;
    final d = locationDecision(cached: _last, now: now, permission: perm, ios: _ios);
    if (d != LocationDecision.request) return null;
    try {
      return await _ask();
    } catch (_) {
      return null;
    }
  }
}
