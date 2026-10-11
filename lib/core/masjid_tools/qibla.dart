import 'dart:math' as math;

/// The Kaaba, Makkah.
const kaabaLat = 21.4225;
const kaabaLng = 39.8262;

double _rad(double d) => d * math.pi / 180;
double _deg(double r) => r * 180 / math.pi;

/// Initial great-circle bearing from ([lat], [lng]) to the Kaaba, in
/// degrees clockwise from true north (0–360). Cairo ≈ 136°.
double qiblaBearing(double lat, double lng) {
  final p1 = _rad(lat);
  final p2 = _rad(kaabaLat);
  final dl = _rad(kaabaLng - lng);
  final y = math.sin(dl) * math.cos(p2);
  final x = math.cos(p1) * math.sin(p2) - math.sin(p1) * math.cos(p2) * math.cos(dl);
  return normalizeDegrees(_deg(math.atan2(y, x)));
}

/// Great-circle distance to the Kaaba in km (haversine, mean Earth radius).
double distanceToKaabaKm(double lat, double lng) {
  final dp = _rad(kaabaLat - lat);
  final dl = _rad(kaabaLng - lng);
  final a = math.pow(math.sin(dp / 2), 2) + math.cos(_rad(lat)) * math.cos(_rad(kaabaLat)) * math.pow(math.sin(dl / 2), 2);
  return 6371.0 * 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
}

/// Any angle → [0, 360).
double normalizeDegrees(double d) {
  final r = d % 360;
  return r < 0 ? r + 360 : r;
}

/// Compass heading (clockwise from north) of the top of the *screen*, from
/// a W3C absolute `deviceorientation(absolute)` alpha (counter-clockwise
/// from north), corrected for the screen's rotation (`screen.orientation
/// .angle`: 0 portrait, 90 landscape turned counter-clockwise, 270/-90 the
/// other way).
double headingFromAlpha(double alpha, {double screenAngle = 0}) => normalizeDegrees(360 - alpha + screenAngle);

/// iOS Safari's `webkitCompassHeading` is already clockwise from north for
/// the device's top edge; only the screen rotation has to be added.
double headingFromWebkit(double webkitHeading, {double screenAngle = 0}) => normalizeDegrees(webkitHeading + screenAngle);

/// Signed shortest turn from [heading] to [target] (−180..180, clockwise
/// positive). With target = qibla it is how far to turn the phone — and the
/// on-screen rotation of the qibla arrow.
double turnToQibla(double target, double heading) {
  final d = normalizeDegrees(target - heading);
  return d >= 180 ? d - 360 : d;
}

/// The phone is far from flat (beta = front/back tilt, gamma = sideways
/// tilt), so an alpha-based heading is unreliable.
bool isTilted(double? beta, double? gamma, {double limit = 35}) =>
    (beta != null && beta.abs() > limit) || (gamma != null && gamma.abs() > limit);

/// iOS `webkitCompassAccuracy` (± degrees; negative = uncalibrated) is poor.
bool isPoorAccuracy(double? accuracy) => accuracy != null && (accuracy < 0 || accuracy > 25);

/// Circular mean of angles (degrees) — 350° and 10° average to 0°, not 180°.
double circularMean(Iterable<double> angles) {
  var x = 0.0, y = 0.0;
  for (final a in angles) {
    x += math.cos(_rad(a));
    y += math.sin(_rad(a));
  }
  return normalizeDegrees(_deg(math.atan2(y, x)));
}

/// Circular standard deviation in degrees (0 = all equal). Large values mean
/// the readings jump around — the magnetometer needs calibrating.
double circularSpread(List<double> angles) {
  if (angles.length < 2) return 0;
  var x = 0.0, y = 0.0;
  for (final a in angles) {
    x += math.cos(_rad(a));
    y += math.sin(_rad(a));
  }
  final r = math.sqrt(x * x + y * y) / angles.length;
  if (r >= 1) return 0;
  if (r <= 1e-9) return 180;
  return _deg(math.sqrt(-2 * math.log(r)));
}

/// Exponential smoothing on the unit circle: averages the (cos, sin) vectors
/// so the needle glides through 359° → 0° instead of spinning round.
class HeadingSmoother {
  HeadingSmoother({this.factor = 0.25});

  /// Weight of each new reading (0..1]; 1 = no smoothing.
  final double factor;
  double? _x, _y;

  double? get value => _x == null ? null : normalizeDegrees(_deg(math.atan2(_y!, _x!)));

  double add(double heading) {
    final cx = math.cos(_rad(heading)), cy = math.sin(_rad(heading));
    if (_x == null) {
      _x = cx;
      _y = cy;
    } else {
      _x = _x! + (cx - _x!) * factor;
      _y = _y! + (cy - _y!) * factor;
      // Opposite readings can cancel out; restart from the newest one.
      if (_x!.abs() < 1e-6 && _y!.abs() < 1e-6) {
        _x = cx;
        _y = cy;
      }
    }
    return value!;
  }

  void reset() => _x = _y = null;
}

/// One compass sample from the browser.
class CompassReading {
  const CompassReading({required this.heading, this.accuracy, this.beta, this.gamma, this.ios = false});

  /// Degrees clockwise from (magnetic) north for the top of the screen.
  final double heading;

  /// iOS `webkitCompassAccuracy` in ± degrees (null elsewhere).
  final double? accuracy;
  final double? beta;
  final double? gamma;
  final bool ios;
}

/// «جنوب شرق» — the 8-point name of a bearing.
String compassPointAr(double bearing) {
  const names = ['الشمال', 'الشمال الشرقي', 'الشرق', 'الجنوب الشرقي', 'الجنوب', 'الجنوب الغربي', 'الغرب', 'الشمال الغربي'];
  return names[((normalizeDegrees(bearing) + 22.5) ~/ 45) % 8];
}
