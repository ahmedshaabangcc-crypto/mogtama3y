/// متجري's catalogue model (migration 0098): options → variants, the
/// storefront's variant pick, collections, and the Shopify-like CSV.
///
/// A product map may carry `variants` (from merchant_catalog /
/// store_catalog / merchant_product): one map per combination with
/// option_values (the values in option order), sku, barcode, price,
/// compare_at_price, stock (null = unlimited), image_url, position,
/// is_available. A product with no options has no variants: the product
/// row is its single variant.
library;

typedef ProductOption = ({String name, List<String> values});

/// Option definitions of a product: [{name: 'المقاس', values: ['S','M']}].
List<ProductOption> productOptions(Map<String, dynamic> p) {
  final raw = p['options'];
  if (raw is! List) return const [];
  return [
    for (final o in raw)
      if (o is Map && o['name'] is String && o['values'] is List)
        (name: o['name'] as String, values: List<String>.from((o['values'] as List).map((v) => '$v'))),
  ].where((o) => o.values.isNotEmpty).toList();
}

List<Map<String, dynamic>> variantsOf(Map<String, dynamic> p) {
  final raw = p['variants'];
  if (raw is! List) return const [];
  final list = [for (final v in raw) if (v is Map) Map<String, dynamic>.from(v)];
  list.sort((a, b) => ((a['position'] as num?) ?? 0).compareTo((b['position'] as num?) ?? 0));
  return list;
}

List<String> valuesOf(Map<String, dynamic> v) => [for (final x in (v['option_values'] as List? ?? const [])) '$x'];

/// «المقاس: M • اللون: أسود» — the same text the server and old carts use.
String variantLabel(List<ProductOption> options, List<String> values) => [
      for (var i = 0; i < options.length && i < values.length; i++) '${options[i].name}: ${values[i]}',
    ].join(' • ');

String variantLabelOf(Map<String, dynamic> product, Map<String, dynamic> variant) => variantLabel(productOptions(product), valuesOf(variant));

/// Every combination of the option values, in order.
List<List<String>> optionsMatrix(List<ProductOption> options) {
  if (options.isEmpty) return const [];
  var acc = <List<String>>[[]];
  for (final o in options) {
    acc = [
      for (final a in acc)
        for (final v in o.values) [...a, v],
    ];
  }
  return acc;
}

String comboKey(List<String> values) => values.join('\u0001');

bool _inStock(Map<String, dynamic> v) => v['stock'] == null || ((v['stock'] as num) > 0);

/// The product as one variant shows it: its price, compare-at, stock and
/// image first; `variant_id` / `variant_label` set. Null [v] → [p].
Map<String, dynamic> productWithVariant(Map<String, dynamic> p, Map<String, dynamic>? v) {
  if (v == null) return p;
  final images = [
    ...List<String>.from(p['images'] as List? ?? const []),
    if ((p['images'] as List? ?? const []).isEmpty && p['image_url'] is String) p['image_url'] as String,
  ];
  final img = v['image_url'] as String?;
  final ordered = img == null ? images : [img, ...images.where((x) => x != img)];
  final cmp = (v['compare_at_price'] as num?);
  final price = (v['price'] as num?) ?? 0;
  return {
    ...p,
    'price': price,
    'old_price': cmp != null && cmp > price ? cmp : null,
    'stock': v['stock'],
    'images': ordered,
    'image_url': ordered.isEmpty ? null : ordered.first,
    'variant_id': v['id'],
    'variant_label': variantLabelOf(p, v),
    'sku': v['sku'],
  };
}

/// The variant matching every chosen value, or null.
Map<String, dynamic>? findVariant(Map<String, dynamic> p, Map<String, String> chosen) {
  final options = productOptions(p);
  if (options.isEmpty || chosen.length < options.length) return null;
  for (final v in variantsOf(p)) {
    final vals = valuesOf(v);
    var all = true;
    for (var i = 0; i < options.length; i++) {
      if (i >= vals.length || chosen[options[i].name] != vals[i]) {
        all = false;
        break;
      }
    }
    if (all) return v;
  }
  return null;
}

/// Whether picking [value] for option [index] (keeping the other chosen
/// values) can still lead to an available variant with stock.
bool valueAvailable(Map<String, dynamic> p, int index, String value, Map<String, String> chosen) {
  final options = productOptions(p);
  for (final v in variantsOf(p)) {
    if (v['is_available'] == false || !_inStock(v)) continue;
    final vals = valuesOf(v);
    if (index >= vals.length || vals[index] != value) continue;
    var ok = true;
    for (var i = 0; i < options.length; i++) {
      if (i == index) continue;
      final c = chosen[options[i].name];
      if (c != null && (i >= vals.length || vals[i] != c)) {
        ok = false;
        break;
      }
    }
    if (ok) return true;
  }
  return false;
}

