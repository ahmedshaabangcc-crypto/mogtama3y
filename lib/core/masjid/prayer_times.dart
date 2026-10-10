import 'dart:math' as math;

import 'world_places.dart';
import 'world_time.dart';

export 'world_time.dart' show egyptDstOn;

/// مواقيت الصلاة — computed on the device, no external API, anywhere.
///
/// Sun position from the standard low-precision formulae (the
/// PrayTimes.org algorithm that aladhan.com also uses), refined with one
/// iteration. Methods: the official ones of Egypt, Saudi Arabia (Umm
/// al-Qura), the UAE, Kuwait, Qatar, the Gulf, Turkey, Iran, Pakistan /
/// South Asia (Karachi), North America (ISNA), Singapore, Malaysia
/// (JAKIM), Indonesia (Kemenag) and the Muslim World League (the default
/// elsewhere) — picked by country, overridable by the user. Asr Shafi'i
/// (shadow factor 1) or Hanafi (2). High latitudes: where the sun never
/// gets low enough (e.g. London in June) Fajr/Isha are capped at a portion
/// of the night (angle/60 — aladhan's default — 1/7, or half).
///
/// Clock: any IANA time zone (world_time.dart) — the device's for "my
/// location", the mosque's own for a mosque page.
enum Prayer { fajr, sunrise, dhuhr, asr, maghrib, isha }

const prayerNames = {
  Prayer.fajr: 'الفجر',
  Prayer.sunrise: 'الشروق',
  Prayer.dhuhr: 'الظهر',
  Prayer.asr: 'العصر',
  Prayer.maghrib: 'المغرب',
  Prayer.isha: 'العشاء',
};

/// The five prayers (no sunrise), in order.
const fivePrayers = [Prayer.fajr, Prayer.dhuhr, Prayer.asr, Prayer.maghrib, Prayer.isha];

/// UTC offset of Egypt's clock on that calendar date, in hours.
int egyptUtcOffsetHours(int year, int month, int day) => egyptDstOn(year, month, day) ? 3 : 2;

/// Egypt's wall clock for an instant (fields = Cairo time, flagged UTC).
DateTime egyptWallClock(DateTime instant) => wallClockIn(instant, cairoTz);

/// Today's date in Egypt.
DateTime egyptToday([DateTime? now]) => todayIn(cairoTz, now);

// --------------------------------------------------------------- methods

/// A calculation method (the parameters aladhan.com uses for the same
/// authority; `aladhanId` is its method number, for checking).
class PrayerMethod {
  const PrayerMethod(this.id, this.nameAr, this.aladhanId,
      {required this.fajr, this.isha, this.ishaMinutes, this.ramadanIshaMinutes, this.maghribAngle, this.tune = const {}});

  final String id;
  final String nameAr;
  final int aladhanId;
  final double fajr;

  /// Isha angle, or null when Isha is [ishaMinutes] after Maghrib.
  final double? isha;
  final int? ishaMinutes;

  /// Umm al-Qura: Isha 120 min after Maghrib in Ramadan.
  final int? ramadanIshaMinutes;

  /// Maghrib at this angle (Tehran) instead of sunset.
  final double? maghribAngle;

  /// Fixed minute adjustments the authority publishes with its times.
  final Map<Prayer, int> tune;
}

const prayerMethods = <PrayerMethod>[
  PrayerMethod('egypt', 'الهيئة المصرية العامة للمساحة', 5, fajr: 19.5, isha: 17.5, tune: {Prayer.dhuhr: 1}),
  PrayerMethod('umm_al_qura', 'أم القرى (السعودية)', 4, fajr: 18.5, ishaMinutes: 90, ramadanIshaMinutes: 120),
  PrayerMethod('uae', 'الهيئة العامة للشؤون الإسلامية والأوقاف (الإمارات)', 16,
      fajr: 18.2, isha: 18.2, tune: {Prayer.dhuhr: 3, Prayer.maghrib: 3}),
  PrayerMethod('kuwait', 'وزارة الأوقاف الكويتية', 9, fajr: 18, isha: 17.5),
  PrayerMethod('qatar', 'وزارة الأوقاف القطرية', 10, fajr: 18, ishaMinutes: 90),
  PrayerMethod('gulf', 'منطقة الخليج (البحرين وعُمان)', 8, fajr: 19.5, ishaMinutes: 90),
  PrayerMethod('mwl', 'رابطة العالم الإسلامي', 3, fajr: 18, isha: 17),
  PrayerMethod('isna', 'الجمعية الإسلامية لأمريكا الشمالية (ISNA)', 2, fajr: 15, isha: 15),
  PrayerMethod('karachi', 'جامعة العلوم الإسلامية بكراتشي', 1, fajr: 18, isha: 18),
  PrayerMethod('turkey', 'رئاسة الشؤون الدينية التركية', 13,
      fajr: 18, isha: 17, tune: {Prayer.sunrise: -7, Prayer.dhuhr: 5, Prayer.asr: 4, Prayer.maghrib: 7}),
  PrayerMethod('singapore', 'مجلس سنغافورة الإسلامي', 11, fajr: 20, isha: 18),
  PrayerMethod('jakim', 'جاكيم (ماليزيا)', 17, fajr: 20, isha: 18),
  PrayerMethod('kemenag', 'وزارة الشؤون الدينية (إندونيسيا)', 20, fajr: 20, isha: 18),
  PrayerMethod('tehran', 'معهد الجيوفيزياء بطهران', 7, fajr: 17.7, isha: 14, maghribAngle: 4.5),
];

