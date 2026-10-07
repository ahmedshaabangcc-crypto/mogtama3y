import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:qr_flutter/qr_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/app_flavor.dart';
import '../../core/auth/auth_service.dart';
import '../../core/shops/store_service.dart';
import '../../core/storage/upload_service.dart';
import '../../core/theme/app_colors.dart';
import '../auth/auth_landing_screen.dart';
import '../e_address/e_address_widgets.dart';
import '../profile/profile_screen.dart';
import '../shared/install_app_banner.dart';
import '../shared/load_error_view.dart';
import '../shared/push_opt_in.dart';
import '../support/support_contact_screen.dart';
import 'starter_products_screen.dart';
import 'store_qr_card_screen.dart';

String _money(num v) => '${NumberFormat('#,##0.##').format(v)} ج.م';
String _errorText(Object e, String fallback) => e is PostgrestException ? e.message : fallback;

/// The merchant panel (mogtama3y.com/#/merchant): register a shop, then
/// manage its products, orders and public link / QR. See
/// backend/migrations/0047_merchant_stores.sql.
class MerchantDashboardScreen extends StatefulWidget {
  const MerchantDashboardScreen({super.key});

  @override
  State<MerchantDashboardScreen> createState() => _MerchantDashboardScreenState();
}

class _MerchantDashboardScreenState extends State<MerchantDashboardScreen> {
  bool _loading = true;
  bool _loadError = false;
  List<Map<String, dynamic>> _shops = [];
  int _selected = 0;
  int _tab = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    if (!AuthService.isSignedIn) {
      setState(() => _loading = false);
      return;
    }
    setState(() {
      _loading = true;
      _loadError = false;
    });
    try {
      final shops = await StoreService.fetchMyShops();
      if (!mounted) return;
      setState(() {
        _shops = shops;
        _selected = _selected.clamp(0, shops.isEmpty ? 0 : shops.length - 1);
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

  @override
  Widget build(BuildContext context) {
    if (!AuthService.isSignedIn) {
      return Scaffold(
        backgroundColor: AppColors.bg,
        appBar: AppBar(title: const Text('لوحة التاجر')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              const Icon(Icons.storefront_rounded, size: 48, color: AppColors.teal),
              const SizedBox(height: 12),
              const Text('خلّي محلك أونلاين ببلاش', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
              const SizedBox(height: 6),
              const Text('سجّل دخول أو اعمل حساب، وبعدها سجّل محلك وخد رابط وQR باسمه.', textAlign: TextAlign.center, style: TextStyle(color: AppColors.inkSecondary, height: 1.6)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  await Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AuthLandingScreen()));
                  if (mounted) _load();
                },
                child: const Text('تسجيل الدخول / حساب جديد'),
              ),
            ]),
          ),
        ),
      );
    }
    if (_loading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    if (_loadError) {
      return Scaffold(backgroundColor: AppColors.bg, appBar: AppBar(title: const Text('لوحة التاجر')), body: LoadErrorView(onRetry: _load));
    }
    if (_shops.isEmpty) {
      return Scaffold(
        backgroundColor: AppColors.bg,
        appBar: AppBar(title: const Text('سجّل محلك'), actions: const [if (isTajerApp) _TajerAccountMenu()]),
        body: Column(children: [
          if (isTajerApp) const Padding(padding: EdgeInsets.fromLTRB(16, 12, 16, 0), child: InstallAppBanner()),
          Expanded(child: _RegisterShopForm(onCreated: _load)),
        ]),
      );
    }

    final shop = _shops[_selected];
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: _shops.length == 1
            ? Text(shop['name'] as String? ?? 'لوحة التاجر')
            : DropdownButton<int>(
                value: _selected,
                underline: const SizedBox.shrink(),
                items: [for (var i = 0; i < _shops.length; i++) DropdownMenuItem(value: i, child: Text(_shops[i]['name'] as String? ?? ''))],
                onChanged: (i) => setState(() => _selected = i ?? 0),
              ),
        actions: const [if (isTajerApp) _TajerAccountMenu()],
      ),
      body: IndexedStack(index: _tab, children: [
        _HomeTab(key: ValueKey('h${shop['id']}'), shop: shop, onGoTo: (i) => setState(() => _tab = i)),
        _ProductsTab(key: ValueKey('p${shop['id']}'), shopId: shop['id'] as String, shopSlug: shop['slug'] as String?, shopName: shop['name'] as String? ?? '', shopCategory: shop['category'] as String?),
        _OrdersTab(key: ValueKey('o${shop['id']}'), shopId: shop['id'] as String),
        _MyStoreTab(key: ValueKey('s${shop['id']}'), shop: shop, onChanged: _load),
      ]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: (i) => setState(() => _tab = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.space_dashboard_outlined), selectedIcon: Icon(Icons.space_dashboard_rounded), label: 'الرئيسية'),
          NavigationDestination(icon: Icon(Icons.inventory_2_outlined), selectedIcon: Icon(Icons.inventory_2_rounded), label: 'المنتجات'),
          NavigationDestination(icon: Icon(Icons.receipt_long_outlined), selectedIcon: Icon(Icons.receipt_long_rounded), label: 'الطلبات'),
          NavigationDestination(icon: Icon(Icons.storefront_outlined), selectedIcon: Icon(Icons.storefront_rounded), label: 'متجري'),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------
// Register a shop
// ---------------------------------------------------------------------

class _RegisterShopForm extends StatefulWidget {
  const _RegisterShopForm({required this.onCreated});
  final VoidCallback onCreated;

  @override
  State<_RegisterShopForm> createState() => _RegisterShopFormState();
}

class _RegisterShopFormState extends State<_RegisterShopForm> {
  final _name = TextEditingController();
  final _slug = TextEditingController();
  final _whatsapp = TextEditingController();
  final _address = TextEditingController();
  final _otherActivity = TextEditingController();
  String _category = StoreService.categories.first;
  // Activities earlier merchants typed under "نشاط تاني".
  List<String> _learned = const [];
  bool _saving = false;
  String? _error;

  bool get _isOther => _category == StoreService.otherActivity;

