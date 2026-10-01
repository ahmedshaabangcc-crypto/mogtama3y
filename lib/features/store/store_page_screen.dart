import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/auth/auth_service.dart';
import '../../core/shops/store_service.dart';
import '../../core/theme/app_colors.dart';
import '../auth/auth_landing_screen.dart';
import '../shared/load_error_view.dart';

/// A merchant's public store at `mogtama3y.com/#/s/<slug>` — what opens
/// when a customer scans the QR on the shop. Browsing needs no account;
/// ordering does (the order is recorded for the merchant and also sent
/// to the shop on WhatsApp).
class StorePageScreen extends StatefulWidget {
  const StorePageScreen({super.key, required this.slug});
  final String slug;

  @override
  State<StorePageScreen> createState() => _StorePageScreenState();
}

class _StorePageScreenState extends State<StorePageScreen> {
  bool _loading = true;
  bool _loadError = false;
  Map<String, dynamic>? _shop;
  List<Map<String, dynamic>> _products = [];
  final Map<String, int> _cart = {};

  @override
  void initState() {
    super.initState();
    StoreService.recordScan(widget.slug);
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _loadError = false;
    });
    try {
      final shop = await StoreService.fetchStoreBySlug(widget.slug);
      final products = shop == null ? <Map<String, dynamic>>[] : await StoreService.fetchProducts(shop['id'] as String);
      if (!mounted) return;
      setState(() {
        _shop = shop;
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

  double get _total {
    var total = 0.0;
    for (final p in _products) {
      total += ((p['price'] as num?)?.toDouble() ?? 0) * (_cart[p['id']] ?? 0);
    }
    return total;
  }

  int get _itemCount => _cart.values.fold(0, (a, b) => a + b);

  void _changeQty(String productId, int delta) {
    setState(() {
      final q = (_cart[productId] ?? 0) + delta;
      if (q <= 0) {
        _cart.remove(productId);
      } else {
        _cart[productId] = q.clamp(1, 99);
      }
    });
  }

  String _money(num v) => '${NumberFormat('#,##0.##').format(v)} ج.م';

  Future<void> _checkout() async {
    if (!AuthService.isSignedIn) {
      await Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AuthLandingScreen()));
      if (!AuthService.isSignedIn || !mounted) return;
    }
    final profile = await AuthService.fetchCurrentProfile();
    if (!mounted) return;
    final phoneCtrl = TextEditingController(text: profile?['phone'] as String? ?? '');
    final noteCtrl = TextEditingController();
    final confirmed = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (sheetContext) => Padding(
        padding: EdgeInsets.fromLTRB(20, 16, 20, 20 + MediaQuery.of(sheetContext).viewInsets.bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('تأكيد الطلب', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
            const SizedBox(height: 6),
            Text('$_itemCount منتج — الإجمالي ${_money(_total)}', style: const TextStyle(fontSize: 12.5, color: AppColors.inkSecondary)),
            const SizedBox(height: 14),
            TextField(controller: phoneCtrl, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'رقم موبايلك (عشان المحل يتواصل معاك)')),
            const SizedBox(height: 10),
            TextField(controller: noteCtrl, maxLines: 2, decoration: const InputDecoration(labelText: 'ملاحظات أو عنوان التوصيل (اختياري)')),
            const SizedBox(height: 10),
            const Text('الدفع والتوصيل بيتفق عليهم مع المحل مباشرة. هيتفتح واتساب برسالة الطلب عشان تبعتها للمحل.',
                style: TextStyle(fontSize: 10.5, color: AppColors.inkMuted, height: 1.6)),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () => Navigator.of(sheetContext).pop(true),
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.teal, foregroundColor: Colors.white),
                child: const Text('اطلب وابعت للمحل على واتساب'),
              ),
            ),
          ],
        ),
      ),
    );
    final phone = phoneCtrl.text.trim();
    final note = noteCtrl.text.trim();
    phoneCtrl.dispose();
    noteCtrl.dispose();
    if (confirmed != true || !mounted) return;

    final shop = _shop!;
    try {
      await StoreService.placeOrder(shopId: shop['id'] as String, items: Map.of(_cart), customerPhone: phone, note: note);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e is PostgrestException ? e.message : 'تعذر إرسال الطلب، حاول مرة أخرى')));
      return;
    }

    final lines = [
      'طلب جديد من مُجتمعي 🛒',
      for (final p in _products)
        if ((_cart[p['id']] ?? 0) > 0) '• ${p['name']} × ${_cart[p['id']]} = ${_money(((p['price'] as num?) ?? 0) * _cart[p['id']]!)}',
      'الإجمالي: ${_money(_total)}',
      'موبايلي: $phone',
      if (note.isNotEmpty) 'ملاحظات: $note',
    ];
    final whatsapp = shop['whatsapp'] as String?;
    if (whatsapp != null && whatsapp.isNotEmpty) {
      await StoreService.openWhatsAppOrder(shopWhatsapp: whatsapp, message: lines.join('\n'));
    }
    if (!mounted) return;
    setState(_cart.clear);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم إرسال طلبك للمحل، وهيوصلك إشعار بكل تحديث')));
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    if (_loadError) {
      return Scaffold(backgroundColor: AppColors.bg, appBar: AppBar(title: const Text('المتجر')), body: LoadErrorView(onRetry: _load));
    }
    final shop = _shop;
    if (shop == null) {
      return Scaffold(
        backgroundColor: AppColors.bg,
        appBar: AppBar(title: const Text('المتجر')),
        body: const Center(child: Text('المتجر ده مش موجود أو الرابط اتغيّر', style: TextStyle(color: AppColors.inkMuted))),
      );
    }
    final acceptsOrders = shop['owner_id'] != null;

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: Text(shop['name'] as String? ?? 'المتجر')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 110),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: AppColors.navy, borderRadius: BorderRadius.circular(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(shop['name'] as String? ?? '', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 18)),
                if (shop['category'] != null) ...[
                  const SizedBox(height: 4),
                  Text(shop['category'] as String, style: const TextStyle(color: Colors.white70, fontSize: 12)),
                ],
                if (shop['address'] != null) ...[
                  const SizedBox(height: 8),
                  Row(children: [
                    const Icon(Icons.location_on_outlined, size: 14, color: AppColors.gold),
                    const SizedBox(width: 4),
                    Expanded(child: Text(shop['address'] as String, style: const TextStyle(color: Colors.white70, fontSize: 11.5))),
                  ]),
                ],
                if (shop['description'] != null && (shop['description'] as String).isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(shop['description'] as String, style: const TextStyle(color: Colors.white, fontSize: 12, height: 1.6)),
                ],
              ],
            ),
          ),
          const SizedBox(height: 18),
          Text('المنتجات (${_products.length})', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
          const SizedBox(height: 10),
          if (_products.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 30),
              child: Center(child: Text('المحل لسه مضافش منتجات', style: TextStyle(color: AppColors.inkMuted))),
            )
          else
            for (final p in _products) ...[
              _ProductTile(
                product: p,
                quantity: _cart[p['id']] ?? 0,
                canOrder: acceptsOrders,
                onAdd: () => _changeQty(p['id'] as String, 1),
                onRemove: () => _changeQty(p['id'] as String, -1),
              ),
              const SizedBox(height: 10),
            ],
        ],
      ),
      bottomSheet: _itemCount == 0
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _checkout,
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.teal, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                    child: Text('اطلب $_itemCount منتج — ${_money(_total)}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                  ),
                ),
              ),
            ),
    );
  }
}

