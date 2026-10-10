import '../masjid/world_places.dart';
import '../masjid/world_time.dart';
import 'egypt_cities.dart';

/// A city to compute prayer times / qibla for when the location is off.
class PickCity {
  const PickCity(this.name, this.lat, this.lng, this.tz, this.iso);
  final String name;
  final double lat;
  final double lng;
  final String tz;
  final String iso;

  /// «دبي — الإمارات».
  String get label => iso == 'EG' ? name : '$name — ${countries[iso]?.nameAr ?? iso}';
}

/// Egypt's governorate capitals and the world's main cities (one per time
/// zone, plus a few more), the device's country first.
List<PickCity> pickerCities() {
  final seen = <String>{};
  final all = <PickCity>[
    for (final c in egyptCities) PickCity(c.$1, c.$2, c.$3, cairoTz, 'EG'),
    for (final z in tzZones)
      if (z.iso != 'EG') PickCity(z.city, z.lat, z.lng, z.tz, z.iso),
    for (final c in extraCities) PickCity(c.$1, c.$3, c.$4, c.$2, zoneInfo(c.$2)?.iso ?? ''),
  ].where((c) => seen.add('${c.name}|${c.iso}')).toList();
  final mine = countryOfTimeZone(deviceTimeZone) ?? 'EG';
  return [...all.where((c) => c.iso == mine), ...all.where((c) => c.iso != mine)];
}

/// Cities whose name or country contains [q].
List<PickCity> searchCities(List<PickCity> cities, String q) {
  final t = q.trim();
  if (t.isEmpty) return cities;
  return cities.where((c) => c.label.contains(t) || c.tz.toLowerCase().contains(t.toLowerCase())).toList();
}
