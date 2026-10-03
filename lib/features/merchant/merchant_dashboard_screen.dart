import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:qr_flutter/qr_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/auth/auth_service.dart';
import '../../core/shops/store_service.dart';
import '../../core/storage/upload_service.dart';
import '../../core/theme/app_colors.dart';
import '../auth/auth_landing_screen.dart';
import '../e_address/e_address_widgets.dart';
import '../shared/load_error_view.dart';

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
        appBar: AppBar(title: const Text('سجّل محلك')),
        body: _RegisterShopForm(onCreated: _load),
      );
    }

    final shop = _shops[_selected];
    return DefaultTabController(
      length: 3,
      child: Scaffold(
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
          bottom: const TabBar(tabs: [Tab(text: 'المنتجات'), Tab(text: 'الطلبات'), Tab(text: 'متجري')]),
        ),
        body: TabBarView(
          children: [
            _ProductsTab(key: ValueKey('p${shop['id']}'), shopId: shop['id'] as String),
            _OrdersTab(key: ValueKey('o${shop['id']}'), shopId: shop['id'] as String),
            _MyStoreTab(key: ValueKey('s${shop['id']}'), shop: shop, onChanged: _load),
          ],
        ),
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
  String _category = StoreService.categories.first;
  bool _saving = false;
  String? _error;

  @override
  void dispose() {
    _name.dispose();
    _slug.dispose();
    _whatsapp.dispose();
    _address.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await StoreService.createMyShop(
        name: _name.text.trim(),
        category: _category,
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
          items: [for (final c in StoreService.categories) DropdownMenuItem(value: c, child: Text(c))],
          onChanged: (v) => setState(() => _category = v ?? _category),
        ),
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
  const _ProductsTab({super.key, required this.shopId});
  final String shopId;

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
      builder: (_) => _ProductEditor(shopId: widget.shopId, product: product),
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
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: Text('لسه مفيش منتجات. دوس "أضف منتج" وضيف أول منتج بصورة وسعر.', textAlign: TextAlign.center, style: TextStyle(color: AppColors.inkMuted, height: 1.6)),
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _load,
                      child: ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
                        itemCount: _products.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 10),
                        itemBuilder: (context, i) {
                          final p = _products[i];
                          final available = p['is_available'] == true;
                          final image = p['image_url'] as String?;
                          return Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
                            child: Row(children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: image == null
                                    ? Container(width: 56, height: 56, color: AppColors.surfaceAlt, child: const Icon(Icons.inventory_2_outlined, color: AppColors.inkMuted))
                                    : Image.network(image, width: 56, height: 56, fit: BoxFit.cover),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  Text(p['name'] as String? ?? '', style: const TextStyle(fontWeight: FontWeight.w700)),
                                  Text(_money((p['price'] as num?) ?? 0), style: const TextStyle(color: AppColors.teal, fontWeight: FontWeight.w700, fontSize: 12.5)),
                                  if (!available) const Text('مخفي عن الزباين', style: TextStyle(fontSize: 10.5, color: AppColors.categorySos)),
                                ]),
                              ),
                              IconButton(onPressed: () => _edit(p), icon: const Icon(Icons.edit_outlined)),
                              IconButton(onPressed: () => _delete(p), icon: const Icon(Icons.delete_outline_rounded, color: AppColors.categorySos)),
                            ]),
                          );
                        },
                      ),
                    ),
    );
  }
}

class _ProductEditor extends StatefulWidget {
  const _ProductEditor({required this.shopId, this.product});
  final String shopId;
  final Map<String, dynamic>? product;

  @override
  State<_ProductEditor> createState() => _ProductEditorState();
}

class _ProductEditorState extends State<_ProductEditor> {
  late final _name = TextEditingController(text: widget.product?['name'] as String? ?? '');
  late final _price = TextEditingController(text: (widget.product?['price'] as num?)?.toString() ?? '');
  late final _desc = TextEditingController(text: widget.product?['description'] as String? ?? '');
  late String? _imageUrl = widget.product?['image_url'] as String?;
  late bool _available = widget.product?['is_available'] as bool? ?? true;
  bool _uploading = false;
  bool _saving = false;
  String? _error;

