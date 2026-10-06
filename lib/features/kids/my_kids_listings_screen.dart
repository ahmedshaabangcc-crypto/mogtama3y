import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/kids/kids_service.dart';
import '../../core/routing/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../shared/load_error_view.dart';
import 'add_kids_item_screen.dart';
import 'kids_market_screen.dart' show KidsPhotoPlaceholder;

/// "إعلاناتي" for kids gear: the signed-in user's listings, with edit,
/// mark as sold / given away, pause / show again, and delete.
class MyKidsListingsScreen extends StatefulWidget {
  const MyKidsListingsScreen({super.key});

  @override
  State<MyKidsListingsScreen> createState() => _MyKidsListingsScreenState();
}

class _MyKidsListingsScreenState extends State<MyKidsListingsScreen> {
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
      final items = await KidsService.fetchMine();
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

  Future<void> _edit(Map<String, dynamic> item) async {
    final saved = await Navigator.of(context).push<bool>(MaterialPageRoute(builder: (_) => AddKidsItemScreen(initial: item)));
    if (saved == true) _load();
  }

  Future<bool> _confirm(String title, String body) async =>
      await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(title),
          content: Text(body),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('لأ')),
            FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('أيوه')),
          ],
        ),
      ) ==
      true;

  Future<void> _act(Map<String, dynamic> item, String action) async {
    final id = item['id'] as String;
    final free = item['is_free'] == true;
    try {
      switch (action) {
        case 'edit':
          await _edit(item);
          return;
        case 'sold':
          if (!await _confirm(free ? 'اتسلّمت؟' : 'اتباعت؟', 'الإعلان هيختفي من القسم ويتعلّم إنه خلص.')) return;
          await KidsService.setSold(id, true);
        case 'unsold':
          await KidsService.setSold(id, false);
        case 'pause':
          if (!await _confirm('توقف الإعلان؟', 'الإعلان هيختفي من القسم لحد ما ترجّعه.')) return;
          await KidsService.setActive(id, false);
        case 'resume':
          await KidsService.setActive(id, true);
        case 'delete':
          if (!await _confirm('تمسح الإعلان؟', 'الإعلان هيتمسح خالص ومش هينفع ترجّعه.')) return;
          await KidsService.delete(id);
      }
      await _load();
    } catch (_) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تعذر التعديل، جرّب تاني')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final side = width > 760 ? (width - 720) / 2 : 12.0;
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const Text('إعلاناتي — مستلزمات الأطفال')),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.teal,
        foregroundColor: Colors.white,
        onPressed: () async {
          final created = await Navigator.of(context).push<bool>(MaterialPageRoute(builder: (_) => const AddKidsItemScreen()));
          if (created == true) _load();
        },
        icon: const Icon(Icons.add_rounded),
        label: const Text('أضف إعلان'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error
              ? LoadErrorView(onRetry: _load)
              : _items.isEmpty
                  ? const Center(child: Text('لسه معندكش إعلانات مستلزمات أطفال', style: TextStyle(color: AppColors.inkMuted)))
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

  Widget _tile(Map<String, dynamic> c) {
    final images = (c['images'] as List?)?.cast<String>() ?? const [];
    final free = c['is_free'] == true;
    final sold = c['is_sold'] == true;
    final active = c['is_active'] == true;
    final (statusLabel, statusColor) = sold
        ? (free ? 'اتسلّمت' : 'اتباعت', const Color(0xFF2E7D32))
        : active
            ? ('منشور', AppColors.teal)
            : ('متوقف', AppColors.inkMuted);
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => context.push(AppRoutes.kidsItem(c['id'] as String), extra: c),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
          child: Row(children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                width: 84,
                height: 68,
                child: images.isEmpty
                    ? KidsPhotoPlaceholder(category: c['category'] as String?, size: 26)
                    : Image.network(images.first, cacheWidth: 300, fit: BoxFit.cover, errorBuilder: (_, _, _) => const ColoredBox(color: AppColors.surfaceAlt)),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(c['title'] as String? ?? '', maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.ink)),
                const SizedBox(height: 2),
                Text(kidsPrice(c), style: const TextStyle(color: AppColors.teal, fontWeight: FontWeight.w700, fontSize: 13)),
                const SizedBox(height: 2),
                Text('${kidsCategories[c['category']] ?? ''} · $statusLabel', style: TextStyle(fontSize: 12, color: statusColor)),
              ]),
            ),
            PopupMenuButton<String>(
              tooltip: 'خيارات',
              onSelected: (v) => _act(c, v),
              itemBuilder: (_) => [
                const PopupMenuItem(value: 'edit', child: Text('عدّل')),
                if (!sold) PopupMenuItem(value: 'sold', child: Text(free ? 'اتسلّمت' : 'اتباعت'))
                else const PopupMenuItem(value: 'unsold', child: Text('لسه متاحة')),
                if (active) const PopupMenuItem(value: 'pause', child: Text('وقّف الإعلان'))
                else const PopupMenuItem(value: 'resume', child: Text('رجّع الإعلان')),
                const PopupMenuItem(value: 'delete', child: Text('امسح الإعلان', style: TextStyle(color: Color(0xFFC62828)))),
              ],
            ),
          ]),
        ),
      ),
    );
  }
}
