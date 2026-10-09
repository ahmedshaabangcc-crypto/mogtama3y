import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/routing/app_router.dart';
import '../../core/auth/auth_service.dart';
import '../../core/cars/car_service.dart';
import '../../core/reports/report_service.dart' show reportGovernorates;
import '../../core/theme/app_colors.dart';
import '../auth/auth_landing_screen.dart';
import '../shared/load_error_view.dart';
import 'add_car_listing_screen.dart';
import 'my_car_listings_screen.dart';
import 'package:mogtama3y/core/utils/numbers.dart';

/// "سيارات" (`/cars`) — cars, motorcycles and tuktuks for sale or rent,
/// plus parts & accessories. Guests can browse; posting needs an account.
class CarsMarketScreen extends StatefulWidget {
  const CarsMarketScreen({super.key});

  @override
  State<CarsMarketScreen> createState() => _CarsMarketScreenState();
}

class _CarsMarketScreenState extends State<CarsMarketScreen> {
  static const _tabs = <(String, List<String>)>[
    ('بيع', ['sale']),
    ('إيجار', ['rent_daily', 'rent_monthly']),
    ('قطع غيار', ['parts']),
  ];

  int _tab = 0;
  CarFilters _filters = const CarFilters();
  final _search = TextEditingController();
  Timer? _debounce;

  List<Map<String, dynamic>> _items = [];
  bool _loading = true;
  bool _error = false;
  int _loadSeq = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _search.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final seq = ++_loadSeq;
    setState(() {
      _loading = true;
      _error = false;
    });
    try {
      final items = await CarService.fetch(_filters.copyWith(offerTypes: _tabs[_tab].$2, query: _search.text));
      if (!mounted || seq != _loadSeq) return;
      setState(() {
        _items = items;
        _loading = false;
      });
    } catch (_) {
      if (!mounted || seq != _loadSeq) return;
      setState(() {
        _loading = false;
        _error = true;
      });
    }
  }

  void _onSearch(String _) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), _load);
  }

  Future<bool> _ensureSignedIn() async {
    if (AuthService.isSignedIn) return true;
    await Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AuthLandingScreen()));
    return AuthService.isSignedIn;
  }

  Future<void> _add() async {
    if (!await _ensureSignedIn() || !mounted) return;
    final created = await Navigator.of(context).push<bool>(MaterialPageRoute(builder: (_) => const AddCarListingScreen()));
    if (created == true) _load();
  }

  Future<void> _mine() async {
    if (!await _ensureSignedIn() || !mounted) return;
    await Navigator.of(context).push(MaterialPageRoute(builder: (_) => const MyCarListingsScreen()));
    _load();
  }

  Future<void> _openFilters() async {
    final result = await showModalBottomSheet<CarFilters>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(22))),
      builder: (_) => _FiltersSheet(initial: _filters, partsOnly: _tab == 2),
    );
    if (result != null) {
      _filters = result;
      _load();
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final side = width > 760 ? (width - 720) / 2 : 12.0;
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: const Text('سيارات'),
        actions: [
          IconButton(onPressed: _mine, icon: const Icon(Icons.list_alt_rounded), tooltip: 'إعلاناتي'),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _add,
        backgroundColor: AppColors.teal,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: const Text('أضف إعلان'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(side, 10, side, 4),
            child: Row(children: [
              for (var i = 0; i < _tabs.length; i++)
                Padding(
                  padding: const EdgeInsetsDirectional.only(end: 8),
                  child: ChoiceChip(
                    label: Text(_tabs[i].$1),
                    selected: _tab == i,
                    showCheckmark: false,
                    selectedColor: AppColors.teal,
                    labelStyle: TextStyle(color: _tab == i ? Colors.white : AppColors.ink, fontWeight: FontWeight.w700),
                    onSelected: (_) {
                      if (_tab == i) return;
                      setState(() => _tab = i);
                      _load();
                    },
                  ),
                ),
            ]),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(side, 6, side, 8),
            child: Row(children: [
              Expanded(
                child: TextField(
                  controller: _search,
                  onChanged: _onSearch,
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintText: 'دوّر بالاسم: كورولا، إلنترا، كاوتش…',
                    prefixIcon: const Icon(Icons.search_rounded),
                    isDense: true,
                    filled: true,
                    fillColor: AppColors.surface,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.border)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.border)),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Badge(
                isLabelVisible: _filters.activeCount > 0,
                label: Text('${_filters.activeCount}'),
                backgroundColor: AppColors.gold,
                textColor: AppColors.ink,
                child: IconButton.filledTonal(
                  onPressed: _openFilters,
                  icon: const Icon(Icons.tune_rounded),
                  tooltip: 'فلترة',
                ),
              ),
            ]),
          ),
          Expanded(child: _body(side, width)),
        ],
      ),
    );
  }

  Widget _body(double side, double width) {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_error) return LoadErrorView(onRetry: _load);
    if (_items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.directions_car_outlined, size: 46, color: AppColors.inkMuted),
            const SizedBox(height: 10),
            Text(
              _filters.activeCount > 0 || _search.text.trim().isNotEmpty ? 'مفيش إعلانات بالفلاتر دي' : 'لسه مفيش إعلانات هنا — كن أول واحد يعلن',
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.inkMuted),
            ),
          ]),
        ),
      );
    }
    final cols = width >= 640 ? 3 : 2;
    return RefreshIndicator(
      onRefresh: _load,
      child: GridView.builder(
        padding: EdgeInsets.fromLTRB(side, 4, side, 96),
        itemCount: _items.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: cols,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 0.68,
        ),
        itemBuilder: (_, i) => CarCard(
          item: _items[i],
          onTap: () async {
            await context.push(AppRoutes.car(_items[i]['id'] as String), extra: _items[i]);
          },
        ),
      ),
    );
  }
}

