/// When to ask the browser for the position (pure — unit tested).
///
/// iPhone home-screen apps show the location prompt again on every launch
/// whenever the page calls getCurrentPosition, and some screens used to do
/// that on open. So: the last good fix is kept on the device (12 h) and
/// reused; the browser is asked silently only when the permission is known
/// to be granted (and never on iPhone, where that isn't reliable); anything
/// else waits for the user's tap («حدّث موقعي»).
library;

/// A remembered position.
class GeoFix {
  const GeoFix(this.lat, this.lng, this.accuracy, this.at);
  final double lat;
  final double lng;

  /// Metres (0 = unknown).
  final double accuracy;
  final DateTime at;

  bool freshAt(DateTime now, Duration maxAge) {
    final age = now.difference(at);
    return !age.isNegative && age < maxAge;
  }

  Map<String, dynamic> toJson() => {'lat': lat, 'lng': lng, 'acc': accuracy, 'at': at.toUtc().millisecondsSinceEpoch};

  static GeoFix? fromJson(Object? j) {
    if (j is! Map) return null;
    final lat = j['lat'], lng = j['lng'], at = j['at'];
    if (lat is! num || lng is! num || at is! num) return null;
    if (lat.abs() > 90 || lng.abs() > 180) return null;
    return GeoFix(lat.toDouble(), lng.toDouble(), (j['acc'] as num?)?.toDouble() ?? 0,
        DateTime.fromMillisecondsSinceEpoch(at.toInt(), isUtc: true));
  }
}

/// What the browser says about the location permission.
enum GeoPermission { granted, prompt, denied, unknown }

enum LocationDecision {
  /// Use the remembered fix — no browser call at all.
  useCached,

  /// Ask the browser now.
  request,

  /// Don't ask: show «فعّل الموقع» / «حدّث موقعي» and wait for a tap.
  needTap,
}

const locationMaxAge = Duration(hours: 12);

/// [userAction]: the user just tapped a location button (a prompt is fine).
/// [fresh]: the caller needs a new fix even if one is remembered (the tap
/// on «حدّث موقعي»). [ios]: iPhone/iPad, where a silent call can still
/// show the prompt.
LocationDecision locationDecision({
  required GeoFix? cached,
  required DateTime now,
  required GeoPermission permission,
  bool userAction = false,
  bool fresh = false,
  bool ios = false,
  Duration maxAge = locationMaxAge,
}) {
  if (!fresh && cached != null && cached.freshAt(now, maxAge)) return LocationDecision.useCached;
  if (userAction) return LocationDecision.request;
  if (permission == GeoPermission.granted && !ios) return LocationDecision.request;
  return LocationDecision.needTap;
}