/// Lowest / highest price over the (available) variants, or the product's.
({num min, num max}) priceRange(Map<String, dynamic> p) {
  final vs = variantsOf(p).where((v) => v['is_available'] != false).toList();
  if (vs.isEmpty) {
    final price = (p['price'] as num?) ?? 0;
    return (min: price, max: price);
  }
  final prices = vs.map((v) => (v['price'] as num?) ?? 0).toList()..sort();
  return (min: prices.first, max: prices.last);
}

/// Units in stock: the product's, or the sum of its available variants'
/// (null = unlimited).
int? stockTotal(Map<String, dynamic> p) {
  final vs = variantsOf(p).where((v) => v['is_available'] != false).toList();
  if (vs.isEmpty) return variantsOf(p).isEmpty ? (p['stock'] as num?)?.toInt() : 0;
  if (vs.any((v) => v['stock'] == null)) return null;
  return vs.fold<int>(0, (s, v) => s + (v['stock'] as num).toInt());
}

/// Every variant sold out (or the product's own stock at 0).
bool allSoldOut(Map<String, dynamic> p) {
  final total = stockTotal(p);
  return total != null && total <= 0;
}

/// The 11-character YouTube id of a link, or null.
String? youtubeId(String? url) {
  if (url == null) return null;
  final m = RegExp(r'^(?:https?://)?(?:www\.|m\.)?(?:youtube\.com/(?:watch\?(?:[^#]*&)?v=|shorts/|embed/|live/)|youtu\.be/)([A-Za-z0-9_-]{11})(?:[?&#/].*)?$')
      .firstMatch(url.trim());
  return m?.group(1);
}

/// A handle from any text (the server's catalog_slugify).
String catalogSlugify(String text) {
  var s = text.toLowerCase().replaceAll(RegExp('[ً-ٟـ]'), '');
  s = s.replaceAll(RegExp('[^a-z0-9ء-ي٠-٩]+'), '-');
  s = s.replaceAll(RegExp(r'^-+|-+$'), '');
  if (s.length > 70) s = s.substring(0, 70).replaceAll(RegExp(r'-+$'), '');
  return s.isEmpty ? 'p' : s;
}

// ------------------------------------------------------------------ CSV

/// The columns متجري exports / the template has (Shopify-like names, so
/// a Shopify export imports too).
const catalogCsvHeaders = [
  'Handle', 'Title', 'Body (HTML)', 'Status', 'Tags', 'Collection',
  'Option1 Name', 'Option1 Value', 'Option2 Name', 'Option2 Value', 'Option3 Name', 'Option3 Value',
  'Variant SKU', 'Variant Barcode', 'Variant Price', 'Variant Compare At Price', 'Variant Inventory Qty',
  'Image Src', 'Variant Image', 'SEO Title', 'SEO Description', 'Video URL', 'Currency',
];

/// Decimals a price may have in [currency] (3 for KWD, BHD, OMR, JOD, IQD,
/// LYD, TND; else 2) — the server's currency_decimals.
int currencyDecimals(String? currency) =>
    const {'KWD', 'BHD', 'OMR', 'JOD', 'IQD', 'LYD', 'TND'}.contains((currency ?? '').toUpperCase()) ? 3 : 2;

/// Whether [v] fits [currency]'s decimals.
bool priceFitsCurrency(num v, String? currency) {
  final d = currencyDecimals(currency);
  final f = v * _pow10(d);
  return (f - f.round()).abs() < 1e-6;
}

int _pow10(int d) => d == 3 ? 1000 : 100;