  @override
  void initState() {
    super.initState();
    StoreService.learnedActivities().then((l) {
      if (mounted) setState(() => _learned = l);
    });
  }

  @override
  void dispose() {
    _otherActivity.dispose();
    _name.dispose();
    _slug.dispose();
    _whatsapp.dispose();
    _address.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final typed = _otherActivity.text.trim().replaceAll(RegExp(r'\s+'), ' ');
    if (_isOther && typed.length < 2) {
      setState(() => _error = 'اكتب نشاط محلك');
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await StoreService.createMyShop(
        name: _name.text.trim(),
        category: _isOther ? typed : _category,
        slug: _slug.text.trim(),
        whatsapp: _whatsapp.text.trim(),
        address: _address.text.trim(),
      );
      widget.onCreated();
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = _errorText(e, 'تعذر تسجيل المحل، حاول مرة أخرى'));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('متجر أونلاين مجاني لمحلك، من غير عمولة ولا اشتراك.', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
        const SizedBox(height: 4),
        const Text('هتاخد رابط وQR باسم محلك، وزباينك يطلبوا منك والطلب يوصلك على الواتساب.', style: TextStyle(fontSize: 12, color: AppColors.inkSecondary, height: 1.6)),
        const SizedBox(height: 16),
        TextField(controller: _name, decoration: const InputDecoration(labelText: 'اسم المحل *')),
        const SizedBox(height: 10),
        DropdownButtonFormField<String>(
          initialValue: _category,
          decoration: const InputDecoration(labelText: 'النشاط *'),
          items: [
            for (final c in StoreService.categories)
              if (c != StoreService.otherActivity) DropdownMenuItem(value: c, child: Text(c)),
            for (final c in _learned) DropdownMenuItem(value: c, child: Text(c)),
            const DropdownMenuItem(value: StoreService.otherActivity, child: Text('${StoreService.otherActivity} (اكتبه بنفسك)')),
          ],
          onChanged: (v) => setState(() => _category = v ?? _category),
        ),
        if (_isOther) ...[
          const SizedBox(height: 10),
          TextField(
            controller: _otherActivity,
            onChanged: (_) => setState(() {}),
            decoration: const InputDecoration(labelText: 'اكتب نشاط محلك *', hintText: 'مثلاً: مكتبة، ورد، أدوات صحية'),
          ),
          // Matching activities other merchants already typed — one tap picks it.
          if (_otherActivity.text.trim().isNotEmpty)
            Wrap(spacing: 6, children: [
              for (final a in _learned.where((a) => a.contains(_otherActivity.text.trim())).take(6))
                ActionChip(label: Text(a), onPressed: () => setState(() => _category = a)),
            ]),
        ],
        const SizedBox(height: 10),
        TextField(
          controller: _slug,
          textDirection: TextDirection.ltr,
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9-]'))],
          onChanged: (_) => setState(() {}),
          decoration: const InputDecoration(labelText: 'اسم الرابط بالإنجليزي *', hintText: 'elsalam'),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text('رابطك: ${StoreService.storeUrl(_slug.text.trim().toLowerCase().isEmpty ? '...' : _slug.text.trim().toLowerCase())}',
              textDirection: TextDirection.ltr, style: const TextStyle(fontSize: 11, color: AppColors.teal)),
        ),
        const SizedBox(height: 10),
        TextField(controller: _whatsapp, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'رقم الواتساب لاستقبال الطلبات *', hintText: '01xxxxxxxxx')),
        const SizedBox(height: 10),
        TextField(controller: _address, decoration: const InputDecoration(labelText: 'العنوان (المحافظة، الحي، الشارع)')),
        if (_error != null) ...[
          const SizedBox(height: 12),
          Text(_error!, style: const TextStyle(color: Colors.redAccent, fontSize: 12)),
        ],
        const SizedBox(height: 20),
        SizedBox(
          height: 50,
          child: ElevatedButton(
            onPressed: _saving ? null : _submit,
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.teal, foregroundColor: Colors.white),
            child: _saving ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Text('سجّل محلك ببلاش'),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------
// Products
// ---------------------------------------------------------------------

class _ProductsTab extends StatefulWidget {
  const _ProductsTab({super.key, required this.shopId, this.shopSlug, this.shopName = '', this.shopCategory});
  final String shopId;
  final String? shopSlug;
  final String shopName;
  final String? shopCategory;

  @override
  State<_ProductsTab> createState() => _ProductsTabState();
}

class _ProductsTabState extends State<_ProductsTab> {
  bool _loading = true;
  bool _loadError = false;
  List<Map<String, dynamic>> _products = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _loadError = false;
    });
    try {
      final products = await StoreService.fetchProducts(widget.shopId, includeHidden: true);
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

  Future<void> _edit([Map<String, dynamic>? product]) async {
    final saved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => _ProductEditor(shopId: widget.shopId, product: product, shopCategory: widget.shopCategory),
    );
    if (saved == true) _load();
  }

