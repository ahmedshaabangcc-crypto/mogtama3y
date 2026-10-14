import 'dart:convert';

import 'package:http/http.dart' as http;

import '../geo/admin_areas.dart' show arabCountryAt;
import '../geo/phones.dart';
import '../masjid/osm_mosques.dart' show OsmMosques, distanceMeters;
import '../masjid_tools/platform/kv_store.dart';

/// The directory's Arabic groups (migration 0094 private.dir_categories,
/// seo/dalil/server.mjs CATEGORIES, backend/maintenance/directory/2_clean.sql).
const directoryCategories = <String>[
  'سوبر ماركت وبقالة', 'صيدليات', 'مطاعم', 'كافيهات', 'حلويات ومخبوزات', 'صحة وعيادات',
  'ملابس وأزياء', 'إلكترونيات وموبايلات', 'أدوات منزلية وأثاث', 'تجميل وعناية',
  'صيانة وخدمات منزلية', 'سيارات', 'هدايا ومكتبات', 'رياضة', 'تعليم', 'عقارات', 'سفر وفنادق',
  'مناسبات وتصوير', 'خدمات وشركات', 'مصانع وموردين', 'بنوك وصرافات', 'محلات متنوعة',
];

const _grocery = 'سوبر ماركت وبقالة', _sweets = 'حلويات ومخبوزات', _clothes = 'ملابس وأزياء', _tech = 'إلكترونيات وموبايلات';
const _home = 'أدوات منزلية وأثاث', _beauty = 'تجميل وعناية', _repair = 'صيانة وخدمات منزلية', _cars = 'سيارات';
const _gifts = 'هدايا ومكتبات', _health = 'صحة وعيادات';

// OSM tag value → directory group. Anything else under shop=* is «محلات متنوعة».
const _shop = <String, String>{
  'supermarket': _grocery, 'convenience': _grocery, 'grocery': _grocery, 'greengrocer': _grocery, 'butcher': _grocery,
  'dairy': _grocery, 'seafood': _grocery, 'deli': _grocery, 'frozen_food': _grocery, 'beverages': _grocery,
  'water': _grocery, 'general': _grocery, 'spices': _grocery, 'nuts': _grocery, 'coffee': _grocery, 'food': _grocery,
  'bakery': _sweets, 'pastry': _sweets, 'confectionery': _sweets, 'chocolate': _sweets,
  'clothes': _clothes, 'shoes': _clothes, 'boutique': _clothes, 'fashion': _clothes, 'jewelry': _clothes,
  'bag': _clothes, 'tailor': _clothes, 'fabric': _clothes, 'watches': _clothes, 'fashion_accessories': _clothes,
  'electronics': _tech, 'mobile_phone': _tech, 'computer': _tech, 'appliance': _tech,
  'hardware': _home, 'doityourself': _home, 'furniture': _home, 'houseware': _home, 'kitchen': _home,
  'lighting': _home, 'paint': _home, 'interior_decoration': _home, 'curtain': _home, 'bed': _home, 'carpet': _home,
  'hairdresser': _beauty, 'beauty': _beauty, 'cosmetics': _beauty, 'perfumery': _beauty, 'chemist': _beauty,
  'laundry': _repair, 'dry_cleaning': _repair,
  'car_repair': _cars, 'car': _cars, 'car_parts': _cars, 'tyres': _cars, 'motorcycle': _cars,
  'books': _gifts, 'stationery': _gifts, 'gift': _gifts, 'toys': _gifts, 'florist': _gifts, 'pet': _gifts, 'music': _gifts,
  'sports': 'رياضة', 'bicycle': 'رياضة', 'optician': _health, 'medical_supply': _health,
};
const _amenity = <String, String>{
  'pharmacy': 'صيدليات', 'restaurant': 'مطاعم', 'fast_food': 'مطاعم', 'food_court': 'مطاعم', 'cafe': 'كافيهات',
  'ice_cream': _sweets, 'clinic': _health, 'doctors': _health, 'dentist': _health, 'hospital': _health,
  'veterinary': _health, 'bank': 'بنوك وصرافات', 'bureau_de_change': 'بنوك وصرافات', 'fuel': _cars, 'car_wash': _cars,
};
const _craft = <String, String>{
  'plumber': _repair, 'electrician': _repair, 'hvac': _repair, 'carpenter': _repair, 'painter': _repair, 'tailor': _clothes,
};
const _leisure = <String, String>{'fitness_centre': 'رياضة', 'sports_centre': 'رياضة'};

