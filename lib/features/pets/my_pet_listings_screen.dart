import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/pets/pet_service.dart';
import '../../core/routing/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../shared/load_error_view.dart';
import 'add_pet_listing_screen.dart';

/// "إعلاناتي" for pets: the signed-in user's listings, with edit, quick
/// close (اتلقى / اتبنى / اتباع), stop / show again, and delete.
class MyPetListingsScreen extends StatefulWidget {
  const MyPetListingsScreen({super.key});

  @override
  State<MyPetListingsScreen> createState() => _MyPetListingsScreenState();
}

class _MyPetListingsScreenState extends State<MyPetListingsScreen> {
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
      final items = await PetService.fetchMine();
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

  /// The quick-close outcome that fits the listing's kind.
  static String _outcomeFor(String? kind) => switch (kind) {
        'lost' || 'found' => 'reunited',
        'adoption' => 'adopted',
        _ => 'sold',
      };

  static String _closeLabel(String? kind) => switch (kind) {
        'lost' => 'اتلقى',
        'found' => 'رجع لصاحبه',
        'adoption' => 'اتبنى',
        'mating' => 'خلص',
        _ => 'اتباع',
      };

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
    final kind = item['kind'] as String?;
    if (action == 'edit') {
      final saved = await Navigator.of(context).push<bool>(MaterialPageRoute(builder: (_) => AddPetListingScreen(initial: item)));
      if (saved == true) _load();
      return;
    }
    final (title, body) = switch (action) {
      'close' => ('${_closeLabel(kind)}؟', 'الإعلان هيختفي من القسم ويتعلّم إنه ${_closeLabel(kind)}.'),
      'stop' => ('توقف الإعلان؟', 'الإعلان هيختفي من القسم، وتقدر ترجّعه بعدين.'),
      'show' => ('ترجّع الإعلان؟', 'الإعلان هيظهر تاني في القسم.'),
      _ => ('تمسح الإعلان؟', 'الإعلان هيتمسح خالص ومش هينفع يرجع.'),
    };
    if (!await _confirm(title, body)) return;
    try {
      switch (action) {
        case 'close':
          await PetService.close(id, _outcomeFor(kind));
        case 'stop':
          await PetService.setActive(id, false);
        case 'show':
          await PetService.setActive(id, true);
        default:
          await PetService.delete(id);
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
      appBar: AppBar(title: const Text('إعلاناتي — حيوانات أليفة')),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.teal,
        foregroundColor: Colors.white,
        onPressed: () async {
          final created = await Navigator.of(context).push<bool>(MaterialPageRoute(builder: (_) => const AddPetListingScreen()));
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
                  ? const Center(child: Text('لسه معندكش إعلانات حيوانات أليفة', style: TextStyle(color: AppColors.inkMuted)))
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
    final kind = c['kind'] as String?;
    final active = c['is_active'] == true;
    final outcome = c['outcome'] as String?;
    final (statusLabel, statusColor) = active
        ? ('منشور', AppColors.teal)
        : outcome != null
            ? (petOutcomes[outcome] ?? '', const Color(0xFF2E7D32))
            : ('متوقف', AppColors.inkMuted);
    final price = petPrice(c);
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () async {
          await context.push(AppRoutes.pet(c['id'] as String), extra: c);
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
                    ? ColoredBox(color: AppColors.surfaceAlt, child: Icon(petAnimalIcon(c['animal'] as String?), color: AppColors.inkMuted))
                    : Image.network(images.first, cacheWidth: 300, fit: BoxFit.cover, errorBuilder: (_, _, _) => const ColoredBox(color: AppColors.surfaceAlt)),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(c['title'] as String? ?? '', maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.ink)),
                if (price.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(price, style: const TextStyle(color: AppColors.teal, fontWeight: FontWeight.w700, fontSize: 13)),
                ],
                const SizedBox(height: 2),
                Text('${petKinds[kind] ?? ''} · $statusLabel', style: TextStyle(fontSize: 12, color: statusColor)),
              ]),
            ),
            if (active && (kind == 'lost' || kind == 'adoption'))
              TextButton(
                onPressed: () => _act(c, 'close'),
                child: Text(_closeLabel(kind), style: const TextStyle(fontWeight: FontWeight.w800)),
              ),
            PopupMenuButton<String>(
              tooltip: 'خيارات',
              onSelected: (v) => _act(c, v),
              itemBuilder: (_) => [
                const PopupMenuItem(value: 'edit', child: Text('عدّل')),
                if (active) PopupMenuItem(value: 'close', child: Text(_closeLabel(kind))),
                if (active) const PopupMenuItem(value: 'stop', child: Text('وقّف الإعلان')),
                if (!active) const PopupMenuItem(value: 'show', child: Text('رجّع الإعلان')),
                const PopupMenuItem(value: 'delete', child: Text('امسح الإعلان', style: TextStyle(color: Color(0xFFC62828)))),
              ],
            ),
          ]),
        ),
      ),
    );
  }
}
