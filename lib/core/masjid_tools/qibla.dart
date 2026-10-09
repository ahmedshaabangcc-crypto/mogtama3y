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

/// Compass heading (clockwise from north) from a W3C `deviceorientation`
/// alpha (counter-clockwise), corrected for the screen's rotation.
double headingFromAlpha(double alpha, {double screenAngle = 0}) => normalizeDegrees(360 - alpha + screenAngle);

/// How far to turn the phone (clockwise, −180..180) so its top faces the qibla.
double turnToQibla(double qibla, double heading) {
  final d = normalizeDegrees(qibla - heading);
  return d > 180 ? d - 360 : d;
}

/// «جنوب شرق» — the 8-point name of a bearing.
String compassPointAr(double bearing) {
  const names = ['الشمال', 'الشمال الشرقي', 'الشرق', 'الجنوب الشرقي', 'الجنوب', 'الجنوب الغربي', 'الغرب', 'الشمال الغربي'];
  return names[((normalizeDegrees(bearing) + 22.5) ~/ 45) % 8];
}
