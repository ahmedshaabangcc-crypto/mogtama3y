import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart' as intl;

import '../../../core/geo/money.dart';
import '../../../core/shops/checkout_service.dart';
import '../../../core/shops/store_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/numbers.dart';
import '../../shared/load_error_view.dart';
import '../admin/admin_common.dart';
import '../admin/merchant_session.dart';

/// «الخصومات» (/discounts, 0099): discount codes and automatic discounts,
/// their state, uses and sales.
///
/// Stacking rule (the server's): one code per order + the best automatic
/// discount; they add up only when the code is marked «يتجمع مع الخصومات
/// التلقائية», otherwise the customer gets whichever saves more.
class DiscountsPage extends StatefulWidget {
  const DiscountsPage({super.key});

  @override
  State<DiscountsPage> createState() => _DiscountsPageState();
}

String discountValueText(Map<String, dynamic> d, String currency) => switch (d['type']) {
      'percent' => '${_n(d['value'])}%',
      'fixed' => money(d['value'] as num, currency),
      _ => 'توصيل مجاني',
    };

String _n(Object? v) {
  final d = (v as num?)?.toDouble();
  if (d == null) return '';
  return d == d.roundToDouble() ? '${d.toInt()}' : '$d';
}

(String, Color, Color) discountState(String? s) => switch (s) {
      'active' => ('شغال', AppColors.success.withValues(alpha: 0.15), const Color(0xFF047857)),
      'scheduled' => ('مجدول', AppColors.crystal.withValues(alpha: 0.12), AppColors.crystal),
      'expired' => ('خلصت مدته', AppColors.surfaceAlt, AppColors.inkSecondary),
      'used_up' => ('خلص عدده', AppColors.gold.withValues(alpha: 0.22), const Color(0xFF8A5A12)),
      _ => ('متوقف', AppColors.surfaceAlt, AppColors.inkSecondary),
    };

class _DiscountsPageState extends State<DiscountsPage> {
  String? _shopId;
  List<Map<String, dynamic>>? _rows;
  bool _failed = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final id = MerchantScope.of(context).shopId;
    if (id != null && id != _shopId) {
      _shopId = id;
      _load();
    }
  }

  Future<void> _load() async {
    setState(() => _failed = false);
    try {
      final rows = await CheckoutService.discounts(_shopId!);
      if (mounted) setState(() => _rows = rows);
    } catch (_) {
      if (mounted) setState(() => _failed = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currency = currencyOf(MerchantScope.of(context).shop);
    final rows = _rows;
    return AdminPage(
      title: 'الخصومات',
      subtitle: 'أكواد خصم وعروض تلقائية',
      actions: [
        ElevatedButton.icon(
          key: const ValueKey('new-discount'),
          onPressed: () => context.go('/discounts/new'),
          icon: const Icon(Icons.add_rounded, size: 18),
          label: const Text('خصم جديد'),
        ),
      ],
      scrollable: true,
      maxWidth: 980,
      body: _failed
          ? LoadErrorView(onRetry: _load)
          : rows == null
              ? const Padding(padding: EdgeInsets.all(40), child: Center(child: CircularProgressIndicator()))
              : rows.isEmpty
                  ? AdminCard(
                      child: Column(children: [
                        const SizedBox(height: 12),
                        const Icon(Icons.local_offer_rounded, size: 48, color: AppColors.gold),
                        const SizedBox(height: 8),
                        const Text('لسه معملتش خصومات', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                        const SizedBox(height: 4),
                        const Text('اعمل كود خصم تبعته لزباينك، أو خصم تلقائي زي «10% على الطلبات فوق 300»', textAlign: TextAlign.center,
                            style: TextStyle(color: AppColors.inkSecondary)),
                        const SizedBox(height: 12),
                        ElevatedButton(onPressed: () => context.go('/discounts/new'), child: const Text('اعمل أول خصم')),
                        const SizedBox(height: 12),
                      ]),
                    )
                  : Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                      const Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: Text('كل طلب ياخد كود واحد + أحسن خصم تلقائي؛ ولو الكود مش «بيتجمع» الزبون بياخد الأوفر فيهم.',
                            style: TextStyle(fontSize: 12, color: AppColors.inkMuted)),
                      ),
                      for (final d in rows) _DiscountTile(d: d, currency: currency, onTap: () => context.go('/discounts/${d['id']}', extra: d)),
                    ]),
    );
  }
}

