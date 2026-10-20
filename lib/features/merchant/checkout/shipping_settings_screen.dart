import 'package:flutter/material.dart';

import '../../../core/geo/admin_areas.dart';
import '../../../core/geo/money.dart';
import '../../../core/shops/checkout_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/numbers.dart';
import '../../shared/load_error_view.dart';
import '../admin/admin_common.dart';
import '../admin/merchant_session.dart';

/// «الشحن والتوصيل» (/settings/shipping, 0099): zones of the shop's
/// country with their own fee / free-over / ETA, «باقي المناطق», pickup,
/// store hours, vacation, «بنستقبل طلبات», minimum order and the WhatsApp
/// confirmation rule.
class ShippingSettingsScreen extends StatefulWidget {
  const ShippingSettingsScreen({super.key});

  @override
  State<ShippingSettingsScreen> createState() => _ShippingSettingsScreenState();
}

const weekdayNames = ['الأحد', 'الاثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة', 'السبت'];

String _num(Object? v) {
  final d = (v as num?)?.toDouble();
  if (d == null) return '';
  return d == d.roundToDouble() ? '${d.toInt()}' : '$d';
}

class _ShippingSettingsScreenState extends State<ShippingSettingsScreen> {
  String? _shopId;
  Map<String, dynamic>? _data;
  bool _failed = false;
  bool _saving = false;
  String? _error;