/// A listing tile: first photo, title, price, key specs and place.
class CarCard extends StatelessWidget {
  const CarCard({super.key, required this.item, this.onTap});
  final Map<String, dynamic> item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final images = (item['images'] as List?)?.cast<String>() ?? const [];
    final specs = [
      if (item['year'] != null) '${item['year']}',
      if (item['km'] != null) '${carPrice(item['km']).replaceAll(' ج.م', '')} كم',
      if (item['transmission'] != null) carTransmissions[item['transmission']] ?? '',
    ].where((s) => s.isNotEmpty).join(' · ');
    final place = [item['area'], item['governorate']].whereType<String>().where((s) => s.trim().isNotEmpty).join('، ');
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: item['is_featured'] == true ? AppColors.gold : AppColors.border, width: item['is_featured'] == true ? 1.5 : 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Stack(fit: StackFit.expand, children: [
                  images.isEmpty
                      ? const _PhotoPlaceholder()
                      : Image.network(images.first, cacheWidth: 600, fit: BoxFit.cover, errorBuilder: (_, _, _) => const _PhotoPlaceholder()),
                  if (item['is_featured'] == true)
                    PositionedDirectional(
                      top: 8,
                      start: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                        decoration: BoxDecoration(color: AppColors.gold, borderRadius: BorderRadius.circular(8)),
                        child: const Row(mainAxisSize: MainAxisSize.min, children: [
                          Icon(Icons.star_rounded, size: 12, color: AppColors.ink),
                          SizedBox(width: 2),
                          Text('مميز', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800, color: AppColors.ink)),
                        ]),
                      ),
                    ),
                  if (item['offer_type'] != 'sale')
                    PositionedDirectional(
                      top: 8,
                      end: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                        decoration: BoxDecoration(color: AppColors.navy.withValues(alpha: 0.75), borderRadius: BorderRadius.circular(8)),
                        child: Text(carOfferTypes[item['offer_type']] ?? '', style: const TextStyle(fontSize: 10.5, color: Colors.white, fontWeight: FontWeight.w700)),
                      ),
                    ),
                ]),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(item['title'] as String? ?? '',
                      maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13.5, color: AppColors.ink)),
                  const SizedBox(height: 3),
                  Text.rich(
                    TextSpan(children: [
                      TextSpan(text: carPrice(item['price'] as num?) + carPriceSuffix(item['offer_type'] as String?)),
                      if (item['negotiable'] == true)
                        const TextSpan(text: '  قابل للتفاوض', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600, color: AppColors.inkMuted)),
                    ]),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: AppColors.teal, fontWeight: FontWeight.w800, fontSize: 13.5),
                  ),
                  if (specs.isNotEmpty) ...[
                    const SizedBox(height: 3),
                    Text(specs, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11.5, color: AppColors.inkSecondary)),
                  ],
                  if (place.isNotEmpty) ...[
                    const SizedBox(height: 3),
                    Row(children: [
                      const Icon(Icons.place_outlined, size: 13, color: AppColors.inkMuted),
                      const SizedBox(width: 2),
                      Expanded(child: Text(place, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11, color: AppColors.inkMuted))),
                    ]),
                  ],
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PhotoPlaceholder extends StatelessWidget {
  const _PhotoPlaceholder();

  @override
  Widget build(BuildContext context) => const ColoredBox(
        color: AppColors.surfaceAlt,
        child: Center(child: Icon(Icons.directions_car_filled_rounded, size: 40, color: AppColors.inkMuted)),
      );
}

