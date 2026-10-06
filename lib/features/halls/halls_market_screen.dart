import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../core/auth/auth_service.dart';
import '../../core/halls/hall_service.dart';
import '../../core/reports/report_service.dart' show reportGovernorates;
import '../../core/routing/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../auth/auth_landing_screen.dart';
import '../shared/load_error_view.dart';
import 'add_hall_screen.dart';
import 'my_halls_screen.dart';

/// "قاعات المناسبات" (`/halls`) — wedding halls, party halls, conference
/// rooms, rooftops, boats… Guests browse and contact; listing needs an
/// account.
class HallsMarketScreen extends StatefulWidget {
  const HallsMarketScreen({super.key});

  @override
  State<HallsMarketScreen> createState() => _HallsMarketScreenState();
}

class _HallsMarketScreenState extends State<HallsMarketScreen> {
  HallFilters _filters = const HallFilters();
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
      final items = await HallService.fetch(_filters.copyWith(query: _search.text));
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
    final created = await Navigator.of(context).push<bool>(MaterialPageRoute(builder: (_) => const AddHallScreen()));
    if (created == true) _load();
  }

  Future<void> _mine() async {
    if (!await _ensureSignedIn() || !mounted) return;
    await Navigator.of(context).push(MaterialPageRoute(builder: (_) => const MyHallsScreen()));
    _load();
  }

  Future<void> _openFilters() async {
    final result = await showModalBottomSheet<HallFilters>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(22))),
      builder: (_) => _FiltersSheet(initial: _filters),
    );
    if (result != null) {
      _filters = result;
      _load();
    }
  }

  Widget _typeChip(String label, String? type) {
    final selected = _filters.hallType == type;
    return Padding(
      padding: const EdgeInsetsDirectional.only(end: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        showCheckmark: false,
        selectedColor: AppColors.teal,
        labelStyle: TextStyle(color: selected ? Colors.white : AppColors.ink, fontWeight: FontWeight.w700),
        onSelected: (_) {
          if (selected) return;
          setState(() => _filters = _filters.copyWith(hallType: type, clearHallType: type == null));
          _load();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final side = width > 760 ? (width - 720) / 2 : 12.0;
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: const Text('قاعات المناسبات'),
        actions: [
          IconButton(onPressed: _mine, icon: const Icon(Icons.list_alt_rounded), tooltip: 'إعلاناتي'),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _add,
        backgroundColor: AppColors.teal,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: const Text('أضف قاعتك'),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 52,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.fromLTRB(side, 10, side, 4),
              children: [
                _typeChip('الكل', null),
                for (final e in hallTypes.entries) _typeChip(e.value, e.key),
              ],
            ),
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
                    hintText: 'دوّر باسم القاعة',
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
      final filtered = _filters.activeCount > 0 || _filters.hallType != null || _search.text.trim().isNotEmpty;
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.celebration_outlined, size: 46, color: AppColors.inkMuted),
            const SizedBox(height: 10),
            Text(
              filtered ? 'مفيش قاعات بالفلاتر دي' : 'لسه مفيش قاعات هنا — لو عندك قاعة، أعلن عنها ببلاش',
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
        itemBuilder: (_, i) => HallCard(
          item: _items[i],
          onTap: () async {
            await context.push(AppRoutes.hall(_items[i]['id'] as String), extra: _items[i]);
          },
        ),
      ),
    );
  }
}

/// A hall tile: first photo, name, starting price, capacity and place.
class HallCard extends StatelessWidget {
  const HallCard({super.key, required this.item, this.onTap});
  final Map<String, dynamic> item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final images = (item['images'] as List?)?.cast<String>() ?? const [];
    final place = [item['area'], item['governorate']].whereType<String>().where((s) => s.trim().isNotEmpty).join('، ');
    final featured = item['is_featured'] == true;
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: featured ? AppColors.gold : AppColors.border, width: featured ? 1.5 : 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Stack(fit: StackFit.expand, children: [
                  images.isEmpty
                      ? const HallPhotoPlaceholder()
                      : Image.network(images.first, cacheWidth: 600, fit: BoxFit.cover, errorBuilder: (_, _, _) => const HallPhotoPlaceholder()),
                  if (featured)
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
                  PositionedDirectional(
                    top: 8,
                    end: 8,
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 130),
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(color: AppColors.navy.withValues(alpha: 0.75), borderRadius: BorderRadius.circular(8)),
                      child: Text(hallTypes[item['hall_type']] ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 10.5, color: Colors.white, fontWeight: FontWeight.w700)),
                    ),
                  ),
                ]),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(item['name'] as String? ?? '',
                      maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13.5, color: AppColors.ink)),
                  const SizedBox(height: 3),
                  Text(hallPrice(item),
                      maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.teal, fontWeight: FontWeight.w800, fontSize: 13)),
                  const SizedBox(height: 3),
                  Row(children: [
                    const Icon(Icons.groups_outlined, size: 13, color: AppColors.inkSecondary),
                    const SizedBox(width: 3),
                    Expanded(
                      child: Text(hallCapacity(item),
                          maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11.5, color: AppColors.inkSecondary)),
                    ),
                  ]),
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