  String _country = 'EG';
  String _currency = 'EGP';
  List<Map<String, dynamic>> _zones = [];
  String _defaultMode = 'rate';
  final _defaultFee = TextEditingController();
  final _defaultFree = TextEditingController();
  final _defaultEta = TextEditingController();
  bool _pickup = false;
  final _pickupAddress = TextEditingController();
  final _pickupNotes = TextEditingController();
  bool _accepting = true;
  bool _vacation = false;
  final _vacationMsg = TextEditingController();
  bool _hoursOn = false;
  List<Map<String, dynamic>> _hours = [for (var i = 0; i < 7; i++) {'open': true, 'from': '09:00', 'to': '23:00'}];
  String _afterHours = 'accept';
  final _minOrder = TextEditingController();
  bool _requireConfirm = false;

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
    for (final c in [_defaultFee, _defaultFree, _defaultEta, _pickupAddress, _pickupNotes, _vacationMsg, _minOrder]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => _failed = false);
    try {
      final d = await CheckoutService.shipping(_shopId!);
      if (!mounted) return;
      _fill(d);
    } catch (_) {
      if (mounted) setState(() => _failed = true);
    }
  }

  void _fill(Map<String, dynamic> d) {
    setState(() {
      _data = d;
      _country = d['country'] as String? ?? 'EG';
      _currency = d['currency'] as String? ?? 'EGP';
      _zones = [for (final z in d['zones'] as List? ?? const []) Map<String, dynamic>.from(z as Map)];
      _defaultMode = d['default_mode'] as String? ?? 'rate';
      _defaultFee.text = _num(d['default_fee']);
      _defaultFree.text = _num(d['default_free_over']);
      _defaultEta.text = d['default_eta'] as String? ?? '';
      _pickup = d['pickup_enabled'] == true;
      _pickupAddress.text = d['pickup_address'] as String? ?? '';
      _pickupNotes.text = d['pickup_instructions'] as String? ?? '';
      _accepting = d['accepting_orders'] != false;
      _vacation = d['vacation'] == true;
      _vacationMsg.text = d['vacation_message'] as String? ?? '';
      final h = d['hours'];
      _hoursOn = h is List && h.length == 7;
      if (_hoursOn) _hours = [for (final x in h) Map<String, dynamic>.from(x as Map)];
      _afterHours = d['after_hours'] as String? ?? 'accept';
      _minOrder.text = _num(d['min_order']);
      _requireConfirm = d['require_confirmation'] == true;
    });
  }

  double? _money(TextEditingController c) => c.text.trim().isEmpty ? null : looseDouble(c.text.trim());

  /// What set_shop_shipping takes.
  Map<String, dynamic> get payload => {
        'default_mode': _defaultMode,
        'default_fee': _money(_defaultFee) ?? 0,
        'default_free_over': _money(_defaultFree),
        'default_eta': _defaultEta.text.trim(),
        'zones': _zones,
        'pickup_enabled': _pickup,
        'pickup_address': _pickupAddress.text.trim(),
        'pickup_instructions': _pickupNotes.text.trim(),
        'accepting_orders': _accepting,
        'vacation': _vacation,
        'vacation_message': _vacationMsg.text.trim(),
        'hours': _hoursOn ? _hours : null,
        'after_hours': _afterHours,
        'min_order': _money(_minOrder),
        'require_confirmation': _requireConfirm,
      };

  Future<void> _save() async {
    if (_pickup && _pickupAddress.text.trim().length < 5) return setState(() => _error = 'اكتب عنوان الاستلام من المحل');
    if (_defaultFee.text.trim().isNotEmpty && (_money(_defaultFee) == null || _money(_defaultFee)! < 0)) return setState(() => _error = 'سعر التوصيل لباقي المناطق مش صحيح');
    if (!_pickup && _defaultMode == 'none' && _zones.isEmpty) return setState(() => _error = 'ضيف منطقة شحن واحدة على الأقل أو فعّل الاستلام من المحل');
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      final d = await CheckoutService.saveShipping(_shopId!, payload);
      if (!mounted) return;
      _fill(d);
      MerchantScope.of(context).load();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('اتحفظت إعدادات الشحن ✓')));
    } catch (e) {
      if (mounted) setState(() => _error = adminErrorText(e, 'تعذر الحفظ'));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _editZone([int? index]) async {
    final taken = <String>{
      for (final (i, z) in _zones.indexed)
        if (i != index) ...List<String>.from(z['areas'] as List),
    };
    final z = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) => ZoneDialog(country: _country, currency: _currency, zone: index == null ? null : _zones[index], taken: taken),
    );
    if (z == null) return;
    setState(() => index == null ? _zones.add(z) : _zones[index] = z);
  }

  Future<void> _pickTime(int day, String key) async {
    final parts = (_hours[day][key] as String? ?? '09:00').split(':');
    final t = await showTimePicker(context: context, initialTime: TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1])));
    if (t == null) return;
    setState(() => _hours[day][key] = '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}');
  }

  @override
  Widget build(BuildContext context) {
    return AdminPage(
      title: 'الشحن والتوصيل',
      subtitle: 'مناطق التوصيل وأسعارها، الاستلام من المحل، المواعيد',
      backTo: '/settings',
      scrollable: true,
      maxWidth: 900,
      body: _failed
          ? LoadErrorView(onRetry: _load)
          : _data == null
              ? const Padding(padding: EdgeInsets.all(40), child: Center(child: CircularProgressIndicator()))
              : _body(),
    );
  }

  Widget _body() {
    String m(num v) => money(v, _currency);
    final label = adminAreaLabel(_country);
    const gap = SizedBox(height: 12);
    final open = Map<String, dynamic>.from(_data!['open'] as Map? ?? const {});
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      AdminCard(
        title: 'استقبال الطلبات',
        trailing: Pill(open['can_order'] == false ? 'مقفول' : open['open_now'] == false ? 'بعد المواعيد' : 'شغال',
            open['can_order'] == false ? AppColors.categorySos.withValues(alpha: 0.12) : AppColors.success.withValues(alpha: 0.15),
            open['can_order'] == false ? const Color(0xFFB91C1C) : const Color(0xFF047857)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          SwitchListTile(
            key: const ValueKey('ship-accepting'),
            contentPadding: EdgeInsets.zero,
            value: _accepting,
            onChanged: (v) => setState(() => _accepting = v),
            title: const Text('بنستقبل طلبات'),
            subtitle: const Text('اقفلها لو عندك ضغط ومش قادر تجهّز طلبات جديدة'),
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            value: _vacation,
            onChanged: (v) => setState(() => _vacation = v),
            title: const Text('المحل في إجازة'),
            subtitle: const Text('الزبون بيشوف المنتجات بس مش بيقدر يطلب'),
          ),
          if (_vacation)
            TextField(controller: _vacationMsg, maxLength: 200, decoration: const InputDecoration(labelText: 'رسالة للزبون', hintText: 'إجازة العيد — راجعين السبت')),
        ]),
      ),
      gap,
      AdminCard(
        title: 'مناطق الشحن',
        trailing: TextButton.icon(key: const ValueKey('add-zone'), onPressed: () => _editZone(), icon: const Icon(Icons.add_rounded, size: 18), label: const Text('أضف منطقة')),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text('كل منطقة شحن = مجموعة ${_country == 'EG' ? 'محافظات' : 'مناطق'} بسعر توصيل واحد. الزبون بيختار $label وبيشوف السعر الصح.',
              style: const TextStyle(fontSize: 12.5, color: AppColors.inkSecondary)),
          const SizedBox(height: 8),
          if (_zones.isEmpty)
            const Padding(padding: EdgeInsets.symmetric(vertical: 10), child: Text('مفيش مناطق — كل الطلبات بسعر «باقي المناطق»', style: TextStyle(color: AppColors.inkMuted))),
          for (final (i, z) in _zones.indexed)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const CircleAvatar(backgroundColor: AppColors.surfaceAlt, child: Icon(Icons.local_shipping_outlined, color: AppColors.crystal)),
              title: Text(z['name'] as String, style: const TextStyle(fontWeight: FontWeight.w700)),
              subtitle: Text(
                [
                  (z['areas'] as List).join('، '),
                  [
                    (z['fee'] as num? ?? 0) == 0 ? 'مجاني' : m(z['fee'] as num),
                    if (z['free_over'] != null) 'مجاني فوق ${m(z['free_over'] as num)}',
                    if ((z['eta'] as String?)?.isNotEmpty ?? false) z['eta'],
                  ].join(' • '),
                ].join('\n'),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              isThreeLine: true,
              trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                IconButton(tooltip: 'تعديل', onPressed: () => _editZone(i), icon: const Icon(Icons.edit_outlined)),
                IconButton(tooltip: 'حذف', onPressed: () => setState(() => _zones.removeAt(i)), icon: const Icon(Icons.delete_outline_rounded)),
              ]),
            ),
          const Divider(height: 24),
          const Text('باقي المناطق', style: TextStyle(fontWeight: FontWeight.w800)),
          RadioGroup<String>(
            groupValue: _defaultMode,
            onChanged: (v) => setState(() => _defaultMode = v ?? 'rate'),
            child: const Column(children: [
              RadioListTile(contentPadding: EdgeInsets.zero, value: 'rate', title: Text('بنوصّل بسعر ثابت')),
              RadioListTile(contentPadding: EdgeInsets.zero, value: 'none', title: Text('مش بنوصّل هناك')),
            ]),
          ),
          if (_defaultMode == 'rate')
            Wrap(spacing: 10, runSpacing: 10, children: [
              SizedBox(
                width: 200,
                child: TextField(
                  key: const ValueKey('default-fee'),
                  controller: _defaultFee,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(labelText: 'سعر التوصيل (${currencyLabel(_currency)})', hintText: 'فاضي = مجاني'),
                ),
              ),
              SizedBox(
                width: 200,
                child: TextField(
                  controller: _defaultFree,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(labelText: 'مجاني لو الطلب فوق', hintText: 'اختياري'),
                ),
              ),
              SizedBox(width: 200, child: TextField(controller: _defaultEta, decoration: const InputDecoration(labelText: 'مدة التوصيل', hintText: '2-3 أيام'))),
            ]),
        ]),
      ),
      gap,
      AdminCard(
        title: 'الاستلام من المحل',
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            value: _pickup,
            onChanged: (v) => setState(() => _pickup = v),
            title: const Text('الزبون يقدر يستلم من المحل'),
            subtitle: const Text('من غير مصاريف توصيل'),
          ),
          if (_pickup) ...[
            TextField(controller: _pickupAddress, decoration: const InputDecoration(labelText: 'عنوان الاستلام *', hintText: 'الشارع، الحي — علامة مميزة')),
            const SizedBox(height: 8),
            TextField(controller: _pickupNotes, decoration: const InputDecoration(labelText: 'تعليمات (اختياري)', hintText: 'الطلب بيبقى جاهز خلال ساعة من التأكيد')),
          ],
        ]),
      ),
      gap,
      AdminCard(
        title: 'مواعيد المحل',
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            value: _hoursOn,
            onChanged: (v) => setState(() => _hoursOn = v),
            title: const Text('عندي مواعيد شغل'),
            subtitle: const Text('مقفولة = بنستقبل طلبات 24 ساعة'),
          ),
          if (_hoursOn) ...[
            for (var d = 0; d < 7; d++)
              Row(children: [
                SizedBox(width: 86, child: Text(weekdayNames[d], style: const TextStyle(fontWeight: FontWeight.w600))),
                Switch(value: _hours[d]['open'] == true, onChanged: (v) => setState(() => _hours[d]['open'] = v)),
                const SizedBox(width: 6),
                if (_hours[d]['open'] == true) ...[
                  TextButton(onPressed: () => _pickTime(d, 'from'), child: Text('من ${_hours[d]['from']}')),
                  TextButton(onPressed: () => _pickTime(d, 'to'), child: Text('لـ ${_hours[d]['to']}')),
                ] else
                  const Text('إجازة', style: TextStyle(color: AppColors.inkMuted)),
              ]),
            const SizedBox(height: 6),
            const Text('بعد المواعيد:', style: TextStyle(fontWeight: FontWeight.w700)),
            RadioGroup<String>(
              groupValue: _afterHours,
              onChanged: (v) => setState(() => _afterHours = v ?? 'accept'),
              child: const Column(children: [
                RadioListTile(contentPadding: EdgeInsets.zero, value: 'accept', title: Text('نستقبل الطلب ونجهّزه أول ما نفتح')),
                RadioListTile(contentPadding: EdgeInsets.zero, value: 'refuse', title: Text('منستقبلش طلبات')),
              ]),
            ),
          ],
        ]),
      ),
      gap,
      AdminCard(
        title: 'قواعد الطلب',
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          SizedBox(
            width: 260,
            child: TextField(
              controller: _minOrder,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(labelText: 'أقل قيمة للطلب (${currencyLabel(_currency)})', hintText: 'فاضي = من غير حد أدنى'),
            ),
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            value: _requireConfirm,
            onChanged: (v) => setState(() => _requireConfirm = v),
            title: const Text('اطلب تأكيد واتساب قبل التجهيز'),
            subtitle: const Text('طلبات الكاش مش بتتجهّز غير لما تدوس «اتأكد» بعد ما الزبون يأكّد — بيقلل الطلبات الوهمية'),
          ),
        ]),
      ),
      if (_error != null) Padding(padding: const EdgeInsets.only(top: 10), child: Text(_error!, style: const TextStyle(color: Colors.redAccent))),
      const SizedBox(height: 12),
      Align(
        alignment: AlignmentDirectional.centerStart,
        child: ElevatedButton.icon(
          key: const ValueKey('save-shipping'),
          onPressed: _saving ? null : _save,
          icon: _saving ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.save_rounded, size: 18),
          label: const Text('احفظ الشحن والتوصيل'),
        ),
      ),
    ]);
  }
}