/// Filters bottom sheet; pops the new [CarFilters] (or nothing on dismiss).
class _FiltersSheet extends StatefulWidget {
  const _FiltersSheet({required this.initial, required this.partsOnly});
  final CarFilters initial;
  final bool partsOnly;

  @override
  State<_FiltersSheet> createState() => _FiltersSheetState();
}

class _FiltersSheetState extends State<_FiltersSheet> {
  late String? _vehicle = widget.initial.vehicleType;
  late String? _brand = widget.initial.brand;
  late int? _yearFrom = widget.initial.yearFrom;
  late int? _yearTo = widget.initial.yearTo;
  late final _price = TextEditingController(text: widget.initial.priceMax?.toStringAsFixed(0) ?? '');
  late String? _transmission = widget.initial.transmission;
  late String? _fuel = widget.initial.fuel;
  late String? _governorate = widget.initial.governorate;

  @override
  void dispose() {
    _price.dispose();
    super.dispose();
  }

  List<int> get _years => [for (var y = DateTime.now().year + 1; y >= 1960; y--) y];

  Widget _dropdown<T>(String label, T? value, Map<T, String> options, ValueChanged<T?> onChanged) {
    return DropdownButtonFormField<T>(
      initialValue: value,
      isExpanded: true,
      decoration: InputDecoration(labelText: label, isDense: true, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
      items: [
        DropdownMenuItem<T>(value: null, child: const Text('الكل')),
        for (final e in options.entries) DropdownMenuItem<T>(value: e.key, child: Text(e.value, overflow: TextOverflow.ellipsis)),
      ],
      onChanged: onChanged,
    );
  }

  @override
  Widget build(BuildContext context) {
    final parts = widget.partsOnly;
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SafeArea(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('فلترة', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: AppColors.ink)),
                const SizedBox(height: 14),
                _dropdown<String>('نوع المركبة', _vehicle, carVehicleTypes, (v) => setState(() => _vehicle = v)),
                const SizedBox(height: 10),
                BrandPickerField(value: _brand, allowAny: true, onChanged: (v) => setState(() => _brand = v)),
                if (!parts) ...[
                  const SizedBox(height: 10),
                  Row(children: [
                    Expanded(child: _dropdown<int>('من سنة', _yearFrom, {for (final y in _years) y: '$y'}, (v) => setState(() => _yearFrom = v))),
                    const SizedBox(width: 10),
                    Expanded(child: _dropdown<int>('لحد سنة', _yearTo, {for (final y in _years) y: '$y'}, (v) => setState(() => _yearTo = v))),
                  ]),
                  const SizedBox(height: 10),
                  Row(children: [
                    Expanded(child: _dropdown<String>('ناقل الحركة', _transmission, carTransmissions, (v) => setState(() => _transmission = v))),
                    const SizedBox(width: 10),
                    Expanded(child: _dropdown<String>('الوقود', _fuel, carFuels, (v) => setState(() => _fuel = v))),
                  ]),
                ],
                const SizedBox(height: 10),
                TextField(
                  controller: _price,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'أقصى سعر (ج.م)',
                    isDense: true,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 10),
                _dropdown<String>('المحافظة', _governorate, {for (final g in reportGovernorates) g: g}, (v) => setState(() => _governorate = v)),
                const SizedBox(height: 16),
                Row(children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context, const CarFilters()),
                      child: const Text('مسح الفلاتر'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: FilledButton(
                      style: FilledButton.styleFrom(backgroundColor: AppColors.teal),
                      onPressed: () => Navigator.pop(
                        context,
                        CarFilters(
                          vehicleType: _vehicle,
                          brand: _brand,
                          yearFrom: parts ? null : _yearFrom,
                          yearTo: parts ? null : _yearTo,
                          priceMax: looseNum(_price.text.trim().replaceAll(',', '')),
                          transmission: parts ? null : _transmission,
                          fuel: parts ? null : _fuel,
                          governorate: _governorate,
                        ),
                      ),
                      child: const Text('عرض النتايج'),
                    ),
                  ),
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// A brand field that opens a searchable list of [carBrands].
class BrandPickerField extends StatelessWidget {
  const BrandPickerField({super.key, required this.value, required this.onChanged, this.allowAny = false, this.label = 'الماركة'});
  final String? value;
  final ValueChanged<String?> onChanged;
  final bool allowAny;
  final String label;

  Future<void> _pick(BuildContext context) async {
    final picked = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(22))),
      builder: (_) => _BrandSearchSheet(allowAny: allowAny),
    );
    if (picked == null) return;
    onChanged(picked.isEmpty ? null : picked);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _pick(context),
      borderRadius: BorderRadius.circular(12),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          isDense: true,
          suffixIcon: const Icon(Icons.arrow_drop_down_rounded),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Text(value ?? (allowAny ? 'الكل' : 'اختار الماركة'),
            style: TextStyle(color: value == null ? AppColors.inkMuted : AppColors.ink)),
      ),
    );
  }
}

