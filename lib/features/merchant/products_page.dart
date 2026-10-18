import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/shops/catalog.dart';
import '../../core/shops/print_card.dart';
import '../../core/shops/store_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/numbers.dart';
import '../shared/load_error_view.dart';
import 'admin/admin_common.dart';
import 'admin/merchant_session.dart';
import 'starter_products_screen.dart';

/// `/products`: the shop's products with a status filter (الكل = نشط +
/// مسودة, مؤرشف apart), a collection filter, search, share, duplicate,
/// archive and delete. Wide screens get a table (image, name, status,
/// stock, price range, variants, collections) besides the grid; rows
/// multi-select for bulk actions and drag to set the manual order
/// (0098). CSV export here, import at `/products/import`.
class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final shop = MerchantScope.of(context).shop!;
    return _ProductsView(key: ValueKey('p${shop['id']}'), shop: shop);
  }
}

class _ProductsView extends StatefulWidget {
  const _ProductsView({super.key, required this.shop});
  final Map<String, dynamic> shop;

  @override
  State<_ProductsView> createState() => _ProductsViewState();
}

class _ProductsViewState extends State<_ProductsView> {
  static const _tableWidth = 900.0;
  static void _noop() {}

  bool _loading = true;
  bool _loadError = false;
  List<Map<String, dynamic>> _products = [];
  List<Map<String, dynamic>> _collections = [];
  String? _filter; // null = active + draft
  String? _collection;
  final _search = TextEditingController();
  final Set<String> _selected = {};
  bool? _table; // null = by width
  bool _busy = false;