/// OSM tags → (directory group, the tag it came from, e.g. 'shop=bakery'),
/// or null for things the directory doesn't list.
(String, String)? osmCategory(Map tags) {
  String? v(String k) => tags[k] is String ? (tags[k] as String).trim() : null;
  for (final (key, map) in [('amenity', _amenity), ('craft', _craft), ('leisure', _leisure)]) {
    final x = v(key);
    if (x != null && map[x] != null) return (map[x]!, '$key=$x');
  }
  final s = v('shop');
  if (s == null || s.isEmpty || s == 'vacant' || s == 'no') return null;
  return (_shop[s] ?? 'محلات متنوعة', 'shop=${RegExp(r'^[a-z0-9_;]{2,40}$').hasMatch(s) ? s : 'yes'}');
}

/// A shop / amenity from OpenStreetMap (© OpenStreetMap contributors, ODbL).
class OsmPlace {
  const OsmPlace({
    required this.type,
    required this.id,
    required this.name,
    required this.category,
    required this.kind,
    required this.lat,
    required this.lng,
    this.phone,
    this.whatsapp,
    this.website,
    this.openingHours,
    this.address,
    this.distanceM = 0,
  });

  final String type; // node | way | relation
  final int id;
  final String name;
  final String category;
  final String kind;
  final double lat;
  final double lng;
  final String? phone;
  final String? whatsapp;
  final String? website;
  final String? openingHours;
  final String? address;
  final double distanceM;

  /// The id it gets in public.directory_places once imported.
  String get dirId => 'osm-$type-$id';

  OsmPlace at(double fromLat, double fromLng) => OsmPlace(
        type: type, id: id, name: name, category: category, kind: kind, lat: lat, lng: lng, phone: phone,
        whatsapp: whatsapp, website: website, openingHours: openingHours, address: address,
        distanceM: distanceMeters(fromLat, fromLng, lat, lng),
      );

  Map<String, dynamic> toJson() => {
        'type': type, 'id': id, 'name': name, 'category': category, 'kind': kind, 'lat': lat, 'lng': lng,
        if (phone != null) 'phone': phone, if (whatsapp != null) 'whatsapp': whatsapp, if (website != null) 'website': website,
        if (openingHours != null) 'opening_hours': openingHours, if (address != null) 'address': address,
      };

  static OsmPlace? fromJson(Map<String, dynamic> j) {
    final type = j['type'], id = j['id'], lat = j['lat'], lng = j['lng'], name = j['name'], cat = j['category'];
    if (type is! String || id is! num || lat is! num || lng is! num || name is! String || cat is! String) return null;
    return OsmPlace(
      type: type, id: id.toInt(), name: name, category: cat, kind: j['kind'] as String? ?? '', lat: lat.toDouble(), lng: lng.toDouble(),
      phone: j['phone'] as String?, whatsapp: j['whatsapp'] as String?, website: j['website'] as String?,
      openingHours: j['opening_hours'] as String?, address: j['address'] as String?,
    );
  }

  /// Shaped like a nearby_directory row, plus `osm: true` and what
  /// directory_import_osm needs.
  Map<String, dynamic> toRow() => {
        'id': dirId, 'name': name, 'category': category, 'phone': phone, 'whatsapp': whatsapp, 'website': website,
        'address': address, 'opening_hours': openingHours, 'lat': lat, 'lng': lng, 'claimed_shop_id': null,
        'distance_km': distanceM / 1000, 'osm': true, 'osm_type': type, 'osm_id': id, 'kind': kind,
      };
}

