import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/auth/auth_service.dart';
import '../../core/demo/demo_mode.dart';
import '../../core/demo/demo_store.dart';
import '../../core/e_address/e_address_service.dart';
import '../../core/geo/admin_areas.dart';
import '../../core/shops/checkout_service.dart';
import '../../core/shops/shop_pixels.dart';
import '../../core/shops/store_service.dart';
import '../../core/theme/app_colors.dart';
import 'online_payment_screen.dart';
import 'order_tracking_screen.dart';
import 'store_cart.dart';
import '../legal/privacy_policy_screen.dart';
import '../../core/geo/phones.dart';
import '../shared/phone_field.dart';
import 'package:mogtama3y/core/geo/money.dart';

/// Cart + checkout: no account needed — name, mobile, area / address (or
/// pickup from the store), an optional discount code, cash on delivery or
/// (0100) «ادفع أونلاين» with the store's Fawaterak.
///
/// Totals come from the server (quote_store_checkout, 0099): shipping by
/// zone, discounts, minimum order, open / closed. The cart is saved for
/// «سلات متروكة» once the phone and name are typed. Without 0099 on the
/// backend it falls back to the flat delivery fee as before.
class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key, required this.shop, required this.cart, this.cartToken});
  final Map<String, dynamic> shop;
  final StoreCart cart;

  /// The «كمّل طلبك» cart this visit came from (marks it recovered).
  final String? cartToken;

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _name = TextEditingController(text: AuthService.currentUser?.userMetadata?['full_name'] as String? ?? '');
  final _phone = PhoneController(phone: AuthService.currentUser?.userMetadata?['phone'] as String?);
  final _address = TextEditingController();
  final _note = TextEditingController();
  final _codeField = TextEditingController();
  List<Map<String, dynamic>> _myAddresses = const [];
  bool _placing = false;
  String? _error;

  CheckoutInfo? _info;
  bool _infoLoaded = false;
  CheckoutQuote? _quote;
  bool _quoting = false;
  String? _quoteError;
  String _fulfillment = 'delivery';
  String? _area;
  String? _code; // the applied code (sent with the quote / order)
  String? _codeMessage;
  bool _codeOpen = false;
  Timer? _quoteTimer;
  Timer? _cartTimer;
  String? _savedCartKey;
  String? _savedCartToken;
  bool _pixelSent = false;
  int _quoteSeq = 0;
  CheckoutMethods _methods = const CheckoutMethods({});
  bool _payOnlineChosen = false;

  String get _shopId => widget.shop['id'] as String;
  String get _country => (_info?.country ?? widget.shop['country'] as String?) ?? 'EG';

  @override
  void initState() {
    super.initState();
    widget.cart.addListener(_cartChanged);
    _name.addListener(_contactChanged);
    _phone.addListener(_contactChanged);
    if (!widget.cart.isEmpty) ShopPixels.pageView('s/${widget.shop['slug']}/checkout');
    if (AuthService.isSignedIn) {
      EAddressService.myAddresses().then((a) {
        if (!mounted) return;
        setState(() => _myAddresses = a);
        // The customer's own governorate, when the shop delivers by area.
        final gov = a.isEmpty ? null : a.first['governorate'] as String?;
        if (_area == null && gov != null && adminAreaNames(_country).contains(gov)) _setArea(gov);
      }).catchError((_) {});
    }
    _loadInfo();
  }

  Future<void> _loadInfo() async {
    final (info, methods) = await (CheckoutService.info(_shopId), CheckoutService.methods(_shopId)).wait;
    if (!mounted) return;
    setState(() {
      _info = info;
      _infoLoaded = true;
      _methods = methods;
    });
    _requote(now: true);
  }

  void _cartChanged() {
    setState(() {});
    _requote();
    _scheduleCartSave();
  }

  void _contactChanged() {
    _scheduleCartSave();
    // Per-phone code limits: re-check the applied code with the phone.
    if (_code != null) _requote(delay: const Duration(milliseconds: 900));
  }

  @override
  void dispose() {
    _quoteTimer?.cancel();
    _cartTimer?.cancel();
    widget.cart.removeListener(_cartChanged);
    _name.dispose();
    _phone.dispose();
    _address.dispose();
    _note.dispose();
    _codeField.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------- quote

  void _requote({bool now = false, Duration delay = const Duration(milliseconds: 350)}) {
    _quoteTimer?.cancel();
    if (_info == null || widget.cart.isEmpty) {
      if (mounted) setState(() => _quote = null);
      return;
    }
    if (now) {
      _runQuote();
    } else {
      _quoteTimer = Timer(delay, _runQuote);
    }
  }

  Future<void> _runQuote() async {
    final seq = ++_quoteSeq;
    setState(() => _quoting = true);
    try {
      final q = await CheckoutService.quote(
        shopId: _shopId,
        lines: widget.cart.toOrderLines(),
        area: _fulfillment == 'delivery' ? _area : null,
        fulfillment: _fulfillment,
        code: _code,
        phone: _phone.stored,
      );
      if (!mounted || seq != _quoteSeq) return;
      setState(() {
        _quote = q;
        _quoteError = null;
        if (_code != null) {
          final s = q.codeStatus;
          if (s == 'applied') {
            _codeMessage = null;
          } else {
            _codeMessage = q.codeMessage;
            if (s != 'not_better') _code = null; // a code that doesn't apply isn't sent with the order
          }
        }
      });
      if (!_pixelSent) {
        _pixelSent = true;
        ShopPixels.initiateCheckout(widget.cart.toPixelItems(),
            value: q.total, currency: currencyOf(widget.shop), shipping: q.shipping, discount: q.discount, coupon: q.discountCode);
      }
    } on PostgrestException catch (e) {
      if (mounted && seq == _quoteSeq) setState(() => _quoteError = e.message);
    } catch (_) {
      if (mounted && seq == _quoteSeq) setState(() => _quoteError = 'تعذر حساب الإجمالي — اتأكد من النت');
    } finally {
      if (mounted && seq == _quoteSeq) setState(() => _quoting = false);
    }
  }

  void _setArea(String? a) {
    setState(() => _area = a);
    _requote(now: true);
    _scheduleCartSave();
  }

  void _setFulfillment(String f) {
    setState(() => _fulfillment = f);
    _requote(now: true);
  }

  void _applyCode() {
    final c = _codeField.text.trim();
    if (c.isEmpty) return;
    setState(() {
      _code = c;
      _codeMessage = null;
    });
    _requote(now: true);
  }

  void _removeCode() {
    setState(() {
      _code = null;
      _codeMessage = null;
      _codeField.clear();
    });
    _requote(now: true);
  }

  // ------------------------------------------------- abandoned cart (0099)

  void _scheduleCartSave() {
    _cartTimer?.cancel();
    if (_info == null) return;
    _cartTimer = Timer(const Duration(milliseconds: 1500), () async {
      final phone = _phone.stored;
      final name = _name.text.trim();
      if (phone == null || name.length < 2 || widget.cart.isEmpty) return;
      final lines = widget.cart.toOrderLines();
      final key = '$phone|$name|$_area|$lines';
      if (key == _savedCartKey) return;
      _savedCartKey = key;
      final token = await CheckoutService.saveCart(shopId: _shopId, phone: phone, name: name, lines: lines, area: _area);
      if (token != null) _savedCartToken = token;
    });
  }

  // ---------------------------------------------------------------- totals

  // Legacy (backend without 0099): the flat fee, computed here.
  double get _legacyDelivery => StoreService.deliveryFor(widget.shop, widget.cart.total);
  bool get _legacy => _infoLoaded && _info == null;

  double get _subtotal => _quote?.subtotal ?? widget.cart.total;
  double get _shipping => _legacy ? _legacyDelivery : (_quote?.shipping ?? 0);
  double get _discount => _quote?.discount ?? 0;
  double get _grandTotal => _legacy ? widget.cart.total + _legacyDelivery : (_quote?.total ?? widget.cart.total);

  bool get _needsArea => _fulfillment == 'delivery' && (_info?.needsArea ?? false);

  String? get _blocking {
    if (_legacy) return null;
    if (_quoteError != null) return _quoteError;
    final q = _quote;
    if (q == null) return null;
    if (q.errors.isNotEmpty) return q.errors.first['message'] as String?;
    return null;
  }

  bool get _canPlace => !_placing && (_legacy || (_quote != null && !_quoting && _blocking == null));

  // «ادفع أونلاين» (0100): offered when the store connected Fawaterak;
  // the only way when it turned cash on delivery off.
  bool get _onlineOffered => !_legacy && _methods.online;
  bool get _payOnline => _onlineOffered && (_payOnlineChosen || !_methods.cod);

  void _useAddress(Map<String, dynamic> a) {
    final landmark = (a['landmark'] as String?)?.trim();
    _address.text = [
      EAddressService.oneLine(a),
      if (landmark != null && landmark.isNotEmpty) 'علامة مميزة: $landmark',
      'العنوان على الخريطة: ${EAddressService.shareLinkFor(a)}',
    ].join('\n');
    final gov = a['governorate'] as String?;
    if (gov != null && adminAreaNames(_country).contains(gov) && gov != _area) _setArea(gov);
    setState(() {});
  }

  Future<void> _place() async {
    if (widget.cart.isEmpty) return;
    // Stored form (0089): 01… in Egypt, E.164 elsewhere — the server reads both.
    final phone = _phone.stored;
    final delivery = _fulfillment == 'delivery';
    final problem = _name.text.trim().length < 2
        ? 'اكتب اسمك'
        : phone == null
            ? invalidPhoneMessage
            : delivery && _needsArea && _area == null
                ? 'اختار ${adminAreaLabel(_country)} عشان نحسب التوصيل'
                : delivery && _address.text.trim().length < 8
                    ? 'اكتب العنوان بالتفصيل عشان الطلب يوصلك'
                    : _blocking;
    if (problem != null) {
      setState(() => _error = problem);
      return;
    }
    setState(() {
      _placing = true;
      _error = null;
    });
    final quote = _quote;
    try {
      final note = _note.text.trim().isEmpty ? null : _note.text.trim();
      final String? code;
      if (_legacy) {
        code = await StoreService.placeStoreOrder(
          shopId: _shopId,
          lines: widget.cart.toOrderLines(),
          name: _name.text.trim(),
          phone: phone!,
          address: _address.text.trim(),
          note: note,
        );
      } else {
        code = await CheckoutService.place(
          shopId: _shopId,
          lines: widget.cart.toOrderLines(),
          name: _name.text.trim(),
          phone: phone!,
          address: _address.text.trim(),
          note: note,
          area: delivery ? _area : null,
          fulfillment: _fulfillment,
          code: _code,
          cartToken: widget.cartToken ?? _savedCartToken,
          expectedTotal: quote?.total,
        );
      }
      if (code == null) {
        // The code was refused (wrong / too many tries): nothing was placed.
        if (!mounted) return;
        setState(() {
          _code = null;
          _codeMessage = 'الكود ده مش صحيح — شيلناه، راجع الإجمالي وأكّد تاني';
          _error = _codeMessage;
        });
        _requote(now: true);
        return;
      }
      final summary = [
        for (final l in widget.cart.lines) '• ${l.product['name']}${l.options.isEmpty ? '' : ' (${l.options})'} × ${l.quantity}',
      ].join('\n');
      final total = _grandTotal;
      // Merchant pixels (0097): the order code is the dedup event id.
      ShopPixels.pageView('s/${widget.shop['slug']}/success');
      ShopPixels.purchase(code, widget.cart.toPixelItems(),
          value: total, currency: currencyOf(widget.shop), shipping: _shipping, discount: _discount, coupon: quote?.discountCode);
      widget.cart.clear();
      if (!mounted) return;
      if (_payOnline) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => OnlinePaymentScreen(code: code!, phone: phone)));
        return;
      }
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (_) => OrderPlacedScreen(
          shop: widget.shop,
          code: code!,
          summary: summary,
          total: total,
          discount: _discount,
          shipping: _shipping,
          pickup: !delivery,
          pickupAddress: _info?.pickup?['address'] as String?,
          needsConfirmation: _info?.requireConfirmation ?? false,
          name: _name.text.trim(),
          address: _address.text.trim(),
          note: _note.text.trim(),
        ),
      ));
    } on PostgrestException catch (e) {
      if (mounted) setState(() => _error = e.message);
      _requote(now: true);
    } catch (_) {
      if (mounted) setState(() => _error = 'تعذر إرسال الطلب، حاول مرة أخرى');
    } finally {
      if (mounted) setState(() => _placing = false);
    }
  }

  // ---------------------------------------------------------------- UI

  @override
  Widget build(BuildContext context) {
    final cart = widget.cart;
    final wide = MediaQuery.sizeOf(context).width >= 900;
    return Scaffold(
      appBar: AppBar(title: const Text('السلة وإتمام الطلب')),
      body: cart.isEmpty
          ? const Center(child: Text('السلة فاضية', style: TextStyle(color: AppColors.inkMuted)))
          : wide
              ? Align(
                  alignment: Alignment.topCenter,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1100),
                    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Expanded(flex: 6, child: ListView(padding: const EdgeInsets.fromLTRB(24, 16, 12, 32), children: _form())),
                      Expanded(flex: 5, child: ListView(padding: const EdgeInsets.fromLTRB(12, 16, 24, 32), children: _summaryColumn())),
                    ]),
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
                  children: [..._form(), const SizedBox(height: 16), ..._summaryColumn()],
                ),
    );
  }

  Widget _section(String title, {Widget? trailing}) => Padding(
        padding: const EdgeInsets.only(top: 14, bottom: 10),
        child: Row(children: [
          Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16))),
          ?trailing,
        ]),
      );

  List<Widget> _form() {
    final cart = widget.cart;
    final info = _info;
    final open = _quote?.open ?? info?.open;
    final pickup = info?.pickup;
    return [
      if (open != null && open['code'] != 'ok' && open['message'] != null)
        _Notice(
          icon: open['can_order'] == false ? Icons.storefront_rounded : Icons.schedule_rounded,
          text: open['message'] as String,
          danger: open['can_order'] == false,
        ),
      for (final l in cart.lines) _CartLineTile(shop: widget.shop, line: l, cart: cart),
      _section('بيانات العميل',
          trailing: kDemo
              // Demo build only: a fictional customer in one tap.
              ? TextButton.icon(
                  onPressed: () => setState(() {
                    _name.text = DemoTajer.sampleCustomerName;
                    _phone.setPhone(DemoTajer.sampleCustomerPhone);
                    _address.text = DemoTajer.sampleCustomerAddress;
                    _note.text = DemoTajer.sampleCustomerNote;
                    if (_area == null && adminAreaNames(_country).contains('القاهرة')) _setArea('القاهرة');
                  }),
                  icon: const Icon(Icons.auto_fix_high_rounded, size: 18),
                  label: const Text('املأ بيانات تجريبية'),
                )
              : null),
      TextField(controller: _name, decoration: const InputDecoration(labelText: 'الاسم *', prefixIcon: Icon(Icons.person_outline_rounded))),
      const SizedBox(height: 10),
      PhoneFormField(controller: _phone, labelText: 'رقم الموبايل *'),
      if (pickup != null) ...[
        _section('الاستلام'),
        SegmentedButton<String>(
          segments: const [
            ButtonSegment(value: 'delivery', icon: Icon(Icons.local_shipping_outlined), label: Text('توصيل')),
            ButtonSegment(value: 'pickup', icon: Icon(Icons.storefront_outlined), label: Text('استلام من المحل')),
          ],
          selected: {_fulfillment},
          onSelectionChanged: (s) => _setFulfillment(s.first),
        ),
      ],
      if (_fulfillment == 'pickup' && pickup != null) ...[
        const SizedBox(height: 10),
        _Notice(
          icon: Icons.storefront_rounded,
          text: [
            'هتستلم طلبك من: ${pickup['address'] ?? ''}',
            if ((pickup['instructions'] as String?)?.isNotEmpty ?? false) pickup['instructions'] as String,
          ].join('\n'),
        ),
      ] else ...[
        _section('عنوان التوصيل'),
        if (_needsArea || (info?.zones.isNotEmpty ?? false)) ...[
          DropdownButtonFormField<String>(
            key: const ValueKey('checkout-area'),
            initialValue: _area,
            isExpanded: true,
            decoration: InputDecoration(labelText: '${adminAreaLabel(_country)} *', prefixIcon: const Icon(Icons.map_outlined)),
            items: [for (final a in adminAreaNames(_country)) DropdownMenuItem(value: a, child: Text(a))],
            onChanged: _setArea,
          ),
          const SizedBox(height: 10),
        ],
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
      ],
      const SizedBox(height: 10),
      TextField(controller: _note, decoration: const InputDecoration(labelText: 'ملاحظة للمحل (اختياري)', prefixIcon: Icon(Icons.sticky_note_2_outlined))),
    ];
  }

  List<Widget> _summaryColumn() {
    final q = _quote;
    final shop = widget.shop;
    String m(num v) => moneyOf(shop, v);
    final showCode = !_legacy && (_info?.hasCodes ?? false);
    final shippingLabel = _fulfillment == 'pickup'
        ? 'الاستلام من المحل'
        : [
            'التوصيل',
            if (q?.zone != null) '(${q!.zone})',
          ].join(' ');
    return [
      if (showCode) _codeBox(),
      Container(
        key: const ValueKey('checkout-summary'),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(16)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          const Text('ملخص الطلب', style: TextStyle(fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          for (final l in widget.cart.lines)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(children: [
                Expanded(
                  child: Text('${l.product['name']}${l.options.isEmpty ? '' : ' (${l.options})'} × ${l.quantity}',
                      maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12.5, color: AppColors.inkSecondary)),
                ),
                Text(m(l.total), style: const TextStyle(fontSize: 12.5, color: AppColors.inkSecondary)),
              ]),
            ),
          const Divider(height: 16),
          _row('المنتجات', m(_subtotal)),
          if (_discount > 0)
            _row('الخصم${q?.discountTitle != null ? ' — ${q!.discountTitle}' : ''}', '−${m(_discount)}', color: AppColors.success, key: const ValueKey('checkout-discount')),
          _row(
            shippingLabel,
            _shipping == 0 ? 'مجاني' : m(_shipping),
            color: _shipping == 0 ? AppColors.success : null,
            bold: _shipping == 0,
            key: const ValueKey('checkout-shipping'),
          ),
          if (q?.eta != null && _fulfillment == 'delivery')
            Text('بيوصل ${q!.eta}', style: const TextStyle(fontSize: 11.5, color: AppColors.inkMuted)),
          if (_fulfillment == 'delivery' && _shipping > 0 && (q?.freeOver ?? (_legacy ? (shop['free_delivery_over'] as num?)?.toDouble() : null)) != null)
            Text('زوّد ${m((q?.freeOver ?? (shop['free_delivery_over'] as num).toDouble()) - _subtotal)} والتوصيل يبقى مجاني',
                style: const TextStyle(fontSize: 11.5, color: AppColors.gold)),
          if (q?.hint != null) Text(q!.hint!, style: const TextStyle(fontSize: 11.5, color: AppColors.gold)),
          const Divider(height: 18),
          Row(children: [
            const Text('الإجمالي', style: TextStyle(fontWeight: FontWeight.w800)),
            const Spacer(),
            if (_quoting) const Padding(padding: EdgeInsetsDirectional.only(end: 8), child: SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2))),
            Text(m(_grandTotal), key: const ValueKey('checkout-total'), style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 17, color: AppColors.crystal)),
          ]),
          const SizedBox(height: 6),
          if (!_onlineOffered)
            Row(children: [
              const Icon(Icons.payments_outlined, size: 18, color: AppColors.success),
              const SizedBox(width: 6),
              Expanded(
                child: Text(_fulfillment == 'pickup' ? 'الدفع كاش عند الاستلام من المحل' : 'الدفع كاش عند الاستلام',
                    style: const TextStyle(fontSize: 12, color: AppColors.inkSecondary)),
              ),
            ]),
        ]),
      ),
      if (_onlineOffered) ..._paymentChoice(),
      if (_blocking != null && _error == null) Padding(padding: const EdgeInsets.only(top: 10), child: _Notice(icon: Icons.info_outline_rounded, text: _blocking!, danger: true)),
      if (_error != null) Padding(padding: const EdgeInsets.only(top: 10), child: Text(_error!, style: const TextStyle(color: Colors.redAccent))),
      const SizedBox(height: 16),
      SizedBox(
        height: 56,
        child: ElevatedButton(
          onPressed: _canPlace ? _place : null,
          child: _placing
              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
              : Text('${_payOnline ? 'كمّل للدفع' : 'تأكيد الطلب'} — ${moneyOf(widget.shop, _grandTotal)}', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
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
    ];
  }

  List<Widget> _paymentChoice() {
    Widget option(bool online, IconData icon, String title, String subtitle) => Card(
          margin: const EdgeInsets.only(bottom: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: BorderSide(color: _payOnline == online ? AppColors.crystal : AppColors.border, width: _payOnline == online ? 2 : 1),
          ),
          child: ListTile(
            key: ValueKey(online ? 'pay-online' : 'pay-cod'),
            onTap: () => setState(() => _payOnlineChosen = online),
            leading: Icon(icon, color: _payOnline == online ? AppColors.crystal : AppColors.inkMuted),
            title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
            subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
            trailing: Icon(_payOnline == online ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded,
                color: _payOnline == online ? AppColors.crystal : AppColors.inkMuted),
          ),
        );
    return [
      _section('هتدفع إزاي؟'),
      option(true, Icons.credit_card_rounded, 'ادفع أونلاين', 'كارت، فوري، أو محفظة موبايل — عن طريق فواتيرك'),
      if (_methods.cod)
        option(false, Icons.payments_outlined, _fulfillment == 'pickup' ? 'كاش عند الاستلام من المحل' : 'كاش عند الاستلام', 'بتدفع لما الطلب يوصلك'),
    ];
  }

  Widget _codeBox() {
    final applied = _code != null && _quote?.codeStatus == 'applied';
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        if (applied)
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: InputChip(
              key: const ValueKey('checkout-code-chip'),
              avatar: const Icon(Icons.local_offer_rounded, size: 16, color: AppColors.success),
              label: Text('${_quote!.discountCode ?? _code} — اتطبّق'),
              onDeleted: _removeCode,
            ),
          )
        else if (!_codeOpen)
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: TextButton.icon(
              onPressed: () => setState(() => _codeOpen = true),
              icon: const Icon(Icons.local_offer_outlined, size: 18),
              label: const Text('عندك كود خصم؟'),
            ),
          )
        else
          Row(children: [
            Expanded(
              child: TextField(
                key: const ValueKey('checkout-code'),
                controller: _codeField,
                textCapitalization: TextCapitalization.characters,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _applyCode(),
                decoration: const InputDecoration(labelText: 'كود الخصم', prefixIcon: Icon(Icons.local_offer_outlined), isDense: true),
              ),
            ),
            const SizedBox(width: 8),
            OutlinedButton(onPressed: _quoting ? null : _applyCode, child: const Text('تطبيق')),
          ]),
        if (_codeMessage != null)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(_codeMessage!,
                style: TextStyle(fontSize: 12, color: _quote?.codeStatus == 'not_better' ? AppColors.gold : Colors.redAccent)),
          ),
      ]),
    );
  }

  Widget _row(String label, String value, {Color? color, bool bold = false, Key? key}) => Padding(
        key: key,
        padding: const EdgeInsets.only(top: 4),
        child: Row(children: [
          Expanded(child: Text(label, maxLines: 2, overflow: TextOverflow.ellipsis)),
          Text(value, style: TextStyle(color: color, fontWeight: bold ? FontWeight.w800 : null)),
        ]),
      );
}