  Future<void> _delete(Map<String, dynamic> product) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('حذف المنتج'),
        content: Text('هتحذف "${product['name']}"؟ لو عليه طلبات قديمة الأفضل تخفيه بدل الحذف.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(c).pop(false), child: const Text('تراجع')),
          ElevatedButton(onPressed: () => Navigator.of(c).pop(true), child: const Text('حذف')),
        ],
      ),
    );
    if (ok != true) return;
    try {
      await StoreService.deleteProduct(product['id'] as String);
      _load();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(_errorText(e, 'تعذر الحذف — لو المنتج عليه طلبات اخفيه بدل الحذف'))));
    }
  }

  Future<void> _openStarter() async {
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => StarterProductsScreen(shopId: widget.shopId, shopCategory: widget.shopCategory),
    ));
    _load();
  }

  Future<void> _openPricing() async {
    await Navigator.of(context).push(MaterialPageRoute(builder: (_) => QuickPricingScreen(shopId: widget.shopId)));
    _load();
  }

  Widget _unpricedBanner() {
    final n = _products.where((p) => ((p['price'] as num?) ?? 0) == 0).length;
    if (n == 0) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
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

  void _share(Map<String, dynamic> p) {
    final slug = widget.shopSlug;
    if (slug == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('اختار رابط متجرك الأول من «متجري»')));
      return;
    }
    final text = '${p['name']} — ${_money((p['price'] as num?) ?? 0)}\nمن ${widget.shopName}، اطلبه من هنا والدفع عند الاستلام:\n${StoreService.productUrl(slug, p['id'] as String)}';
    launchUrl(Uri.parse('https://wa.me/?text=${Uri.encodeComponent(text)}'), mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _edit(),
        backgroundColor: AppColors.teal,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text('أضف منتج', style: TextStyle(color: Colors.white)),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _loadError
              ? LoadErrorView(onRetry: _load)
              : _products.isEmpty
                  ? Center(
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
                    )
                  : RefreshIndicator(
                      onRefresh: _load,
                      child: CustomScrollView(slivers: [
                        SliverToBoxAdapter(child: _unpricedBanner()),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
                            child: Align(
                              alignment: AlignmentDirectional.centerStart,
                              child: TextButton.icon(onPressed: _openStarter, icon: const Icon(Icons.playlist_add_rounded, size: 18), label: const Text('ضيف منتجات جاهزة تانية')),
                            ),
                          ),
                        ),
                        SliverPadding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
                        sliver: SliverGrid.builder(
                        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 240,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 0.66,
                        ),
                        itemCount: _products.length,
                        itemBuilder: (context, i) {
                          final p = _products[i];
                          final available = p['is_available'] == true;
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
                                    if (!available)
                                      const PositionedDirectional(top: 8, start: 8, child: _Pill('مخفي', Colors.black87, Colors.white)),
                                    if (stock != null)
                                      PositionedDirectional(
                                        top: 8,
                                        end: 8,
                                        child: _Pill(stock == 0 ? 'نفد' : 'متاح $stock', stock == 0 ? Colors.redAccent : AppColors.night, Colors.white),
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
                                    Expanded(child: Text(_money((p['price'] as num?) ?? 0), style: const TextStyle(color: AppColors.crystal, fontWeight: FontWeight.w800))),
                                    IconButton(tooltip: 'شارك على واتساب', visualDensity: VisualDensity.compact, onPressed: () => _share(p), icon: const Icon(Icons.share_rounded, size: 19, color: AppColors.success)),
                                    PopupMenuButton<String>(
                                      icon: const Icon(Icons.more_vert_rounded, size: 19),
                                      onSelected: (v) => v == 'edit' ? _edit(p) : _delete(p),
                                      itemBuilder: (_) => const [
                                        PopupMenuItem(value: 'edit', child: Text('تعديل')),
                                        PopupMenuItem(value: 'delete', child: Text('حذف')),
                                      ],
                                    ),
                                  ]),
                                ),
                              ]),
                            ),
                          );
                        },
                      ),
                        ),
                      ]),
                    ),
    );
  }
}

class _ProductEditor extends StatefulWidget {
  const _ProductEditor({required this.shopId, this.product, this.shopCategory});
  final String shopId;
  final Map<String, dynamic>? product;
  final String? shopCategory;

  @override
  State<_ProductEditor> createState() => _ProductEditorState();
}

class _ProductEditorState extends State<_ProductEditor> {
  static const _maxImages = 6;

  late final _name = TextEditingController(text: widget.product?['name'] as String? ?? '');
  late final _price = TextEditingController(text: (widget.product?['price'] as num?)?.toString() ?? '');
  late final _oldPrice = TextEditingController(text: (widget.product?['old_price'] as num?)?.toString() ?? '');
  late final _desc = TextEditingController(text: widget.product?['description'] as String? ?? '');
  late final _highlights = TextEditingController(
      text: List<String>.from(widget.product?['highlights'] as List? ?? const []).join('\n'));
  late final List<String> _images = widget.product == null ? [] : StoreService.imagesOf(widget.product!);
  late final _category = TextEditingController(text: widget.product?['category'] as String? ?? '');
  late final _stock = TextEditingController(text: (widget.product?['stock'] as int?)?.toString() ?? '');
  late final _sizes = TextEditingController(text: _optionValues('المقاس'));
  late final _colors = TextEditingController(text: _optionValues('اللون'));

  String _optionValues(String name) {
    if (widget.product == null) return '';
    return StoreService.optionsOf(widget.product!).where((o) => o.name == name).map((o) => o.values.join('، ')).firstOrNull ?? '';
  }

  List<String> _split(String s) => s.split(RegExp(r'[,،\n]')).map((v) => v.trim()).where((v) => v.isNotEmpty).take(20).toList();
  late bool _available = widget.product?['is_available'] as bool? ?? true;
  bool _uploading = false;
  bool _thinking = false;
  bool _saving = false;
  String? _error;

  @override
  void dispose() {
    _name.dispose();
    _price.dispose();
    _oldPrice.dispose();
    _desc.dispose();
    _highlights.dispose();
    _category.dispose();
    _stock.dispose();
    _sizes.dispose();
    _colors.dispose();
    super.dispose();
  }

  Future<void> _addImage(ImageSource source) async {
    final room = _maxImages - _images.length;
    if (room <= 0) return;
    // Camera: one shot. Gallery: pick several at once.
    final files = source == ImageSource.camera
        ? [?await UploadService.pickImage(source: source)]
        : await UploadService.pickImages(limit: room);
    if (files.isEmpty) return;
    setState(() {
      _uploading = true;
      _error = null;
    });
    final results = await Future.wait(files.take(room).map((f) async {
      try {
        return await UploadService.uploadPublicPhoto(purpose: 'products', file: f);
      } catch (_) {
        return null;
      }
    }));
    if (!mounted) return;
    final ok = results.whereType<String>().toList();
    setState(() {
      _images.addAll(ok);
      _uploading = false;
      if (ok.length < results.length) _error = 'فيه ${results.length - ok.length} صورة مارفعتش، جرّب تاني';
    });
  }