/// Overpass QL: named shops and the amenities / crafts the directory lists
/// within [radiusM] of a point.
String placesOverpassQuery(double lat, double lng, int radiusM) {
  final around = '(around:$radiusM,${lat.toStringAsFixed(5)},${lng.toStringAsFixed(5)})';
  return '[out:json][timeout:20];('
      'nwr[shop][name]$around;'
      'nwr[amenity~"^(${_amenity.keys.join('|')})\$"][name]$around;'
      'nwr[craft~"^(${_craft.keys.join('|')})\$"][name]$around;'
      'nwr[leisure~"^(${_leisure.keys.join('|')})\$"][name]$around;'
      ');out center 200;';
}

/// Elements of an Overpass answer → places (Arabic name first).
List<OsmPlace> parsePlacesOverpass(Map<String, dynamic> json, {String? country}) {
  final out = <OsmPlace>[];
  for (final e in (json['elements'] as List? ?? const [])) {
    if (e is! Map) continue;
    final type = e['type'], id = e['id'];
    final center = e['center'] is Map ? e['center'] as Map : e;
    final lat = center['lat'], lng = center['lon'];
    final tags = e['tags'] is Map ? e['tags'] as Map : const {};
    if (type is! String || id is! num || lat is! num || lng is! num) continue;
    final cat = osmCategory(tags);
    String? tag(List<String> keys) {
      for (final k in keys) {
        final v = tags[k];
        if (v is String && v.trim().isNotEmpty) return v.trim();
      }
      return null;
    }
    final name = tag(const ['name:ar', 'name', 'name:en']);
    if (cat == null || name == null || name.length < 2) continue;
    // «+966 50 …; +966 11 …» → the first number.
    final phone = tag(const ['phone', 'contact:phone', 'mobile', 'contact:mobile'])?.split(RegExp(r'[;,]')).first.trim();
    final wa = tag(const ['contact:whatsapp', 'whatsapp']);
    final web = tag(const ['website', 'contact:website']);
    final street = [tag(const ['addr:street']), tag(const ['addr:housenumber'])].whereType<String>().join(' ');
    final addr = [street, tag(const ['addr:city'])].where((s) => s != null && s.isNotEmpty).join('، ');
    out.add(OsmPlace(
      type: type,
      id: id.toInt(),
      name: name.length > 120 ? name.substring(0, 120) : name,
      category: cat.$1,
      kind: cat.$2,
      lat: lat.toDouble(),
      lng: lng.toDouble(),
      phone: phone,
      whatsapp: storePhone(wa ?? phone, country: country),
      website: web != null && RegExp(r'^https?://').hasMatch(web) ? web : null,
      openingHours: tag(const ['opening_hours']),
      address: addr.isEmpty ? null : addr,
    ));
  }
  return out;
}

/// Same folding as the SQL private.place_name_key (0094).
String placeNameKey(String? s) => (s ?? '')
    .toLowerCase()
    .replaceAll(RegExp('[أإآٱ]'), 'ا')
    .replaceAll('ة', 'ه')
    .replaceAll('ى', 'ي')
    .replaceAll(RegExp(r'[^\p{L}\p{N}]', unicode: true), '');

bool placeNamesSimilar(String? a, String? b) {
  final ka = placeNameKey(a), kb = placeNameKey(b);
  if (ka.isEmpty || kb.isEmpty) return false;
  return ka == kb || (ka.length >= 3 && kb.contains(ka)) || (kb.length >= 3 && ka.contains(kb));
}

/// Should the screen also ask OpenStreetMap? Outside Egypt always (our
/// directory is Egypt's Overture import); in Egypt when ours is sparse.
bool wantsOsm({required int ours, String? country, int enough = 10}) => country != 'EG' || ours < enough;

