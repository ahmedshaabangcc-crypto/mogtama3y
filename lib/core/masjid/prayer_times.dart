import 'dart:math' as math;

/// مواقيت الصلاة — computed on the device, no external API.
///
/// Method: الهيئة المصرية العامة للمساحة (Egyptian General Authority of
/// Survey): Fajr at 19.5° below the horizon, Isha at 17.5°, Asr when an
/// object's shadow equals its length plus the noon shadow (shadow factor 1,
/// Shafi'i / standard), Maghrib at sunset, Dhuhr a minute after the sun's
/// transit. Sun position from the standard low-precision formulae (the
/// PrayTimes.org algorithm, accurate to well under a minute at Egypt's
/// latitudes), refined with one iteration.
///
/// Clock: Egypt (Africa/Cairo): UTC+2, and UTC+3 during summer time, which
/// Egypt has observed again since 2023 — from the last Friday of April to
/// the last Thursday of October (inclusive).
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

/// Egyptian summer time on this calendar date (Cairo wall clock)?
bool egyptDstOn(int year, int month, int day) {
  if (year < 2023) return false; // suspended 2015–2022
  if (month < 4 || month > 10) return false;
  if (month > 4 && month < 10) return true;
  if (month == 4) return day >= _lastWeekday(year, 4, DateTime.friday);
  return day <= _lastWeekday(year, 10, DateTime.thursday);
}

int _lastWeekday(int year, int month, int weekday) {
  final last = DateTime.utc(year, month + 1, 0);
  return last.day - ((last.weekday - weekday) % 7);
}

/// UTC offset of Egypt's clock on that calendar date, in hours.
int egyptUtcOffsetHours(int year, int month, int day) => egyptDstOn(year, month, day) ? 3 : 2;

/// Egypt's wall clock for an instant, as a DateTime whose fields are the
/// Cairo date/time (flagged UTC so nothing re-converts it).
DateTime egyptWallClock(DateTime instant) {
  final u = instant.toUtc();
  final at2 = u.add(const Duration(hours: 2));
  final at3 = u.add(const Duration(hours: 3));
  // Summer time starts at 00:00 Friday (→ 01:00) and ends at 24:00 Thursday
  // (→ 23:00), so it applies when both readings fall on summer-time dates.
  final dst = egyptDstOn(at2.year, at2.month, at2.day) && egyptDstOn(at3.year, at3.month, at3.day);
  return dst ? at3 : at2;
}

/// Today's date in Egypt.
DateTime egyptToday([DateTime? now]) {
  final w = egyptWallClock(now ?? DateTime.now());
  return DateTime.utc(w.year, w.month, w.day);
}

class PrayerDay {
  PrayerDay._(this.year, this.month, this.day, this.utcOffsetHours, this.times);

  final int year;
  final int month;
  final int day;
  final int utcOffsetHours;

  /// Instants (UTC) of each time.
  final Map<Prayer, DateTime> times;

  DateTime operator [](Prayer p) => times[p]!;

  /// Egypt wall-clock time of [p] (fields = Cairo time).
  DateTime wall(Prayer p) => times[p]!.add(Duration(hours: utcOffsetHours));

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
  const PrayerCalculator({this.fajrAngle = 19.5, this.ishaAngle = 17.5, this.asrFactor = 1, this.dhuhrMinutes = 1});

  /// Egyptian General Authority of Survey.
  static const egypt = PrayerCalculator();

  final double fajrAngle;
  final double ishaAngle;
  final double asrFactor;
  final int dhuhrMinutes;

  /// Times for the Cairo calendar date [year]-[month]-[day] at [lat], [lng].
  PrayerDay compute(int year, int month, int day, double lat, double lng) {
    final offset = egyptUtcOffsetHours(year, month, day);
    final jDate = _julian(year, month, day) - lng / (15 * 24);

    // Initial guesses (hours, local mean), one refinement pass.
    var t = <Prayer, double>{
      Prayer.fajr: 5,
      Prayer.sunrise: 6,
      Prayer.dhuhr: 12,
      Prayer.asr: 13,
      Prayer.maghrib: 18,
      Prayer.isha: 18,
    };
    for (var i = 0; i < 2; i++) {
      final p = t.map((k, v) => MapEntry(k, v / 24));
      t = {
        Prayer.fajr: _sunAngleTime(jDate, lat, fajrAngle, p[Prayer.fajr]!, ccw: true),
        Prayer.sunrise: _sunAngleTime(jDate, lat, _riseSet, p[Prayer.sunrise]!, ccw: true),
        Prayer.dhuhr: _midDay(jDate, p[Prayer.dhuhr]!),
        Prayer.asr: _asrTime(jDate, lat, p[Prayer.asr]!),
        Prayer.maghrib: _sunAngleTime(jDate, lat, _riseSet, p[Prayer.maghrib]!),
        Prayer.isha: _sunAngleTime(jDate, lat, ishaAngle, p[Prayer.isha]!),
      };
    }

    final base = DateTime.utc(year, month, day);
    final out = <Prayer, DateTime>{};
    for (final e in t.entries) {
      // Local-mean hours → UTC hours.
      var hours = e.value - lng / 15;
      if (e.key == Prayer.dhuhr) hours += dhuhrMinutes / 60;
      final minutes = (hours * 60).round();
      out[e.key] = base.add(Duration(minutes: minutes));
    }
    return PrayerDay._(year, month, day, offset, out);
  }

  static const _riseSet = 0.833;

  double _midDay(double jDate, double t) => _fixHour(12 - _sun(jDate + t).eqt);

  double _sunAngleTime(double jDate, double lat, double angle, double t, {bool ccw = false}) {
    final decl = _sun(jDate + t).decl;
    final noon = _midDay(jDate, t);
    final cosT = (-_sin(angle) - _sin(decl) * _sin(lat)) / (_cos(decl) * _cos(lat));
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

/// The next of the five prayers after [now] (tomorrow's Fajr after Isha).
({Prayer prayer, DateTime at, Duration left}) nextPrayer(double lat, double lng, {DateTime? now, PrayerCalculator calc = PrayerCalculator.egypt}) {
  final instant = (now ?? DateTime.now()).toUtc();
  final today = egyptToday(instant);
  final day = calc.compute(today.year, today.month, today.day, lat, lng);
  for (final p in fivePrayers) {
    if (day[p].isAfter(instant)) return (prayer: p, at: day[p], left: day[p].difference(instant));
  }
  final t = today.add(const Duration(days: 1));
  final next = calc.compute(t.year, t.month, t.day, lat, lng);
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