/// Add / edit one shipping zone.
class ZoneDialog extends StatefulWidget {
  const ZoneDialog({super.key, required this.country, required this.currency, this.zone, this.taken = const {}});
  final String country;
  final String currency;
  final Map<String, dynamic>? zone;

  /// Areas already in another zone (an area is in one zone only).
  final Set<String> taken;

  @override
  State<ZoneDialog> createState() => _ZoneDialogState();
}

class _ZoneDialogState extends State<ZoneDialog> {
  late final _name = TextEditingController(text: widget.zone?['name'] as String? ?? '');
  late final _fee = TextEditingController(text: _num(widget.zone?['fee']));
  late final _free = TextEditingController(text: _num(widget.zone?['free_over']));
  late final _eta = TextEditingController(text: widget.zone?['eta'] as String? ?? '');
  late final Set<String> _areas = {...List<String>.from(widget.zone?['areas'] as List? ?? const [])};
  String? _error;

  @override
  void dispose() {
    for (final c in [_name, _fee, _free, _eta]) {
      c.dispose();
    }
    super.dispose();
  }

  void _done() {
    final fee = _fee.text.trim().isEmpty ? 0.0 : looseDouble(_fee.text.trim());
    final free = _free.text.trim().isEmpty ? null : looseDouble(_free.text.trim());
    final problem = _name.text.trim().isEmpty
        ? 'اكتب اسم المنطقة'
        : _areas.isEmpty
            ? 'اختار ${adminAreaLabel(widget.country)} واحدة على الأقل'
            : fee == null || fee < 0
                ? 'سعر التوصيل مش صحيح'
                : _free.text.trim().isNotEmpty && (free == null || free <= 0)
                    ? 'حد التوصيل المجاني مش صحيح'
                    : null;
    if (problem != null) return setState(() => _error = problem);
    Navigator.of(context).pop(<String, dynamic>{
      if (widget.zone?['id'] != null) 'id': widget.zone!['id'],
      'name': _name.text.trim(),
      'areas': [for (final a in adminAreaNames(widget.country)) if (_areas.contains(a)) a, ..._areas.where((a) => !adminAreaNames(widget.country).contains(a))],
      'fee': fee,
      'free_over': free,
      'eta': _eta.text.trim().isEmpty ? null : _eta.text.trim(),
    });
  }