class _CartLineTile extends StatelessWidget {
  const _CartLineTile({required this.shop, required this.line, required this.cart});
  final Map<String, dynamic> shop;
  final CartLine line;
  final StoreCart cart;

  @override
  Widget build(BuildContext context) {
    final l = line;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
      child: Row(children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: StoreService.imagesOf(l.product).isEmpty
              ? Container(width: 64, height: 64, color: AppColors.surfaceAlt)
              : Image.network(StoreService.imagesOf(l.product).first, cacheWidth: 200, width: 64, height: 64, fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => Container(width: 64, height: 64, color: AppColors.surfaceAlt)),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(l.product['name'] as String? ?? '', maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w700)),
            if (l.options.isNotEmpty) Text(l.options, style: const TextStyle(color: AppColors.inkMuted, fontSize: 12)),
            Text(moneyOf(shop, l.total), style: const TextStyle(color: AppColors.crystal, fontWeight: FontWeight.w800)),
          ]),
        ),
        IconButton(onPressed: () => cart.setQuantity(l, l.quantity - 1), icon: const Icon(Icons.remove_circle_outline_rounded)),
        Text('${l.quantity}', style: const TextStyle(fontWeight: FontWeight.w800)),
        IconButton(
          onPressed: !cart.canIncrease(l) ? null : () => cart.setQuantity(l, l.quantity + 1),
          icon: const Icon(Icons.add_circle_rounded, color: AppColors.crystal),
        ),
      ]),
    );
  }
}

