import 'package:flutter/material.dart';

import '../../core/shops/catalog.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/numbers.dart';
import 'admin/admin_common.dart';

/// The editor's options + variants (0098, Shopify-style): up to 3 options
/// with free names and values; the matrix of every combination is made
/// from them, each row with its price, compare-at, stock, SKU, barcode,
/// photo (one of the product's) and an «متاح» switch. Editing the
/// options keeps the rows that still exist (matched by their values).
class VariantsModel extends ChangeNotifier {
  VariantsModel({List<ProductOption> options = const [], List<Map<String, dynamic>> variants = const []}) {
    for (final o in options) {
      _options.add(OptionDraft(o.name, o.values));
    }
    for (final v in variants) {
      final d = VariantDraft(valuesOf(v), price: _fmt(v['price']), compareAt: _fmt(v['compare_at_price']), stock: _fmt(v['stock']),
          sku: v['sku'] as String? ?? '', barcode: v['barcode'] as String? ?? '', imageUrl: v['image_url'] as String?, available: v['is_available'] != false);
      _byKey[comboKey(d.values)] = d;
    }
    _rebuild();
  }

  static const maxOptions = 3;
  static const maxVariants = 100;
  static const suggestedNames = ['المقاس', 'اللون', 'الخامة', 'الحجم', 'الموديل'];

  final List<OptionDraft> _options = [];
  final Map<String, VariantDraft> _byKey = {};
  List<VariantDraft> _variants = [];

  /// Prices / stock new rows start with (the product's own fields).
  String defaultPrice = '';
  String defaultCompareAt = '';
  String defaultStock = '';

  List<OptionDraft> get options => List.unmodifiable(_options);
  List<VariantDraft> get variants => List.unmodifiable(_variants);
  bool get hasOptions => _options.any((o) => o.values.isNotEmpty);

  /// Options that have a name and values (what gets saved).
  List<ProductOption> get cleanOptions => [
        for (final o in _options)
          if (o.name.text.trim().isNotEmpty && o.values.isNotEmpty) (name: o.name.text.trim(), values: List.of(o.values)),
      ];

  int get matrixSize => cleanOptions.fold(cleanOptions.isEmpty ? 0 : 1, (n, o) => n * o.values.length);

  static String _fmt(Object? v) {
    if (v == null) return '';
    final n = v is num ? v : num.tryParse('$v');
    if (n == null) return '$v';
    return n == n.roundToDouble() ? '${n.toInt()}' : '$n';
  }

  void addOption() {
    if (_options.length >= maxOptions) return;
    final used = _options.map((o) => o.name.text.trim()).toSet();
    _options.add(OptionDraft(suggestedNames.firstWhere((n) => !used.contains(n), orElse: () => ''), const []));
    notifyListeners();
  }

  void removeOption(int i) {
    _options.removeAt(i).dispose();
    _rebuild();
  }

  /// Adds one or more values ("S، M، L") to option [i].
  void addValues(int i, String text) {
    final o = _options[i];
    for (final raw in text.split(RegExp(r'[,،\n]'))) {
      final v = raw.trim();
      if (v.isEmpty || o.values.contains(v) || o.values.length >= 30) continue;
      o.values.add(v.length > 40 ? v.substring(0, 40) : v);
    }
    _rebuild();
  }

  void removeValue(int i, String value) {
    _options[i].values.remove(value);
    _rebuild();
  }

  /// Renaming an option keeps its rows.
  void renamed() => notifyListeners();

  void _rebuild() {
    final matrix = optionsMatrix(cleanOptions);
    final next = <VariantDraft>[];
    for (final combo in matrix.take(maxVariants)) {
      final key = comboKey(combo);
      next.add(_byKey[key] ??= VariantDraft(combo, price: defaultPrice, compareAt: defaultCompareAt, stock: defaultStock));
    }
    _variants = next;
    notifyListeners();
  }

  String labelOf(VariantDraft v) => variantLabel(cleanOptions, v.values);

