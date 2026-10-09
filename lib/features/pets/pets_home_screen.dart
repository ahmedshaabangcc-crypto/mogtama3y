import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/auth/auth_service.dart';
import '../../core/pets/pet_service.dart';
import '../../core/reports/report_service.dart' show reportGovernorates;
import '../../core/routing/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../auth/auth_landing_screen.dart';
import '../shared/load_error_view.dart';
import 'add_pet_listing_screen.dart';
import 'my_pet_listings_screen.dart';
import 'package:mogtama3y/core/utils/numbers.dart';

/// "الحيوانات الأليفة" (`/pets`) — pets for sale, adoption and mating,
/// lost & found pets, and supplies. Guests can browse; posting needs an
/// account.
class PetsHomeScreen extends StatefulWidget {
  const PetsHomeScreen({super.key});

  @override
  State<PetsHomeScreen> createState() => _PetsHomeScreenState();
}

class _PetsHomeScreenState extends State<PetsHomeScreen> {
  PetFilters _filters = const PetFilters();
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
      final items = await PetService.fetch(_filters.copyWith(query: _search.text));
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
    final created = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => AddPetListingScreen(initialKind: _filters.kind)),
    );
    if (created == true) _load();
  }

  Future<void> _mine() async {
    if (!await _ensureSignedIn() || !mounted) return;
    await Navigator.of(context).push(MaterialPageRoute(builder: (_) => const MyPetListingsScreen()));
    _load();
  }

  Future<void> _openFilters() async {
    final result = await showModalBottomSheet<PetFilters>(
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

  Widget _chip(String label, bool selected, VoidCallback onTap, {IconData? icon}) => Padding(
        padding: const EdgeInsetsDirectional.only(end: 8),
        child: ChoiceChip(
          avatar: icon == null ? null : Icon(icon, size: 16, color: selected ? Colors.white : AppColors.teal),
          label: Text(label),
          selected: selected,
          showCheckmark: false,
          selectedColor: AppColors.teal,
          labelStyle: TextStyle(color: selected ? Colors.white : AppColors.ink, fontWeight: FontWeight.w700),
          onSelected: (_) => onTap(),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final side = width > 760 ? (width - 720) / 2 : 12.0;
    final kind = _filters.kind;
    final animal = _filters.animal;
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: const Text('الحيوانات الأليفة'),
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
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.fromLTRB(side, 10, side, 2),
            child: Row(children: [
              _chip('الكل', kind == null, () {
                if (kind == null) return;
                setState(() => _filters = _filters.copyWith(clearKind: true));
                _load();
              }),
              for (final e in petKinds.entries)
                _chip(e.value, kind == e.key, () {
                  if (kind == e.key) return;
                  setState(() => _filters = _filters.copyWith(kind: e.key));
                  _load();
                }),
            ]),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.fromLTRB(side, 4, side, 2),
            child: Row(children: [
              _chip('كل الحيوانات', animal == null, () {
                if (animal == null) return;
                setState(() => _filters = _filters.copyWith(clearAnimal: true));
                _load();
              }),
              for (final e in petAnimals.entries)
                _chip(e.value, animal == e.key, icon: petAnimalIcon(e.key), () {
                  if (animal == e.key) return;
                  setState(() => _filters = _filters.copyWith(animal: e.key));
                  _load();
                }),
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
                    hintText: 'دوّر بالاسم أو السلالة: شيرازي، جولدن…',
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
      final filtered = _filters.activeCount > 0 || _filters.kind != null || _filters.animal != null || _search.text.trim().isNotEmpty;
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.pets_rounded, size: 46, color: AppColors.inkMuted),
            const SizedBox(height: 10),
            Text(
              filtered ? 'مفيش إعلانات بالفلاتر دي' : 'لسه مفيش إعلانات هنا — كن أول واحد يعلن',
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
        itemBuilder: (_, i) => PetCard(
          item: _items[i],
          onTap: () async {
            await context.push(AppRoutes.pet(_items[i]['id'] as String), extra: _items[i]);
          },
        ),
      ),
    );
  }
}

/// A listing tile: first photo, title, price (or free label), animal and
/// place. Lost / found get a colored badge.
class PetCard extends StatelessWidget {
  const PetCard({super.key, required this.item, this.onTap});
  final Map<String, dynamic> item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final images = (item['images'] as List?)?.cast<String>() ?? const [];
    final kind = item['kind'] as String?;
    final specs = [
      petAnimals[item['animal']] ?? '',
      (item['breed'] as String?)?.trim() ?? '',
      (item['age_text'] as String?)?.trim() ?? '',
    ].where((s) => s.isNotEmpty).join(' · ');
    final place = [item['area'], item['governorate']].whereType<String>().where((s) => s.trim().isNotEmpty).join('، ');
    final badgeColor = switch (kind) {
      'lost' => const Color(0xFFC62828),
      'found' => const Color(0xFF2E7D32),
      'adoption' => AppColors.gold,
      _ => AppColors.navy.withValues(alpha: 0.75),
    };
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
                      ? _PhotoPlaceholder(animal: item['animal'] as String?)
                      : Image.network(images.first,
                          cacheWidth: 600, fit: BoxFit.cover, errorBuilder: (_, _, _) => _PhotoPlaceholder(animal: item['animal'] as String?)),
                  PositionedDirectional(
                    top: 8,
                    end: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(color: badgeColor, borderRadius: BorderRadius.circular(8)),
                      child: Text(petKinds[kind] ?? '',
                          style: TextStyle(fontSize: 10.5, color: kind == 'adoption' ? AppColors.ink : Colors.white, fontWeight: FontWeight.w800)),
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
                  Text(
                    petPrice(item),
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
  const _PhotoPlaceholder({this.animal});
  final String? animal;

  @override
  Widget build(BuildContext context) => ColoredBox(
        color: AppColors.surfaceAlt,
        child: Center(child: Icon(petAnimalIcon(animal), size: 40, color: AppColors.inkMuted)),
      );
}

/// Filters bottom sheet; pops the new [PetFilters] (or nothing on dismiss).
class _FiltersSheet extends StatefulWidget {
  const _FiltersSheet({required this.initial});
  final PetFilters initial;

  @override
  State<_FiltersSheet> createState() => _FiltersSheetState();
}

class _FiltersSheetState extends State<_FiltersSheet> {
  late String? _governorate = widget.initial.governorate;
  late final _area = TextEditingController(text: widget.initial.area ?? '');
  late final _price = TextEditingController(text: widget.initial.priceMax?.toStringAsFixed(0) ?? '');

  @override
  void dispose() {
    _area.dispose();
    _price.dispose();
    super.dispose();
  }

  InputDecoration _dec(String label, {String? hint}) => InputDecoration(
        labelText: label,
        hintText: hint,
        isDense: true,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      );

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
                DropdownButtonFormField<String>(
                  initialValue: _governorate,
                  isExpanded: true,
                  decoration: _dec('المحافظة'),
                  items: [
                    const DropdownMenuItem<String>(value: null, child: Text('الكل')),
                    for (final g in reportGovernorates) DropdownMenuItem<String>(value: g, child: Text(g)),
                  ],
                  onChanged: (v) => setState(() => _governorate = v),
                ),
                const SizedBox(height: 10),
                TextField(controller: _area, decoration: _dec('المنطقة', hint: 'مثلاً: مدينة نصر')),
                const SizedBox(height: 10),
                TextField(
                  controller: _price,
                  keyboardType: TextInputType.number,
                  decoration: _dec('أقصى سعر (ج.م)'),
                ),
                const SizedBox(height: 16),
                Row(children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context, widget.initial.withSheet()),
                      child: const Text('مسح الفلاتر'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: FilledButton(
                      style: FilledButton.styleFrom(backgroundColor: AppColors.teal),
                      onPressed: () => Navigator.pop(
                        context,
                        widget.initial.withSheet(
                          governorate: _governorate,
                          area: _area.text.trim().isEmpty ? null : _area.text.trim(),
                          priceMax: looseNum(_price.text.trim().replaceAll(',', '')),
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
