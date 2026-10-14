import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mogtama3y/core/places/osm_places.dart';

void main() {
  group('OSM tags → directory categories', () {
    test('shops, amenities, crafts and leisure', () {
      expect(osmCategory({'amenity': 'pharmacy'}), ('صيدليات', 'amenity=pharmacy'));
      expect(osmCategory({'shop': 'supermarket'})?.$1, 'سوبر ماركت وبقالة');
      expect(osmCategory({'shop': 'convenience'})?.$1, 'سوبر ماركت وبقالة');
      expect(osmCategory({'shop': 'butcher'})?.$1, 'سوبر ماركت وبقالة');
      expect(osmCategory({'shop': 'bakery'})?.$1, 'حلويات ومخبوزات');
      expect(osmCategory({'amenity': 'restaurant'})?.$1, 'مطاعم');
      expect(osmCategory({'amenity': 'fast_food'})?.$1, 'مطاعم');
      expect(osmCategory({'amenity': 'cafe'})?.$1, 'كافيهات');
      expect(osmCategory({'amenity': 'clinic'})?.$1, 'صحة وعيادات');
      expect(osmCategory({'amenity': 'doctors'})?.$1, 'صحة وعيادات');
      expect(osmCategory({'amenity': 'hospital'})?.$1, 'صحة وعيادات');
      expect(osmCategory({'shop': 'laundry'})?.$1, 'صيانة وخدمات منزلية');
      expect(osmCategory({'shop': 'car_repair'})?.$1, 'سيارات');
      expect(osmCategory({'shop': 'hairdresser'})?.$1, 'تجميل وعناية');
      expect(osmCategory({'shop': 'electronics'})?.$1, 'إلكترونيات وموبايلات');
      expect(osmCategory({'shop': 'mobile_phone'})?.$1, 'إلكترونيات وموبايلات');
      expect(osmCategory({'shop': 'hardware'})?.$1, 'أدوات منزلية وأثاث');
      expect(osmCategory({'craft': 'plumber'}), ('صيانة وخدمات منزلية', 'craft=plumber'));
      expect(osmCategory({'leisure': 'fitness_centre'})?.$1, 'رياضة');
      expect(osmCategory({'amenity': 'bank'})?.$1, 'بنوك وصرافات');
    });

    test('an amenity wins over a shop tag; unknown shops are «محلات متنوعة»; the rest is skipped', () {
      expect(osmCategory({'amenity': 'pharmacy', 'shop': 'chemist'})?.$1, 'صيدليات');
      expect(osmCategory({'shop': 'something_new'}), ('محلات متنوعة', 'shop=something_new'));
      expect(osmCategory({'shop': 'Weird Value!'})?.$2, 'shop=yes');
      expect(osmCategory({'shop': 'vacant'}), isNull);
      expect(osmCategory({'amenity': 'bench'}), isNull);
      expect(osmCategory({'building': 'yes'}), isNull);
    });

    test('every mapped category is a directory category', () {
      for (final tags in [
        for (final v in ['supermarket', 'bakery', 'clothes', 'electronics', 'hardware', 'beauty', 'laundry', 'car', 'books', 'sports', 'optician', 'zzz'])
          {'shop': v},
        for (final v in ['pharmacy', 'restaurant', 'cafe', 'ice_cream', 'clinic', 'bank', 'fuel']) {'amenity': v},
        {'craft': 'electrician'},
        {'leisure': 'sports_centre'},
      ]) {
        expect(directoryCategories, contains(osmCategory(tags)!.$1), reason: '$tags');
      }
    });
  });

  group('Overpass', () {
    test('query asks for named shops and our amenities around the point', () {
      final q = placesOverpassQuery(24.71360, 46.67530, 1500);
      expect(q, contains('nwr[shop][name](around:1500,24.71360,46.67530)'));
      expect(q, contains('pharmacy|restaurant'));
      expect(q, contains('craft~"^(plumber|'));
      expect(q, endsWith('out center 200;'));
    });

    test('parse: Arabic name first, way centres, phone → WhatsApp in the country, skips unnamed / unmapped', () {
      final items = parsePlacesOverpass({
        'elements': [
          {'type': 'node', 'id': 1, 'lat': 24.71, 'lon': 46.67, 'tags': {'shop': 'bakery', 'name': 'Al Nakheel Bakery', 'name:ar': 'مخبز النخيل', 'phone': '0501234567; 0112345678', 'opening_hours': 'Mo-Su 06:00-23:00', 'website': 'https://bakery.example', 'addr:street': 'طريق الملك فهد', 'addr:housenumber': '12', 'addr:city': 'الرياض'}},
          {'type': 'way', 'id': 2, 'center': {'lat': 24.72, 'lon': 46.68}, 'tags': {'amenity': 'pharmacy', 'name': 'Nahdi', 'website': 'nahdi.sa'}},
          {'type': 'node', 'id': 3, 'lat': 24.7, 'lon': 46.6, 'tags': {'shop': 'bakery'}},
          {'type': 'node', 'id': 4, 'lat': 24.7, 'lon': 46.6, 'tags': {'amenity': 'bench', 'name': 'x bench'}},
        ],
      }, country: 'SA');
      expect(items.length, 2);
      final b = items.first;
      expect(b.name, 'مخبز النخيل');
      expect(b.category, 'حلويات ومخبوزات');
      expect(b.kind, 'shop=bakery');
      expect(b.phone, '0501234567');
      expect(b.whatsapp, '+966501234567');
      expect(b.openingHours, 'Mo-Su 06:00-23:00');
      expect(b.website, 'https://bakery.example');
      expect(b.address, 'طريق الملك فهد 12، الرياض');
      expect(b.dirId, 'osm-node-1');
      final w = items.last;
      expect((w.type, w.lat, w.lng, w.website, w.whatsapp), ('way', 24.72, 46.68, null, null));
    });

    test('row shape for lists and the import RPC; json round trip', () {
      const p = OsmPlace(type: 'way', id: 42, name: 'صيدلية', category: 'صيدليات', kind: 'amenity=pharmacy', lat: 25.2, lng: 55.3, phone: '+97150', openingHours: '24/7');
      final r = p.at(25.2, 55.3).toRow();
      expect(r['id'], 'osm-way-42');
      expect(r['osm'], isTrue);
      expect((r['osm_type'], r['osm_id'], r['kind'], r['opening_hours'], r['claimed_shop_id']), ('way', 42, 'amenity=pharmacy', '24/7', null));
      expect(r['distance_km'], 0);
      final back = OsmPlace.fromJson(p.toJson())!;
      expect((back.dirId, back.category, back.phone, back.openingHours), ('osm-way-42', 'صيدليات', '+97150', '24/7'));
      expect(OsmPlace.fromJson({'type': 'node', 'id': 1}), isNull);
    });

    test('near(): one request, then the device cache', () async {
      SharedPreferences.setMockInitialValues({});
      OsmPlaces.debugResetRateLimit();
      var calls = 0;
      final client = MockClient((req) async {
        calls++;
        expect(req.url.toString(), OsmPlaces.endpoint);
        expect(req.bodyFields['data'], contains('nwr[shop][name]'));
        return http.Response.bytes(utf8.encode(jsonEncode({
          'elements': [
            {'type': 'node', 'id': 9, 'lat': 24.7140, 'lon': 46.6760, 'tags': {'shop': 'supermarket', 'name': 'بنده'}},
          ],
        })), 200);
      });
      final a = await OsmPlaces.near(24.7136, 46.6753, client: client).timeout(const Duration(seconds: 5));
      final b = await OsmPlaces.near(24.7136, 46.6753, client: client).timeout(const Duration(seconds: 5));
      expect(a.single.name, 'بنده');
      expect(a.single.distanceM, greaterThan(0));
      expect(b.single.category, 'سوبر ماركت وبقالة');
      expect(calls, 1);
    });

    test('near(): a busy Overpass (429) gives nothing, quietly', () async {
      SharedPreferences.setMockInitialValues({});
      OsmPlaces.debugResetRateLimit();
      final client = MockClient((req) async => http.Response('busy', 429));
      expect(await OsmPlaces.near(21.4858, 39.1925, client: client), isEmpty);
    });
  });

  group('merge with our directory', () {
    const lat = 24.7136, lng = 46.6753;
    OsmPlace osm(int id, String name, double dLat, {String cat = 'سوبر ماركت وبقالة'}) =>
        OsmPlace(type: 'node', id: id, name: name, category: cat, kind: 'shop=supermarket', lat: lat + dLat, lng: lng);

    test('names: alef / taa marbuta / yaa folded, spaces and punctuation ignored', () {
      expect(placeNameKey('صيدلية  العزبي!'), placeNameKey('صيدليه العزبى'));
      expect(placeNameKey('أسواق'), 'اسواق');
      expect(placeNamesSimilar('بنده', 'أسواق بنده'), isTrue);
      expect(placeNamesSimilar('Panda', 'PANDA Hyper'), isTrue);
      expect(placeNamesSimilar('بنده', 'العثيم'), isFalse);
      expect(placeNamesSimilar('', 'x'), isFalse);
    });

    test('drops OSM places we already have (same id, or ≤ 40 m with a similar name), keeps the rest, nearest first', () {
      final ours = [
        {'id': 'usr-1', 'name': 'أسواق بنده', 'category': 'سوبر ماركت وبقالة', 'lat': lat + 0.0002, 'lng': lng, 'distance_km': 0.022},
        {'id': 'osm-node-3', 'name': 'imported', 'category': 'سوبر ماركت وبقالة', 'lat': lat + 0.01, 'lng': lng, 'distance_km': 1.1},
      ];
      final merged = mergeWithOsm(ours, [
        osm(1, 'بنده', 0.0001), // ~11 m from ours, similar → same place
        osm(2, 'العثيم', 0.0001), // same spot, other name → kept
        osm(3, 'imported', 0.01), // already imported
        osm(4, 'تميمي', 0.003),
      ], lat, lng);
      expect(merged.map((r) => r['id']), ['osm-node-2', 'usr-1', 'osm-node-4', 'osm-node-3']);
      expect(merged.where((r) => r['osm'] == true).length, 2);
    });

    test('category filter and cap', () {
      final merged = mergeWithOsm(const [], [
        osm(1, 'صيدلية', 0.001, cat: 'صيدليات'),
        for (var i = 2; i < 10; i++) osm(i, 'محل $i', 0.001 * i),
      ], lat, lng, categories: {'صيدليات'});
      expect(merged.single['id'], 'osm-node-1');
      expect(mergeWithOsm(const [], [for (var i = 1; i < 10; i++) osm(i, 'محل $i', 0.001 * i)], lat, lng, maxOsm: 3).length, 3);
    });

    test('when to ask OpenStreetMap: always outside Egypt, in Egypt only when ours are few', () {
      expect(wantsOsm(ours: 50, country: 'SA'), isTrue);
      expect(wantsOsm(ours: 0, country: null), isTrue);
      expect(wantsOsm(ours: 50, country: 'EG'), isFalse);
      expect(wantsOsm(ours: 3, country: 'EG'), isTrue);
    });
  });
}
