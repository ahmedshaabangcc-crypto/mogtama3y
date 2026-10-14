import 'world_places.dart';
import 'tz_platform.dart';

/// Time zones and countries for «مسجدي» worldwide.
///
/// Offsets come from the browser's Intl (the full IANA database) on the
/// web; off the web (tests) from the compact rule table in
/// world_places.dart. Wall-clock values are DateTimes flagged UTC whose
/// fields are the local date/time (nothing re-converts them).

const cairoTz = 'Africa/Cairo';

String? _debugDeviceTz;

/// Tests: pretend the device is in [tz] (null = back to the real one).
set debugDeviceTimeZone(String? tz) => _debugDeviceTz = tz;

String? _deviceTzCache;

/// The device's IANA zone ("Asia/Dubai"). Off the web, without an
/// override, guessed from the device's current offset (Cairo when it
/// matches Egypt's clock).
String get deviceTimeZone {
  if (_debugDeviceTz != null) return _debugDeviceTz!;
  return _deviceTzCache ??= platformDeviceTimeZone() ?? _guessFromOffset(DateTime.now());
}

String _guessFromOffset(DateTime now) {
  final m = now.timeZoneOffset.inMinutes;
  if (m == tzOffsetMinutes(cairoTz, now.toUtc())) return cairoTz;
  if (m % 60 == 0) return m == 0 ? 'UTC' : 'Etc/GMT${m > 0 ? '-' : '+'}${(m ~/ 60).abs()}';
  return 'UTC';
}

TzZone? zoneInfo(String tz) {
  for (final z in tzZones) {
    if (z.tz == tz) return z;
  }
  return null;
}

int? _etcOffset(String tz) {
  if (tz == 'UTC' || tz == 'Etc/UTC' || tz == 'GMT' || tz == 'Etc/GMT') return 0;
  final m = RegExp(r'^Etc/GMT([+-])(\d{1,2})$').firstMatch(tz);
  if (m == null) return null;
  final h = int.parse(m.group(2)!);
  return (m.group(1) == '-' ? h : -h) * 60;
}

/// Whether [tz] is a zone we can compute.
bool isKnownTimeZone(String tz) => platformKnowsZone(tz) ?? (zoneInfo(tz) != null || _etcOffset(tz) != null);

/// A usable zone: [tz] when known, else one from the longitude.
String resolveTimeZone(String? tz, {double? lng}) {
  if (tz != null && tz.isNotEmpty && isKnownTimeZone(tz)) return tz;
  if (lng == null) return cairoTz;
  final h = (lng / 15).round().clamp(-12, 14);
  return h == 0 ? 'UTC' : 'Etc/GMT${h > 0 ? '-' : '+'}${h.abs()}';
}

/// Minutes east of UTC in [tz] at the instant [utc].
int tzOffsetMinutes(String tz, DateTime utc) {
  final u = utc.toUtc();
  final p = platformOffsetMinutes(tz, u);
  if (p != null) return p;
  final z = zoneInfo(tz);
  if (z == null) return _etcOffset(tz) ?? 0;
  return z.std + (_dstOn(z, u) ? 60 : 0);
}

DateTime _lastWeekdayUtc(int year, int month, int weekday) {
  final last = DateTime.utc(year, month + 1, 0);
  return DateTime.utc(year, month, last.day - ((last.weekday - weekday) % 7));
}

DateTime _nthWeekdayUtc(int year, int month, int weekday, int n) {
  final first = DateTime.utc(year, month, 1);
  final d = 1 + ((weekday - first.weekday) % 7) + 7 * (n - 1);
  return DateTime.utc(year, month, d);
}

bool _dstOn(TzZone z, DateTime u) {
  final y = u.year;
  switch (z.rule) {
    case TzRule.none:
      return false;
    case TzRule.eu:
      final start = _lastWeekdayUtc(y, 3, DateTime.sunday).add(const Duration(hours: 1));
      final end = _lastWeekdayUtc(y, 10, DateTime.sunday).add(const Duration(hours: 1));
      return !u.isBefore(start) && u.isBefore(end);
    case TzRule.us:
      final start = _nthWeekdayUtc(y, 3, DateTime.sunday, 2).add(Duration(minutes: 120 - z.std));
      final end = _nthWeekdayUtc(y, 11, DateTime.sunday, 1).add(Duration(minutes: 60 - z.std));
      return !u.isBefore(start) && u.isBefore(end);
    case TzRule.au:
      final end = _nthWeekdayUtc(y, 4, DateTime.sunday, 1).add(Duration(minutes: 120 - z.std));
      final start = _nthWeekdayUtc(y, 10, DateTime.sunday, 1).add(Duration(minutes: 120 - z.std));
      return u.isBefore(end) || !u.isBefore(start);
    case TzRule.il:
      final start = _lastWeekdayUtc(y, 3, DateTime.sunday).subtract(const Duration(days: 2)).add(Duration(minutes: 120 - z.std));
      final end = _lastWeekdayUtc(y, 10, DateTime.sunday).add(Duration(minutes: 60 - z.std));
      return !u.isBefore(start) && u.isBefore(end);
    case TzRule.eg:
      final at2 = u.add(const Duration(hours: 2));
      final at3 = u.add(const Duration(hours: 3));
      return egyptDstOn(at2.year, at2.month, at2.day) && egyptDstOn(at3.year, at3.month, at3.day);
  }
}