  @override
  void dispose() {
    _name.dispose();
    _price.dispose();
    _desc.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final file = await UploadService.pickImage(source: source);
    if (file == null) return;
    setState(() => _uploading = true);
    try {
      final url = await UploadService.uploadPublicPhoto(purpose: 'products', file: file);
      if (!mounted) return;
      setState(() => _imageUrl = url);
    } catch (_) {
      if (!mounted) return;
      setState(() => _error = 'تعذر رفع الصورة، حاول مرة أخرى');
    } finally {
      if (mounted) setState(() => _uploading = false);
    }
  }

  Future<void> _save() async {
    final price = double.tryParse(_price.text.trim());
    if (_name.text.trim().isEmpty || price == null || price < 0) {
      setState(() => _error = 'اكتب اسم المنتج وسعر صحيح');
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
        description: _desc.text.trim().isEmpty ? null : _desc.text.trim(),
        imageUrl: _imageUrl,
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
            const SizedBox(height: 12),
            Row(children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: _imageUrl == null
                    ? Container(width: 80, height: 80, color: AppColors.surfaceAlt, child: _uploading ? const Center(child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.add_a_photo_outlined, color: AppColors.inkMuted))
                    : Image.network(_imageUrl!, width: 80, height: 80, fit: BoxFit.cover),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                  OutlinedButton.icon(onPressed: _uploading ? null : () => _pickImage(ImageSource.camera), icon: const Icon(Icons.photo_camera_outlined, size: 16), label: const Text('صوّر المنتج')),
                  OutlinedButton.icon(onPressed: _uploading ? null : () => _pickImage(ImageSource.gallery), icon: const Icon(Icons.photo_library_outlined, size: 16), label: const Text('من المعرض')),
                ]),
              ),
            ]),
            const SizedBox(height: 12),
            TextField(controller: _name, decoration: const InputDecoration(labelText: 'اسم المنتج *')),
            const SizedBox(height: 10),
            TextField(controller: _price, keyboardType: const TextInputType.numberWithOptions(decimal: true), decoration: const InputDecoration(labelText: 'السعر بالجنيه *')),
            const SizedBox(height: 10),
            TextField(controller: _desc, maxLines: 2, decoration: const InputDecoration(labelText: 'وصف قصير (اختياري)')),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: _available,
              onChanged: (v) => setState(() => _available = v),
              title: const Text('ظاهر للزباين'),
            ),
            if (_error != null) Text(_error!, style: const TextStyle(color: Colors.redAccent, fontSize: 12)),
            const SizedBox(height: 10),
            SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: _saving || _uploading ? null : _save,
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.teal, foregroundColor: Colors.white),
                child: const Text('حفظ'),
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
      const Padding(
        padding: EdgeInsets.fromLTRB(16, 12, 16, 0),
        child: EAddressLookupBox(title: 'عنوان زبون للتوصيل'),
      ),
      Expanded(child: _ordersList()),
    ]);
  }

  Widget _ordersList() {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_loadError) return LoadErrorView(onRetry: _load);
    if (_orders.isEmpty) {
      return const Center(child: Padding(padding: EdgeInsets.all(24), child: Text('لسه مفيش طلبات. شارك رابط متجرك وعلّق الـ QR على المحل.', textAlign: TextAlign.center, style: TextStyle(color: AppColors.inkMuted, height: 1.6))));
    }
    return RefreshIndicator(
      onRefresh: _load,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _orders.length,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (context, i) {
          final o = _orders[i];
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
              if (createdAt != null) Text(DateFormat('d/M – h:mm a').format(createdAt), style: const TextStyle(fontSize: 10.5, color: AppColors.inkMuted)),
              const SizedBox(height: 8),
              for (final it in items)
                Text('• ${(it['product'] as Map?)?['name'] ?? ''} × ${it['quantity']}', style: const TextStyle(fontSize: 12.5)),
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
