import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/routing/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/tutoring/tutoring_service.dart';
import '../shared/load_error_view.dart';
import 'add_tutor_listing_screen.dart';
import 'tutoring_market_screen.dart' show TutorPhotoPlaceholder;

/// "إعلاناتي" for tutoring: the signed-in user's listings, with edit,
/// stop / show again and delete.
class MyTutorListingsScreen extends StatefulWidget {
  const MyTutorListingsScreen({super.key});

  @override
  State<MyTutorListingsScreen> createState() => _MyTutorListingsScreenState();
}

class _MyTutorListingsScreenState extends State<MyTutorListingsScreen> {
  List<Map<String, dynamic>> _items = [];
  bool _loading = true;
  bool _error = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = false;
    });
    try {
      final items = await TutoringService.fetchMine();
      if (!mounted) return;
      setState(() {
        _items = items;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = true;
      });
    }
  }

  Future<void> _edit(Map<String, dynamic>? item) async {
    final saved = await Navigator.of(context).push<bool>(MaterialPageRoute(builder: (_) => AddTutorListingScreen(existing: item)));
    if (saved == true) _load();
  }

  Future<void> _toggle(Map<String, dynamic> item) async {
    final active = item['is_active'] == true;
    try {
      await TutoringService.setActive(item['id'] as String, !active);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(active ? 'الإعلان اتوقف ومش هيظهر للطلبة' : 'الإعلان رجع يظهر تاني')));
      await _load();
    } catch (_) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تعذر التعديل، جرّب تاني')));
    }
  }

  Future<void> _delete(Map<String, dynamic> item) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('تمسح الإعلان؟'),
        content: const Text('الإعلان هيتمسح خالص ومش هينفع ترجّعه. لو عايز توقفه مؤقتاً استخدم "وقّف الإعلان".'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('لأ')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: const Color(0xFFC62828)),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('امسح'),
          ),
        ],
      ),
    );
    if (ok != true) return;
    try {
      await TutoringService.delete(item['id'] as String);
      await _load();
    } catch (_) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تعذر المسح، جرّب تاني')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final side = width > 760 ? (width - 720) / 2 : 12.0;
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const Text('إعلاناتي — دروس خصوصية')),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.teal,
        foregroundColor: Colors.white,
        onPressed: () => _edit(null),
        icon: const Icon(Icons.add_rounded),
        label: const Text('أضف إعلان'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error
              ? LoadErrorView(onRetry: _load)
              : _items.isEmpty
                  ? const Center(child: Text('لسه معندكش إعلانات دروس', style: TextStyle(color: AppColors.inkMuted)))
                  : RefreshIndicator(
                      onRefresh: _load,
                      child: ListView.separated(
                        padding: EdgeInsets.fromLTRB(side, 12, side, 96),
                        itemCount: _items.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 10),
                        itemBuilder: (_, i) => _tile(_items[i]),
                      ),
                    ),
    );
  }

  Widget _tile(Map<String, dynamic> t) {
    final images = (t['images'] as List?)?.cast<String>() ?? const [];
    final active = t['is_active'] == true;
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => context.push(AppRoutes.tutor(t['id'] as String), extra: t),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
          child: Row(children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                width: 72,
                height: 72,
                child: images.isEmpty
                    ? const TutorPhotoPlaceholder(size: 28)
                    : Image.network(images.first, cacheWidth: 300, fit: BoxFit.cover, errorBuilder: (_, _, _) => const TutorPhotoPlaceholder(size: 28)),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(tutorLabels(t['subjects'], tutorSubjects),
                    maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.ink)),
                const SizedBox(height: 2),
                Text(tutorPrice(t['price'] as num?, t['price_unit'] as String?),
                    style: const TextStyle(color: AppColors.teal, fontWeight: FontWeight.w700, fontSize: 13)),
                const SizedBox(height: 2),
                Text('${tutorLabels(t['stages'], tutorStages)} · ${active ? 'منشور' : 'متوقف'}',
                    maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12, color: active ? AppColors.teal : AppColors.inkMuted)),
              ]),
            ),
            PopupMenuButton<String>(
              tooltip: 'خيارات',
              onSelected: (v) => switch (v) {
                'edit' => _edit(t),
                'toggle' => _toggle(t),
                _ => _delete(t),
              },
              itemBuilder: (_) => [
                const PopupMenuItem(value: 'edit', child: Text('عدّل الإعلان')),
                PopupMenuItem(value: 'toggle', child: Text(active ? 'وقّف الإعلان' : 'رجّع الإعلان')),
                const PopupMenuItem(value: 'delete', child: Text('امسح الإعلان')),
              ],
            ),
          ]),
        ),
      ),
    );
  }
}