class _ProductTile extends StatelessWidget {
  const _ProductTile({required this.product, required this.quantity, required this.canOrder, required this.onAdd, required this.onRemove});
  final Map<String, dynamic> product;
  final int quantity;
  final bool canOrder;
  final VoidCallback onAdd, onRemove;

  @override
  Widget build(BuildContext context) {
    final image = product['image_url'] as String?;
    final price = (product['price'] as num?) ?? 0;
    final placeholder = Container(width: 64, height: 64, color: AppColors.surfaceAlt, child: const Icon(Icons.inventory_2_outlined, color: AppColors.inkMuted));
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
      child: Row(children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: image == null ? placeholder : Image.network(image, width: 64, height: 64, fit: BoxFit.cover, errorBuilder: (_, _, _) => placeholder),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(product['name'] as String? ?? '', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
            if (product['description'] != null && (product['description'] as String).isNotEmpty)
              Text(product['description'] as String, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 10.5, color: AppColors.inkMuted)),
            const SizedBox(height: 4),
            Text('${NumberFormat('#,##0.##').format(price)} ج.م', style: const TextStyle(color: AppColors.teal, fontWeight: FontWeight.w800, fontSize: 13)),
          ]),
        ),
        if (canOrder)
          quantity == 0
              ? IconButton.filled(onPressed: onAdd, icon: const Icon(Icons.add_rounded), style: IconButton.styleFrom(backgroundColor: AppColors.teal))
              : Row(mainAxisSize: MainAxisSize.min, children: [
                  IconButton(onPressed: onRemove, icon: const Icon(Icons.remove_circle_outline_rounded, color: AppColors.inkSecondary)),
                  Text('$quantity', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                  IconButton(onPressed: onAdd, icon: const Icon(Icons.add_circle_rounded, color: AppColors.teal)),
                ]),
      ]),
    );
  }
}