PrayerMethod prayerMethodById(String? id) => prayerMethods.firstWhere((m) => m.id == id, orElse: () => prayerMethods[6]);

/// The usual method of a country (MWL when we don't know one).
PrayerMethod methodForCountry(String? iso) => prayerMethodById(countries[iso]?.method ?? 'mwl');

enum HighLatRule { angle, seventh, middle }

const highLatNames = {
  HighLatRule.angle: 'حسب الزاوية (الافتراضي)',
  HighLatRule.seventh: 'سُبع الليل',
  HighLatRule.middle: 'منتصف الليل',
};

/// Ramadan (Umm al-Qura) start / Shawwal 1 — for Isha +120 min in Ramadan.
const _ramadans = [
  ('2024-03-11', '2024-04-10'), ('2025-03-01', '2025-03-30'), ('2026-02-18', '2026-03-20'),
  ('2027-02-08', '2027-03-09'), ('2028-01-28', '2028-02-26'), ('2029-01-16', '2029-02-14'),
  ('2030-01-05', '2030-02-04'), ('2030-12-26', '2031-01-24'), ('2031-12-15', '2032-01-14'),
  ('2032-12-04', '2033-01-02'), ('2033-11-23', '2033-12-23'), ('2034-11-12', '2034-12-12'),
  ('2035-11-01', '2035-12-01'), ('2036-10-20', '2036-11-19'), ('2037-10-10', '2037-11-08'),
  ('2038-09-30', '2038-10-29'), ('2039-09-19', '2039-10-19'), ('2040-09-07', '2040-10-07'),
];

bool isRamadan(int year, int month, int day) {
  final d = '$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';
  for (final (s, e) in _ramadans) {
    if (d.compareTo(s) >= 0 && d.compareTo(e) < 0) return true;
  }
  return false;
}

// ------------------------------------------------------------------ days

class PrayerDay {
  PrayerDay._(this.year, this.month, this.day, this.tz, this.times);

  final int year;
  final int month;
  final int day;

  /// The IANA zone the wall-clock times are shown in.
  final String tz;

  /// Instants (UTC) of each time.
  final Map<Prayer, DateTime> times;

  DateTime operator [](Prayer p) => times[p]!;

  /// Wall-clock time of [p] in [tz] (fields = local time).
  DateTime wall(Prayer p) => wallClockIn(times[p]!, tz);

  /// "04:08" (24 h) — used by tests; the UI shows [format12].
  String hhmm(Prayer p) {
    final w = wall(p);
    return '${w.hour.toString().padLeft(2, '0')}:${w.minute.toString().padLeft(2, '0')}';
  }
}

/// "4:08 ص" / "7:59 م".
String format12(DateTime wall) {
  final h = wall.hour % 12 == 0 ? 12 : wall.hour % 12;
  return '$h:${wall.minute.toString().padLeft(2, '0')} ${wall.hour < 12 ? 'ص' : 'م'}';
}

class PrayerCalculator {
  const PrayerCalculator({this.method = _egyptMethod, this.asrFactor = 1, this.highLat = HighLatRule.angle});

  static const _egyptMethod = PrayerMethod('egypt', 'الهيئة المصرية العامة للمساحة', 5, fajr: 19.5, isha: 17.5, tune: {Prayer.dhuhr: 1});

  /// Egyptian General Authority of Survey.
  static const egypt = PrayerCalculator();

