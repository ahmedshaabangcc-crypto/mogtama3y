import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/shops/starter_catalog.dart';
import '../../core/shops/store_service.dart';
import '../../core/theme/app_colors.dart';

SupabaseClient get _db => Supabase.instance.client;

/// "ضيف منتجات نشاطك الجاهزة": the merchant ticks ready-made products for
/// their activity; they're added hidden with price 0, then priced quickly.
class StarterProductsScreen extends StatefulWidget {
  const StarterProductsScreen({super.key, required this.shopId, this.shopCategory});
  final String shopId;
  final String? shopCategory;

  @override
  State<StarterProductsScreen> createState() => _StarterProductsScreenState();
}

class _StarterProductsScreenState extends State<StarterProductsScreen> {
  late String _activity = starterCatalog.containsKey(widget.shopCategory) ? widget.shopCategory! : starterCatalog.keys.first;
  late Set<int> _picked = {for (var i = 0; i < starterCatalog[_activity]!.length; i++) i};
  bool _saving = false;

  List<StarterProduct> get _items => starterCatalog[_activity]!;

  Future<void> _add() async {
    if (_picked.isEmpty) return;
    setState(() => _saving = true);
    try {
      final rows = [for (final i in _picked.toList()..sort()) _items[i].toRow(widget.shopId)];
      await _db.from('shop_products').insert(rows);
      if (!mounted) return;
      await Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => QuickPricingScreen(shopId: widget.shopId)));
    } catch (_) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تعذر إضافة المنتجات، جرّب تاني')));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = _items;
    return Scaffold(
      appBar: AppBar(title: const Text('منتجات جاهزة لنشاطك')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
        children: [
          const Text('اختار المنتجات اللي بتبيعها، وهتتضاف بالاسم والوصف والأحجام. بعدها هتكتب السعر بس.',
              style: TextStyle(color: AppColors.inkSecondary, height: 1.6)),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            initialValue: _activity,
            decoration: const InputDecoration(labelText: 'نشاط المحل'),
            items: [for (final k in starterCatalog.keys) DropdownMenuItem(value: k, child: Text(k))],
            onChanged: (v) => setState(() {
              _activity = v!;
              _picked = {for (var i = 0; i < starterCatalog[v]!.length; i++) i};
            }),
          ),
          const SizedBox(height: 8),
          Row(children: [
            Text('${_picked.length} من ${items.length} مختارين', style: const TextStyle(fontWeight: FontWeight.w700)),
            const Spacer(),
            TextButton(
              onPressed: () => setState(() => _picked = _picked.length == items.length ? {} : {for (var i = 0; i < items.length; i++) i}),
              child: Text(_picked.length == items.length ? 'شيل الكل' : 'اختار الكل'),
            ),
          ]),
          for (var i = 0; i < items.length; i++)
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              value: _picked.contains(i),
              onChanged: (v) => setState(() => v == true ? _picked.add(i) : _picked.remove(i)),
              secondary: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SizedBox.square(
                  dimension: 52,
                  child: items[i].imageUrl == null
                      ? const ColoredBox(color: Colors.black12, child: Icon(Icons.image_outlined, color: AppColors.inkMuted))
                      : Image.network(items[i].imageUrl!, cacheWidth: 400, fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => const ColoredBox(color: Colors.black12)),
                ),
              ),
              title: Text(items[i].name, style: const TextStyle(fontWeight: FontWeight.w700)),
              subtitle: Text(
                [items[i].section, if (items[i].sizes.isNotEmpty) items[i].sizes.join('، ')].join(' • '),
                style: const TextStyle(fontSize: 12),
              ),
            ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: SizedBox(
            height: 54,
            child: ElevatedButton(
              onPressed: _saving || _picked.isEmpty ? null : _add,
              child: _saving
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                  : Text('ضيف ${_picked.length} منتج وحط الأسعار'),
            ),
          ),
        ),
      ),
    );
  }
}

/// Quick pricing: every product without a price (or hidden) in one list —
/// type the prices, save, and the priced ones show up for customers.
class QuickPricingScreen extends StatefulWidget {
  const QuickPricingScreen({super.key, required this.shopId});
  final String shopId;

  @override
  State<QuickPricingScreen> createState() => _QuickPricingScreenState();
}

class _QuickPricingScreenState extends State<QuickPricingScreen> {
  List<Map<String, dynamic>>? _products;
  final Map<String, TextEditingController> _prices = {};
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    for (final c in _prices.values) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _load() async {
    final all = await StoreService.fetchProducts(widget.shopId, includeHidden: true);
    final todo = all.where((p) => ((p['price'] as num?) ?? 0) == 0 || p['is_available'] != true).toList();
    if (!mounted) return;
    setState(() {
      _products = todo;
      for (final p in todo) {
        final price = (p['price'] as num?) ?? 0;
        _prices[p['id'] as String] = TextEditingController(text: price == 0 ? '' : price.toString());
      }
    });
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    var done = 0;
    try {
      for (final p in _products!) {
        final price = double.tryParse(_prices[p['id']]!.text.trim().replaceAll('٫', '.'));
        if (price == null || price <= 0) continue;
        await _db.from('shop_products').update({'price': price, 'is_available': true}).eq('id', p['id'] as String);
        done++;
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(done == 0 ? 'اكتب سعر منتج واحد على الأقل' : 'اتنشر $done منتج في متجرك 🎉')));
      if (done > 0) Navigator.of(context).pop(true);
    } catch (_) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('حصلت مشكلة في الحفظ، جرّب تاني')));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final products = _products;
    return Scaffold(
      appBar: AppBar(title: const Text('حط الأسعار')),
      body: products == null
          ? const Center(child: CircularProgressIndicator())
          : products.isEmpty
              ? const Center(child: Text('كل منتجاتك متسعّرة وظاهرة 👌', style: TextStyle(color: AppColors.inkMuted)))
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
                  itemCount: products.length + 1,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (context, i) {
                    if (i == 0) {
                      return const Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: Text('اكتب سعر كل منتج بتبيعه. اللي هتسيبه فاضي هيفضل مخفي لحد ما تسعّره.',
                            style: TextStyle(color: AppColors.inkSecondary, height: 1.6)),
                      );
                    }
                    final p = products[i - 1];
                    final sizes = StoreService.optionsOf(p).expand((o) => o.values).join('، ');
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(children: [
                        Expanded(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(p['name'] as String? ?? '', style: const TextStyle(fontWeight: FontWeight.w700)),
                            if (sizes.isNotEmpty) Text(sizes, style: const TextStyle(fontSize: 11.5, color: AppColors.inkMuted)),
                          ]),
                        ),
                        SizedBox(
                          width: 110,
                          child: TextField(
                            controller: _prices[p['id']],
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            textAlign: TextAlign.center,
                            decoration: const InputDecoration(hintText: 'السعر', suffixText: 'ج.م', isDense: true),
                          ),
                        ),
                      ]),
                    );
                  },
                ),
      bottomNavigationBar: products == null || products.isEmpty
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: SizedBox(
                  height: 54,
                  child: ElevatedButton(
                    onPressed: _saving ? null : _save,
                    child: _saving
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Text('احفظ وانشر المنتجات المتسعّرة'),
                  ),
                ),
              ),
            ),
    );
  }
}
