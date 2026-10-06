import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/halls/hall_service.dart';
import '../../core/routing/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../shared/load_error_view.dart';
import 'add_hall_screen.dart';

/// "إعلاناتي" for event halls: the signed-in owner's halls, with edit,
/// hide / show and delete.
class MyHallsScreen extends StatefulWidget {
  const MyHallsScreen({super.key});

  @override
  State<MyHallsScreen> createState() => _MyHallsScreenState();
}

class _MyHallsScreenState extends State<MyHallsScreen> {
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
      final items = await HallService.fetchMine();
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

  Future<void> _edit(Map<String, dynamic>? hall) async {
    final saved = await Navigator.of(context).push<bool>(MaterialPageRoute(builder: (_) => AddHallScreen(existing: hall)));
    if (saved == true) _load();
  }

  Future<void> _run(Future<void> Function() action) async {
    try {
      await action();
      await _load();
    } catch (_) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تعذر التعديل، جرّب تاني')));
    }
  }

  Future<void> _delete(Map<String, dynamic> hall) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('تمسح القاعة؟'),
        content: const Text('الإعلان هيتمسح نهائي ومش هتقدر ترجّعه. لو عايز توقفه شوية، خليه "مخفي" بدل ما تمسحه.'),
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
    if (ok == true) await _run(() => HallService.delete(hall['id'] as String));
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final side = width > 760 ? (width - 720) / 2 : 12.0;
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const Text('إعلاناتي — قاعات')),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.teal,
        foregroundColor: Colors.white,
        onPressed: () => _edit(null),
        icon: const Icon(Icons.add_rounded),
        label: const Text('أضف قاعة'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error
              ? LoadErrorView(onRetry: _load)
              : _items.isEmpty
                  ? const Center(child: Text('لسه معندكش قاعات معلن عنها', style: TextStyle(color: AppColors.inkMuted)))
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

  Widget _tile(Map<String, dynamic> h) {
    final images = (h['images'] as List?)?.cast<String>() ?? const [];
    final active = h['is_active'] == true;
    final id = h['id'] as String;
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () async {
          await context.push(AppRoutes.hall(id), extra: h);
          _load();
        },
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
                    ? const ColoredBox(color: AppColors.surfaceAlt, child: Icon(Icons.celebration_rounded, color: AppColors.inkMuted))
                    : Image.network(images.first, cacheWidth: 300, fit: BoxFit.cover, errorBuilder: (_, _, _) => const ColoredBox(color: AppColors.surfaceAlt)),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(h['name'] as String? ?? '', maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.ink)),
                const SizedBox(height: 2),
                Text(hallPrice(h), maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.teal, fontWeight: FontWeight.w700, fontSize: 13)),
                const SizedBox(height: 2),
                Text('${hallTypes[h['hall_type']] ?? ''} · ${active ? 'ظاهرة للناس' : 'مخفية'}',
                    maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12, color: active ? AppColors.teal : AppColors.inkMuted)),
              ]),
            ),
            PopupMenuButton<String>(
              tooltip: 'خيارات',
              onSelected: (v) => switch (v) {
                'edit' => _edit(h),
                'toggle' => _run(() => HallService.setActive(id, !active)),
                _ => _delete(h),
              },
              itemBuilder: (_) => [
                const PopupMenuItem(value: 'edit', child: Text('عدّل')),
                PopupMenuItem(value: 'toggle', child: Text(active ? 'اخفيها مؤقتاً' : 'اظهرها تاني')),
                const PopupMenuItem(value: 'delete', child: Text('امسح', style: TextStyle(color: Color(0xFFC62828)))),
              ],
            ),
          ]),
        ),
      ),
    );
  }
}
