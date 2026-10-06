import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

/// The user's rough position, shared by the browsing screens (home, discover,
/// technicians, reports, people). A fix is reused for 10 minutes and the
/// browser may hand back a cached one, so screens open instantly instead of
/// each waiting several seconds for GPS. Places that need a precise, fresh
/// fix (the report form, the e-address form) call Geolocator directly.
class Where {
  Where._();

  static const _maxAge = Duration(minutes: 10);
  static Position? _last;
  static DateTime? _at;

  static Position? get cached =>
      _last != null && _at != null && DateTime.now().difference(_at!) < _maxAge ? _last : null;

  static Future<Position> current() async {
    final hit = cached;
    if (hit != null) return hit;
    final settings = kIsWeb
        ? WebSettings(accuracy: LocationAccuracy.medium, maximumAge: _maxAge, timeLimit: const Duration(seconds: 15))
        : const LocationSettings(accuracy: LocationAccuracy.medium, timeLimit: Duration(seconds: 15));
    final p = await Geolocator.getCurrentPosition(locationSettings: settings);
    _last = p;
    _at = DateTime.now();
    return p;
  }
}