  /// Sets a field on the selected rows (all rows when none is selected).
  void bulkSet({String? price, String? compareAt, String? stock}) {
    final targets = _variants.where((v) => v.selected).toList();
    for (final v in targets.isEmpty ? _variants : targets) {
      if (price != null) v.price.text = price;
      if (compareAt != null) v.compareAt.text = compareAt;
      if (stock != null) v.stock.text = stock;
    }
    notifyListeners();
  }

  void selectAll(bool on) {
    for (final v in _variants) {
      v.selected = on;
    }
    notifyListeners();
  }

  void toggle(VariantDraft v) {
    v.selected = !v.selected;
    notifyListeners();
  }

  void setImage(VariantDraft v, String? url) {
    v.imageUrl = url;
    notifyListeners();
  }

  void setAvailable(VariantDraft v, bool on) {
    v.available = on;
    notifyListeners();
  }

  /// Drops variant photos that are no longer product photos.
  void keepImages(List<String> images) {
    for (final v in _byKey.values) {
      if (v.imageUrl != null && !images.contains(v.imageUrl)) v.imageUrl = null;
    }
  }

  /// The first problem (Arabic), or null when everything can be saved.
  /// [currency]: the store's (prices may have 2 or 3 decimals).
  String? validate({String? currency}) {
    final names = <String>{};
    for (final o in _options) {
      final n = o.name.text.trim();
      if (o.values.isEmpty) return n.isEmpty ? 'ضيف قيم للخيار أو امسحه' : 'ضيف قيمة واحدة على الأقل لـ «$n»';
      if (n.isEmpty) return 'اكتب اسم الخيار (مثلاً: المقاس)';
      if (!names.add(n.toLowerCase())) return 'الخيار «$n» متكرر';
    }
    if (matrixSize > maxVariants) return 'لحد $maxVariants نوع للمنتج — قلّل القيم';
    final skus = <String>{};
    for (final v in _variants) {
      final label = labelOf(v);
      final price = looseDouble(v.price.text.trim());
      if (price == null || price < 0) return 'اكتب سعر «$label»';
      if (!priceFitsCurrency(price, currency)) return 'سعر «$label» فيه أرقام بعد العلامة أكتر من اللازم';
      final cmp = v.compareAt.text.trim().isEmpty ? null : looseDouble(v.compareAt.text.trim());
      if (v.compareAt.text.trim().isNotEmpty && (cmp == null || cmp <= price)) return 'السعر قبل الخصم لـ «$label» لازم يكون أكبر من سعره';
      if (v.stock.text.trim().isNotEmpty && (looseInt(v.stock.text.trim()) == null || looseInt(v.stock.text.trim())! < 0)) return 'الكمية لـ «$label» لازم تكون رقم';
      final sku = v.sku.text.trim().toLowerCase();
      if (sku.isNotEmpty && !skus.add(sku)) return 'الـ SKU «${v.sku.text.trim()}» متكرر';
    }
    return null;
  }

  /// merchant_save_product's p_variants.
  List<Map<String, dynamic>> toJson() => [
        for (final v in _variants)
          {
            'option_values': v.values,
            'price': looseDouble(v.price.text.trim()),
            'compare_at_price': v.compareAt.text.trim().isEmpty ? null : looseDouble(v.compareAt.text.trim()),
            'stock': v.stock.text.trim().isEmpty ? null : looseInt(v.stock.text.trim()),
            'sku': v.sku.text.trim().isEmpty ? null : v.sku.text.trim(),
            'barcode': v.barcode.text.trim().isEmpty ? null : v.barcode.text.trim(),
            'image_url': v.imageUrl,
            'is_available': v.available,
          },
      ];

  @override
  void dispose() {
    for (final o in _options) {
      o.dispose();
    }
    for (final v in _byKey.values) {
      v.dispose();
    }
    super.dispose();
  }
}

class OptionDraft {
  OptionDraft(String name, List<String> values)
      : name = TextEditingController(text: name),
        values = List.of(values);
  final TextEditingController name;
  final List<String> values;
  final TextEditingController input = TextEditingController();

  void dispose() {
    name.dispose();
    input.dispose();
  }
}