class _Notice extends StatelessWidget {
  const _Notice({required this.icon, required this.text, this.danger = false});
  final IconData icon;
  final String text;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    final color = danger ? const Color(0xFFB91C1C) : const Color(0xFF8A5A12);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: (danger ? AppColors.categorySos : AppColors.gold).withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 8),
        Expanded(child: Text(text, style: TextStyle(color: color, fontWeight: FontWeight.w600, height: 1.5))),
      ]),
    );
  }
}

/// «تم الطلب»: the code, the totals and «أكّد طلبك على واتساب» (0099 —
/// confirming a cash order cuts fake orders; the merchant marks it «اتأكد»).
class OrderPlacedScreen extends StatelessWidget {
  const OrderPlacedScreen({
    super.key,
    required this.shop,
    required this.code,
    required this.summary,
    required this.total,
    required this.name,
    required this.address,
    required this.note,
    this.discount = 0,
    this.shipping = 0,
    this.pickup = false,
    this.pickupAddress,
    this.needsConfirmation = false,
  });
  final Map<String, dynamic> shop;
  final String code;
  final String summary;
  final double total;
  final double discount;
  final double shipping;
  final bool pickup;
  final String? pickupAddress;
  final bool needsConfirmation;
  final String name;
  final String address;
  final String note;