/// Header (any case / spacing, Shopify or ours) → the import RPC's key.
String? importKeyOf(String header) {
  final h = header.trim().toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
  return switch (h) {
    'handle' || 'urlhandle' => 'handle',
    'title' || 'name' || 'productname' => 'title',
    'bodyhtml' || 'body' || 'description' => 'description',
    'status' => 'status',
    'tags' => 'tags',
    'collection' || 'collections' || 'productcategory' || 'category' || 'type' => 'collection',
    'option1name' => 'option1_name',
    'option1value' => 'option1_value',
    'option2name' => 'option2_name',
    'option2value' => 'option2_value',
    'option3name' => 'option3_name',
    'option3value' => 'option3_value',
    'variantsku' || 'sku' => 'sku',
    'variantbarcode' || 'barcode' => 'barcode',
    'variantprice' || 'price' => 'price',
    'variantcompareatprice' || 'compareatprice' || 'compareat' || 'oldprice' => 'compare_at',
    'variantinventoryqty' || 'inventoryqty' || 'stock' || 'quantity' || 'inventory' => 'stock',
    'imagesrc' || 'image' => 'image_src',
    'imageurls' || 'images' => 'image_urls',
    'variantimage' => 'variant_image',
    'seotitle' => 'seo_title',
    'seodescription' => 'seo_description',
    'videourl' || 'video' => 'video_url',
    'currency' || 'variantcurrency' => 'currency',
    _ => null,
  };
}

String _csvCell(Object? v) {
  final s = v == null ? '' : '$v';
  if (s.contains(RegExp(r'[",\n\r]'))) return '"${s.replaceAll('"', '""')}"';
  return s;
}

String _num(Object? v) {
  if (v == null) return '';
  final n = v is num ? v : num.tryParse('$v');
  if (n == null) return '$v';
  return n == n.roundToDouble() ? '${n.toInt()}' : '$n';
}

/// The catalogue as a CSV (UTF-8 with a BOM so Excel reads Arabic):
/// one row per variant, extra photos on extra rows (like Shopify).
/// [currency]: the store's (the Currency column; prices are in it).
String catalogCsv(List<Map<String, dynamic>> products, List<Map<String, dynamic>> collections, {required String currency}) {
  final namesOf = <String, List<String>>{};
  for (final c in collections) {
    for (final id in (c['product_ids'] as List? ?? const [])) {
      if (c['rules'] == null) (namesOf['$id'] ??= []).add(c['name'] as String? ?? '');
    }
  }
  final out = StringBuffer('﻿')..writeln(catalogCsvHeaders.map(_csvCell).join(','));
  for (final p in products) {
    final handle = (p['slug'] as String?) ?? catalogSlugify(p['name'] as String? ?? '');
    final options = productOptions(p);
    final variants = variantsOf(p);
    final images = List<String>.from(p['images'] as List? ?? const []);
    if (images.isEmpty && p['image_url'] is String) images.add(p['image_url'] as String);
    final rows = <List<Object?>>[];
    final colls = namesOf['${p['id']}'] ?? (p['category'] is String && collections.isEmpty ? [p['category'] as String] : const <String>[]);
    List<Object?> productCells() => [
          handle, p['name'], p['description'], p['status'] ?? 'active',
          (p['tags'] as List? ?? const []).join(', '), colls.join(', '),
        ];
    List<Object?> blankProduct() => [handle, '', '', '', '', ''];
    if (variants.isEmpty) {
      rows.add([
        ...productCells(), '', '', '', '', '', '',
        p['sku'], p['barcode'], _num(p['price']), _num(p['old_price']), _num(p['stock']),
        images.isEmpty ? '' : images.first, '', p['seo_title'], p['seo_description'], p['video_url'], currency,
      ]);
    } else {
      for (final (i, v) in variants.indexed) {
        final vals = valuesOf(v);
        final opt = <Object?>[];
        for (var k = 0; k < 3; k++) {
          opt
            ..add(i == 0 && k < options.length ? options[k].name : '')
            ..add(k < vals.length ? vals[k] : '');
        }
        rows.add([
          ...(i == 0 ? productCells() : blankProduct()), ...opt,
          v['sku'], v['barcode'], _num(v['price']), _num(v['compare_at_price']), _num(v['stock']),
          i < images.length ? images[i] : '', v['image_url'],
          i == 0 ? p['seo_title'] : '', i == 0 ? p['seo_description'] : '', i == 0 ? p['video_url'] : '', currency,
        ]);
      }
    }
    for (var i = rows.length; i < images.length; i++) {
      rows.add([...blankProduct(), for (var k = 0; k < 11; k++) '', images[i], '', '', '', '', '']);
    }
    for (final r in rows) {
      out.writeln(r.map(_csvCell).join(','));
    }
  }
  return out.toString();
}