class VariantDraft {
  VariantDraft(this.values, {String price = '', String compareAt = '', String stock = '', String sku = '', String barcode = '', this.imageUrl, this.available = true})
      : price = TextEditingController(text: price),
        compareAt = TextEditingController(text: compareAt),
        stock = TextEditingController(text: stock),
        sku = TextEditingController(text: sku),
        barcode = TextEditingController(text: barcode);
  final List<String> values;
  final TextEditingController price;
  final TextEditingController compareAt;
  final TextEditingController stock;
  final TextEditingController sku;
  final TextEditingController barcode;
  String? imageUrl;
  bool available;
  bool selected = false;

  void dispose() {
    price.dispose();
    compareAt.dispose();
    stock.dispose();
    sku.dispose();
    barcode.dispose();
  }
}

/// The options + variants card of the product editor.
class VariantsEditor extends StatelessWidget {
  const VariantsEditor({super.key, required this.model, required this.images, required this.currencyLabel});
  final VariantsModel model;

  /// The product's photos (a variant's photo is one of them).
  final List<String> images;
  final String currencyLabel;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: model,
      builder: (context, _) => Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        for (final (i, o) in model.options.indexed) _OptionEditor(model: model, index: i, option: o),
        if (model.options.length < VariantsModel.maxOptions)
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: TextButton.icon(
              key: const ValueKey('add-option'),
              onPressed: model.addOption,
              icon: const Icon(Icons.add_rounded),
              label: Text(model.options.isEmpty ? 'ضيف خيارات زي المقاس أو اللون' : 'ضيف خيار تاني'),
            ),
          ),
        if (model.matrixSize > VariantsModel.maxVariants)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text('الخيارات دي بتعمل ${model.matrixSize} نوع — الحد ${VariantsModel.maxVariants}',
                style: const TextStyle(color: Colors.redAccent, fontSize: 12)),
          ),
        if (model.variants.isNotEmpty) ...[
          const SizedBox(height: 8),
          _BulkBar(model: model),
          const SizedBox(height: 6),
          LayoutBuilder(builder: (context, c) {
            final wide = c.maxWidth >= 640;
            return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              if (wide) const _TableHeader(),
              for (final v in model.variants)
                _VariantRow(key: ValueKey('variant-${comboKey(v.values)}'), model: model, v: v, images: images, wide: wide, currencyLabel: currencyLabel),
            ]);
          }),
        ],
      ]),
    );
  }
}

class _OptionEditor extends StatelessWidget {
  const _OptionEditor({required this.model, required this.index, required this.option});
  final VariantsModel model;
  final int index;
  final OptionDraft option;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(14)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Row(children: [
          Expanded(
            child: TextField(
              key: ValueKey('option-name-$index'),
              controller: option.name,
              onChanged: (_) => model.renamed(),
              decoration: InputDecoration(labelText: 'اسم الخيار ${index + 1}', hintText: 'المقاس، اللون، الخامة…', isDense: true),
            ),
          ),
          IconButton(tooltip: 'امسح الخيار', onPressed: () => model.removeOption(index), icon: const Icon(Icons.delete_outline_rounded)),
        ]),
        if (option.name.text.trim().isEmpty)
          Wrap(spacing: 6, children: [
            for (final n in VariantsModel.suggestedNames)
              ActionChip(
                label: Text(n, style: const TextStyle(fontSize: 12)),
                visualDensity: VisualDensity.compact,
                onPressed: () {
                  option.name.text = n;
                  model.renamed();
                },
              ),
          ]),
        const SizedBox(height: 8),
        Wrap(spacing: 6, runSpacing: 6, crossAxisAlignment: WrapCrossAlignment.center, children: [
          for (final v in option.values)
            InputChip(
              key: ValueKey('value-$index-$v'),
              label: Text(v),
              onDeleted: () => model.removeValue(index, v),
              deleteButtonTooltipMessage: 'امسح',
            ),
          SizedBox(
            width: 190,
            child: TextField(
              key: ValueKey('option-input-$index'),
              controller: option.input,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                isDense: true,
                hintText: 'ضيف قيمة (S، M…)',
                suffixIcon: IconButton(
                  tooltip: 'ضيف',
                  icon: const Icon(Icons.add_circle_rounded, color: AppColors.crystal),
                  onPressed: () {
                    model.addValues(index, option.input.text);
                    option.input.clear();
                  },
                ),
              ),
              onSubmitted: (t) {
                model.addValues(index, t);
                option.input.clear();
              },
            ),
          ),
        ]),
      ]),
    );
  }
}