  /// The ready-made confirmation the customer sends the shop.
  String get whatsappMessage => [
        'أهلاً ${shop['name']}، أنا $name وبأكّد طلبي رقم $code ✅',
        '',
        'الطلب:',
        summary,
        '',
        if (discount > 0) 'الخصم: −${moneyOf(shop, discount)}',
        pickup ? 'استلام من المحل' : 'التوصيل: ${shipping == 0 ? 'مجاني' : moneyOf(shop, shipping)}',
        'الإجمالي: ${moneyOf(shop, total)} (الدفع عند الاستلام)',
        if (!pickup) 'العنوان: $address',
        if (note.isNotEmpty) 'ملاحظة: $note',
        '',
        'متابعة الطلب: ${StoreService.trackUrl(code)}',
      ].join('\n');

  @override
  Widget build(BuildContext context) {
    final whatsapp = (shop['whatsapp'] as String?)?.trim();
    final hasWhatsapp = whatsapp != null && whatsapp.isNotEmpty;
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false, title: const Text('تم الطلب')),
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 72),
              const SizedBox(height: 12),
              const Text('طلبك وصل للمحل 🎉', textAlign: TextAlign.center, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
              const SizedBox(height: 6),
              Text(
                pickup ? '${shop['name']} هيجهّز طلبك وتستلمه من المحل${pickupAddress != null ? ': $pickupAddress' : ''}.' : '${shop['name']} هيكلمك يأكد الطلب ومعاد التوصيل.',
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.inkSecondary),
              ),
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
                  Text('الإجمالي ${moneyOf(shop, total)} — الدفع عند الاستلام', style: const TextStyle(color: Colors.white)),
                  if (discount > 0) Text('وفّرت ${moneyOf(shop, discount)} 🎁', style: const TextStyle(color: AppColors.gold, fontWeight: FontWeight.w700)),
                ]),
              ),
              if (hasWhatsapp) ...[
                const SizedBox(height: 18),
                Text(needsConfirmation ? 'المحل محتاج تأكيدك عشان يبدأ يجهّز طلبك:' : 'أكّد طلبك على واتساب عشان المحل يجهّزه أسرع:',
                    textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.inkSecondary)),
                const SizedBox(height: 8),
                SizedBox(
                  height: 58,
                  child: ElevatedButton.icon(
                    key: const ValueKey('confirm-whatsapp'),
                    onPressed: () => StoreService.openWhatsAppOrder(shopWhatsapp: whatsapp, message: whatsappMessage),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF25D366),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    icon: const Icon(Icons.chat_rounded, size: 24),
                    label: const Text('أكّد طلبك على واتساب', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                  ),
                ),
                const SizedBox(height: 4),
                const Text('الرسالة جاهزة فيها رقم الطلب والمنتجات والإجمالي — اضغط إرسال بس.',
                    textAlign: TextAlign.center, style: TextStyle(fontSize: 11.5, color: AppColors.inkMuted)),
              ],
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
            ],
          ),
        ),
      ),
    );
  }
}