  Future<void> _suggest() async {
    setState(() {
      _thinking = true;
      _error = null;
    });
    try {
      final s = await StoreService.suggestProductCopy(
        imageUrls: _images,
        name: _name.text.trim(),
        category: widget.shopCategory,
        notes: _desc.text.trim(),
      );
      if (!mounted) return;
      setState(() {
        if (s.name.isNotEmpty && _name.text.trim().isEmpty) _name.text = s.name;
        if (s.description.isNotEmpty) _desc.text = s.description;
        if (s.highlights.isNotEmpty) _highlights.text = s.highlights.join('\n');
      });
    } on FunctionException catch (e) {
      final details = e.details;
      if (mounted) setState(() => _error = details is Map && details['error'] is String ? details['error'] as String : 'الذكاء الاصطناعي مش متاح دلوقتي');
    } catch (e) {
      if (mounted) setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _thinking = false);
    }
  }

  Future<void> _save() async {
    final price = double.tryParse(_price.text.trim());
    final oldPrice = _oldPrice.text.trim().isEmpty ? null : double.tryParse(_oldPrice.text.trim());
    if (_name.text.trim().isEmpty || price == null || price < 0) {
      setState(() => _error = 'اكتب اسم المنتج وسعر صحيح');
      return;
    }
    if (oldPrice != null && oldPrice <= price) {
      setState(() => _error = 'السعر قبل الخصم لازم يكون أكبر من السعر الحالي');
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await StoreService.saveProduct(
        productId: widget.product?['id'] as String?,
        shopId: widget.shopId,
        name: _name.text.trim(),
        price: price,
        oldPrice: oldPrice,
        description: _desc.text.trim().isEmpty ? null : _desc.text.trim(),
        images: _images,
        highlights: _highlights.text.split('\n').map((s) => s.trim()).where((s) => s.isNotEmpty).take(6).toList(),
        category: _category.text.trim().isEmpty ? null : _category.text.trim(),
        stock: int.tryParse(_stock.text.trim()),
        options: [
          if (_split(_sizes.text).isNotEmpty) {'name': 'المقاس', 'values': _split(_sizes.text)},
          if (_split(_colors.text).isNotEmpty) {'name': 'اللون', 'values': _split(_colors.text)},
        ],
        isAvailable: _available,
      );
      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = _errorText(e, 'تعذر حفظ المنتج'));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Widget _photoStrip() {
    return SizedBox(
      height: 92,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          for (var i = 0; i < _images.length; i++)
            Padding(
              padding: const EdgeInsetsDirectional.only(end: 8),
              child: Stack(children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.network(_images[i], cacheWidth: 300, width: 92, height: 92, fit: BoxFit.cover),
                ),
                if (i == 0)
                  PositionedDirectional(
                    bottom: 4,
                    start: 4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(color: AppColors.gold, borderRadius: BorderRadius.circular(8)),
                      child: const Text('الغلاف', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: AppColors.night)),
                    ),
                  ),
                PositionedDirectional(
                  top: 2,
                  end: 2,
                  child: InkWell(
                    onTap: () => setState(() => _images.removeAt(i)),
                    child: const CircleAvatar(radius: 11, backgroundColor: Colors.black54, child: Icon(Icons.close_rounded, size: 14, color: Colors.white)),
                  ),
                ),
                if (i > 0)
                  PositionedDirectional(
                    bottom: 2,
                    end: 2,
                    child: InkWell(
                      onTap: () => setState(() => _images.insert(0, _images.removeAt(i))),
                      child: const CircleAvatar(radius: 11, backgroundColor: Colors.black54, child: Icon(Icons.star_rounded, size: 14, color: AppColors.gold)),
                    ),
                  ),
              ]),
            ),
          if (_images.length < _maxImages)
            Container(
              width: 92,
              decoration: BoxDecoration(
                color: AppColors.surfaceAlt,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              ),
              child: _uploading
                  ? const Center(child: CircularProgressIndicator(strokeWidth: 2))
                  : Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      IconButton(
                        visualDensity: VisualDensity.compact,
                        tooltip: 'صوّر بالكاميرا',
                        onPressed: () => _addImage(ImageSource.camera),
                        icon: const Icon(Icons.photo_camera_rounded, color: AppColors.crystal),
                      ),
                      IconButton(
                        visualDensity: VisualDensity.compact,
                        tooltip: 'من المعرض (كذا صورة مرة واحدة)',
                        onPressed: () => _addImage(ImageSource.gallery),
                        icon: const Icon(Icons.photo_library_rounded, color: AppColors.crystal),
                      ),
                    ]),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 16, 20, 20 + MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(widget.product == null ? 'منتج جديد' : 'تعديل المنتج', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
            const SizedBox(height: 4),
            Text('صور المنتج (لحد $_maxImages) — أول صورة هي الغلاف، ودوس ⭐ عشان تخلي صورة الغلاف',
                style: const TextStyle(color: AppColors.inkMuted, fontSize: 11.5)),
            const SizedBox(height: 10),
            _photoStrip(),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(gradient: AppColors.brandGradient, borderRadius: BorderRadius.circular(16)),
              child: Row(children: [
                const Icon(Icons.auto_awesome_rounded, color: AppColors.gold),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text('خلّي الذكاء الاصطناعي يكتب الاسم والوصف والمميزات من صور المنتج',
                      style: TextStyle(color: Colors.white, fontSize: 12.5, height: 1.5)),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.gold, foregroundColor: AppColors.night, padding: const EdgeInsets.symmetric(horizontal: 14)),
                  onPressed: _thinking || _uploading ? null : _suggest,
                  child: _thinking
                      ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.night))
                      : const Text('✨ اكتبلي'),
                ),
              ]),
            ),
            const SizedBox(height: 12),
            TextField(controller: _name, decoration: const InputDecoration(labelText: 'اسم المنتج *')),
            const SizedBox(height: 10),
            Row(children: [
              Expanded(
                child: TextField(
                  controller: _price,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(labelText: 'السعر بالجنيه *'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: _oldPrice,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(labelText: 'السعر قبل الخصم', hintText: 'اختياري'),
                ),
              ),
            ]),
            const SizedBox(height: 10),
            TextField(
              controller: _desc,
              maxLines: 5,
              minLines: 3,
              maxLength: 2000,
              decoration: const InputDecoration(labelText: 'وصف المنتج', hintText: 'اكتب ملاحظاتك هنا، أو دوس «اكتبلي»', alignLabelWithHint: true),
            ),
            Row(children: [
              Expanded(child: TextField(controller: _category, decoration: const InputDecoration(labelText: 'القسم', hintText: 'مثلاً: تيشيرتات'))),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: _stock,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'الكمية المتاحة', hintText: 'فاضية = مفتوحة'),
                ),
              ),
            ]),
            const SizedBox(height: 10),
            TextField(controller: _sizes, decoration: const InputDecoration(labelText: 'المقاسات (اختياري)', hintText: 'S، M، L، XL')),
            const SizedBox(height: 10),
            TextField(controller: _colors, decoration: const InputDecoration(labelText: 'الألوان (اختياري)', hintText: 'أسود، أبيض، كحلي')),
            const SizedBox(height: 10),
            TextField(
              controller: _highlights,
              maxLines: 4,
              minLines: 2,
              decoration: const InputDecoration(labelText: 'مميزات المنتج', hintText: 'كل ميزة في سطر، مثلاً: قطن 100%', alignLabelWithHint: true),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: _available,
              onChanged: (v) => setState(() => _available = v),
              title: const Text('ظاهر للزباين'),
            ),
            if (_error != null) Text(_error!, style: const TextStyle(color: Colors.redAccent, fontSize: 12)),
            const SizedBox(height: 10),
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: _saving || _uploading || _thinking ? null : _save,
                child: _saving ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Text('حفظ المنتج'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------
// Orders
// ---------------------------------------------------------------------

const _statusLabels = {
  'placed': 'طلب جديد',
  'preparing': 'بيتجهّز',
  'delivering': 'في الطريق',
  'delivered': 'اتسلّم',
  'cancelled': 'ملغي',
};

class _OrdersTab extends StatefulWidget {
  const _OrdersTab({super.key, required this.shopId});
  final String shopId;

  @override
  State<_OrdersTab> createState() => _OrdersTabState();
}

class _OrdersTabState extends State<_OrdersTab> {
  bool _loading = true;
  bool _loadError = false;
  List<Map<String, dynamic>> _orders = [];
  String? _filter = 'placed';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _loadError = false;
    });
    try {
      final orders = await StoreService.fetchShopOrders(widget.shopId);
      if (!mounted) return;
      setState(() {
        _orders = orders;
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

  Future<void> _setStatus(String orderId, String status) async {
    try {
      await StoreService.updateOrderStatus(orderId: orderId, status: status);
      _load();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(_errorText(e, 'تعذر تحديث الطلب'))));
    }
  }

  List<(String, String)> _nextActions(String status) => switch (status) {
        'placed' => [('preparing', 'ابدأ التجهيز'), ('cancelled', 'إلغاء')],
        'preparing' => [('delivering', 'خرج للتوصيل'), ('delivered', 'اتسلّم'), ('cancelled', 'إلغاء')],
        'delivering' => [('delivered', 'اتسلّم'), ('cancelled', 'إلغاء')],
        _ => const [],
      };

  @override
  Widget build(BuildContext context) {
    // Delivery: open the customer's digital address from the name, mobile
    // or code they gave the shop (every opening is shown to the customer).
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      SizedBox(
        height: 52,
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 2),
          children: [
            for (final (key, label) in const [('placed', 'جديدة'), ('preparing', 'بتتجهّز'), ('delivering', 'في الطريق'), ('delivered', 'اتسلّمت'), ('cancelled', 'ملغية'), (null, 'الكل')])
              Padding(
                padding: const EdgeInsetsDirectional.only(end: 8),
                child: ChoiceChip(
                  label: Text('$label (${_orders.where((o) => key == null || o['status'] == key).length})'),
                  selected: _filter == key,
                  onSelected: (_) => setState(() => _filter = key),
                ),
              ),
          ],
        ),
      ),
      Expanded(child: _ordersList()),
      const Padding(
        padding: EdgeInsets.fromLTRB(16, 4, 16, 12),
        child: EAddressLookupBox(title: 'عنوان زبون للتوصيل'),
      ),
    ]);
  }

  Widget _ordersList() {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_loadError) return LoadErrorView(onRetry: _load);
    final orders = _orders.where((o) => _filter == null || o['status'] == _filter).toList();
    if (orders.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(_orders.isEmpty ? 'لسه مفيش طلبات. شارك رابط متجرك ومنتجاتك على واتساب وفيسبوك.' : 'مفيش طلبات هنا',
              textAlign: TextAlign.center, style: const TextStyle(color: AppColors.inkMuted, height: 1.6)),
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: _load,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: orders.length,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (context, i) {
          final o = orders[i];
          final status = o['status'] as String? ?? 'placed';
          final items = List<Map<String, dynamic>>.from(o['items'] as List? ?? const []);
          final phone = o['customer_phone'] as String?;
          final createdAt = DateTime.tryParse(o['created_at'] as String? ?? '')?.toLocal();
          return Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: status == 'placed' ? AppColors.gold : AppColors.border)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Text(_statusLabels[status] ?? status, style: TextStyle(fontWeight: FontWeight.w800, color: status == 'placed' ? AppColors.gold : AppColors.inkSecondary)),
                const Spacer(),
                Text(_money((o['total_amount'] as num?) ?? 0), style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.teal)),
              ]),
              if (createdAt != null)
                Text('${o['order_code'] != null ? 'طلب ${o['order_code']} • ' : ''}${DateFormat('d/M – h:mm a').format(createdAt)}',
                    style: const TextStyle(fontSize: 10.5, color: AppColors.inkMuted)),
              if (o['customer_name'] != null) ...[
                const SizedBox(height: 6),
                Text('👤 ${o['customer_name']}', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
              ],
              if (o['delivery_address'] != null)
                Text('📍 ${o['delivery_address']}', style: const TextStyle(fontSize: 12, color: AppColors.inkSecondary, height: 1.5)),
              const SizedBox(height: 8),
              for (final it in items)
                Text(
                  '• ${(it['product'] as Map?)?['name'] ?? ''}${(it['chosen_options'] as String?)?.isNotEmpty ?? false ? ' (${it['chosen_options']})' : ''} × ${it['quantity']}',
                  style: const TextStyle(fontSize: 12.5),
                ),
              if (((o['delivery_fee'] as num?) ?? 0) > 0)
                Text('🚚 التوصيل: ${_money(o['delivery_fee'] as num)} (داخل الإجمالي)', style: const TextStyle(fontSize: 12, color: AppColors.inkSecondary)),
              if (o['note'] != null) ...[
                const SizedBox(height: 6),
                Text('ملاحظات: ${o['note']}', style: const TextStyle(fontSize: 11.5, color: AppColors.inkSecondary)),
              ],
              if (phone != null) ...[
                const SizedBox(height: 8),
                Row(children: [
                  OutlinedButton.icon(onPressed: () => launchUrl(Uri.parse('tel:$phone')), icon: const Icon(Icons.call_rounded, size: 16), label: Text(phone)),
                  const SizedBox(width: 8),
                  OutlinedButton.icon(
                    onPressed: () => launchUrl(Uri.parse('https://wa.me/2$phone'), mode: LaunchMode.externalApplication),
                    icon: const Icon(Icons.chat_rounded, size: 16),
                    label: const Text('واتساب'),
                  ),
                ]),
              ],
              if (_nextActions(status).isNotEmpty) ...[
                const SizedBox(height: 8),
                Wrap(spacing: 8, children: [
                  for (final (next, label) in _nextActions(status))
                    next == 'cancelled'
                        ? TextButton(onPressed: () => _setStatus(o['id'] as String, next), child: Text(label, style: const TextStyle(color: AppColors.categorySos)))
                        : ElevatedButton(onPressed: () => _setStatus(o['id'] as String, next), child: Text(label)),
                ]),
              ],
            ]),
          );
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------
// My store: link, QR, visits
// ---------------------------------------------------------------------