class _DiscountTile extends StatelessWidget {
  const _DiscountTile({required this.d, required this.currency, required this.onTap});
  final Map<String, dynamic> d;
  final String currency;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final (label, bg, ink) = discountState(d['state'] as String?);
    final auto = d['method'] == 'auto';
    final limit = d['usage_limit'] as num?;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: AdminCard(
        padding: EdgeInsets.zero,
        child: ListTile(
          onTap: onTap,
          leading: CircleAvatar(
            backgroundColor: AppColors.surfaceAlt,
            child: Icon(auto ? Icons.auto_awesome_rounded : Icons.local_offer_rounded, color: auto ? AppColors.gold : AppColors.crystal),
          ),
          title: Wrap(spacing: 8, crossAxisAlignment: WrapCrossAlignment.center, children: [
            Text(auto ? d['title'] as String : d['code'] as String,
                style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: auto ? 0 : 1, fontFamily: auto ? null : 'monospace')),
            Pill(label, bg, ink),
          ]),
          subtitle: Text([
            '${discountValueText(d, currency)}${auto ? ' — تلقائي' : ''}',
            if (d['min_subtotal'] != null) 'فوق ${money(d['min_subtotal'] as num, currency)}',
            'استُخدم ${d['used_count'] ?? 0}${limit != null ? ' من ${limit.toInt()}' : ''} مرة',
            if (((d['sales'] as num?) ?? 0) > 0) 'مبيعات ${money(d['sales'] as num, currency)}',
          ].join(' • ')),
          trailing: const Icon(Icons.chevron_left_rounded),
        ),
      ),
    );
  }
}

/// /discounts/new and /discounts/:id.
class DiscountEditorPage extends StatefulWidget {
  const DiscountEditorPage({super.key, this.discountId, this.initial, this.products, this.collections});
  final String? discountId;
  final Map<String, dynamic>? initial;

  /// Tests pass the shop's products (the app loads them).
  final List<Map<String, dynamic>>? products;

  /// …and its collections («الأقسام», 0098).
  final List<Map<String, dynamic>>? collections;

  @override
  State<DiscountEditorPage> createState() => _DiscountEditorPageState();
}

class _DiscountEditorPageState extends State<DiscountEditorPage> {
  String? _shopId;
  Map<String, dynamic>? _d;
  bool _loading = true;
  bool _saving = false;
  String? _error;
  List<Map<String, dynamic>> _products = const [];
  List<Map<String, dynamic>> _collections = const [];
  final Set<String> _collectionIds = {};
  List<Map<String, dynamic>>? _orders;

  String _method = 'code';
  String _type = 'percent';
  String _applies = 'all';
  final _code = TextEditingController();
  final _title = TextEditingController();
  final _value = TextEditingController();
  final _min = TextEditingController();
  final _limit = TextEditingController();
  final _perPhone = TextEditingController();
  final Set<String> _productIds = {};
  DateTime? _starts;
  DateTime? _ends;
  bool _active = true;
  bool _combines = false;

