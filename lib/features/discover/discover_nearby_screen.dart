import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../../core/places/places_service.dart';
import '../../core/theme/app_colors.dart';
import '../shared/load_error_view.dart';
import 'place_details_screen.dart';

const _categories = [
  ('pharmacy', 'صيدليات', Icons.local_pharmacy_rounded),
  ('clinic', 'عيادات', Icons.medical_services_rounded),
  ('hospital', 'مستشفيات', Icons.local_hospital_rounded),
  ('supermarket', 'سوبر ماركت', Icons.local_grocery_store_rounded),
  ('restaurant', 'مطاعم', Icons.restaurant_rounded),
  ('cafe', 'كافيهات', Icons.local_cafe_rounded),
  ('bakery', 'مخابز', Icons.bakery_dining_rounded),
  ('clothing', 'ملابس', Icons.checkroom_rounded),
  ('electronics', 'موبايلات', Icons.phone_android_rounded),
  ('bank', 'بنوك وATM', Icons.account_balance_rounded),
  ('fuel', 'بنزينة', Icons.local_gas_station_rounded),
  ('beauty', 'صالونات', Icons.content_cut_rounded),
  ('gym', 'جيم', Icons.fitness_center_rounded),
  ('laundry', 'مغاسل', Icons.local_laundry_service_rounded),
];

double _distanceKm(double lat1, double lng1, double lat2, double lng2) {
  const r = 6371.0;
  final dLat = (lat2 - lat1) * math.pi / 180;
  final dLng = (lng2 - lng1) * math.pi / 180;
  final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
      math.cos(lat1 * math.pi / 180) * math.cos(lat2 * math.pi / 180) * math.sin(dLng / 2) * math.sin(dLng / 2);
  return r * 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
}

/// "اكتشف حواليك" — every business around the user (clinics, pharmacies,
/// restaurants, shops, …) live from Google Maps, nearest first. Results
/// are shown, never stored (Google Maps terms). Works without an account.
class DiscoverNearbyScreen extends StatefulWidget {
  const DiscoverNearbyScreen({super.key});

  @override
  State<DiscoverNearbyScreen> createState() => _DiscoverNearbyScreenState();
}

class _DiscoverNearbyScreenState extends State<DiscoverNearbyScreen> {
  Position? _position;
  String? _locationError;
  String _category = _categories.first.$1;
  bool _loading = true;
  bool _loadError = false;
  String? _errorMessage;
  List<Map<String, dynamic>> _places = [];

  @override
  void initState() {
    super.initState();
    _locate();
  }

  Future<void> _locate() async {
    setState(() {
      _loading = true;
      _locationError = null;
    });
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        throw 'شغّل خدمة الموقع (GPS) عشان نعرض اللي حواليك';
      }
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        throw 'محتاجين إذن الموقع عشان نعرض الأماكن القريبة منك';
      }
      final position = await Geolocator.getCurrentPosition(locationSettings: const LocationSettings(accuracy: LocationAccuracy.medium));
      if (!mounted) return;
      _position = position;
      await _load();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _locationError = e is String ? e : 'تعذر تحديد موقعك';
      });
    }
  }

  Future<void> _load() async {
    final p = _position;
    if (p == null) return;
    setState(() {
      _loading = true;
      _loadError = false;
    });
    try {
      final places = await PlacesService.nearby(lat: p.latitude, lng: p.longitude, category: _category);
      if (!mounted) return;
      setState(() {
        _places = places;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _loadError = true;
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const Text('اكتشف حواليك')),
      body: Column(
        children: [
          SizedBox(
            height: 50,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, i) {
                final (key, label, icon) = _categories[i];
                final selected = key == _category;
                return ChoiceChip(
                  selected: selected,
                  avatar: Icon(icon, size: 16, color: selected ? Colors.white : AppColors.teal),
                  label: Text(label),
                  labelStyle: TextStyle(color: selected ? Colors.white : AppColors.ink, fontSize: 12),
                  selectedColor: AppColors.teal,
                  showCheckmark: false,
                  onSelected: (_) {
                    setState(() => _category = key);
                    _load();
                  },
                );
              },
            ),
          ),
          Expanded(child: _body()),
        ],
      ),
    );
  }

  Widget _body() {
    if (_locationError != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.location_off_rounded, size: 40, color: AppColors.inkMuted),
            const SizedBox(height: 10),
            Text(_locationError!, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.inkSecondary, height: 1.6)),
            const SizedBox(height: 12),
            OutlinedButton(onPressed: _locate, child: const Text('حاول تاني')),
          ]),
        ),
      );
    }
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_loadError) return LoadErrorView(onRetry: _load, message: _errorMessage ?? 'تعذر تحميل الأماكن القريبة');
    if (_places.isEmpty) {
      return const Center(child: Text('مفيش أماكن من النوع ده قريبة منك (في حدود 3 كم)', style: TextStyle(color: AppColors.inkMuted)));
    }
    final p = _position!;
    return RefreshIndicator(
      onRefresh: _load,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(12, 4, 12, 24),
        itemCount: _places.length,
        separatorBuilder: (_, _) => const SizedBox(height: 10),
        itemBuilder: (context, i) {
          final place = _places[i];
          final lat = (place['lat'] as num?)?.toDouble();
          final lng = (place['lng'] as num?)?.toDouble();
          final km = lat == null || lng == null ? null : _distanceKm(p.latitude, p.longitude, lat, lng);
          final openNow = place['open_now'] as bool?;
          final rating = (place['rating'] as num?)?.toDouble();
          return InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => PlaceDetailsScreen(placeId: place['place_id'] as String, name: place['name'] as String? ?? ''))),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
              child: Row(children: [
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(place['name'] as String? ?? '', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5)),
                    if ((place['type'] as String?)?.isNotEmpty == true)
                      Text(place['type'] as String, style: const TextStyle(fontSize: 11, color: AppColors.inkMuted)),
                    const SizedBox(height: 4),
                    Wrap(spacing: 10, children: [
                      if (km != null) Text(km < 1 ? '${(km * 1000).round()} م' : '${km.toStringAsFixed(1)} كم', style: const TextStyle(fontSize: 11.5, color: AppColors.inkSecondary)),
                      if (rating != null) Text('★ ${rating.toStringAsFixed(1)} (${place['rating_count']})', style: const TextStyle(fontSize: 11.5, color: AppColors.gold)),
                      if (openNow != null)
                        Text(openNow ? 'مفتوح الآن' : 'مغلق الآن', style: TextStyle(fontSize: 11.5, color: openNow ? AppColors.teal : AppColors.categorySos, fontWeight: FontWeight.w600)),
                    ]),
                  ]),
                ),
                if (place['store_slug'] != null)
                  const Padding(padding: EdgeInsetsDirectional.only(start: 6), child: Chip(label: Text('متجر', style: TextStyle(fontSize: 10)), visualDensity: VisualDensity.compact))
                else if (place['has_website'] == true)
                  const Icon(Icons.language_rounded, size: 18, color: AppColors.inkMuted),
                const Icon(Icons.chevron_left_rounded, color: AppColors.inkMuted),
              ]),
            ),
          );
        },
      ),
    );
  }
}
