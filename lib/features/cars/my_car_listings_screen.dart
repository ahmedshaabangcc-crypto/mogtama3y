import 'package:flutter/material.dart';

import '../../core/cars/car_service.dart';
import '../../core/theme/app_colors.dart';
import '../shared/load_error_view.dart';
import 'add_car_listing_screen.dart';
import 'car_details_screen.dart';

/// "إعلاناتي" for cars: the signed-in user's listings, with mark-as-sold
/// and remove.
class MyCarListingsScreen extends StatefulWidget {
  const MyCarListingsScreen({super.key});

  @override
  State<MyCarListingsScreen> createState() => _MyCarListingsScreenState();
}

class _MyCarListingsScreenState extends State<MyCarListingsScreen> {
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
      final items = await CarService.fetchMine();
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

  Future<void> _act(Map<String, dynamic> item, {required bool sold}) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(sold ? 'اتباعت؟' : 'تشيل الإعلان؟'),
        content: Text(sold ? 'الإعلان هيختفي من السوق ويتعلّم إنه اتباع.' : 'الإعلان هيختفي من السوق.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('لأ')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('أيوه')),
        ],
      ),
    );
    if (ok != true) return;
    try {
      final id = item['id'] as String;
      sold ? await CarService.markSold(id) : await CarService.remove(id);
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
      appBar: AppBar(title: const Text('إعلاناتي — سيارات')),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.teal,
        foregroundColor: Colors.white,
        onPressed: () async {
          final created = await Navigator.of(context).push<bool>(MaterialPageRoute(builder: (_) => const AddCarListingScreen()));
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
                  ? const Center(child: Text('لسه معندكش إعلانات سيارات', style: TextStyle(color: AppColors.inkMuted)))
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
    final status = c['status'] as String?;
    final (statusLabel, statusColor) = switch (status) {
      'sold' => ('اتباع', const Color(0xFF2E7D32)),
      'removed' => ('متشال', AppColors.inkMuted),
      _ => ('منشور', AppColors.teal),
    };
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => CarDetailsScreen(listingId: c['id'] as String, initial: c))),
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
                    ? const ColoredBox(color: AppColors.surfaceAlt, child: Icon(Icons.directions_car_filled_rounded, color: AppColors.inkMuted))
                    : Image.network(images.first, fit: BoxFit.cover, errorBuilder: (_, _, _) => const ColoredBox(color: AppColors.surfaceAlt)),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(c['title'] as String? ?? '', maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.ink)),
                const SizedBox(height: 2),
                Text('${carPrice(c['price'] as num?)}${carPriceSuffix(c['offer_type'] as String?)}',
                    style: const TextStyle(color: AppColors.teal, fontWeight: FontWeight.w700, fontSize: 13)),
                const SizedBox(height: 2),
                Text('${carOfferTypes[c['offer_type']] ?? ''} · $statusLabel', style: TextStyle(fontSize: 12, color: statusColor)),
              ]),
            ),
            if (status == 'active')
              PopupMenuButton<String>(
                tooltip: 'خيارات',
                onSelected: (v) => _act(c, sold: v == 'sold'),
                itemBuilder: (_) => [
                  PopupMenuItem(value: 'sold', child: Text(c['offer_type'] == 'sale' || c['offer_type'] == 'parts' ? 'اتباعت' : 'اتأجرت / خلص')),
                  const PopupMenuItem(value: 'remove', child: Text('شيل الإعلان')),
                ],
              ),
          ]),
        ),
      ),
    );
  }
}