  bool get _editing => widget.discountId != null;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final id = MerchantScope.of(context).shopId;
    if (id != null && id != _shopId) {
      _shopId = id;
      _load();
    }
  }

  @override
  void dispose() {
    for (final c in [_code, _title, _value, _min, _limit, _perPhone]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _load() async {
    var d = widget.initial;
    try {
      if (_editing && (d == null || d['id'] != widget.discountId)) {
        d = (await CheckoutService.discounts(_shopId!)).where((x) => x['id'] == widget.discountId).firstOrNull;
      }
      _products = widget.products ?? await StoreService.fetchProducts(_shopId!, includeHidden: true);
    } catch (_) {
      _products = widget.products ?? const [];
    }
    try {
      _collections = widget.collections ?? await StoreService.fetchCollections(_shopId!);
    } catch (_) {
      _collections = widget.collections ?? const []; // a backend without 0098
    }
    if (!mounted) return;
    setState(() {
      _loading = false;
      _d = d;
      if (d != null) _fill(d);
    });
    if (d != null) {
      CheckoutService.discountOrders(d['id'] as String).then((o) {
        if (mounted) setState(() => _orders = o);
      }).catchError((_) {});
    }
  }

  void _fill(Map<String, dynamic> d) {
    _method = d['method'] as String? ?? 'code';
    _type = d['type'] as String? ?? 'percent';
    _applies = d['applies_to'] as String? ?? 'all';
    _code.text = d['code'] as String? ?? '';
    _title.text = d['title'] as String? ?? '';
    _value.text = _type == 'free_shipping' ? '' : _n(d['value']);
    _min.text = _n(d['min_subtotal']);
    _limit.text = _n(d['usage_limit']);
    _perPhone.text = _n(d['per_phone_limit']);
    _productIds
      ..clear()
      ..addAll(List<String>.from(d['product_ids'] as List? ?? const []));
    _collectionIds
      ..clear()
      ..addAll(List<String>.from(d['collection_ids'] as List? ?? const []));
    _starts = DateTime.tryParse(d['starts_at'] as String? ?? '')?.toLocal();
    _ends = DateTime.tryParse(d['ends_at'] as String? ?? '')?.toLocal();
    _active = d['active'] != false;
    _combines = d['combines'] == true;
  }

  void _generate() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    final r = Random.secure();
    setState(() => _code.text = List.generate(8, (_) => chars[r.nextInt(chars.length)]).join());
  }

  /// What save_shop_discount takes (null + [_error] when invalid).
  Map<String, dynamic>? payload() {
    String? problem;
    final value = looseDouble(_value.text.trim());
    int? intOf(TextEditingController c) => c.text.trim().isEmpty ? null : int.tryParse(latinDigits(c.text.trim()));
    if (_method == 'code' && !RegExp(r'^[A-Za-z0-9_ء-ي-]{3,30}$').hasMatch(_code.text.trim())) {
      problem = 'الكود لازم يكون من 3 لـ 30 حرف أو رقم (من غير مسافات)';
    } else if (_method == 'auto' && _title.text.trim().isEmpty) {
      problem = 'اكتب اسم للخصم (الزبون بيشوفه في السلة)';
    } else if (_type == 'percent' && (value == null || value <= 0 || value > 100)) {
      problem = 'النسبة لازم تكون من 1 لـ 100';
    } else if (_type == 'fixed' && (value == null || value <= 0)) {
      problem = 'اكتب قيمة الخصم';
    } else if (_applies == 'products' && _productIds.isEmpty) {
      problem = 'اختار المنتجات اللي عليها الخصم';
    } else if (_applies == 'collections' && _collectionIds.isEmpty) {
      problem = 'اختار الأقسام اللي عليها الخصم';
    } else if ((_limit.text.trim().isNotEmpty && (intOf(_limit) ?? 0) <= 0) || (_perPhone.text.trim().isNotEmpty && (intOf(_perPhone) ?? 0) <= 0)) {
      problem = 'حد الاستخدام لازم يكون رقم أكبر من صفر';
    } else if (_starts != null && _ends != null && !_ends!.isAfter(_starts!)) {
      problem = 'تاريخ النهاية لازم يكون بعد البداية';
    }
    setState(() => _error = problem);
    if (problem != null) return null;
    return {
      if (_d?['id'] != null) 'id': _d!['id'],
      'method': _method,
      'code': _method == 'code' ? _code.text.trim().toUpperCase() : null,
      'title': _title.text.trim(),
      'type': _type,
      'value': _type == 'free_shipping' ? 0 : value,
      'applies_to': _type == 'free_shipping' ? 'all' : _applies,
      'product_ids': _applies == 'products' ? _productIds.toList() : const <String>[],
      'collection_ids': _applies == 'collections' ? _collectionIds.toList() : const <String>[],
      'min_subtotal': looseDouble(_min.text.trim()),
      'usage_limit': intOf(_limit),
      'per_phone_limit': intOf(_perPhone),
      'starts_at': _starts?.toUtc().toIso8601String(),
      'ends_at': _ends?.toUtc().toIso8601String(),
      'active': _active,
      'combines': _combines,
    };
  }

  Future<void> _save() async {
    final p = payload();
    if (p == null) return;
    setState(() => _saving = true);
    try {
      await CheckoutService.saveDiscount(_shopId!, p);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('اتحفظ الخصم ✓')));
      context.go('/discounts');
    } catch (e) {
      if (mounted) setState(() => _error = adminErrorText(e, 'تعذر الحفظ'));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _delete() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('تمسح الخصم ده؟'),
        content: const Text('لو اتستخدم قبل كده هيتوقف بس (الطلبات بتفضل محتفظة بيه).'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('لا')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('امسح')),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    try {
      final deleted = await CheckoutService.deleteDiscount(_d!['id'] as String);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(deleted ? 'اتمسح الخصم' : 'الخصم اتستخدم قبل كده — وقفناه بدل ما نمسحه')));
      context.go('/discounts');
    } catch (e) {
      if (mounted) setState(() => _error = adminErrorText(e, 'تعذر المسح'));
    }
  }

  Future<void> _pickDate(bool start) async {
    final now = DateTime.now();
    final first = start ? DateTime(now.year - 1) : (_starts ?? now);
    final d = await showDatePicker(context: context, firstDate: first, lastDate: DateTime(now.year + 5), initialDate: (start ? _starts : _ends) ?? (first.isAfter(now) ? first : now));
    if (d == null) return;
    setState(() => start ? _starts = d : _ends = DateTime(d.year, d.month, d.day, 23, 59));
  }

  @override
  Widget build(BuildContext context) {
    final currency = currencyOf(MerchantScope.of(context).shop);
    return AdminPage(
      title: _editing ? (_d?['code'] as String? ?? _d?['title'] as String? ?? 'الخصم') : 'خصم جديد',
      backTo: '/discounts',
      scrollable: true,
      maxWidth: 820,
      actions: [
        if (_editing && _d != null) IconButton(tooltip: 'مسح', onPressed: _delete, icon: const Icon(Icons.delete_outline_rounded)),
      ],
      body: _loading
          ? const Padding(padding: EdgeInsets.all(40), child: Center(child: CircularProgressIndicator()))
          : _editing && _d == null
              ? const Padding(padding: EdgeInsets.all(40), child: Center(child: Text('الخصم ده مش موجود')))
              : _form(currency),
    );
  }

  Widget _form(String currency) {
    const gap = SizedBox(height: 12);
    final df = intl.DateFormat('d/M/y');
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      if (_d != null) _usage(currency),
      AdminCard(
        title: 'نوع الخصم',
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'code', icon: Icon(Icons.local_offer_outlined), label: Text('كود خصم')),
              ButtonSegment(value: 'auto', icon: Icon(Icons.auto_awesome_outlined), label: Text('خصم تلقائي')),
            ],
            selected: {_method},
            onSelectionChanged: (s) => setState(() => _method = s.first),
          ),
          const SizedBox(height: 10),
          if (_method == 'code')
            Row(children: [
              Expanded(
                child: TextField(
                  key: const ValueKey('discount-code'),
                  controller: _code,
                  textCapitalization: TextCapitalization.characters,
                  textDirection: TextDirection.ltr,
                  decoration: const InputDecoration(labelText: 'الكود', hintText: 'EID20'),
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton(onPressed: _generate, child: const Text('اعمل كود')),
            ])
          else
            const Text('بيتطبّق لوحده في السلة لما الطلب يستوفي الشروط.', style: TextStyle(fontSize: 12.5, color: AppColors.inkSecondary)),
          const SizedBox(height: 8),
          TextField(
            key: const ValueKey('discount-title'),
            controller: _title,
            decoration: InputDecoration(labelText: _method == 'auto' ? 'اسم الخصم (الزبون بيشوفه) *' : 'وصف (اختياري)', hintText: 'خصم 10% فوق 300'),
          ),
        ]),
      ),
      gap,
      AdminCard(
        title: 'قيمة الخصم',
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'percent', label: Text('نسبة %')),
              ButtonSegment(value: 'fixed', label: Text('مبلغ ثابت')),
              ButtonSegment(value: 'free_shipping', label: Text('توصيل مجاني')),
            ],
            selected: {_type},
            onSelectionChanged: (s) => setState(() => _type = s.first),
          ),
          if (_type != 'free_shipping') ...[
            const SizedBox(height: 10),
            SizedBox(
              width: 240,
              child: TextField(
                key: const ValueKey('discount-value'),
                controller: _value,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(labelText: _type == 'percent' ? 'النسبة %' : 'المبلغ (${currencyLabel(currency)})'),
              ),
            ),
            const SizedBox(height: 10),
            const Text('يتطبّق على', style: TextStyle(fontWeight: FontWeight.w700)),
            RadioGroup<String>(
              groupValue: _applies,
              onChanged: (v) => setState(() => _applies = v ?? 'all'),
              child: Column(children: [
                const RadioListTile(contentPadding: EdgeInsets.zero, value: 'all', title: Text('الطلب كله')),
                const RadioListTile(contentPadding: EdgeInsets.zero, value: 'products', title: Text('منتجات معيّنة')),
                if (_collections.isNotEmpty || _applies == 'collections')
                  const RadioListTile(contentPadding: EdgeInsets.zero, value: 'collections', title: Text('أقسام معيّنة')),
              ]),
            ),
            if (_applies == 'products')
              Wrap(spacing: 6, runSpacing: 6, children: [
                for (final p in _products)
                  FilterChip(
                    label: Text(p['name'] as String? ?? ''),
                    selected: _productIds.contains(p['id']),
                    onSelected: (v) => setState(() => v ? _productIds.add(p['id'] as String) : _productIds.remove(p['id'])),
                  ),
                if (_products.isEmpty) const Text('مفيش منتجات لسه', style: TextStyle(color: AppColors.inkMuted)),
              ]),
            if (_applies == 'collections')
              Wrap(spacing: 6, runSpacing: 6, children: [
                for (final c in _collections)
                  FilterChip(
                    label: Text(c['name'] as String? ?? ''),
                    selected: _collectionIds.contains(c['id']),
                    onSelected: (v) => setState(() => v ? _collectionIds.add(c['id'] as String) : _collectionIds.remove(c['id'])),
                  ),
              ]),
          ],
        ]),
      ),
      gap,
      AdminCard(
        title: 'الشروط والحدود',
        child: Wrap(spacing: 10, runSpacing: 10, children: [
          SizedBox(
            width: 220,
            child: TextField(
              key: const ValueKey('discount-min'),
              controller: _min,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(labelText: 'أقل قيمة للطلب (${currencyLabel(currency)})', hintText: 'اختياري'),
            ),
          ),
          SizedBox(
            width: 220,
            child: TextField(
              controller: _limit,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'عدد مرات الاستخدام كله', hintText: 'من غير حد'),
            ),
          ),
          SizedBox(
            width: 220,
            child: TextField(
              controller: _perPhone,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'لكل رقم موبايل', hintText: 'من غير حد'),
            ),
          ),
        ]),
      ),
      gap,
      AdminCard(
        title: 'المدة',
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Wrap(spacing: 10, runSpacing: 6, children: [
            OutlinedButton.icon(
              onPressed: () => _pickDate(true),
              icon: const Icon(Icons.event_rounded, size: 18),
              label: Text(_starts == null ? 'يبدأ: دلوقتي' : 'يبدأ: ${df.format(_starts!)}'),
            ),
            OutlinedButton.icon(
              onPressed: () => _pickDate(false),
              icon: const Icon(Icons.event_busy_rounded, size: 18),
              label: Text(_ends == null ? 'ينتهي: من غير نهاية' : 'ينتهي: ${df.format(_ends!)}'),
            ),
            if (_ends != null) TextButton(onPressed: () => setState(() => _ends = null), child: const Text('من غير نهاية')),
          ]),
          SwitchListTile(contentPadding: EdgeInsets.zero, value: _active, onChanged: (v) => setState(() => _active = v), title: const Text('شغال')),
          if (_method == 'code')
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: _combines,
              onChanged: (v) => setState(() => _combines = v),
              title: const Text('يتجمع مع الخصومات التلقائية'),
              subtitle: const Text('مقفولة: الزبون بياخد الأوفر بين الكود والخصم التلقائي'),
            ),
        ]),
      ),
      if (_error != null) Padding(padding: const EdgeInsets.only(top: 10), child: Text(_error!, key: const ValueKey('discount-error'), style: const TextStyle(color: Colors.redAccent))),
      const SizedBox(height: 12),
      Align(
        alignment: AlignmentDirectional.centerStart,
        child: ElevatedButton.icon(
          key: const ValueKey('save-discount'),
          onPressed: _saving ? null : _save,
          icon: _saving ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.save_rounded, size: 18),
          label: const Text('احفظ الخصم'),
        ),
      ),
    ]);
  }

  Widget _usage(String currency) {
    final d = _d!;
    final (label, bg, ink) = discountState(d['state'] as String?);
    final orders = _orders;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: AdminCard(
        title: 'الاستخدام',
        trailing: Pill(label, bg, ink),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Wrap(spacing: 24, runSpacing: 8, children: [
            _stat('استُخدم', '${d['used_count'] ?? 0}${d['usage_limit'] != null ? ' / ${_n(d['usage_limit'])}' : ''}'),
            _stat('المبيعات', money((d['sales'] as num?) ?? 0, currency)),
            _stat('الخصم اللي اتدفع', money((d['saved'] as num?) ?? 0, currency)),
          ]),
          if (orders != null && orders.isNotEmpty) ...[
            const Divider(height: 20),
            const Text('الطلبات اللي استخدمته', style: TextStyle(fontWeight: FontWeight.w700)),
            for (final o in orders.take(20))
              ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                onTap: () => context.go('/orders/${o['id']}'),
                title: Text('${o['order_code'] ?? ''} — ${o['customer_name'] ?? ''}'),
                subtitle: Text('خصم ${money((o['discount_amount'] as num?) ?? 0, currency)}'),
                trailing: Text(money((o['total_amount'] as num?) ?? 0, currency), style: const TextStyle(fontWeight: FontWeight.w700)),
              ),
          ],
        ]),
      ),
    );
  }

  Widget _stat(String label, String value) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: const TextStyle(fontSize: 12, color: AppColors.inkMuted)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 17)),
      ]);
}
