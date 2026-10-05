import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../../core/places/directory_service.dart';
import '../../core/theme/app_colors.dart';
import '../people/nearby_people_tab.dart';
import '../shared/load_error_view.dart';
import 'directory_place_screen.dart';

// Directory categories (Arabic groups from backend/maintenance/directory/2_clean.sql).
const _categories = <(String?, String, IconData)>[
  (null, 'الكل', Icons.apps_rounded),
  ('سوبر ماركت وبقالة', 'سوبر ماركت', Icons.local_grocery_store_rounded),
  ('صيدليات', 'صيدليات', Icons.local_pharmacy_rounded),
  ('مطاعم', 'مطاعم', Icons.restaurant_rounded),
  ('كافيهات', 'كافيهات', Icons.local_cafe_rounded),
  ('حلويات ومخبوزات', 'حلويات ومخابز', Icons.bakery_dining_rounded),
  ('صحة وعيادات', 'عيادات', Icons.medical_services_rounded),
  ('ملابس وأزياء', 'ملابس', Icons.checkroom_rounded),
  ('إلكترونيات وموبايلات', 'موبايلات', Icons.phone_android_rounded),
  ('أدوات منزلية وأثاث', 'أدوات منزلية', Icons.chair_rounded),
  ('تجميل وعناية', 'تجميل', Icons.content_cut_rounded),
  ('صيانة وخدمات منزلية', 'صيانة', Icons.handyman_rounded),
  ('سيارات', 'سيارات', Icons.directions_car_rounded),
  ('هدايا ومكتبات', 'هدايا ومكتبات', Icons.card_giftcard_rounded),
  ('رياضة', 'رياضة', Icons.fitness_center_rounded),
  ('تعليم', 'تعليم', Icons.school_rounded),
  ('بنوك وصرافات', 'بنوك', Icons.account_balance_rounded),
  ('محلات متنوعة', 'محلات تانية', Icons.storefront_rounded),
];

/// "اكتشف حواليك" — businesses around the user from our own Egypt
/// directory (~300k places, Overture Maps), nearest first, by category or
/// by name. Each one opens as a store page you can order from on WhatsApp.
/// Works without an account, and costs nothing per search.
class DiscoverNearbyScreen extends StatefulWidget {
  const DiscoverNearbyScreen({super.key, this.showPeople = false});

  /// Open on the "ناس" tab instead of "أماكن".
  final bool showPeople;

  @override
  State<DiscoverNearbyScreen> createState() => _DiscoverNearbyScreenState();
}