class _BulkBar extends StatelessWidget {
  const _BulkBar({required this.model});
  final VariantsModel model;

  Future<void> _ask(BuildContext context, String title, void Function(String) apply, {bool allowEmpty = false}) async {
    final v = await askAdminText(context, title: title, number: true, hint: allowEmpty ? 'فاضية = مفتوحة' : null);
    if (v == null || (!allowEmpty && v.isEmpty)) return;
    apply(v);
  }

  @override
  Widget build(BuildContext context) {
    final n = model.variants.where((v) => v.selected).length;
    final all = n == model.variants.length;
    final scope = n == 0 ? 'الكل' : '$n محدد';
    return Wrap(spacing: 8, runSpacing: 6, crossAxisAlignment: WrapCrossAlignment.center, children: [
      Text('${model.variants.length} نوع', style: const TextStyle(fontWeight: FontWeight.w800)),
      TextButton(onPressed: () => model.selectAll(!all), child: Text(all ? 'إلغاء التحديد' : 'حدد الكل')),
      OutlinedButton.icon(
        key: const ValueKey('bulk-price'),
        onPressed: () => _ask(context, 'السعر لـ $scope', (v) => model.bulkSet(price: v)),
        icon: const Icon(Icons.sell_outlined, size: 16),
        label: Text('السعر ($scope)'),
      ),
      OutlinedButton.icon(
        onPressed: () => _ask(context, 'السعر قبل الخصم لـ $scope', (v) => model.bulkSet(compareAt: v), allowEmpty: true),
        icon: const Icon(Icons.local_offer_outlined, size: 16),
        label: const Text('قبل الخصم'),
      ),
      OutlinedButton.icon(
        key: const ValueKey('bulk-stock'),
        onPressed: () => _ask(context, 'الكمية لـ $scope', (v) => model.bulkSet(stock: v), allowEmpty: true),
        icon: const Icon(Icons.inventory_2_outlined, size: 16),
        label: Text('الكمية ($scope)'),
      ),
    ]);
  }
}

class _TableHeader extends StatelessWidget {
  const _TableHeader();

  @override
  Widget build(BuildContext context) {
    const style = TextStyle(fontSize: 11.5, color: AppColors.inkMuted, fontWeight: FontWeight.w700);
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: Row(children: [
        SizedBox(width: 40),
        SizedBox(width: 52, child: Text('صورة', style: style)),
        Expanded(flex: 3, child: Text('النوع', style: style)),
        Expanded(flex: 2, child: Text('السعر', style: style)),
        Expanded(flex: 2, child: Text('قبل الخصم', style: style)),
        Expanded(flex: 2, child: Text('الكمية', style: style)),
        Expanded(flex: 2, child: Text('SKU', style: style)),
        Expanded(flex: 2, child: Text('باركود', style: style)),
        SizedBox(width: 56, child: Text('متاح', style: style)),
      ]),
    );
  }
}

class _VariantRow extends StatelessWidget {
  const _VariantRow({super.key, required this.model, required this.v, required this.images, required this.wide, required this.currencyLabel});
  final VariantsModel model;
  final VariantDraft v;
  final List<String> images;
  final bool wide;
  final String currencyLabel;

