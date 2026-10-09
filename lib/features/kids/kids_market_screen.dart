import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/auth/auth_service.dart';
import '../../core/kids/kids_service.dart';
import '../../core/reports/report_service.dart' show reportGovernorates;
import '../../core/routing/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../auth/auth_landing_screen.dart';
import '../shared/load_error_view.dart';
import 'add_kids_item_screen.dart';
import 'my_kids_listings_screen.dart';
import 'package:mogtama3y/core/utils/numbers.dart';

/// "مستلزمات الأطفال" (`/kids`) — strollers, car seats, cribs, toys,
/// clothes… new or used, for sale, swap or free. Guests can browse;
/// posting needs an account.
class KidsMarketScreen extends StatefulWidget {
  const KidsMarketScreen({super.key});

  @override
  State<KidsMarketScreen> createState() => _KidsMarketScreenState();
}

class _KidsMarketScreenState extends State<KidsMarketScreen> {
  KidsFilters _filters = const KidsFilters();
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
      final items = await KidsService.fetch(_filters.copyWith(query: _search.text));
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
    final created = await Navigator.of(context).push<bool>(MaterialPageRoute(builder: (_) => const AddKidsItemScreen()));
    if (created == true) _load();
  }

  Future<void> _mine() async {
    if (!await _ensureSignedIn() || !mounted) return;
    await Navigator.of(context).push(MaterialPageRoute(builder: (_) => const MyKidsListingsScreen()));
    _load();
  }

  Future<void> _openFilters() async {
    final result = await showModalBottomSheet<KidsFilters>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(22))),
      builder: (_) => _FiltersSheet(initial: _filters),
    );
    if (result != null) {
      _filters = _filters.withSheet(result);
      _load();
    }
  }

  Widget _chip(String label, String? category, {IconData? icon}) {
    final selected = _filters.category == category;
    return Padding(
      padding: const EdgeInsetsDirectional.only(end: 8),
      child: ChoiceChip(
        avatar: icon == null ? null : Icon(icon, size: 16, color: selected ? Colors.white : AppColors.teal),
        label: Text(label),
        selected: selected,
        showCheckmark: false,
        selectedColor: AppColors.teal,
        labelStyle: TextStyle(color: selected ? Colors.white : AppColors.ink, fontWeight: FontWeight.w700),
        onSelected: (_) {
          if (selected) return;
          setState(() => _filters = _filters.copyWith(category: category, clearCategory: category == null));
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
        title: const Text('مستلزمات الأطفال'),
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
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.fromLTRB(side, 8, side, 4),
              children: [
                _chip('الكل', null),
                for (final e in kidsCategories.entries) _chip(e.value, e.key, icon: kidsCategoryIcons[e.key]),
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
                    hintText: 'دوّر: عربية أطفال، كرسي أكل، فستان…',
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
            const Icon(Icons.child_friendly_outlined, size: 46, color: AppColors.inkMuted),
            const SizedBox(height: 10),
            Text(
              _filters.activeCount > 0 || _filters.category != null || _search.text.trim().isNotEmpty
                  ? 'مفيش إعلانات بالفلاتر دي'
                  : 'لسه مفيش إعلانات هنا — عندك حاجة ولادك كبروا عليها؟ اعرضها',
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
        itemBuilder: (_, i) => KidsItemCard(
          item: _items[i],
          onTap: () async {
            await context.push(AppRoutes.kidsItem(_items[i]['id'] as String), extra: _items[i]);
          },
        ),
      ),
    );
  }
}

/// A listing tile: first photo, title, price (or "ببلاش"), condition,
/// age and place.
class KidsItemCard extends StatelessWidget {
  const KidsItemCard({super.key, required this.item, this.onTap});
  final Map<String, dynamic> item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final images = (item['images'] as List?)?.cast<String>() ?? const [];
    final specs = [
      kidsConditions[item['condition']],
      kidsAgeRanges[item['age_range']],
    ].whereType<String>().join(' · ');
    final place = [item['area'], item['governorate']].whereType<String>().where((s) => s.trim().isNotEmpty).join('، ');
    final free = item['is_free'] == true;
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Stack(fit: StackFit.expand, children: [
                  images.isEmpty
                      ? KidsPhotoPlaceholder(category: item['category'] as String?)
                      : Image.network(images.first,
                          cacheWidth: 600, fit: BoxFit.cover, errorBuilder: (_, _, _) => KidsPhotoPlaceholder(category: item['category'] as String?)),
                  if (free || item['swap_allowed'] == true)
                    PositionedDirectional(
                      top: 8,
                      start: 8,
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        if (free) const _Badge('ببلاش', AppColors.gold, AppColors.ink),
                        if (item['swap_allowed'] == true) ...[
                          if (free) const SizedBox(height: 4),
                          _Badge('ممكن أبدّل', AppColors.navy.withValues(alpha: 0.75), Colors.white),
                        ],
                      ]),
                    ),
                ]),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(item['title'] as String? ?? '',
                      maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13.5, color: AppColors.ink)),
                  const SizedBox(height: 3),
                  Text(
                    free ? 'ببلاش لأي حد محتاج' : kidsPrice(item),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: free ? const Color(0xFF2E7D32) : AppColors.teal, fontWeight: FontWeight.w800, fontSize: 13.5),
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