class _BrandSearchSheet extends StatefulWidget {
  const _BrandSearchSheet({required this.allowAny});
  final bool allowAny;

  @override
  State<_BrandSearchSheet> createState() => _BrandSearchSheetState();
}

class _BrandSearchSheetState extends State<_BrandSearchSheet> {
  String _q = '';

  @override
  Widget build(BuildContext context) {
    final q = _q.trim().toLowerCase();
    final list = q.isEmpty ? carBrands : carBrands.where((b) => b.toLowerCase().contains(q)).toList();
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SafeArea(
        child: SizedBox(
          height: MediaQuery.sizeOf(context).height * 0.7,
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: TextField(
                autofocus: true,
                onChanged: (v) => setState(() => _q = v),
                decoration: InputDecoration(
                  hintText: 'دوّر على الماركة (عربي أو English)',
                  prefixIcon: const Icon(Icons.search_rounded),
                  isDense: true,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            Expanded(
              child: ListView(children: [
                if (widget.allowAny && q.isEmpty)
                  ListTile(title: const Text('كل الماركات'), onTap: () => Navigator.pop(context, '')),
                for (final b in list) ListTile(title: Text(b), onTap: () => Navigator.pop(context, b)),
              ]),
            ),
          ]),
        ),
      ),
    );
  }
}