class _MyStoreTab extends StatefulWidget {
  const _MyStoreTab({super.key, required this.shop, required this.onChanged});
  final Map<String, dynamic> shop;
  final VoidCallback onChanged;

  @override
  State<_MyStoreTab> createState() => _MyStoreTabState();
}

class _MyStoreTabState extends State<_MyStoreTab> {
  late final _slug = TextEditingController(text: widget.shop['slug'] as String? ?? '');
  late final _whatsapp = TextEditingController(text: widget.shop['whatsapp'] as String? ?? '');
  bool _saving = false;

  @override
  void dispose() {
    _slug.dispose();
    _whatsapp.dispose();
    super.dispose();
  }

  Future<void> _saveLink() async {
    setState(() => _saving = true);
    try {
      await StoreService.updateShopLink(shopId: widget.shop['id'] as String, slug: _slug.text, whatsapp: _whatsapp.text);
      widget.onChanged();
    } catch (e) {
      if (!mounted) return;
      final msg = e is PostgrestException && e.code == '23505'
          ? 'اسم الرابط ده مستخدم، جرّب اسم تاني'
          : 'تأكد إن اسم الرابط بالإنجليزي (3–40 حرف) ورقم الواتساب صحيح';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final slug = widget.shop['slug'] as String?;
    final hasLink = slug != null && slug.isNotEmpty && (widget.shop['whatsapp'] as String?)?.isNotEmpty == true;

    if (!hasLink) {
      return ListView(padding: const EdgeInsets.all(16), children: [
        const Text('اختار رابط محلك ورقم الواتساب عشان تبدأ تستقبل طلبات', style: TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: 12),
        TextField(controller: _slug, textDirection: TextDirection.ltr, decoration: const InputDecoration(labelText: 'اسم الرابط بالإنجليزي', hintText: 'elsalam')),
        const SizedBox(height: 10),
        TextField(controller: _whatsapp, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'رقم الواتساب', hintText: '01xxxxxxxxx')),
        const SizedBox(height: 16),
        ElevatedButton(onPressed: _saving ? null : _saveLink, child: const Text('حفظ')),
      ]);
    }

    final url = StoreService.storeUrl(slug);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _StoreProfileCard(shop: widget.shop, onSaved: widget.onChanged),
        const SizedBox(height: 14),
        _DeliveryCard(shop: widget.shop, onSaved: widget.onChanged),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
          child: Column(children: [
            const Text('علّق الكود ده على واجهة المحل', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
            const SizedBox(height: 12),
            SizedBox(width: 220, height: 220, child: QrImageView(data: url, backgroundColor: Colors.white, eyeStyle: const QrEyeStyle(color: AppColors.navy), dataModuleStyle: const QrDataModuleStyle(color: AppColors.navy))),
            const SizedBox(height: 8),
            SelectableText(url, textDirection: TextDirection.ltr, style: const TextStyle(color: AppColors.teal, fontWeight: FontWeight.w700)),
            const SizedBox(height: 10),
            Wrap(spacing: 8, alignment: WrapAlignment.center, children: [
              OutlinedButton.icon(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: url));
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم نسخ الرابط')));
                },
                icon: const Icon(Icons.copy_rounded, size: 16),
                label: const Text('انسخ الرابط'),
              ),
              OutlinedButton.icon(
                onPressed: () => launchUrl(Uri.parse('https://wa.me/?text=${Uri.encodeComponent('اطلب من ${widget.shop['name']} أونلاين: $url')}'), mode: LaunchMode.externalApplication),
                icon: const Icon(Icons.share_rounded, size: 16),
                label: const Text('شارك على واتساب'),
              ),
            ]),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => StoreQrCardScreen(shopName: widget.shop['name'] as String? ?? '', slug: slug, url: url),
                )),
                icon: const Icon(Icons.print_rounded, size: 18),
                label: const Text('تحميل / طباعة الـ QR'),
              ),
            ),
          ]),
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: AppColors.navy, borderRadius: BorderRadius.circular(16)),
          child: Row(children: [
            const Icon(Icons.qr_code_scanner_rounded, color: AppColors.gold),
            const SizedBox(width: 10),
            const Expanded(child: Text('عدد مرات فتح متجرك', style: TextStyle(color: Colors.white70))),
            Text('${widget.shop['scan_count'] ?? 0}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 22)),
          ]),
        ),
        const SizedBox(height: 14),
        OutlinedButton.icon(
          onPressed: () => launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication),
          icon: const Icon(Icons.open_in_new_rounded, size: 16),
          label: const Text('شوف متجرك زي الزبون'),
        ),
      ],
    );
  }
}