class _Badge extends StatelessWidget {
  const _Badge(this.text, this.color, this.textColor);
  final String text;
  final Color color;
  final Color textColor;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(8)),
        child: Text(text, style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800, color: textColor)),
      );
}

/// Shown when a listing has no photo (or it fails to load): the category icon.
class KidsPhotoPlaceholder extends StatelessWidget {
  const KidsPhotoPlaceholder({super.key, this.category, this.size = 40});
  final String? category;
  final double size;

  @override
  Widget build(BuildContext context) => ColoredBox(
        color: AppColors.surfaceAlt,
        child: Center(child: Icon(kidsCategoryIcons[category] ?? Icons.child_friendly_rounded, size: size, color: AppColors.inkMuted)),
      );
}

/// Filters bottom sheet; pops the new [KidsFilters] (or nothing on dismiss).
class _FiltersSheet extends StatefulWidget {
  const _FiltersSheet({required this.initial});
  final KidsFilters initial;

  @override
  State<_FiltersSheet> createState() => _FiltersSheetState();
}

class _FiltersSheetState extends State<_FiltersSheet> {
  late String? _condition = widget.initial.condition;
  late String? _age = widget.initial.ageRange;
  late String? _governorate = widget.initial.governorate;
  late final _area = TextEditingController(text: widget.initial.area ?? '');
  late final _price = TextEditingController(text: widget.initial.priceMax?.toStringAsFixed(0) ?? '');
  late bool _freeOnly = widget.initial.freeOnly;

  @override
  void dispose() {
    _area.dispose();
    _price.dispose();
    super.dispose();
  }

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
                Row(children: [
                  Expanded(child: _dropdown<String>('الحالة', _condition, kidsConditions, (v) => setState(() => _condition = v))),
                  const SizedBox(width: 10),
                  Expanded(child: _dropdown<String>('السن', _age, kidsAgeRanges, (v) => setState(() => _age = v))),
                ]),
                const SizedBox(height: 10),
                _dropdown<String>('المحافظة', _governorate, {for (final g in reportGovernorates) g: g}, (v) => setState(() => _governorate = v)),
                const SizedBox(height: 10),
                TextField(
                  controller: _area,
                  decoration: InputDecoration(
                    labelText: 'المنطقة',
                    hintText: 'مثلاً: مدينة نصر',
                    isDense: true,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  value: _freeOnly,
                  onChanged: (v) => setState(() => _freeOnly = v),
                  title: const Text('اللي ببلاش بس'),
                ),
                if (!_freeOnly)
                  TextField(
                    controller: _price,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'أقصى سعر (ج.م)',
                      isDense: true,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                const SizedBox(height: 16),
                Row(children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context, const KidsFilters()),
                      child: const Text('مسح الفلاتر'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: FilledButton(
                      style: FilledButton.styleFrom(backgroundColor: AppColors.teal),
                      onPressed: () => Navigator.pop(
                        context,
                        KidsFilters(
                          condition: _condition,
                          ageRange: _age,
                          governorate: _governorate,
                          area: _area.text.trim().isEmpty ? null : _area.text.trim(),
                          priceMax: _freeOnly ? null : looseNum(_price.text.trim().replaceAll(',', '')),
                          freeOnly: _freeOnly,
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