class _DiscoverNearbyScreenState extends State<DiscoverNearbyScreen> {
  Position? _position;
  String? _locationError;
  String? _category;
  /// The "أماكن" | "ناس" toggle: true shows people nearby.
  late bool _people = widget.showPeople;
  bool _loading = true;
  bool _loadError = false;
  List<Map<String, dynamic>> _places = [];
  final _search = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _locate();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _search.dispose();
    super.dispose();
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
        throw 'محتاجين إذن الموقع عشان نعرض الأماكن القريبة منك — أو دوّر بالاسم فوق';
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
    final q = _search.text.trim();
    if (p == null && q.length < 2) return;
    setState(() {
      _loading = true;
      _loadError = false;
    });
    try {
      List<Map<String, dynamic>> places;
      if (q.length >= 2) {
        places = await DirectoryService.search(q, lat: p?.latitude, lng: p?.longitude);
      } else {
        // Widen the circle when the nearest ring is thin (rural areas).
        places = await DirectoryService.nearby(lat: p!.latitude, lng: p.longitude, category: _category);
        if (places.length < 10) {
          places = await DirectoryService.nearby(lat: p.latitude, lng: p.longitude, category: _category, km: 15);
        }
      }
      if (!mounted) return;
      setState(() {
        _places = places;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _loadError = true;
      });
    }
  }

  void _onSearchChanged(String _) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 450), _load);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final side = width > 760 ? (width - 720) / 2 : 12.0;
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const Text('اكتشف حواليك')),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(side, 10, side, 0),
            child: SizedBox(
              width: double.infinity,
              child: SegmentedButton<bool>(
                segments: const [
                  ButtonSegment(value: false, label: Text('أماكن'), icon: Icon(Icons.storefront_rounded, size: 18)),
                  ButtonSegment(value: true, label: Text('ناس'), icon: Icon(Icons.people_alt_rounded, size: 18)),
                ],
                selected: {_people},
                showSelectedIcon: false,
                onSelectionChanged: (s) => setState(() => _people = s.first),
              ),
            ),
          ),
          if (_people)
            Expanded(child: Padding(padding: EdgeInsets.fromLTRB(side, 10, side, 0), child: const NearbyPeopleTab()))
          else ...[
          Padding(
            padding: EdgeInsets.fromLTRB(side, 10, side, 0),
            child: TextField(
              controller: _search,
              onChanged: _onSearchChanged,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: 'دوّر على محل، صيدلية، مطعم…',
                prefixIcon: const Icon(Icons.search_rounded),
                isDense: true,
                suffixIcon: _search.text.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.close_rounded),
                        onPressed: () {
                          _search.clear();
                          _load();
                        },
                      ),
              ),
            ),
          ),
          SizedBox(
            height: 50,
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: side, vertical: 8),
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, i) {
                final (key, label, icon) = _categories[i];
                final selected = key == _category && _search.text.trim().length < 2;
                return ChoiceChip(
                  selected: selected,
                  avatar: Icon(icon, size: 16, color: selected ? Colors.white : AppColors.teal),
                  label: Text(label),
                  labelStyle: TextStyle(color: selected ? Colors.white : AppColors.ink, fontSize: 12),
                  selectedColor: AppColors.teal,
                  showCheckmark: false,
                  onSelected: (_) {
                    _search.clear();
                    setState(() => _category = key);
                    _load();
                  },
                );
              },
            ),
          ),
          Expanded(child: Padding(padding: EdgeInsets.symmetric(horizontal: side), child: _body())),
          ],
        ],
      ),
    );
  }

  Widget _body() {
    if (_locationError != null && _search.text.trim().length < 2) {
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
    if (_loadError) return LoadErrorView(onRetry: _load, message: 'تعذر تحميل الأماكن');
    if (_places.isEmpty) {
      return const Center(child: Text('مفيش نتايج — جرّب نشاط تاني أو اسم تاني', style: TextStyle(color: AppColors.inkMuted)));
    }
    return RefreshIndicator(
      onRefresh: _load,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(0, 4, 0, 24),
        itemCount: _places.length + 1,
        separatorBuilder: (_, _) => const SizedBox(height: 10),
        itemBuilder: (context, i) {
          if (i == _places.length) {
            return const Padding(
              padding: EdgeInsets.only(top: 6),
              child: Center(child: Text(DirectoryService.attribution, style: TextStyle(fontSize: 10.5, color: AppColors.inkMuted))),
            );
          }
          final place = _places[i];
          final km = (place['distance_km'] as num?)?.toDouble();
          final canOrder = place['whatsapp'] != null;
          return InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => DirectoryPlaceScreen(placeId: place['id'] as String, place: place),
            )),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
              child: Row(children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: AppColors.teal.withValues(alpha: 0.1),
                  child: Icon(_iconFor(place['category'] as String?), color: AppColors.teal, size: 20),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(place['name'] as String? ?? '', maxLines: 1, overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5)),
                    Text(place['category'] as String? ?? '', style: const TextStyle(fontSize: 11, color: AppColors.inkMuted)),
                    if (km != null)
                      Text(km < 1 ? '${(km * 1000).round()} م' : '${km.toStringAsFixed(1)} كم',
                          style: const TextStyle(fontSize: 11.5, color: AppColors.inkSecondary)),
                  ]),
                ),
                if (place['claimed_shop_id'] != null)
                  const Chip(label: Text('متجر', style: TextStyle(fontSize: 10)), visualDensity: VisualDensity.compact)
                else if (canOrder)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(color: const Color(0xFF1FA855), borderRadius: BorderRadius.circular(100)),
                    child: const Text('اطلب', style: TextStyle(color: Colors.white, fontSize: 11.5, fontWeight: FontWeight.w800)),
                  ),
                const Icon(Icons.chevron_left_rounded, color: AppColors.inkMuted),
              ]),
            ),
          );
        },
      ),
    );
  }

  static IconData _iconFor(String? category) {
    for (final (key, _, icon) in _categories) {
      if (key == category) return icon;
    }
    return Icons.storefront_rounded;
  }
}
