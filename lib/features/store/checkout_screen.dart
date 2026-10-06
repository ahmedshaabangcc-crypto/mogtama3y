import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/auth/auth_service.dart';
import '../../core/e_address/e_address_service.dart';
import '../../core/shops/store_service.dart';
import '../../core/theme/app_colors.dart';
import 'order_tracking_screen.dart';
import 'store_cart.dart';
import '../legal/privacy_policy_screen.dart';

/// Cart + checkout: no account needed — name, mobile, address, cash on
/// delivery. Signed-in customers can fill the address from their digital
/// address.
class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key, required this.shop, required this.cart});
  final Map<String, dynamic> shop;
  final StoreCart cart;

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _name = TextEditingController(text: AuthService.currentUser?.userMetadata?['full_name'] as String? ?? '');
  final _phone = TextEditingController(text: AuthService.currentUser?.userMetadata?['phone'] as String? ?? '');
  final _address = TextEditingController();
  final _note = TextEditingController();
  List<Map<String, dynamic>> _myAddresses = const [];
  bool _placing = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    widget.cart.addListener(_refresh);
    if (AuthService.isSignedIn) {
      EAddressService.myAddresses().then((a) {
        if (mounted) setState(() => _myAddresses = a);
      }).catchError((_) {});
    }
  }

  void _refresh() => setState(() {});

  double get _delivery => StoreService.deliveryFor(widget.shop, widget.cart.total);
  double? get _freeOver => (widget.shop['free_delivery_over'] as num?)?.toDouble();
  double get _grandTotal => widget.cart.total + _delivery;

  @override
  void dispose() {
    widget.cart.removeListener(_refresh);
    _name.dispose();
    _phone.dispose();
    _address.dispose();
    _note.dispose();
    super.dispose();
  }

  void _useAddress(Map<String, dynamic> a) {
    final landmark = (a['landmark'] as String?)?.trim();
    _address.text = [
      EAddressService.oneLine(a),
      if (landmark != null && landmark.isNotEmpty) 'علامة مميزة: $landmark',
      'العنوان على الخريطة: ${EAddressService.shareLinkFor(a)}',
    ].join('\n');
    setState(() {});
  }

  /// Egyptian mobile in the 01xxxxxxxxx form: Arabic-Indic digits, spaces,
  /// dashes and a +20 / 0020 prefix are accepted and normalised. Null if
  /// it isn't a valid mobile number.
  static String? _normalisePhone(String raw) {
    const arabic = '٠١٢٣٤٥٦٧٨٩';
    var d = raw.split('').map((c) {
      final i = arabic.indexOf(c);
      return i >= 0 ? '$i' : c;
    }).join().replaceAll(RegExp(r'[^0-9]'), '');
    if (d.startsWith('0020')) d = d.substring(4);
    if (d.startsWith('20') && d.length == 12) d = d.substring(2);
    if (d.length == 10 && d.startsWith('1')) d = '0$d';
    return RegExp(r'^01[0125]\d{8}$').hasMatch(d) ? d : null;
  }

  Future<void> _place() async {
    if (widget.cart.isEmpty) return;
    final phone = _normalisePhone(_phone.text);
    final problem = _name.text.trim().length < 2
        ? 'اكتب اسمك'
        : phone == null
            ? 'رقم الموبايل لازم يكون 11 رقم ويبدأ بـ 010 أو 011 أو 012 أو 015'
            : _address.text.trim().length < 8
                ? 'اكتب العنوان بالتفصيل عشان الطلب يوصلك'
                : null;
    if (problem != null) {
      setState(() => _error = problem);
      return;
    }
    setState(() {
      _placing = true;
      _error = null;
    });
    try {
      final code = await StoreService.placeStoreOrder(
        shopId: widget.shop['id'] as String,
        lines: widget.cart.toOrderLines(),
        name: _name.text.trim(),
        phone: phone!,
        address: _address.text.trim(),
        note: _note.text.trim().isEmpty ? null : _note.text.trim(),
      );
      final summary = [
        for (final l in widget.cart.lines) '• ${l.product['name']}${l.options.isEmpty ? '' : ' (${l.options})'} × ${l.quantity}',
      ].join('\n');
      final total = _grandTotal;
      widget.cart.clear();
      if (!mounted) return;
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (_) => _OrderPlacedScreen(shop: widget.shop, code: code, summary: summary, total: total, name: _name.text.trim()),
      ));
    } on PostgrestException catch (e) {
      if (mounted) setState(() => _error = e.message);
    } catch (_) {
      if (mounted) setState(() => _error = 'تعذر إرسال الطلب، حاول مرة أخرى');
    } finally {
      if (mounted) setState(() => _placing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = widget.cart;
    return Scaffold(
      appBar: AppBar(title: const Text('السلة وإتمام الطلب')),
      body: cart.isEmpty
          ? const Center(child: Text('السلة فاضية', style: TextStyle(color: AppColors.inkMuted)))
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
              children: [
                for (final l in cart.lines)
                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
                    child: Row(children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: StoreService.imagesOf(l.product).isEmpty
                            ? Container(width: 64, height: 64, color: AppColors.surfaceAlt)
                            : Image.network(StoreService.imagesOf(l.product).first, cacheWidth: 200, width: 64, height: 64, fit: BoxFit.cover),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(l.product['name'] as String? ?? '', maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w700)),
                          if (l.options.isNotEmpty) Text(l.options, style: const TextStyle(color: AppColors.inkMuted, fontSize: 12)),
                          Text(egp(l.total), style: const TextStyle(color: AppColors.crystal, fontWeight: FontWeight.w800)),
                        ]),
                      ),
                      IconButton(onPressed: () => cart.setQuantity(l, l.quantity - 1), icon: const Icon(Icons.remove_circle_outline_rounded)),
                      Text('${l.quantity}', style: const TextStyle(fontWeight: FontWeight.w800)),
                      IconButton(
                        onPressed: l.stock != null && cart.quantityOf(l.product['id'] as String) >= l.stock! ? null : () => cart.setQuantity(l, l.quantity + 1),
                        icon: const Icon(Icons.add_circle_rounded, color: AppColors.crystal),
                      ),
                    ]),
                  ),
                const SizedBox(height: 8),
                const Text('بيانات التوصيل', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                const SizedBox(height: 10),
                TextField(controller: _name, decoration: const InputDecoration(labelText: 'الاسم *', prefixIcon: Icon(Icons.person_outline_rounded))),
                const SizedBox(height: 10),
                TextField(
                  controller: _phone,
                  keyboardType: TextInputType.phone,
                  textDirection: TextDirection.ltr,
                  decoration: const InputDecoration(labelText: 'رقم الموبايل *', hintText: '01012345678', prefixIcon: Icon(Icons.phone_outlined)),
                ),
                const SizedBox(height: 10),
                if (_myAddresses.isNotEmpty) ...[
                  Wrap(spacing: 8, runSpacing: 8, children: [
                    for (final a in _myAddresses)
                      ActionChip(
                        avatar: const Icon(Icons.location_on_rounded, size: 16, color: AppColors.gold),
                        label: Text('استخدم «${a['label']}»'),
                        onPressed: () => _useAddress(a),
                      ),
                  ]),
                  const SizedBox(height: 8),
                ],
                TextField(
                  controller: _address,
                  minLines: 2,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: 'العنوان بالتفصيل *',
                    hintText: 'المنطقة، الشارع، رقم العمارة، الدور، الشقة، علامة مميزة',
                    prefixIcon: Icon(Icons.home_outlined),
                    alignLabelWithHint: true,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(controller: _note, decoration: const InputDecoration(labelText: 'ملاحظة للمحل (اختياري)', prefixIcon: Icon(Icons.sticky_note_2_outlined))),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(16)),
                  child: Column(children: [
                    Row(children: [
                      const Text('المنتجات'),
                      const Spacer(),
                      Text(egp(cart.total)),
                    ]),
                    const SizedBox(height: 4),
                    Row(children: [
                      const Text('التوصيل'),
                      const Spacer(),
                      Text(_delivery == 0 ? 'مجاني' : egp(_delivery), style: TextStyle(color: _delivery == 0 ? AppColors.success : null, fontWeight: _delivery == 0 ? FontWeight.w800 : null)),
                    ]),
                    if (_freeOver != null && _delivery > 0)
                      Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: Text('زوّد ${egp(_freeOver! - cart.total)} والتوصيل يبقى مجاني', style: const TextStyle(fontSize: 11.5, color: AppColors.gold)),
                      ),
                    const Divider(height: 18),
                    Row(children: [
                      const Text('الإجمالي', style: TextStyle(fontWeight: FontWeight.w800)),
                      const Spacer(),
                      Text(egp(_grandTotal), style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 17, color: AppColors.crystal)),
                    ]),
                    const SizedBox(height: 6),
                    const Row(children: [
                      Icon(Icons.payments_outlined, size: 18, color: AppColors.success),
                      SizedBox(width: 6),
                      Expanded(child: Text('الدفع كاش عند الاستلام', style: TextStyle(fontSize: 12, color: AppColors.inkSecondary))),
                    ]),
                  ]),
                ),
                if (_error != null)
                  Padding(padding: const EdgeInsets.only(top: 10), child: Text(_error!, style: const TextStyle(color: Colors.redAccent))),
                const SizedBox(height: 16),
                SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _placing ? null : _place,
                    child: _placing
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : Text('تأكيد الطلب — ${egp(_grandTotal)}', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(alignment: WrapAlignment.center, children: [
                  const Text('بتأكيد الطلب بيوصل اسمك ورقمك وعنوانك للمحل بس لتوصيل الطلب. ', style: TextStyle(fontSize: 11.5, color: AppColors.inkMuted)),
                  InkWell(
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen())),
                    child: const Text('سياسة الخصوصية', style: TextStyle(fontSize: 11.5, color: AppColors.crystal, decoration: TextDecoration.underline)),
                  ),
                ]),
              ],
            ),
    );
  }
}

