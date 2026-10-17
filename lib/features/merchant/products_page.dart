import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/shops/store_service.dart';
import '../../core/theme/app_colors.dart';
import '../shared/load_error_view.dart';
import 'admin/admin_common.dart';
import 'admin/merchant_session.dart';
import 'starter_products_screen.dart';

/// `/products`: the shop's products with a status filter (الكل = نشط +
/// مسودة, مؤرشف apart), search, share, archive and delete.
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
  bool _loading = true;
  bool _loadError = false;
  List<Map<String, dynamic>> _products = [];
  String? _filter; // null = active + draft
  final _search = TextEditingController();

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
      final products = await StoreService.fetchProducts(_shopId, includeHidden: true);
      if (!mounted) return;
      setState(() {
        _products = products;
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

  Future<void> _setStatus(Map<String, dynamic> p, String status) async {
    try {
      await StoreService.setProductStatus(p['id'] as String, status);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(status == 'archived' ? 'اتأرشف «${p['name']}»' : 'رجع «${p['name']}» ${productStatusLabels[status]}'),
      ));
      _load();
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(adminErrorText(e, 'تعذر تغيير الحالة'))));
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
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(adminErrorText(e, 'تعذر الحذف'))));
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
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('اختار رابط متجرك الأول من «متجري»')));
      return;
    }
    StoreService.markShared(_shopId);
    final text = '${p['name']} — ${shopMoney((p['price'] as num?) ?? 0)}\nمن ${widget.shop['name']}، اطلبه من هنا والدفع عند الاستلام:\n${StoreService.productUrl(slug, p['id'] as String)}';
    launchUrl(Uri.parse('https://wa.me/?text=${Uri.encodeComponent(text)}'), mode: LaunchMode.externalApplication);
  }

  int _count(String? f) => _products.where((p) => f == null ? productStatusOf(p) != 'archived' : productStatusOf(p) == f).length;

  List<Map<String, dynamic>> get _shown {
    final q = _search.text.trim();
    return [
      for (final p in _products)
        if ((_filter == null ? productStatusOf(p) != 'archived' : productStatusOf(p) == _filter) && (q.isEmpty || (p['name'] as String? ?? '').contains(q))) p,
    ];
  }

  Widget _unpricedBanner() {
    final n = _products.where((p) => productStatusOf(p) != 'archived' && ((p['price'] as num?) ?? 0) == 0).length;
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
    final narrow = MediaQuery.sizeOf(context).width < AdminBreakpoints.rail;
    return AdminPage(
      title: 'المنتجات',
      subtitle: _loading ? null : '${_count(null)} منتج',
      search: AdminSearchField(controller: _search, hint: 'دوّر باسم المنتج', onChanged: (_) => setState(() {})),
      actions: [
        if (!narrow) OutlinedButton.icon(onPressed: _openStarter, icon: const Icon(Icons.playlist_add_rounded, size: 18), label: const Text('منتجات جاهزة')),
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
      body: _body(narrow),
    );
  }

  Widget _body(bool narrow) {
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
          ]),
        ),
      );
    }
    final shown = _shown;
    return RefreshIndicator(
      onRefresh: _load,
      child: CustomScrollView(slivers: [
        SliverToBoxAdapter(child: _unpricedBanner()),
        SliverToBoxAdapter(
          child: SizedBox(
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
                        selected: _filter == key, onSelected: (_) => setState(() => _filter = key)),
                  ),
              ]),
            ),
          ),
        ),
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

  Widget _card(Map<String, dynamic> p) {
    final status = productStatusOf(p);
    final images = StoreService.imagesOf(p);
    final stock = p['stock'] as int?;
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(18),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _edit(p),
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
                  child: Pill(stock == 0 ? 'نفد' : 'متاح $stock', stock == 0 ? Colors.redAccent : AppColors.night, Colors.white),
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
              Expanded(child: Text(shopMoney((p['price'] as num?) ?? 0), style: const TextStyle(color: AppColors.crystal, fontWeight: FontWeight.w800))),
              IconButton(tooltip: 'شارك على واتساب', visualDensity: VisualDensity.compact, onPressed: () => _share(p), icon: const Icon(Icons.share_rounded, size: 19, color: AppColors.success)),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert_rounded, size: 19),
                onSelected: (v) {
                  switch (v) {
                    case 'edit':
                      _edit(p);
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
                  if (status == 'archived')
                    const PopupMenuItem(value: 'unarchive', child: Text('إلغاء الأرشفة'))
                  else
                    const PopupMenuItem(value: 'archive', child: Text('أرشفة')),
                  const PopupMenuItem(value: 'delete', child: Text('حذف')),
                ],
              ),
            ]),
          ),
        ]),
      ),
    );
  }
}
