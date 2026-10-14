/// The signed-in user's country (profiles.country, 0089) — the default for
/// phone fields, and later (phase 2+) currency and areas.
///
/// Before the profile loads (or for guests) it's guessed from the device:
/// the browser's IANA zone → its country when that's one of the 22 Arab
/// states, else Egypt.
library;

import 'package:flutter/foundation.dart';

import '../masjid_tools/platform/kv_store.dart';
import 'arab_countries.dart';
import 'phones.dart';
import 'world_time.dart' show countryOfTimeZone, currencyLabel, deviceTimeZone;

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

  /// Another country the user chose to browse in the feeds (the flag chip,
  /// FeedCountryButton) — null = their own. Remembered on this device.
  static final ValueNotifier<String?> feedOverrideNotifier = ValueNotifier<String?>(null);
  static String? get feedOverride => feedOverrideNotifier.value;
  static set feedOverride(String? v) {
    final c = v?.toUpperCase();
    feedOverrideNotifier.value = (c == null || c == iso.value || !isArabCountry(c)) ? null : c;
    kvSet(_feedKey, feedOverrideNotifier.value ?? '');
  }

  static const _feedKey = 'feed_country';

  /// Restores the remembered feed country (app start).
  static Future<void> loadFeedOverride() async {
    final v = await kvGet(_feedKey);
    if (v != null && isArabCountry(v) && v != iso.value) feedOverrideNotifier.value = v;
  }

  /// Country whose listings the feeds show (0092): the user's own unless
  /// they picked another one.
  static String get feedCountry => feedOverride ?? iso.value;

  /// The user's currency (ISO) — the default for new listings and the
  /// suffix of price fields.
  static String get currency => country.currency;

  /// «ج.م», «ر.س»… of [currency].
  static String get currencyText => currencyLabel(currency);

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