  /// The calculator for a method id ('auto' / unknown → MWL).
  factory PrayerCalculator.of(String? methodId, {int asrFactor = 1, HighLatRule highLat = HighLatRule.angle}) =>
      PrayerCalculator(method: prayerMethodById(methodId), asrFactor: asrFactor == 2 ? 2 : 1, highLat: highLat);

  final PrayerMethod method;
  final int asrFactor;
  final HighLatRule highLat;

  /// Times for the local calendar date [year]-[month]-[day] at [lat],
  /// [lng]; wall clock in [tz].
  PrayerDay compute(int year, int month, int day, double lat, double lng, {String tz = cairoTz}) {
    final jDate = _julian(year, month, day) - lng / (15 * 24);
    const guess = <Prayer, double>{
      Prayer.fajr: 5,
      Prayer.sunrise: 6,
      Prayer.dhuhr: 12,
      Prayer.asr: 13,
      Prayer.maghrib: 18,
      Prayer.isha: 18,
    };
    var t = Map<Prayer, double>.of(guess);
    for (var i = 0; i < 2; i++) {
      final p = t.map((k, v) => MapEntry(k, (v.isNaN ? guess[k]! : v) / 24));
      t = {
        Prayer.fajr: _sunAngleTime(jDate, lat, method.fajr, p[Prayer.fajr]!, ccw: true, nan: true),
        Prayer.sunrise: _sunAngleTime(jDate, lat, _riseSet, p[Prayer.sunrise]!, ccw: true),
        Prayer.dhuhr: _midDay(jDate, p[Prayer.dhuhr]!),
        Prayer.asr: _asrTime(jDate, lat, p[Prayer.asr]!),
        Prayer.maghrib: _sunAngleTime(jDate, lat, method.maghribAngle ?? _riseSet, p[Prayer.maghrib]!, nan: method.maghribAngle != null),
        Prayer.isha: method.isha == null ? double.nan : _sunAngleTime(jDate, lat, method.isha!, p[Prayer.isha]!, nan: true),
      };
    }

    // High latitudes: cap Fajr / Isha (and an angle Maghrib) at a portion of the night.
    final sunset = _sunAngleTime(jDate, lat, _riseSet, (t[Prayer.maghrib]!.isNaN ? 18 : t[Prayer.maghrib]!) / 24);
    final night = _fixHour(t[Prayer.sunrise]! - sunset);
    double portion(double angle) => night * switch (highLat) { HighLatRule.angle => angle / 60, HighLatRule.seventh => 1 / 7, HighLatRule.middle => 1 / 2 };
    final fajrCap = portion(method.fajr);
    if (t[Prayer.fajr]!.isNaN || _fixHour(t[Prayer.sunrise]! - t[Prayer.fajr]!) > fajrCap) t[Prayer.fajr] = t[Prayer.sunrise]! - fajrCap;
    if (method.isha != null) {
      final cap = portion(method.isha!);
      if (t[Prayer.isha]!.isNaN || _fixHour(t[Prayer.isha]! - sunset) > cap) t[Prayer.isha] = sunset + cap;
    }
    if (method.maghribAngle != null) {
      final cap = portion(method.maghribAngle!);
      if (t[Prayer.maghrib]!.isNaN || _fixHour(t[Prayer.maghrib]! - sunset) > cap) t[Prayer.maghrib] = sunset + cap;
    }
    if (method.isha == null) {
      final mins = (method.ramadanIshaMinutes != null && isRamadan(year, month, day)) ? method.ramadanIshaMinutes! : method.ishaMinutes ?? 90;
      t[Prayer.isha] = t[Prayer.maghrib]! + mins / 60;
    }

    final base = DateTime.utc(year, month, day);
    final out = <Prayer, DateTime>{};
    for (final e in t.entries) {
      // Local-mean hours → UTC hours, plus the method's adjustments.
      final hours = (e.value.isNaN ? guess[e.key]! : e.value) - lng / 15 + (method.tune[e.key] ?? 0) / 60;
      out[e.key] = base.add(Duration(minutes: (hours * 60).round()));
    }
    return PrayerDay._(year, month, day, tz, out);
  }

  static const _riseSet = 0.833;

  double _midDay(double jDate, double t) => _fixHour(12 - _sun(jDate + t).eqt);

