import 'dart:convert';
import 'dart:math' as math;

import 'package:http/http.dart' as http;

import '../masjid_tools/platform/kv_store.dart';

/// Mosques from OpenStreetMap (© OpenStreetMap contributors, ODbL) — the
/// fallback when our directory (Egypt only) has few or none near the user.
/// Queried from the browser through the public Overpass API, politely:
/// one request at a time, at most one every few seconds, and each area
/// cached for a week on the device. Opening / joining one turns it into
/// one of our mosques (masjid_import_osm, 0087).
class OsmMosque {
  const OsmMosque({required this.type, required this.id, required this.name, required this.lat, required this.lng, this.distanceM = 0});

  /// node | way | relation
  final String type;
  final int id;
  final String name;
  final double lat;
  final double lng;
  final double distanceM;

  Map<String, dynamic> toJson() => {'type': type, 'id': id, 'name': name, 'lat': lat, 'lng': lng};

  static OsmMosque? fromJson(Map<String, dynamic> j, {double? fromLat, double? fromLng}) {
    final type = j['type'], id = j['id'], lat = j['lat'], lng = j['lng'];
    if (type is! String || id is! num || lat is! num || lng is! num) return null;
    return OsmMosque(
      type: type,
      id: id.toInt(),
      name: (j['name'] as String?) ?? 'مسجد',
      lat: lat.toDouble(),
      lng: lng.toDouble(),
      distanceM: fromLat == null || fromLng == null ? 0 : distanceMeters(fromLat, fromLng, lat.toDouble(), lng.toDouble()),
    );
  }
}

/// Great-circle distance in metres.
double distanceMeters(double lat1, double lng1, double lat2, double lng2) {
  const r = 6371000.0;
  double rad(double d) => d * math.pi / 180;
  final dLat = rad(lat2 - lat1), dLng = rad(lng2 - lng1);
  final a = math.pow(math.sin(dLat / 2), 2) + math.cos(rad(lat1)) * math.cos(rad(lat2)) * math.pow(math.sin(dLng / 2), 2);
  return 2 * r * math.asin(math.sqrt(a.toDouble()));
}

/// The Overpass QL for Muslim places of worship within [radiusM] of a point.
String overpassQuery(double lat, double lng, int radiusM) =>
    '[out:json][timeout:20];nwr[amenity=place_of_worship][religion=muslim](around:$radiusM,${lat.toStringAsFixed(5)},${lng.toStringAsFixed(5)});out center 50;';

/// Elements of an Overpass JSON answer → mosques (Arabic name first).
List<OsmMosque> parseOverpass(Map<String, dynamic> json) {
  final out = <OsmMosque>[];
  for (final e in (json['elements'] as List? ?? const [])) {
    if (e is! Map) continue;
    final type = e['type'], id = e['id'];
    final center = e['center'] is Map ? e['center'] as Map : e;
    final lat = center['lat'], lng = center['lon'];
    if (type is! String || id is! num || lat is! num || lng is! num) continue;
    final tags = e['tags'] is Map ? e['tags'] as Map : const {};
    String? name;
    for (final k in const ['name:ar', 'name', 'name:en', 'official_name']) {
      final v = tags[k];
      if (v is String && v.trim().isNotEmpty) {
        name = v.trim();
        break;
      }
    }
    out.add(OsmMosque(type: type, id: id.toInt(), name: name ?? 'مسجد', lat: lat.toDouble(), lng: lng.toDouble()));
  }
  return out;
}

/// OSM mosques that aren't already in [ours] (anything of ours within
/// [withinM] metres counts as the same place), nearest first.
List<OsmMosque> osmNotInOurs(List<OsmMosque> osm, List<Map<String, dynamic>> ours, double lat, double lng, {double withinM = 40}) {
  final res = <OsmMosque>[];
  for (final o in osm) {
    final dup = ours.any((m) {
      final mLat = (m['lat'] as num?)?.toDouble(), mLng = (m['lng'] as num?)?.toDouble();
      return mLat != null && mLng != null && distanceMeters(mLat, mLng, o.lat, o.lng) <= withinM;
    });
    if (!dup) {
      res.add(OsmMosque(type: o.type, id: o.id, name: o.name, lat: o.lat, lng: o.lng, distanceM: distanceMeters(lat, lng, o.lat, o.lng)));
    }
  }
  res.sort((a, b) => a.distanceM.compareTo(b.distanceM));
  return res;
}

class OsmMosques {
  OsmMosques._();

  static const endpoint = 'https://overpass-api.de/api/interpreter';  static const attribution = '© OpenStreetMap contributors';
  static const copyrightUrl = 'https://www.openstreetmap.org/copyright';
  static const _ttl = Duration(days: 7);
  static const _minGap = Duration(seconds: 4);

  static DateTime? _last;

  /// Tests: forget the polite gap.
  static void debugResetRateLimit() => _last = null;
  static final _inFlight = <String, Future<List<OsmMosque>>>{};

  /// Cache key: ~1 km cells, per radius.
  static String cacheKey(double lat, double lng, int radiusM) => 'mt.osm.v1.${(lat * 100).round()},${(lng * 100).round()},$radiusM';

  /// Mosques within [radiusM] of the point (nearest first, ≤ 50). Empty
  /// on any failure — this is only ever a helpful extra.
  static Future<List<OsmMosque>> near(double lat, double lng, {int radiusM = 2000, http.Client? client}) {
    final key = cacheKey(lat, lng, radiusM);
    // (The callback must not return the removed future — whenComplete would wait on itself.)
    return _inFlight.putIfAbsent(key, () => _near(key, lat, lng, radiusM, client).whenComplete(() {
          _inFlight.remove(key);
        }));
  }

  static Future<List<OsmMosque>> _near(String key, double lat, double lng, int radiusM, http.Client? client) async {
    try {
      final raw = await kvGet(key);
      if (raw != null) {
        final j = jsonDecode(raw) as Map<String, dynamic>;
        final at = DateTime.tryParse(j['at'] as String? ?? '');
        if (at != null && DateTime.now().difference(at) < _ttl) {
          return [
            for (final e in (j['items'] as List)) ?OsmMosque.fromJson(Map<String, dynamic>.from(e as Map), fromLat: lat, fromLng: lng),
          ]..sort((a, b) => a.distanceM.compareTo(b.distanceM));
        }
      }
    } catch (_) {}
    final last = _last;
    if (last != null && DateTime.now().difference(last) < _minGap) return const [];
    _last = DateTime.now();
    try {
      final c = client ?? http.Client();
      final res = await c
          .post(Uri.parse(endpoint), body: {'data': overpassQuery(lat, lng, radiusM)})
          .timeout(const Duration(seconds: 25));
      // Busy (429 / 504): nothing this time — the next screen visit after
      // the polite gap tries again (failures are not cached).
      if (res.statusCode != 200) return const [];
      final items = parseOverpass(jsonDecode(utf8.decode(res.bodyBytes)) as Map<String, dynamic>);
      try {
        await kvSet(key, jsonEncode({'at': DateTime.now().toIso8601String(), 'items': [for (final i in items) i.toJson()]}));
      } catch (_) {}
      return [
        for (final i in items) OsmMosque(type: i.type, id: i.id, name: i.name, lat: i.lat, lng: i.lng, distanceM: distanceMeters(lat, lng, i.lat, i.lng)),
      ]..sort((a, b) => a.distanceM.compareTo(b.distanceM));
    } catch (_) {
      return const [];
    }
  }
}
