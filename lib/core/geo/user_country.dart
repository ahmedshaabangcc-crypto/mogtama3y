/// The signed-in user's country (profiles.country, 0089) — the default for
/// phone fields, and later (phase 2+) currency and areas.
///
/// Before the profile loads (or for guests) it's guessed from the device:
/// the browser's IANA zone → its country when that's one of the 22 Arab
/// states, else Egypt.
library;

import 'package:flutter/foundation.dart';

import 'arab_countries.dart';
import 'phones.dart';
import 'world_time.dart' show countryOfTimeZone, deviceTimeZone;

/// Country for a new account: the phone's dial code if given, else the
/// device's zone, else the location's country, else Egypt.
String guessCountry({String? phone, String? timeZone, String? locationCountry}) {
  final fromPhone = phone == null ? null : phoneCountry(phone.trim().startsWith('+') || phone.trim().startsWith('00') ? phone : null);
  if (fromPhone != null) return fromPhone;
  final tz = timeZone ?? _safeDeviceTz();
  final fromTz = tz == null ? null : countryOfTimeZone(tz);
  if (isArabCountry(fromTz)) return fromTz!;
  if (isArabCountry(locationCountry)) return locationCountry!.toUpperCase();
  return 'EG';
}

String? _safeDeviceTz() {
  try {
    return deviceTimeZone;
  } catch (_) {
    return null;
  }
}

class UserCountry {
  UserCountry._();

  /// Current ISO2 (never null).
  static final ValueNotifier<String> iso = ValueNotifier<String>(guessCountry());

  static ArabCountry get country => arabCountry(iso.value) ?? egypt;

  /// Whether the user is treated as Egyptian (SMS verification offered).
  static bool get inEgypt => iso.value == 'EG';

  /// Called with the profile row when it loads.
  static void fromProfile(Map<String, dynamic>? profile) {
    final c = profile?['country'];
    if (c is String && c.length == 2) iso.value = c.toUpperCase();
  }

  /// Back to the device guess (sign-out).
  static void reset() => iso.value = guessCountry();
}