/// Egyptian summer time on this calendar date (Cairo wall clock)? Since
/// 2023: last Friday of April → last Thursday of October (inclusive).
bool egyptDstOn(int year, int month, int day) {
  if (year < 2023) return false; // suspended 2015–2022
  if (month < 4 || month > 10) return false;
  if (month > 4 && month < 10) return true;
  if (month == 4) return day >= _lastWeekdayUtc(year, 4, DateTime.friday).day;
  return day <= _lastWeekdayUtc(year, 10, DateTime.thursday).day;
}

/// Wall clock of [instant] in [tz] (fields = local date/time, flagged UTC).
DateTime wallClockIn(DateTime instant, String tz) {
  final u = instant.toUtc();
  return u.add(Duration(minutes: tzOffsetMinutes(tz, u)));
}

/// Today's date in [tz].
DateTime todayIn(String tz, [DateTime? now]) {
  final w = wallClockIn(now ?? DateTime.now(), tz);
  return DateTime.utc(w.year, w.month, w.day);
}

/// Today's date on the device's clock zone.
DateTime deviceToday([DateTime? now]) => todayIn(deviceTimeZone, now);

/// "UTC+4" / "UTC+5:30" / "UTC−5".
String utcOffsetLabel(int minutes) {
  final sign = minutes < 0 ? '−' : '+';
  final a = minutes.abs();
  final h = a ~/ 60, m = a % 60;
  return 'UTC$sign$h${m == 0 ? '' : ':${m.toString().padLeft(2, '0')}'}';
}

/// «بتوقيت دبي» for a known zone, else «بتوقيت UTC+4».
String tzLabelAr(String tz, {DateTime? at}) {
  final z = zoneInfo(tz);
  if (z != null) return 'بتوقيت ${z.city}';
  return 'بتوقيت ${utcOffsetLabel(tzOffsetMinutes(tz, (at ?? DateTime.now()).toUtc()))}';
}

/// Whether [tz]'s clock differs from the device's right now.
bool differsFromDevice(String tz, {DateTime? at}) {
  final u = (at ?? DateTime.now()).toUtc();
  return tzOffsetMinutes(tz, u) != tzOffsetMinutes(deviceTimeZone, u);
}

// ------------------------------------------------------------- countries

bool _inPolygon(double lat, double lng, List<(double, double)> poly) {
  var inside = false;
  for (var i = 0, j = poly.length - 1; i < poly.length; j = i++) {
    final (yi, xi) = poly[i];
    final (yj, xj) = poly[j];
    if ((yi > lat) != (yj > lat) && lng < (xj - xi) * (lat - yi) / (yj - yi) + xi) inside = !inside;
  }
  return inside;
}

/// Inside Egypt (same polygon as the server's private.in_egypt)?
bool inEgypt(double lat, double lng) => _inPolygon(lat, lng, egyptPolygon);

/// ISO country of a point (Egypt by polygon, else the smallest
/// containing box), or null over open sea / unknown.
String? countryAt(double lat, double lng) {
  if (inEgypt(lat, lng)) return 'EG';
  String? best;
  var bestArea = double.infinity;
  for (final (iso, a, b, c, d) in countryBoxes) {
    if (lat >= a && lat <= b && lng >= c && lng <= d) {
      final area = (b - a) * (d - c);
      if (area < bestArea) {
        bestArea = area;
        best = iso;
      }
    }
  }
  return best;
}

/// Country of a time zone (from the zone table), e.g. Asia/Dubai → AE.
String? countryOfTimeZone(String tz) => zoneInfo(tz)?.iso;

/// Where to compute when the device gives no location: the main city of
/// the device's zone, else Cairo. (name, lat, lng, tz)
(String, double, double, String) defaultPlace() {
  final tz = deviceTimeZone;
  final z = zoneInfo(tz);
  if (z != null) return (z.city, z.lat, z.lng, z.tz);
  return ('القاهرة', 30.0444, 31.2357, cairoTz);
}

/// Currency of a country (ISO 4217), EGP when unknown.
String currencyOfCountry(String? iso) => countries[iso]?.currency ?? (iso == null ? 'EGP' : 'USD');

/// Arabic label of a currency: «ج.م», «د.إ», «$»… else the ISO code.
String currencyLabel(String? code) => currencyLabels[code ?? 'EGP'] ?? (code ?? 'EGP');
