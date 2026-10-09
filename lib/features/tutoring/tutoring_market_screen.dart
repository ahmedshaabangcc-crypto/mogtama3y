import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/auth/auth_service.dart';
import '../../core/reports/report_service.dart' show reportGovernorates;
import '../../core/routing/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/tutoring/tutoring_service.dart';
import '../auth/auth_landing_screen.dart';
import '../shared/load_error_view.dart';
import 'add_tutor_listing_screen.dart';
import 'my_tutor_listings_screen.dart';
import 'package:mogtama3y/core/utils/numbers.dart';

/// "دروس خصوصية" (`/tutoring`) — teachers and tutors near you, by subject,
/// stage and how they teach. Guests can browse; posting needs an account.
class TutoringMarketScreen extends StatefulWidget {
  const TutoringMarketScreen({super.key});

  @override
  State<TutoringMarketScreen> createState() => _TutoringMarketScreenState();
}

class _TutoringMarketScreenState extends State<TutoringMarketScreen> {
  TutorFilters _filters = const TutorFilters();
  final _area = TextEditingController();
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
    _area.dispose();
    super.dispose();
  }

  TutorFilters get _effective => TutorFilters(
        subject: _filters.subject,
        stage: _filters.stage,
        mode: _filters.mode,
        governorate: _filters.governorate,
        area: _area.text.trim().isEmpty ? null : _area.text,
        priceMax: _filters.priceMax,
        priceUnit: _filters.priceUnit,
      );

  Future<void> _load() async {
    final seq = ++_loadSeq;
    setState(() {
      _loading = true;
      _error = false;
    });
    try {
      final items = await TutoringService.fetch(_effective);
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

  void _onArea(String _) {
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
    final created = await Navigator.of(context).push<bool>(MaterialPageRoute(builder: (_) => const AddTutorListingScreen()));
    if (created == true) _load();
  }

  Future<void> _mine() async {
    if (!await _ensureSignedIn() || !mounted) return;
    await Navigator.of(context).push(MaterialPageRoute(builder: (_) => const MyTutorListingsScreen()));
    _load();
  }

  Future<void> _openFilters() async {
    final result = await showModalBottomSheet<TutorFilters>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(22))),
      builder: (_) => _FiltersSheet(initial: _filters),
    );
    if (result != null) {
      _filters = result.withSubject(_filters.subject);
      _load();
    }
  }

  void _pickSubject(String? subject) {
    if (_filters.subject == subject) return;
    setState(() => _filters = _filters.withSubject(subject));
    _load();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final side = width > 760 ? (width - 720) / 2 : 12.0;
    final chips = <(String?, String)>[(null, 'الكل'), for (final e in tutorSubjects.entries) (e.key, e.value)];
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: const Text('دروس خصوصية'),
        actions: [
          IconButton(onPressed: _mine, icon: const Icon(Icons.list_alt_rounded), tooltip: 'إعلاناتي'),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _add,
        backgroundColor: AppColors.teal,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: const Text('أعلن عن دروسك'),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 50,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.fromLTRB(side, 10, side, 4),
              itemCount: chips.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final (code, label) = chips[i];
                final selected = _filters.subject == code;
                return ChoiceChip(
                  label: Text(label),
                  selected: selected,
                  showCheckmark: false,
                  selectedColor: AppColors.teal,
                  labelStyle: TextStyle(color: selected ? Colors.white : AppColors.ink, fontWeight: FontWeight.w700),
                  onSelected: (_) => _pickSubject(code),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(side, 6, side, 8),
            child: Row(children: [
              Expanded(
                child: TextField(
                  controller: _area,
                  onChanged: _onArea,
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintText: 'دوّر بالمنطقة: مدينة نصر، سموحة…',
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
          Expanded(child: _body(side)),
        ],
      ),
    );
  }

  Widget _body(double side) {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_error) return LoadErrorView(onRetry: _load);
    if (_items.isEmpty) {
      final filtered = _filters.activeCount > 0 || _filters.subject != null || _area.text.trim().isNotEmpty;
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.school_outlined, size: 46, color: AppColors.inkMuted),
            const SizedBox(height: 10),
            Text(
              filtered ? 'مفيش مدرسين بالفلاتر دي — جرّب توسّع البحث' : 'لسه مفيش مدرسين هنا — لو بتدّي دروس أعلن دلوقتي',
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.inkMuted),
            ),
          ]),
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: _load,
      child: ListView.separated(
        padding: EdgeInsets.fromLTRB(side, 4, side, 96),
        itemCount: _items.length,
        separatorBuilder: (_, _) => const SizedBox(height: 10),
        itemBuilder: (_, i) => TutorCard(
          item: _items[i],
          onTap: () => context.push(AppRoutes.tutor(_items[i]['id'] as String), extra: _items[i]),
        ),
      ),
    );
  }
}