/// A ready-to-fill file in the store's [currency]: a product with two
/// sizes and a simple product.
String catalogCsvTemplate({required String currency}) {
  final three = currencyDecimals(currency) == 3;
  String price(num v) => three ? (v / 10).toStringAsFixed(3) : '$v';
  final rows = [
    catalogCsvHeaders,
    ['tshirt-cotton', 'تيشيرت قطن', 'تيشيرت قطن 100%', 'active', 'قطن, صيفي', 'تيشيرتات', 'المقاس', 'M', 'اللون', 'أسود', '', '', 'TS-M-BLK', '', price(250), price(300), '10', 'https://example.com/tshirt.jpg', '', '', '', '', currency],
    ['tshirt-cotton', '', '', '', '', '', '', 'L', '', 'أسود', '', '', 'TS-L-BLK', '', price(260), '', '5', '', '', '', '', '', currency],
    ['leather-bag', 'شنطة جلد', 'شنطة جلد طبيعي', 'draft', '', 'شنط', '', '', '', '', '', '', 'BAG-1', '1234567890128', price(800), '', '', '', '', '', '', '', currency],
  ];
  return '﻿${rows.map((r) => r.map(_csvCell).join(',')).join('\n')}\n';
}

/// RFC 4180 rows (quotes, doubled quotes, newlines in quotes, CRLF, BOM).
List<List<String>> parseCsv(String text) {
  var s = text;
  if (s.startsWith('﻿')) s = s.substring(1);
  // Semicolon files (Excel in some locales) when the header has no commas.
  final firstLine = s.split('\n').first;
  final sep = !firstLine.contains(',') && firstLine.contains(';') ? ';' : ',';
  final rows = <List<String>>[];
  var row = <String>[];
  final cell = StringBuffer();
  var quoted = false;
  for (var i = 0; i < s.length; i++) {
    final ch = s[i];
    if (quoted) {
      if (ch == '"') {
        if (i + 1 < s.length && s[i + 1] == '"') {
          cell.write('"');
          i++;
        } else {
          quoted = false;
        }
      } else {
        cell.write(ch);
      }
    } else if (ch == '"') {
      quoted = true;
    } else if (ch == sep) {
      row.add(cell.toString());
      cell.clear();
    } else if (ch == '\n' || ch == '\r') {
      if (ch == '\r' && i + 1 < s.length && s[i + 1] == '\n') i++;
      row.add(cell.toString());
      cell.clear();
      rows.add(row);
      row = <String>[];
    } else {
      cell.write(ch);
    }
  }
  if (cell.isNotEmpty || row.isNotEmpty) {
    row.add(cell.toString());
    rows.add(row);
  }
  return rows.where((r) => r.any((c) => c.trim().isNotEmpty)).toList();
}

/// The parsed file as import rows ({key: value, _row}) — unknown columns
/// are listed in [ignored]; [missing] names required columns not found.
({List<Map<String, String>> rows, List<String> ignored, List<String> missing}) csvToImportRows(String text) {
  final table = parseCsv(text);
  if (table.isEmpty) return (rows: const [], ignored: const [], missing: const ['Handle / Title']);
  final header = table.first;
  final keys = [for (final h in header) importKeyOf(h)];
  final ignored = [for (var i = 0; i < header.length; i++) if (keys[i] == null && header[i].trim().isNotEmpty) header[i].trim()];
  final missing = <String>[
    if (!keys.contains('handle') && !keys.contains('title')) 'Handle / Title',
  ];
  final rows = <Map<String, String>>[];
  for (var r = 1; r < table.length; r++) {
    final m = <String, String>{'_row': '${r + 1}'};
    for (var i = 0; i < keys.length && i < table[r].length; i++) {
      final k = keys[i];
      if (k == null) continue;
      final v = table[r][i].trim();
      if (v.isEmpty) continue;
      // image_src may repeat (several image columns): join them.
      m[k] = m.containsKey(k) && (k == 'image_src' || k == 'image_urls') ? '${m[k]} $v' : v;
    }
    rows.add(m);
  }
  return (rows: rows, ignored: ignored, missing: missing);
}

/// Splits import rows into batches of at most [size] rows, never cutting
/// a product (consecutive rows with the same handle, or rows without a
/// handle / title that continue the previous product).
List<List<Map<String, String>>> importBatches(List<Map<String, String>> rows, {int size = 400}) {
  final batches = <List<Map<String, String>>>[];
  var current = <Map<String, String>>[];
  String? lastHandle;
  for (final r in rows) {
    final h = r['handle'] != null ? catalogSlugify(r['handle']!) : (r['title'] != null ? catalogSlugify(r['title']!) : lastHandle);
    final sameProduct = h != null && h == lastHandle;
    if (current.length >= size && !sameProduct) {
      batches.add(current);
      current = [];
    }
    current.add(r);
    lastHandle = h;
  }
  if (current.isNotEmpty) batches.add(current);
  return batches;
}