  @override
  Widget build(BuildContext context) {
    final names = adminAreaNames(widget.country);
    return AlertDialog(
      title: Text(widget.zone == null ? 'منطقة شحن جديدة' : 'تعديل المنطقة'),
      content: SizedBox(
        width: 520,
        child: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            TextField(key: const ValueKey('zone-name'), controller: _name, decoration: const InputDecoration(labelText: 'اسم المنطقة', hintText: 'المنطقة القريبة')),
            const SizedBox(height: 10),
            Row(children: [
              Expanded(child: Text(adminAreaLabel(widget.country), style: const TextStyle(fontWeight: FontWeight.w700))),
              TextButton(
                onPressed: () => setState(() => _areas.addAll(names.where((a) => !widget.taken.contains(a)))),
                child: const Text('اختار الكل'),
              ),
            ]),
            Wrap(spacing: 6, runSpacing: 6, children: [
              for (final a in names)
                FilterChip(
                  label: Text(a),
                  selected: _areas.contains(a),
                  onSelected: widget.taken.contains(a) ? null : (v) => setState(() => v ? _areas.add(a) : _areas.remove(a)),
                  tooltip: widget.taken.contains(a) ? 'موجودة في منطقة تانية' : null,
                ),
            ]),
            const SizedBox(height: 10),
            Row(children: [
              Expanded(
                child: TextField(
                  key: const ValueKey('zone-fee'),
                  controller: _fee,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(labelText: 'سعر التوصيل (${currencyLabel(widget.currency)})', hintText: 'فاضي = مجاني'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _free,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(labelText: 'مجاني فوق', hintText: 'اختياري'),
                ),
              ),
            ]),
            const SizedBox(height: 8),
            TextField(controller: _eta, decoration: const InputDecoration(labelText: 'مدة التوصيل (اختياري)', hintText: 'خلال يوم')),
            if (_error != null) Padding(padding: const EdgeInsets.only(top: 8), child: Text(_error!, style: const TextStyle(color: Colors.redAccent))),
          ]),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('إلغاء')),
        FilledButton(key: const ValueKey('zone-done'), onPressed: _done, child: const Text('تمام')),
      ],
    );
  }
}