  String get _shopId => widget.shop['id'] as String;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = _products.isEmpty;
      _loadError = false;
    });
    try {
      final c = await StoreService.merchantCatalog(_shopId);
      if (!mounted) return;
      setState(() {
        _products = c.products;
        _collections = c.collections;
        _selected.removeWhere((id) => !_products.any((p) => p['id'] == id));
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _loadError = true;
      });
    }
  }

  void _edit([Map<String, dynamic>? p]) => p == null ? context.go('/products/new') : context.go('/products/${p['id']}', extra: p);

  void _snack(String text) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));

  Future<void> _setStatus(Map<String, dynamic> p, String status) async {
    try {
      await StoreService.setProductStatus(p['id'] as String, status);
      if (!mounted) return;
      _snack(status == 'archived' ? 'اتأرشف «${p['name']}»' : 'رجع «${p['name']}» ${productStatusLabels[status]}');
      _load();
    } catch (e) {
      if (mounted) _snack(adminErrorText(e, 'تعذر تغيير الحالة'));
    }
  }

  Future<void> _duplicate(Map<String, dynamic> p) async {
    try {
      final id = await StoreService.duplicateProduct(p['id'] as String);
      if (!mounted) return;
      _snack('اتعملت نسخة من «${p['name']}» (مسودة)');
      context.go('/products/$id');
    } catch (e) {
      if (mounted) _snack(adminErrorText(e, 'تعذر نسخ المنتج'));
    }
  }

  Future<void> _delete(Map<String, dynamic> p) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('حذف المنتج'),
        content: Text('هتحذف «${p['name']}» نهائياً؟'),
        actions: [
          TextButton(onPressed: () => Navigator.of(c).pop(false), child: const Text('تراجع')),
          ElevatedButton(onPressed: () => Navigator.of(c).pop(true), child: const Text('حذف')),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    try {
      final deleted = await StoreService.deleteProduct(p['id'] as String);
      if (!mounted) return;
      if (deleted) {
        _load();
        return;
      }
      // It has orders: archiving keeps them intact.
      final archive = await showDialog<bool>(
        context: context,
        builder: (c) => AlertDialog(
          title: const Text('المنتج ده عليه طلبات'),
          content: const Text('مينفعش يتمسح عشان طلباته القديمة. أرشفه بدل كده: هيختفي من المتجر ومن قايمتك، وتقدر ترجّعه وقت ما تحب.'),
          actions: [
            TextButton(onPressed: () => Navigator.of(c).pop(false), child: const Text('تراجع')),
            ElevatedButton.icon(onPressed: () => Navigator.of(c).pop(true), icon: const Icon(Icons.archive_outlined, size: 18), label: const Text('أرشفة')),
          ],
        ),
      );
      if (archive == true) _setStatus(p, 'archived');
    } catch (e) {
      if (mounted) _snack(adminErrorText(e, 'تعذر الحذف'));
    }
  }

  Future<void> _openStarter() async {
    await Navigator.of(context).push(MaterialPageRoute(builder: (_) => StarterProductsScreen(shopId: _shopId, shopCategory: widget.shop['category'] as String?)));
    _load();
  }

  Future<void> _openPricing() async {
    await Navigator.of(context).push(MaterialPageRoute(builder: (_) => QuickPricingScreen(shopId: _shopId)));
    _load();
  }

  void _share(Map<String, dynamic> p) {
    final slug = widget.shop['slug'] as String?;
    if (slug == null) {
      _snack('اختار رابط متجرك الأول من «متجري»');
      return;
    }
    StoreService.markShared(_shopId);
    final text = '${p['name']} — ${shopMoney((p['price'] as num?) ?? 0)}\nمن ${widget.shop['name']}، اطلبه من هنا والدفع عند الاستلام:\n${StoreService.productUrl(slug, p['id'] as String)}';
    launchUrl(Uri.parse('https://wa.me/?text=${Uri.encodeComponent(text)}'), mode: LaunchMode.externalApplication);
  }

  void _export() {
    final csv = catalogCsv(_products, _collections, currency: StoreService.merchantCurrency);
    final name = 'products-${widget.shop['slug'] ?? 'shop'}.csv';
    final ok = downloadText(csv, name, mime: 'text/csv;charset=utf-8');
    _snack(ok ? 'اتنزّل ملف المنتجات ($name)' : 'التصدير بيشتغل من المتصفح');
  }

  // ---- bulk

  Future<String?> _askValue(String title, {String? hint}) => askAdminText(context, title: title, hint: hint, number: true);

  Future<void> _bulk(String action, [Object? value]) async {
    if (_selected.isEmpty) return;
    if (action == 'delete') {
      final ok = await showDialog<bool>(
        context: context,
        builder: (c) => AlertDialog(
          title: Text('حذف ${_selected.length} منتج'),
          content: const Text('اللي عليه طلبات هيتأرشف بدل ما يتمسح (عشان الطلبات القديمة).'),
          actions: [
            TextButton(onPressed: () => Navigator.of(c).pop(false), child: const Text('تراجع')),
            ElevatedButton(onPressed: () => Navigator.of(c).pop(true), child: const Text('حذف')),
          ],
        ),
      );
      if (ok != true) return;
    }
    if (action == 'price' || action == 'stock') {
      final v = await _askValue(action == 'price' ? 'السعر الجديد للمحدد' : 'الكمية الجديدة للمحدد', hint: action == 'stock' ? 'فاضية = مفتوحة' : null);
      if (v == null || (action == 'price' && v.isEmpty)) return;
      value = v.isEmpty ? null : (action == 'price' ? looseDouble(v) : looseInt(v));
      if (v.isNotEmpty && value == null) {
        _snack('اكتب رقم صحيح');
        return;
      }
    }
    setState(() => _busy = true);
    try {
      final r = await StoreService.bulkProducts(_shopId, _selected.toList(), action, value);
      if (!mounted) return;
      final skipped = (r['skipped'] as num?)?.toInt() ?? 0;
      _snack([
        if (action == 'delete') 'اتمسح ${r['deleted']}، واتأرشف ${r['archived']}' else 'اتعدّل ${r['updated']} منتج',
        if (skipped > 0) '$skipped اتساب (ليه كذا نوع — عدّله من صفحته)',
      ].join(' • '));
      setState(() => _selected.clear());
      await _load();
    } catch (e) {
      if (mounted) _snack(adminErrorText(e, 'تعذر التعديل'));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _reorder(int from, int to) async {
    final shown = _shown;
    final moved = shown.removeAt(from);
    shown.insert(to, moved);
    setState(() {
      // Keep the rest (archived) after the reordered ones.
      final ids = shown.map((p) => p['id']).toSet();
      _products = [...shown, ..._products.where((p) => !ids.contains(p['id']))];
    });
    try {
      await StoreService.reorderProducts(_shopId, [for (final p in shown) p['id'] as String]);
    } catch (e) {
      if (mounted) _snack(adminErrorText(e, 'تعذر حفظ الترتيب'));
      _load();
    }
  }

  int _count(String? f) => _products.where((p) => f == null ? productStatusOf(p) != 'archived' : productStatusOf(p) == f).length;

  List<Map<String, dynamic>> get _shown {
    final q = _search.text.trim().toLowerCase();
    return [
      for (final p in _products)
        if ((_filter == null ? productStatusOf(p) != 'archived' : productStatusOf(p) == _filter) &&
            (_collection == null || (p['collection_ids'] as List? ?? const []).contains(_collection) ||
                ((_collections.firstWhere((c) => c['id'] == _collection, orElse: () => const <String, dynamic>{})['product_ids'] as List?)?.contains(p['id']) ?? false)) &&
            (q.isEmpty ||
                '${p['name']} ${p['sku'] ?? ''} ${(p['tags'] as List? ?? const []).join(' ')} ${variantsOf(p).map((v) => v['sku'] ?? '').join(' ')}'.toLowerCase().contains(q)))
          p,
    ];
  }

  bool get _canReorder => _filter == null && _collection == null && _search.text.trim().isEmpty;

  String _priceText(Map<String, dynamic> p) {
    final r = priceRange(p);
    return r.min == r.max ? shopMoney(r.min) : '${shopMoney(r.min)} – ${shopMoney(r.max)}';
  }

  String _stockText(Map<String, dynamic> p) {
    final s = stockTotal(p);
    if (s == null) return 'مفتوح';
    final n = variantsOf(p).length;
    return n > 1 ? '$s في $n نوع' : '$s';
  }

  List<String> _collectionNames(Map<String, dynamic> p) => [
        for (final c in _collections)
          if ((c['product_ids'] as List? ?? const []).contains(p['id'])) c['name'] as String? ?? '',
      ];

  Widget _unpricedBanner() {
    final n = _products.where((p) => productStatusOf(p) != 'archived' && ((p['price'] as num?) ?? 0) == 0 && variantsOf(p).isEmpty).length;
    if (n == 0) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: AppColors.gold.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
        child: ListTile(
          leading: const Icon(Icons.sell_rounded, color: AppColors.gold),
          title: Text('عندك $n منتج من غير سعر', style: const TextStyle(fontWeight: FontWeight.w800)),
          subtitle: const Text('مخفيين عن الزباين لحد ما تحط سعرهم'),
          trailing: ElevatedButton(onPressed: _openPricing, child: const Text('حط الأسعار')),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final narrow = width < AdminBreakpoints.rail;
    // Room for every header button (else «منتجات جاهزة» goes in the menu).
    final roomy = width >= 1440;
    final canTable = width >= _tableWidth;
    final table = canTable && (_table ?? true);
    final csvMenu = PopupMenuButton<String>(
      tooltip: 'استيراد / تصدير',
      onSelected: (v) {
        switch (v) {
          case 'import':
            context.go('/products/import');
          case 'export':
            _export();
          case 'collections':
            context.go('/collections');
          default:
            _openStarter();
        }
      },
      itemBuilder: (_) => [
        if (narrow) const PopupMenuItem(value: 'collections', child: ListTile(leading: Icon(Icons.category_outlined), title: Text('الأقسام'), dense: true)),
        const PopupMenuItem(value: 'import', child: ListTile(leading: Icon(Icons.upload_file_rounded), title: Text('استيراد من CSV'), dense: true)),
        const PopupMenuItem(value: 'export', child: ListTile(leading: Icon(Icons.download_rounded), title: Text('تصدير CSV'), dense: true)),
        if (!roomy) const PopupMenuItem(value: 'starter', child: ListTile(leading: Icon(Icons.playlist_add_rounded), title: Text('منتجات جاهزة'), dense: true)),
      ],
      child: narrow
          ? const Padding(padding: EdgeInsets.all(8), child: Icon(Icons.more_vert_rounded))
          : const IgnorePointer(
              child: OutlinedButton(onPressed: _noop, child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.import_export_rounded, size: 18), SizedBox(width: 6), Text('استيراد / تصدير')])),
            ),
    );
    return AdminPage(
      title: 'المنتجات',
      subtitle: _loading ? null : '${_count(null)} منتج',
      search: AdminSearchField(controller: _search, hint: 'دوّر بالاسم أو الـ SKU أو الوسم', onChanged: (_) => setState(() {})),
      actions: [
        if (canTable)
          SegmentedButton<bool>(
            key: const ValueKey('view-toggle'),
            showSelectedIcon: false,
            segments: const [
              ButtonSegment(value: true, icon: Icon(Icons.table_rows_rounded, size: 18), tooltip: 'جدول'),
              ButtonSegment(value: false, icon: Icon(Icons.grid_view_rounded, size: 18), tooltip: 'كروت'),
            ],
            selected: {table},
            onSelectionChanged: (v) => setState(() => _table = v.first),
          ),
        csvMenu,
        if (roomy) OutlinedButton.icon(onPressed: _openStarter, icon: const Icon(Icons.playlist_add_rounded, size: 18), label: const Text('منتجات جاهزة')),
        if (!narrow) ElevatedButton.icon(onPressed: () => _edit(), icon: const Icon(Icons.add_rounded, size: 18), label: const Text('أضف منتج')),
      ],
      floatingActionButton: narrow
          ? FloatingActionButton.extended(
              onPressed: () => _edit(),
              backgroundColor: AppColors.teal,
              icon: const Icon(Icons.add_rounded, color: Colors.white),
              label: const Text('أضف منتج', style: TextStyle(color: Colors.white)),
            )
          : null,
      body: _body(narrow, table),
    );
  }

  Widget _filters() => SizedBox(
        height: 46,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.only(bottom: 6),
          child: Row(children: [
            for (final (key, label) in const [(null, 'الكل'), ('active', 'نشط'), ('draft', 'مسودة'), ('archived', 'مؤرشف')])
              Padding(
                padding: const EdgeInsetsDirectional.only(end: 8),
                child: ChoiceChip(
                    label: Text('$label (${_count(key)})'),
                    labelStyle: chipLabelStyle(_filter == key),
                    checkmarkColor: Colors.white,
                    selected: _filter == key,
                    onSelected: (_) => setState(() => _filter = key)),
              ),
            if (_collections.isNotEmpty)
              PopupMenuButton<String?>(
                tooltip: 'القسم',
                initialValue: _collection,
                onSelected: (v) => setState(() => _collection = v == '' ? null : v),
                itemBuilder: (_) => [
                  const PopupMenuItem(value: '', child: Text('كل الأقسام')),
                  for (final c in _collections) PopupMenuItem(value: c['id'] as String, child: Text(c['name'] as String? ?? '')),
                ],
                child: Chip(
                  avatar: const Icon(Icons.category_outlined, size: 16),
                  label: Text(_collection == null ? 'كل الأقسام' : (_collections.firstWhere((c) => c['id'] == _collection, orElse: () => const {'name': ''})['name'] as String? ?? '')),
                ),
              ),
          ]),
        ),
      );

  Widget _bulkBar() {
    final manual = _collections.where((c) => c['rules'] == null).toList();
    return Container(
      key: const ValueKey('bulk-bar'),
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: AppColors.night, borderRadius: BorderRadius.circular(14)),
      child: Wrap(spacing: 8, runSpacing: 6, crossAxisAlignment: WrapCrossAlignment.center, children: [
        Text('${_selected.length} محدد', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
        TextButton(onPressed: () => setState(_selected.clear), child: const Text('إلغاء', style: TextStyle(color: AppColors.gold))),
        if (_busy) const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)),
        PopupMenuButton<String>(
          tooltip: 'الحالة',
          onSelected: (v) => _bulk('status', v),
          itemBuilder: (_) => [for (final e in productStatusLabels.entries) PopupMenuItem(value: e.key, child: Text(e.value))],
          child: const _BarButton(icon: Icons.toggle_on_outlined, label: 'الحالة'),
        ),
        if (manual.isNotEmpty)
          PopupMenuButton<String>(
            tooltip: 'ضيف لقسم',
            onSelected: (v) => _bulk('add_collection', v),
            itemBuilder: (_) => [for (final c in manual) PopupMenuItem(value: c['id'] as String, child: Text(c['name'] as String? ?? ''))],
            child: const _BarButton(icon: Icons.create_new_folder_outlined, label: 'ضيف لقسم'),
          ),
        InkWell(onTap: () => _bulk('price'), child: const _BarButton(icon: Icons.sell_outlined, label: 'السعر')),
        InkWell(onTap: () => _bulk('stock'), child: const _BarButton(icon: Icons.inventory_2_outlined, label: 'الكمية')),
        InkWell(onTap: () => _bulk('status', 'archived'), child: const _BarButton(icon: Icons.archive_outlined, label: 'أرشفة')),
        InkWell(onTap: () => _bulk('delete'), child: const _BarButton(icon: Icons.delete_outline_rounded, label: 'حذف')),
      ]),
    );
  }

  Widget _body(bool narrow, bool table) {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_loadError) return LoadErrorView(onRetry: _load);
    if (_products.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.auto_awesome_rounded, color: AppColors.gold, size: 40),
            const SizedBox(height: 10),
            const Text('ابدأ بمنتجات جاهزة لنشاطك', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17)),
            const SizedBox(height: 6),
            const Text('هتلاقي منتجات نشاطك متجهزة بالاسم والوصف والأحجام، وإنت تكتب السعر بس.',
                textAlign: TextAlign.center, style: TextStyle(color: AppColors.inkMuted, height: 1.6)),
            const SizedBox(height: 14),
            ElevatedButton.icon(onPressed: _openStarter, icon: const Icon(Icons.playlist_add_rounded), label: const Text('ضيف منتجات نشاطك الجاهزة')),
            const SizedBox(height: 6),
            TextButton(onPressed: () => _edit(), child: const Text('أو ضيف منتج بنفسك')),
            TextButton.icon(onPressed: () => context.go('/products/import'), icon: const Icon(Icons.upload_file_rounded, size: 18), label: const Text('أو استورد ملف CSV')),
          ]),
        ),
      );
    }
    final shown = _shown;
    return RefreshIndicator(
      onRefresh: _load,
      child: CustomScrollView(slivers: [
        SliverToBoxAdapter(child: _unpricedBanner()),
        SliverToBoxAdapter(child: _filters()),
        if (_selected.isNotEmpty) SliverToBoxAdapter(child: _bulkBar()),
        if (narrow)
          SliverToBoxAdapter(
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: TextButton.icon(onPressed: _openStarter, icon: const Icon(Icons.playlist_add_rounded, size: 18), label: const Text('ضيف منتجات جاهزة تانية')),
            ),
          ),
        if (shown.isEmpty)
          const SliverToBoxAdapter(
            child: Padding(padding: EdgeInsets.all(32), child: Center(child: Text('مفيش منتجات هنا', style: TextStyle(color: AppColors.inkMuted)))),
          ),
        if (table && shown.isNotEmpty) ...[
          SliverToBoxAdapter(child: _tableHeader(shown)),
          SliverPadding(
            padding: const EdgeInsets.only(bottom: 96),
            sliver: SliverReorderableList(
              itemCount: shown.length,
              onReorderItem: _reorder,
              itemBuilder: (context, i) => _row(shown[i], i),
            ),
          ),
        ] else
          SliverPadding(
            padding: const EdgeInsets.only(top: 6, bottom: 96),
            sliver: SliverGrid.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 240, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 0.66),
              itemCount: shown.length,
              itemBuilder: (context, i) => _card(shown[i]),
            ),
          ),
      ]),
    );
  }

  static const _hStyle = TextStyle(fontSize: 11.5, color: AppColors.inkMuted, fontWeight: FontWeight.w800);

  Widget _tableHeader(List<Map<String, dynamic>> shown) {
    final all = shown.isNotEmpty && shown.every((p) => _selected.contains(p['id']));
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: const BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.vertical(top: Radius.circular(14))),
      child: Row(children: [
        SizedBox(
          width: 40,
          child: Checkbox(
            key: const ValueKey('select-all'),
            value: all,
            onChanged: (on) => setState(() => on == true ? _selected.addAll(shown.map((p) => p['id'] as String)) : _selected.clear()),
          ),
        ),
        const SizedBox(width: 28),
        const SizedBox(width: 56, child: Text('صورة', style: _hStyle)),
        const Expanded(flex: 4, child: Text('المنتج', style: _hStyle)),
        const SizedBox(width: 86, child: Text('الحالة', style: _hStyle)),
        const Expanded(flex: 2, child: Text('المخزون', style: _hStyle)),
        const Expanded(flex: 2, child: Text('السعر', style: _hStyle)),
        const SizedBox(width: 64, child: Text('الأنواع', style: _hStyle)),
        const Expanded(flex: 3, child: Text('الأقسام', style: _hStyle)),
        const SizedBox(width: 88),
      ]),
    );
  }

  Widget _row(Map<String, dynamic> p, int index) {
    final id = p['id'] as String;
    final status = productStatusOf(p);
    final images = StoreService.imagesOf(p);
    final nVariants = variantsOf(p).length;
    final stock = stockTotal(p);
    final colls = _collectionNames(p);
    final selected = _selected.contains(id);
    return Material(
      key: ValueKey('row-$id'),
      color: selected ? AppColors.tealLight : AppColors.surface,
      child: InkWell(
        onTap: () => _selected.isNotEmpty ? setState(() => selected ? _selected.remove(id) : _selected.add(id)) : _edit(p),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
          decoration: const BoxDecoration(border: Border(top: BorderSide(color: AppColors.border))),
          child: Row(children: [
            SizedBox(width: 40, child: Checkbox(value: selected, onChanged: (_) => setState(() => selected ? _selected.remove(id) : _selected.add(id)))),
            SizedBox(
              width: 28,
              child: _canReorder
                  ? ReorderableDragStartListener(
                      index: index,
                      child: const MouseRegion(cursor: SystemMouseCursors.grab, child: Icon(Icons.drag_indicator_rounded, size: 20, color: AppColors.inkMuted)),
                    )
                  : null,
            ),
            SizedBox(
              width: 56,
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: images.isEmpty
                      ? Container(width: 44, height: 44, color: AppColors.surfaceAlt, child: const Icon(Icons.image_outlined, size: 20, color: AppColors.inkMuted))
                      : Image.network(images.first, cacheWidth: 120, width: 44, height: 44, fit: BoxFit.cover),
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(p['name'] as String? ?? '', maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w700)),
                if ((p['sku'] as String?) != null) Text('SKU ${p['sku']}', style: const TextStyle(fontSize: 11, color: AppColors.inkMuted)),
              ]),
            ),
            SizedBox(
              width: 86,
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: Pill(productStatusLabels[status]!, status == 'active' ? AppColors.success.withValues(alpha: 0.15) : AppColors.surfaceAlt,
                    status == 'active' ? const Color(0xFF047857) : AppColors.inkSecondary),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(_stockText(p),
                  style: TextStyle(fontSize: 12.5, color: stock != null && stock <= 0 ? Colors.redAccent : AppColors.ink, fontWeight: stock != null && stock <= 0 ? FontWeight.w800 : null)),
            ),
            Expanded(flex: 2, child: Text(_priceText(p), style: const TextStyle(fontSize: 12.5, color: AppColors.crystal, fontWeight: FontWeight.w700))),
            SizedBox(width: 64, child: Text(nVariants == 0 ? '—' : '$nVariants', style: const TextStyle(fontSize: 12.5))),
            Expanded(
              flex: 3,
              child: Text(colls.isEmpty ? '—' : colls.join('، '), maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, color: AppColors.inkSecondary)),
            ),
            SizedBox(
              width: 88,
              child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                IconButton(tooltip: 'شارك على واتساب', visualDensity: VisualDensity.compact, onPressed: () => _share(p), icon: const Icon(Icons.share_rounded, size: 18, color: AppColors.success)),
                _menu(p, status),
              ]),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _menu(Map<String, dynamic> p, String status) => PopupMenuButton<String>(
        icon: const Icon(Icons.more_vert_rounded, size: 19),
        onSelected: (v) {
          switch (v) {
            case 'edit':
              _edit(p);
            case 'duplicate':
              _duplicate(p);
            case 'archive':
              _setStatus(p, 'archived');
            case 'unarchive':
              _setStatus(p, 'active');
            default:
              _delete(p);
          }
        },
        itemBuilder: (_) => [
          const PopupMenuItem(value: 'edit', child: Text('تعديل')),
          const PopupMenuItem(value: 'duplicate', child: Text('اعمل نسخة')),
          if (status == 'archived')
            const PopupMenuItem(value: 'unarchive', child: Text('إلغاء الأرشفة'))
          else
            const PopupMenuItem(value: 'archive', child: Text('أرشفة')),
          const PopupMenuItem(value: 'delete', child: Text('حذف')),
        ],
      );

  Widget _card(Map<String, dynamic> p) {
    final id = p['id'] as String;
    final status = productStatusOf(p);
    final images = StoreService.imagesOf(p);
    final stock = stockTotal(p);
    final selected = _selected.contains(id);
    final nVariants = variantsOf(p).length;
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(18),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18), side: BorderSide(color: selected ? AppColors.crystal : Colors.transparent, width: 2)),
      child: InkWell(
        onTap: () => _selected.isNotEmpty ? setState(() => selected ? _selected.remove(id) : _selected.add(id)) : _edit(p),
        onLongPress: () => setState(() => selected ? _selected.remove(id) : _selected.add(id)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Expanded(
            child: Stack(fit: StackFit.expand, children: [
              images.isEmpty
                  ? const ColoredBox(color: AppColors.surfaceAlt, child: Icon(Icons.add_a_photo_outlined, color: AppColors.inkMuted))
                  : Image.network(images.first, cacheWidth: 300, fit: BoxFit.cover),
              if (status != 'active')
                PositionedDirectional(
                  top: 8,
                  start: 8,
                  child: Pill(productStatusLabels[status]!, status == 'archived' ? AppColors.inkSecondary : Colors.black87, Colors.white),
                ),
              if (stock != null)
                PositionedDirectional(
                  top: 8,
                  end: 8,
                  child: Pill(stock <= 0 ? 'نفد' : 'متاح $stock', stock <= 0 ? Colors.redAccent : AppColors.night, Colors.white),
                ),
              if (nVariants > 1)
                PositionedDirectional(bottom: 8, end: 8, child: Pill('$nVariants نوع', Colors.white, AppColors.night)),
              if (_selected.isNotEmpty)
                PositionedDirectional(
                  bottom: 6,
                  start: 6,
                  child: Icon(selected ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded, color: selected ? AppColors.crystal : Colors.white),
                ),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 8, 10, 0),
            child: Text(p['name'] as String? ?? '', maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 0, 4),
            child: Row(children: [
              Expanded(child: Text(_priceText(p), maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.crystal, fontWeight: FontWeight.w800))),
              IconButton(tooltip: 'شارك على واتساب', visualDensity: VisualDensity.compact, onPressed: () => _share(p), icon: const Icon(Icons.share_rounded, size: 19, color: AppColors.success)),
              _menu(p, status),
            ]),
          ),
        ]),
      ),
    );
  }
}

class _BarButton extends StatelessWidget {
  const _BarButton({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, size: 17, color: Colors.white),
          const SizedBox(width: 4),
          Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12.5)),
        ]),
      );
}