/// Our rows + the OSM places that aren't already ours (same imported id,
/// or within [withinM] metres with a similar name), optionally only
/// [categories], nearest first. OSM rows carry `osm: true`.
List<Map<String, dynamic>> mergeWithOsm(
  List<Map<String, dynamic>> ours,
  List<OsmPlace> osm,
  double lat,
  double lng, {
  Set<String>? categories,
  double withinM = 40,
  int maxOsm = 60,
}) {
  final ids = {for (final r in ours) r['id']};
  final extra = <Map<String, dynamic>>[];
  for (final o in osm) {
    if (categories != null && !categories.contains(o.category)) continue;
    if (ids.contains(o.dirId)) continue;
    final dup = ours.any((r) {
      final rLat = (r['lat'] as num?)?.toDouble(), rLng = (r['lng'] as num?)?.toDouble();
      return rLat != null && rLng != null && distanceMeters(rLat, rLng, o.lat, o.lng) <= withinM && placeNamesSimilar(r['name'] as String?, o.name);
    });
    if (!dup) extra.add(o.at(lat, lng).toRow());
  }
  extra.sort((a, b) => (a['distance_km'] as double).compareTo(b['distance_km'] as double));
  final all = [...ours, ...extra.take(maxOsm)];
  double km(Map<String, dynamic> r) => (r['distance_km'] as num?)?.toDouble() ?? double.infinity;
  all.sort((a, b) => km(a).compareTo(km(b)));
  return all;
}

/// Overpass client for places: politely (one request at a time, ≥ 4 s
/// apart), each ~1 km cell cached on the device for a week, empty on any
/// failure — it is only ever a helpful extra. Same approach as OsmMosques.
class OsmPlaces {
  OsmPlaces._();

  static const endpoint = OsmMosques.endpoint;
  static const attribution = '© OpenStreetMap contributors (ODbL)';
  static const copyrightUrl = OsmMosques.copyrightUrl;
  static const _ttl = Duration(days: 7);
  static const _minGap = Duration(seconds: 4);

  static DateTime? _last;
  static final _inFlight = <String, Future<List<OsmPlace>>>{};

  /// Tests: forget the polite gap.
  static void debugResetRateLimit() => _last = null;

  static String cacheKey(double lat, double lng, int radiusM) => 'mt.osmp.v1.${(lat * 100).round()},${(lng * 100).round()},$radiusM';

  /// Places within [radiusM] of the point, nearest first.
  static Future<List<OsmPlace>> near(double lat, double lng, {int radiusM = 1500, http.Client? client}) {
    final key = cacheKey(lat, lng, radiusM);
    return _inFlight.putIfAbsent(key, () => _near(key, lat, lng, radiusM, client).whenComplete(() {
          _inFlight.remove(key);
        }));
  }

  static List<OsmPlace> _sorted(Iterable<OsmPlace> items, double lat, double lng) =>
      [for (final i in items) i.at(lat, lng)]..sort((a, b) => a.distanceM.compareTo(b.distanceM));

  static Future<List<OsmPlace>> _near(String key, double lat, double lng, int radiusM, http.Client? client) async {
    try {
      final raw = await kvGet(key);
      if (raw != null) {
        final j = jsonDecode(raw) as Map<String, dynamic>;
        final at = DateTime.tryParse(j['at'] as String? ?? '');
        if (at != null && DateTime.now().difference(at) < _ttl) {
          return _sorted([for (final e in (j['items'] as List)) ?OsmPlace.fromJson(Map<String, dynamic>.from(e as Map))], lat, lng);
        }
      }
    } catch (_) {}
    final last = _last;
    if (last != null && DateTime.now().difference(last) < _minGap) return const [];
    _last = DateTime.now();
    try {
      final c = client ?? http.Client();
      final res = await c.post(Uri.parse(endpoint), body: {'data': placesOverpassQuery(lat, lng, radiusM)}).timeout(const Duration(seconds: 25));
      if (res.statusCode != 200) return const [];
      final items = parsePlacesOverpass(jsonDecode(utf8.decode(res.bodyBytes)) as Map<String, dynamic>, country: arabCountryAt(lat, lng));
      try {
        await kvSet(key, jsonEncode({'at': DateTime.now().toIso8601String(), 'items': [for (final i in items) i.toJson()]}));
      } catch (_) {}
      return _sorted(items, lat, lng);
    } catch (_) {
      return const [];
    }
  }
}