/// A listing row: photo, name, subjects, stages, how they teach, price
/// and place.
class TutorCard extends StatelessWidget {
  const TutorCard({super.key, required this.item, this.onTap});
  final Map<String, dynamic> item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final images = (item['images'] as List?)?.cast<String>() ?? const [];
    final photo = images.isNotEmpty ? images.first : item['tutor_avatar'] as String?;
    final place = [item['area'], item['governorate']].whereType<String>().where((s) => s.trim().isNotEmpty).join('، ');
    final years = item['experience_years'] as int?;
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: 88,
                height: 104,
                child: photo == null || photo.isEmpty
                    ? const TutorPhotoPlaceholder()
                    : Image.network(photo, cacheWidth: 300, fit: BoxFit.cover, errorBuilder: (_, _, _) => const TutorPhotoPlaceholder()),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(item['tutor_name'] as String? ?? '',
                    maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14.5, color: AppColors.ink)),
                const SizedBox(height: 2),
                Text(tutorLabels(item['subjects'], tutorSubjects),
                    maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5, color: AppColors.teal)),
                const SizedBox(height: 2),
                Text(
                  [tutorLabels(item['stages'], tutorStages), if (years != null && years > 0) 'خبرة $years سنة'].where((s) => s.isNotEmpty).join(' · '),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 11.5, color: AppColors.inkSecondary),
                ),
                const SizedBox(height: 2),
                Text(tutorLabels(item['modes'], tutorModes),
                    maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11.5, color: AppColors.inkSecondary)),
                const SizedBox(height: 4),
                Row(children: [
                  Text(tutorPrice(item['price'] as num?, item['price_unit'] as String?),
                      style: const TextStyle(color: AppColors.teal, fontWeight: FontWeight.w800, fontSize: 13)),
                  const SizedBox(width: 8),
                  if (place.isNotEmpty) ...[
                    const Icon(Icons.place_outlined, size: 13, color: AppColors.inkMuted),
                    const SizedBox(width: 2),
                    Expanded(child: Text(place, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11, color: AppColors.inkMuted))),
                  ],
                ]),
              ]),
            ),
          ]),
        ),
      ),
    );
  }
}

class TutorPhotoPlaceholder extends StatelessWidget {
  const TutorPhotoPlaceholder({super.key, this.size = 34});
  final double size;

  @override
  Widget build(BuildContext context) => ColoredBox(
        color: AppColors.surfaceAlt,
        child: Center(child: Icon(Icons.school_rounded, size: size, color: AppColors.inkMuted)),
      );
}

/// Filters bottom sheet; pops the new [TutorFilters] (or nothing on dismiss).
class _FiltersSheet extends StatefulWidget {
  const _FiltersSheet({required this.initial});
  final TutorFilters initial;

  @override
  State<_FiltersSheet> createState() => _FiltersSheetState();
}

class _FiltersSheetState extends State<_FiltersSheet> {
  late String? _stage = widget.initial.stage;
  late String? _mode = widget.initial.mode;
  late String? _governorate = widget.initial.governorate;
  late String? _unit = widget.initial.priceUnit;
  late final _price = TextEditingController(text: widget.initial.priceMax?.toStringAsFixed(0) ?? '');

  @override
  void dispose() {
    _price.dispose();
    super.dispose();
  }

  Widget _dropdown(String label, String? value, Map<String, String> options, ValueChanged<String?> onChanged) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      isExpanded: true,
      decoration: InputDecoration(labelText: label, isDense: true, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
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
                _dropdown('المرحلة', _stage, tutorStages, (v) => setState(() => _stage = v)),
                const SizedBox(height: 10),
                _dropdown('مكان الدرس', _mode, tutorModes, (v) => setState(() => _mode = v)),
                const SizedBox(height: 10),
                Row(children: [
                  Expanded(
                    child: TextField(
                      controller: _price,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'أقصى سعر (ج.م)',
                        isDense: true,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(child: _dropdown('السعر لـ', _unit, tutorPriceUnits, (v) => setState(() => _unit = v))),
                ]),
                const SizedBox(height: 10),
                _dropdown('المحافظة', _governorate, {for (final g in reportGovernorates) g: g}, (v) => setState(() => _governorate = v)),
                const SizedBox(height: 16),
                Row(children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context, const TutorFilters()),
                      child: const Text('مسح الفلاتر'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: FilledButton(
                      style: FilledButton.styleFrom(backgroundColor: AppColors.teal),
                      onPressed: () => Navigator.pop(
                        context,
                        TutorFilters(
                          stage: _stage,
                          mode: _mode,
                          governorate: _governorate,
                          priceMax: looseNum(_price.text.trim().replaceAll(',', '')),
                          priceUnit: _unit,
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