/// Shown where a hall has no photo (or it fails to load).
class HallPhotoPlaceholder extends StatelessWidget {
  const HallPhotoPlaceholder({super.key, this.size = 40});
  final double size;

  @override
  Widget build(BuildContext context) => ColoredBox(
        color: AppColors.surfaceAlt,
        child: Center(child: Icon(Icons.celebration_rounded, size: size, color: AppColors.inkMuted)),
      );
}

/// Filters bottom sheet; pops the new [HallFilters] (or nothing on dismiss).
/// The type stays on the chips above the list.
class _FiltersSheet extends StatefulWidget {
  const _FiltersSheet({required this.initial});
  final HallFilters initial;

  @override
  State<_FiltersSheet> createState() => _FiltersSheetState();
}

class _FiltersSheetState extends State<_FiltersSheet> {
  late String? _occasion = widget.initial.occasion;
  late String? _governorate = widget.initial.governorate;
  late final _area = TextEditingController(text: widget.initial.area ?? '');
  late final _guests = TextEditingController(text: widget.initial.guests?.toString() ?? '');
  late final _price = TextEditingController(text: widget.initial.priceMax?.toStringAsFixed(0) ?? '');

  @override
  void dispose() {
    _area.dispose();
    _guests.dispose();
    _price.dispose();
    super.dispose();
  }

  InputDecoration _dec(String label, {String? hint, String? suffix}) => InputDecoration(
        labelText: label,
        hintText: hint,
        suffixText: suffix,
        isDense: true,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      );

  Widget _dropdown(String label, String? value, Map<String, String> options, ValueChanged<String?> onChanged) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      isExpanded: true,
      decoration: _dec(label),
      items: [
        const DropdownMenuItem<String>(value: null, child: Text('الكل')),
        for (final e in options.entries) DropdownMenuItem<String>(value: e.key, child: Text(e.value, overflow: TextOverflow.ellipsis)),
      ],
      onChanged: onChanged,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SafeArea(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('فلترة', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: AppColors.ink)),
                const SizedBox(height: 14),
                _dropdown('المناسبة', _occasion, hallOccasions, (v) => setState(() => _occasion = v)),
                const SizedBox(height: 10),
                _dropdown('المحافظة', _governorate, {for (final g in reportGovernorates) g: g}, (v) => setState(() => _governorate = v)),
                const SizedBox(height: 10),
                TextField(controller: _area, decoration: _dec('المنطقة', hint: 'مثلاً: مدينة نصر')),
                const SizedBox(height: 10),
                Row(children: [
                  Expanded(
                    child: TextField(
                      controller: _guests,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: _dec('عدد المعازيم', suffix: 'فرد'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _price,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: _dec('أقصى سعر', suffix: 'ج.م'),
                    ),
                  ),
                ]),
                const SizedBox(height: 16),
                Row(children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context, HallFilters(hallType: widget.initial.hallType)),
                      child: const Text('مسح الفلاتر'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: FilledButton(
                      style: FilledButton.styleFrom(backgroundColor: AppColors.teal),
                      onPressed: () => Navigator.pop(
                        context,
                        HallFilters(
                          hallType: widget.initial.hallType,
                          occasion: _occasion,
                          governorate: _governorate,
                          area: _area.text.trim().isEmpty ? null : _area.text.trim(),
                          guests: int.tryParse(_guests.text.trim()),
                          priceMax: num.tryParse(_price.text.trim()),
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