  /// [nan]: NaN when the sun never reaches [angle] that day (Fajr/Isha at
  /// high latitudes — the high-latitude rule takes over); else clamped.
  double _sunAngleTime(double jDate, double lat, double angle, double t, {bool ccw = false, bool nan = false}) {
    final decl = _sun(jDate + t).decl;
    final noon = _midDay(jDate, t);
    final cosT = (-_sin(angle) - _sin(decl) * _sin(lat)) / (_cos(decl) * _cos(lat));
    if (nan && (cosT < -1 || cosT > 1)) return double.nan;
    final tt = _acos(cosT.clamp(-1.0, 1.0)) / 15;
    return noon + (ccw ? -tt : tt);
  }

  double _asrTime(double jDate, double lat, double t) {
    final decl = _sun(jDate + t).decl;
    final angle = -_acot(asrFactor + _tan((lat - decl).abs()));
    return _sunAngleTime(jDate, lat, angle, t);
  }

  static ({double decl, double eqt}) _sun(double jd) {
    final d = jd - 2451545.0;
    final g = _fixAngle(357.529 + 0.98560028 * d);
    final q = _fixAngle(280.459 + 0.98564736 * d);
    final l = _fixAngle(q + 1.915 * _sin(g) + 0.020 * _sin(2 * g));
    final e = 23.439 - 0.00000036 * d;
    final ra = _fixHour(_atan2(_cos(e) * _sin(l), _cos(l)) / 15);
    final eqt = q / 15 - ra;
    final decl = _asin(_sin(e) * _sin(l));
    return (decl: decl, eqt: eqt);
  }

  static double _julian(int year, int month, int day) {
    var y = year, m = month;
    if (m <= 2) {
      y -= 1;
      m += 12;
    }
    final a = (y / 100).floor();
    final b = 2 - a + (a / 4).floor();
    return (365.25 * (y + 4716)).floor() + (30.6001 * (m + 1)).floor() + day + b - 1524.5;
  }

  static double _dtr(double d) => d * math.pi / 180;
  static double _rtd(double r) => r * 180 / math.pi;
  static double _sin(double d) => math.sin(_dtr(d));
  static double _cos(double d) => math.cos(_dtr(d));
  static double _tan(double d) => math.tan(_dtr(d));
  static double _asin(double x) => _rtd(math.asin(x));
  static double _acos(double x) => _rtd(math.acos(x));
  static double _atan2(double y, double x) => _rtd(math.atan2(y, x));
  static double _acot(double x) => _rtd(math.atan(1 / x));
  static double _fix(double a, double b) {
    final r = a - b * (a / b).floor();
    return r < 0 ? r + b : r;
  }

  static double _fixAngle(double a) => _fix(a, 360);
  static double _fixHour(double a) => _fix(a, 24);
}

/// The next of the five prayers after [now] (tomorrow's Fajr after Isha),
/// for the local dates of [tz].
({Prayer prayer, DateTime at, Duration left}) nextPrayer(double lat, double lng,
    {DateTime? now, PrayerCalculator calc = PrayerCalculator.egypt, String tz = cairoTz}) {
  final instant = (now ?? DateTime.now()).toUtc();
  final today = todayIn(tz, instant);
  final day = calc.compute(today.year, today.month, today.day, lat, lng, tz: tz);
  for (final p in fivePrayers) {
    if (day[p].isAfter(instant)) return (prayer: p, at: day[p], left: day[p].difference(instant));
  }
  final t = today.add(const Duration(days: 1));
  final next = calc.compute(t.year, t.month, t.day, lat, lng, tz: tz);
  return (prayer: Prayer.fajr, at: next[Prayer.fajr], left: next[Prayer.fajr].difference(instant));
}

/// «باقي ساعة و5 دقايق» style countdown text.
String formatCountdown(Duration d) {
  if (d.isNegative || d.inSeconds < 60) return 'دلوقتي';
  final totalMinutes = (d.inSeconds / 60).ceil();
  final h = totalMinutes ~/ 60;
  final m = totalMinutes % 60;
  String hours() => switch (h) { 1 => 'ساعة', 2 => 'ساعتين', _ => '$h ساعات' };
  String mins() => switch (m) { 1 => 'دقيقة', 2 => 'دقيقتين', _ when m <= 10 => '$m دقايق', _ => '$m دقيقة' };
  if (h == 0) return 'باقي ${mins()}';
  if (m == 0) return 'باقي ${hours()}';
  return 'باقي ${hours()} و${mins()}';
}

/// "01:05:09" — a ticking clock for the countdown card.
String formatClock(Duration d) {
  if (d.isNegative) return '00:00:00';
  String two(int n) => n.toString().padLeft(2, '0');
  return '${two(d.inHours)}:${two(d.inMinutes % 60)}:${two(d.inSeconds % 60)}';
}