class _OrderPlacedScreen extends StatelessWidget {
  const _OrderPlacedScreen({required this.shop, required this.code, required this.summary, required this.total, required this.name});
  final Map<String, dynamic> shop;
  final String code;
  final String summary;
  final double total;
  final String name;

  @override
  Widget build(BuildContext context) {
    final whatsapp = shop['whatsapp'] as String?;
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false, title: const Text('تم الطلب')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 72),
          const SizedBox(height: 12),
          const Text('طلبك وصل للمحل 🎉', textAlign: TextAlign.center, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
          const SizedBox(height: 6),
          Text('${shop['name']} هيكلمك يأكد الطلب ومعاد التوصيل.', textAlign: TextAlign.center, style: const TextStyle(color: AppColors.inkSecondary)),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(gradient: AppColors.brandGradient, borderRadius: BorderRadius.circular(20)),
            child: Column(children: [
              const Text('رقم الطلب', style: TextStyle(color: Colors.white70)),
              Directionality(
                textDirection: TextDirection.ltr,
                child: Text(code, style: const TextStyle(color: AppColors.gold, fontSize: 28, fontWeight: FontWeight.w800, letterSpacing: 2)),
              ),
              const SizedBox(height: 6),
              Text('الإجمالي ${egp(total)} — الدفع عند الاستلام', style: const TextStyle(color: Colors.white)),
            ]),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => OrderTrackingScreen(code: code))),
            icon: const Icon(Icons.local_shipping_outlined),
            label: const Text('تابع طلبك'),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: StoreService.trackUrl(code)));
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('اتنسخ لينك متابعة الطلب')));
            },
            icon: const Icon(Icons.link_rounded),
            label: const Text('انسخ لينك المتابعة'),
          ),
          if (whatsapp != null) ...[
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: () {
                final text = 'أهلاً، أنا $name وعملت طلب رقم $code من متجركم على مُجتمعي:\n$summary\nالإجمالي ${egp(total)}';
                launchUrl(Uri.parse('https://wa.me/2$whatsapp?text=${Uri.encodeComponent(text)}'), mode: LaunchMode.externalApplication);
              },
              icon: const Icon(Icons.chat_rounded),
              label: const Text('كلّم المحل على واتساب'),
            ),
          ],
        ],
      ),
    );
  }
}