/// Account menu of the stand-alone merchant app (tajer.mogtama3y.com).
class _TajerAccountMenu extends StatelessWidget {
  const _TajerAccountMenu();

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.account_circle_outlined),
      onSelected: (v) {
        switch (v) {
          case 'profile':
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ProfileScreen()));
          case 'support':
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SupportContactScreen()));
          case 'mogtama3y':
            launchUrl(Uri.parse(mogtama3yUrl), webOnlyWindowName: '_self');
          case 'logout':
            AuthService.signOut();
        }
      },
      itemBuilder: (_) => const [
        PopupMenuItem(value: 'profile', child: Text('حسابي')),
        PopupMenuItem(value: 'support', child: Text('الدعم والمساعدة')),
        PopupMenuItem(value: 'mogtama3y', child: Text('زور مُجتمعي')),
        PopupMenuItem(value: 'logout', child: Text('تسجيل الخروج')),
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill(this.text, this.color, this.ink);
  final String text;
  final Color color;
  final Color ink;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(10)),
        child: Text(text, style: TextStyle(color: ink, fontSize: 11, fontWeight: FontWeight.w800)),
      );
}

// ---------------------------------------------------------------------
// Home: today's numbers, best sellers, quick actions
// ---------------------------------------------------------------------

class _HomeTab extends StatefulWidget {
  const _HomeTab({super.key, required this.shop, required this.onGoTo});
  final Map<String, dynamic> shop;
  final ValueChanged<int> onGoTo;