  Future<void> _pickImage(BuildContext context) async {
    if (images.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('ضيف صور للمنتج الأول، وبعدين اختار صورة لكل نوع')));
      return;
    }
    final picked = await showDialog<String>(
      context: context,
      builder: (d) => AlertDialog(
        title: Text('صورة «${model.labelOf(v)}»'),
        content: Wrap(spacing: 8, runSpacing: 8, children: [
          for (final url in images)
            InkWell(
              onTap: () => Navigator.pop(d, url),
              child: Container(
                decoration: BoxDecoration(border: Border.all(color: url == v.imageUrl ? AppColors.crystal : AppColors.border, width: 2), borderRadius: BorderRadius.circular(12)),
                child: ClipRRect(borderRadius: BorderRadius.circular(10), child: Image.network(url, width: 72, height: 72, cacheWidth: 200, fit: BoxFit.cover)),
              ),
            ),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(d, ''), child: const Text('من غير صورة')),
          TextButton(onPressed: () => Navigator.pop(d), child: const Text('تراجع')),
        ],
      ),
    );
    if (picked == null) return;
    model.setImage(v, picked.isEmpty ? null : picked);
  }

  Widget _thumb(BuildContext context) => InkWell(
        onTap: () => _pickImage(context),
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.border)),
          child: v.imageUrl == null
              ? const Icon(Icons.add_photo_alternate_outlined, size: 20, color: AppColors.inkMuted)
              : ClipRRect(borderRadius: BorderRadius.circular(9), child: Image.network(v.imageUrl!, cacheWidth: 120, fit: BoxFit.cover)),
        ),
      );

  Widget _field(TextEditingController c, String label, {bool number = true, Key? key}) => TextField(
        key: key,
        controller: c,
        keyboardType: number ? const TextInputType.numberWithOptions(decimal: true) : TextInputType.text,
        decoration: InputDecoration(isDense: true, labelText: wide ? null : label, hintText: wide ? label : null),
        style: const TextStyle(fontSize: 13),
      );

  @override
  Widget build(BuildContext context) {
    final label = model.labelOf(v);
    final k = comboKey(v.values);
    final check = Checkbox(value: v.selected, onChanged: (_) => model.toggle(v));
    final available = Switch(value: v.available, onChanged: (on) => model.setAvailable(v, on));
    if (wide) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        decoration: const BoxDecoration(border: Border(top: BorderSide(color: AppColors.border))),
        child: Row(children: [
          SizedBox(width: 40, child: check),
          SizedBox(width: 52, child: Align(alignment: AlignmentDirectional.centerStart, child: _thumb(context))),
          Expanded(flex: 3, child: Text(v.values.join(' / '), style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13))),
          Expanded(flex: 2, child: Padding(padding: const EdgeInsetsDirectional.only(end: 6), child: _field(v.price, 'السعر ($currencyLabel)', key: ValueKey('vprice-$k')))),
          Expanded(flex: 2, child: Padding(padding: const EdgeInsetsDirectional.only(end: 6), child: _field(v.compareAt, 'قبل الخصم'))),
          Expanded(flex: 2, child: Padding(padding: const EdgeInsetsDirectional.only(end: 6), child: _field(v.stock, 'مفتوحة', key: ValueKey('vstock-$k')))),
          Expanded(flex: 2, child: Padding(padding: const EdgeInsetsDirectional.only(end: 6), child: _field(v.sku, 'SKU', number: false))),
          Expanded(flex: 2, child: Padding(padding: const EdgeInsetsDirectional.only(end: 6), child: _field(v.barcode, 'باركود', number: false))),
          SizedBox(width: 56, child: available),
        ]),
      );
    }
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Row(children: [
          check,
          _thumb(context),
          const SizedBox(width: 8),
          Expanded(child: Text(label, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13))),
          available,
        ]),
        const SizedBox(height: 6),
        Row(children: [
          Expanded(child: _field(v.price, 'السعر ($currencyLabel)', key: ValueKey('vprice-$k'))),
          const SizedBox(width: 6),
          Expanded(child: _field(v.compareAt, 'قبل الخصم')),
          const SizedBox(width: 6),
          Expanded(child: _field(v.stock, 'الكمية', key: ValueKey('vstock-$k'))),
        ]),
        const SizedBox(height: 6),
        Row(children: [
          Expanded(child: _field(v.sku, 'SKU', number: false)),
          const SizedBox(width: 6),
          Expanded(child: _field(v.barcode, 'باركود', number: false)),
        ]),
      ]),
    );
  }
}