  @override
  State<_HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<_HomeTab> {
  Map<String, dynamic>? _stats;
  bool _error = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _error = false);
    try {
      final s = await StoreService.shopStats(widget.shop['id'] as String);
      if (mounted) setState(() => _stats = s);
    } catch (_) {
      if (mounted) setState(() => _error = true);
    }
  }

  Widget _stat(String label, String value, IconData icon, {VoidCallback? onTap, bool highlight = false}) => Expanded(
        child: Material(
          color: highlight ? AppColors.gold : AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Icon(icon, color: highlight ? AppColors.night : AppColors.crystal),
                const SizedBox(height: 8),
                Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: highlight ? AppColors.night : AppColors.ink)),
                Text(label, style: TextStyle(fontSize: 12, color: highlight ? AppColors.night : AppColors.inkMuted)),
              ]),
            ),
          ),
        ),
      );

  void _shareStore(String slug) {
    final text = 'اتفرّج على منتجات ${widget.shop['name']} واطلب أونلاين والدفع عند الاستلام:\n${StoreService.storeUrl(slug)}';
    launchUrl(Uri.parse('https://wa.me/?text=${Uri.encodeComponent(text)}'), mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    if (_error) return LoadErrorView(onRetry: _load);
    final s = _stats;
    if (s == null) return const Center(child: CircularProgressIndicator());
    final slug = widget.shop['slug'] as String?;
    final newOrders = (s['new_orders'] as num?)?.toInt() ?? 0;
    final top = List<Map<String, dynamic>>.from(s['top_products'] as List? ?? const []);

    return RefreshIndicator(
      onRefresh: _load,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (isTajerApp) const InstallAppBanner(),
          const PushOptInCard(),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(gradient: AppColors.brandGradient, borderRadius: BorderRadius.circular(22)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('مبيعات النهارده', style: TextStyle(color: Colors.white70)),
              Text(_money((s['sales_today'] as num?) ?? 0), style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w800)),
              const SizedBox(height: 4),
              Text('${s['orders_today']} طلب النهارده • ${_money((s['sales_30d'] as num?) ?? 0)} آخر 30 يوم',
                  style: const TextStyle(color: AppColors.gold, fontSize: 12.5)),
            ]),
          ),
          const SizedBox(height: 12),
          Row(children: [
            _stat('طلبات جديدة', '$newOrders', Icons.notifications_active_rounded, highlight: newOrders > 0, onTap: () => widget.onGoTo(2)),
            const SizedBox(width: 10),
            _stat('زيارات المتجر', '${s['visits']}', Icons.visibility_rounded),
          ]),
          const SizedBox(height: 10),
          Row(children: [
            _stat('طلبات آخر 30 يوم', '${s['orders_30d']}', Icons.receipt_long_rounded, onTap: () => widget.onGoTo(2)),
            const SizedBox(width: 10),
            _stat('المنتجات', '${s['products']}', Icons.inventory_2_rounded, onTap: () => widget.onGoTo(1)),
          ]),
          const SizedBox(height: 16),
          const Text('بيع أكتر', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
          const SizedBox(height: 8),
          Row(children: [
            Expanded(
              child: ElevatedButton.icon(onPressed: () => widget.onGoTo(1), icon: const Icon(Icons.add_rounded), label: const Text('أضف منتج')),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: slug == null ? () => widget.onGoTo(3) : () => _shareStore(slug),
                icon: const Icon(Icons.share_rounded),
                label: const Text('شارك متجرك'),
              ),
            ),
          ]),
          if (top.isNotEmpty) ...[
            const SizedBox(height: 18),
            const Text('الأكثر مبيعاً (30 يوم)', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
            const SizedBox(height: 6),
            for (final (i, t) in top.indexed)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(backgroundColor: AppColors.surfaceAlt, child: Text('${i + 1}', style: const TextStyle(fontWeight: FontWeight.w800))),
                title: Text(t['name'] as String? ?? ''),
                trailing: Text('${t['sold']} قطعة', style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.crystal)),
              ),
          ],
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------
// Store profile: name, description, logo, cover
// ---------------------------------------------------------------------

class _StoreProfileCard extends StatefulWidget {
  const _StoreProfileCard({required this.shop, required this.onSaved});
  final Map<String, dynamic> shop;
  final VoidCallback onSaved;

  @override
  State<_StoreProfileCard> createState() => _StoreProfileCardState();
}

class _StoreProfileCardState extends State<_StoreProfileCard> {
  late final _name = TextEditingController(text: widget.shop['name'] as String? ?? '');
  late final _desc = TextEditingController(text: widget.shop['description'] as String? ?? '');
  late String? _logo = widget.shop['logo_url'] as String?;
  late String? _cover = widget.shop['cover_image_url'] as String?;
  bool _busy = false;

  @override
  void dispose() {
    _name.dispose();
    _desc.dispose();
    super.dispose();
  }

  Future<String?> _pick() async {
    final file = await UploadService.pickImage(source: ImageSource.gallery);
    if (file == null) return null;
    setState(() => _busy = true);
    try {
      return await UploadService.uploadPublicPhoto(purpose: 'products', file: file);
    } catch (_) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تعذر رفع الصورة')));
      return null;
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _pickCover() async {
    final url = await _pick();
    if (url != null) setState(() => _cover = url);
  }

  Future<void> _pickLogo() async {
    final url = await _pick();
    if (url != null) setState(() => _logo = url);
  }

  Future<void> _save() async {
    setState(() => _busy = true);
    try {
      await StoreService.updateShopProfile(
        shopId: widget.shop['id'] as String,
        name: _name.text.trim(),
        description: _desc.text.trim(),
        logoUrl: _logo,
        coverUrl: _cover,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('اتحفظ شكل متجرك')));
      widget.onSaved();
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(_errorText(e, 'تعذر الحفظ'))));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(18), border: Border.all(color: AppColors.border)),
      clipBehavior: Clip.antiAlias,
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        InkWell(
          onTap: _busy ? null : _pickCover,
          child: SizedBox(
            height: 130,
            child: Stack(fit: StackFit.expand, children: [
              if (_cover == null)
                const DecoratedBox(decoration: BoxDecoration(gradient: AppColors.brandGradient))
              else
                Image.network(_cover!, fit: BoxFit.cover),
              const PositionedDirectional(bottom: 8, end: 8, child: _Pill('📷 غيّر الغلاف', Colors.black54, Colors.white)),
            ]),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(14),
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Row(children: [
              InkWell(
                onTap: _busy ? null : _pickLogo,
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceAlt,
                    borderRadius: BorderRadius.circular(16),
                    image: _logo != null ? DecorationImage(image: NetworkImage(_logo!), fit: BoxFit.cover) : null,
                  ),
                  child: _logo == null ? const Icon(Icons.add_photo_alternate_outlined, color: AppColors.inkMuted) : null,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(child: Text('لوجو وغلاف متجرك بيظهروا للزبون أول ما يفتح المتجر', style: TextStyle(fontSize: 12, color: AppColors.inkMuted))),
            ]),
            const SizedBox(height: 12),
            TextField(controller: _name, decoration: const InputDecoration(labelText: 'اسم المتجر')),
            const SizedBox(height: 10),
            TextField(
              controller: _desc,
              maxLines: 3,
              minLines: 2,
              decoration: const InputDecoration(labelText: 'وصف المتجر', hintText: 'بتبيع إيه؟ بتوصّل فين؟ مواعيدك؟', alignLabelWithHint: true),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _busy ? null : _save,
              child: _busy ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('حفظ شكل المتجر'),
            ),
          ]),
        ),
      ]),
    );
  }
}

// ---------------------------------------------------------------------
// Delivery fee (added to every order total, shown to customers)
// ---------------------------------------------------------------------

class _DeliveryCard extends StatefulWidget {
  const _DeliveryCard({required this.shop, required this.onSaved});
  final Map<String, dynamic> shop;
  final VoidCallback onSaved;

  @override
  State<_DeliveryCard> createState() => _DeliveryCardState();
}

class _DeliveryCardState extends State<_DeliveryCard> {
  late final _fee = TextEditingController(text: _num(widget.shop['delivery_fee']));
  late final _freeOver = TextEditingController(text: _num(widget.shop['free_delivery_over']));
  bool _busy = false;

  static String _num(Object? v) {
    final d = (v as num?)?.toDouble();
    if (d == null || d == 0) return '';
    return d == d.roundToDouble() ? '${d.toInt()}' : '$d';
  }

  @override
  void dispose() {
    _fee.dispose();
    _freeOver.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final fee = _fee.text.trim().isEmpty ? 0.0 : double.tryParse(_fee.text.trim());
    final freeOver = _freeOver.text.trim().isEmpty ? null : double.tryParse(_freeOver.text.trim());
    if (fee == null || fee < 0 || (_freeOver.text.trim().isNotEmpty && (freeOver == null || freeOver <= 0))) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('اكتب أرقام صحيحة')));
      return;
    }
    setState(() => _busy = true);
    try {
      await StoreService.setShopDelivery(shopId: widget.shop['id'] as String, fee: fee, freeOver: freeOver);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('اتحفظت قيمة التوصيل')));
      widget.onSaved();
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(_errorText(e, 'تعذر الحفظ'))));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(18), border: Border.all(color: AppColors.border)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        const Row(children: [
          Icon(Icons.local_shipping_rounded, color: AppColors.crystal),
          SizedBox(width: 8),
          Text('التوصيل', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
        ]),
        const SizedBox(height: 4),
        const Text('بيتضاف على إجمالي كل طلب، والزبون بيشوفه قبل ما يطلب.', style: TextStyle(fontSize: 12, color: AppColors.inkMuted)),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(
            child: TextField(
              controller: _fee,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'قيمة التوصيل (ج.م)', hintText: 'فاضية = مجاني'),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _freeOver,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'مجاني لو الطلب فوق', hintText: 'اختياري'),
            ),
          ),
        ]),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: _busy ? null : _save,
          child: _busy ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('حفظ التوصيل'),
        ),
      ]),
    );
  }
}
