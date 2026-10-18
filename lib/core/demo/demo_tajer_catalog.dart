part of 'demo_store.dart';

/// The demo build's side of 0098 (متجري catalog pro): variants,
/// collections, bulk actions, CSV import, low stock — the same rules as
/// the migration, kept small. Answers [DemoStore.rpc] for these
/// functions; returns [_notCatalog] for anything else.
const _notCatalog = Object();

/// Seed data for the demo shop (called from [DemoTajer.seed]).
abstract final class DemoTajerCatalog {
  static String variantId(int product, int n) => DemoStore.fixedId('6', product * 10 + n);
  static String collectionId(int n) => DemoStore.fixedId('5', n);

  /// Adds variants (products 2 and 3), handles, positions, tags and the
  /// collections to the seeded tables.
  static void seed(Map<String, List<DemoRow>> tables, String shopId, String Function(int) productId) {
    final products = tables['shop_products']!;
    final variants = <DemoRow>[];
    DemoRow? product(int n) => products.where((p) => p['id'] == productId(n)).firstOrNull;
    for (final (i, p) in products.indexed) {
      p['position'] = i;
      p['slug'] = catalogSlug(p['name'] as String);
      p['sku'] = null;
      p['barcode'] = null;
      p['tags'] = <String>[];
      p['video_url'] = null;
      p['seo_title'] = null;
      p['seo_description'] = null;
    }
    // قهوة تركي: the sugar levels, one price, unlimited.
    final coffee = product(2);
    if (coffee != null) {
      coffee['tags'] = ['عرض', 'قهوة'];
      coffee['sku'] = null;
      for (final (i, v) in ['سادة', 'مظبوط', 'زيادة'].indexed) {
        variants.add(_variant(variantId(2, i), coffee, [v], price: 20, compareAt: 25, stock: null, position: i, sku: 'TC-${i + 1}'));
      }
    }
    // نسكافيه: size × milk, its own prices and stock (one sold out, one low).
    final nescafe = product(3);
    if (nescafe != null) {
      nescafe['options'] = [
        {'name': 'الحجم', 'values': ['وسط', 'كبير']},
        {'name': 'اللبن', 'values': ['كامل الدسم', 'خالي الدسم']},
      ];
      nescafe['tags'] = ['قهوة'];
      final rows = [
        (['وسط', 'كامل الدسم'], 25, 8, 'NS-M-F'),
        (['وسط', 'خالي الدسم'], 25, 5, 'NS-M-L'),
        (['كبير', 'كامل الدسم'], 32, 2, 'NS-L-F'),
        (['كبير', 'خالي الدسم'], 32, 0, 'NS-L-L'),
      ];
      for (final (i, r) in rows.indexed) {
        variants.add(_variant(variantId(3, i), nescafe, r.$1, price: r.$2, stock: r.$3, position: i, sku: r.$4));
      }
    }
    product(4)?['sku'] = 'OJ-FRESH';
    product(4)?['barcode'] = '6221000000017';
    product(6)?['tags'] = ['عرض'];
    tables['shop_product_variants'] = variants;
    for (final p in products) {
      _rollupRows(p, variants.where((v) => v['product_id'] == p['id']).toList());
    }

    final collections = <DemoRow>[];
    final members = <DemoRow>[];
    final byCategory = <String, List<DemoRow>>{};
    for (final p in products) {
      final c = p['category'] as String?;
      if (c != null) (byCategory[c] ??= []).add(p);
    }
    var n = 0;
    for (final e in byCategory.entries) {
      final id = collectionId(++n);
      collections.add(_collection(id, shopId, e.key, n - 1));
      for (final (i, p) in e.value.indexed) {
        members.add({'collection_id': id, 'product_id': p['id'], 'position': i});
      }
    }
    collections.add({..._collection(collectionId(++n), shopId, 'عروض', n - 1), 'rules': {'tag': 'عرض'}, 'description': 'كل اللي عليه خصم'});
    tables['shop_collections'] = collections;
    tables['shop_collection_products'] = members;
  }

  static DemoRow _collection(String id, String shopId, String name, int position) => {
        'id': id,
        'shop_id': shopId,
        'name': name,
        'slug': catalogSlug(name),
        'description': null,
        'image_url': null,
        'position': position,
        'is_visible': true,
        'rules': null,
        'created_at': DemoStore.nowIso(),
      };

  static DemoRow _variant(String id, DemoRow p, List<String> values,
          {required num price, num? compareAt, int? stock, required int position, String? sku}) =>
      {
        'id': id,
        'product_id': p['id'],
        'shop_id': p['shop_id'],
        'option_values': values,
        'sku': sku,
        'barcode': null,
        'price': price,
        'compare_at_price': compareAt,
        'stock': stock,
        'image_url': null,
        'position': position,
        'is_available': true,
        'created_at': DemoStore.nowIso(),
      };

  /// The server's catalog_slugify.
  static String catalogSlug(String text) {
    var s = text.toLowerCase().replaceAll(RegExp('[ً-ٟـ]'), '');
    s = s.replaceAll(RegExp('[^a-z0-9ء-ي٠-٩]+'), '-').replaceAll(RegExp(r'^-+|-+$'), '');
    if (s.length > 70) s = s.substring(0, 70).replaceAll(RegExp(r'-+$'), '');
    return s.isEmpty ? 'p' : s;
  }

  /// 0098's rollup: price = cheapest available variant, its compare-at,
  /// stock = the available variants' sum (null when any is unlimited).
  static void _rollupRows(DemoRow p, List<DemoRow> vs) {
    if (vs.isEmpty) return;
    final avail = vs.where((v) => v['is_available'] != false).toList();
    final base = avail.isEmpty ? vs : avail;
    final cheapest = (List.of(base)..sort((a, b) => (a['price'] as num).compareTo(b['price'] as num))).first;
    p['price'] = cheapest['price'];
    final cmp = cheapest['compare_at_price'] as num?;
    p['old_price'] = cmp != null && cmp > (cheapest['price'] as num) ? cmp : null;
    p['stock'] = avail.isEmpty ? 0 : (avail.any((v) => v['stock'] == null) ? null : avail.fold<int>(0, (s, v) => s + (v['stock'] as num).toInt()));
  }
}

extension _TajerCatalog on DemoStore {
  List<DemoRow> _variantsOf(String productId) =>
      t('shop_product_variants').where((v) => v['product_id'] == productId).toList()..sort((a, b) => ((a['position'] as num?) ?? 0).compareTo((b['position'] as num?) ?? 0));

  void _rollup(String productId) {
    final p = _firstWhere('shop_products', (x) => x['id'] == productId);
    if (p != null) DemoTajerCatalog._rollupRows(p, _variantsOf(productId));
  }

  String _label(DemoRow p, List values) {
    final opts = (p['options'] as List? ?? const []);
    return [
      for (var i = 0; i < opts.length && i < values.length; i++) '${(opts[i] as Map)['name']}: ${values[i]}',
    ].join(' • ');
  }

  DemoRow _productJson(DemoRow p, {bool public = false}) => {
        ...p,
        'variants': [
          for (final v in _variantsOf(p['id'] as String))
            if (!public || v['is_available'] != false) Map<String, dynamic>.from(v)..remove('shop_id'),
        ],
      };

  int _byPosition(DemoRow a, DemoRow b) {
    final pa = a['position'] as num?, pb = b['position'] as num?;
    if (pa != null && pb != null && pa != pb) return pa.compareTo(pb);
    if (pa == null && pb != null) return 1;
    if (pb == null && pa != null) return -1;
    return '${b['created_at']}'.compareTo('${a['created_at']}');
  }

  List<String> _members(DemoRow c, {bool public = false}) {
    final products = {for (final p in t('shop_products').where((p) => p['shop_id'] == c['shop_id'])) p['id']: p};
    final rules = c['rules'] as Map?;
    List<String> ids;
    if (rules == null) {
      final rows = t('shop_collection_products').where((m) => m['collection_id'] == c['id']).toList()
        ..sort((a, b) => ((a['position'] as num?) ?? 0).compareTo((b['position'] as num?) ?? 0));
      ids = [for (final m in rows) m['product_id'] as String];
    } else {
      final list = products.values.where((p) {
        if (p['status'] == 'archived') return false;
        if (rules['tag'] != null && !(p['tags'] as List? ?? const []).contains(rules['tag'])) return false;
        final price = (p['price'] as num?) ?? 0;
        if (rules['min_price'] != null && price < (rules['min_price'] as num)) return false;
        if (rules['max_price'] != null && price > (rules['max_price'] as num)) return false;
        if (rules['in_stock'] == true && p['stock'] != null && (p['stock'] as num) <= 0) return false;
        return true;
      }).toList()
        ..sort(_byPosition);
      ids = [for (final p in list) p['id'] as String];
    }
    return [
      for (final id in ids)
        if (products[id] != null && (!public || products[id]!['is_available'] == true)) id,
    ];
  }

  DemoRow _collectionJson(DemoRow c, {bool public = false}) => {...c, 'product_ids': _members(c, public: public)};

  bool _skuTaken(String shopId, String? sku, String? productId) {
    if (sku == null || sku.isEmpty) return false;
    final s = sku.toLowerCase();
    return t('shop_products').any((p) => p['shop_id'] == shopId && p['id'] != productId && (p['sku'] as String?)?.toLowerCase() == s) ||
        t('shop_product_variants').any((v) => v['shop_id'] == shopId && v['product_id'] != productId && (v['sku'] as String?)?.toLowerCase() == s);
  }

  String _uniqueSlug(String table, String shopId, String base, String? self) {
    final b = DemoTajerCatalog.catalogSlug(base);
    var tryS = b;
    var n = 1;
    while (t(table).any((r) => r['shop_id'] == shopId && r['slug'] == tryS && r['id'] != self)) {
      tryS = '$b-${++n}';
    }
    return tryS;
  }

  static num? _num(Object? v) {
    if (v == null) return null;
    if (v is num) return v;
    final s = latinDigits('$v').replaceAll(',', '').trim();
    if (s.isEmpty) return null;
    final n = num.tryParse(s);
    if (n == null) throw DemoError('السعر والكمية لازم يكونوا أرقام');
    return n;
  }

  /// merchant_save_product (the core of private.catalog_save).
  String _saveProduct(String shopId, Map<String, dynamic> p, List variantsIn, List? collections) {
    final id = p['id'] as String?;
    DemoRow? old;
    if (id != null) {
      old = _firstWhere('shop_products', (x) => x['id'] == id && x['shop_id'] == shopId) ?? (throw DemoError('المنتج ده مش بتاعك'));
    }
    final name = (p['name'] as String? ?? '').trim();
    if (name.isEmpty) throw DemoError('اكتب اسم المنتج');
    final status = (p['status'] as String?) ?? 'active';
    if (!const ['active', 'draft', 'archived'].contains(status)) throw DemoError('حالة المنتج غير معروفة');
    final options = <Map<String, dynamic>>[];
    for (final o in (p['options'] as List? ?? const [])) {
      final m = Map<String, dynamic>.from(o as Map);
      final values = <String>[];
      for (final v in (m['values'] as List? ?? const [])) {
        final s = '$v'.trim();
        if (s.isNotEmpty && !values.contains(s)) values.add(s);
      }
      final n = '${m['name'] ?? ''}'.trim();
      if (n.isEmpty) throw DemoError('اكتب اسم الخيار (مثلاً: المقاس)');
      if (values.isEmpty) throw DemoError('ضيف قيمة واحدة على الأقل لـ «$n»');
      if (values.length > 30) throw DemoError('لحد 30 قيمة لـ «$n»');
      options.add({'name': n, 'values': values});
    }
    if (options.length > 3) throw DemoError('لحد 3 خيارات للمنتج (زي المقاس واللون والخامة)');
    final images = [for (final i in (p['images'] as List? ?? const [])) '$i'];
    if (images.length > 6) throw DemoError('لحد 6 صور للمنتج');
    final has = options.isNotEmpty;
    final video = (p['video_url'] as String?)?.trim();
    if (video != null && video.isNotEmpty && !RegExp(r'(youtube\.com/(watch|shorts|embed|live)|youtu\.be/)').hasMatch(video)) {
      throw DemoError('لينك الفيديو لازم يكون من يوتيوب');
    }
    var slug = (p['slug'] as String?)?.trim();
    if (slug != null && slug.isNotEmpty) {
      slug = DemoTajerCatalog.catalogSlug(slug);
      if (t('shop_products').any((x) => x['shop_id'] == shopId && x['slug'] == slug && x['id'] != id)) throw DemoError('الرابط «$slug» مستخدم لمنتج تاني في متجرك');
    } else {
      slug = null;
    }
    final variants = <Map<String, dynamic>>[];
    if (has) {
      if (variantsIn.isEmpty) throw DemoError('ضيف نوع واحد على الأقل (مقاس، لون…)');
      if (variantsIn.length > 100) throw DemoError('لحد 100 نوع للمنتج الواحد');
      final seen = <String>{};
      final skus = <String>{};
      for (final raw in variantsIn) {
        final v = Map<String, dynamic>.from(raw as Map);
        final vals = [for (final x in (v['option_values'] as List? ?? const [])) '$x'.trim()];
        if (vals.length != options.length) throw DemoError('كل نوع لازم يكون له قيمة لكل خيار');
        for (var k = 0; k < vals.length; k++) {
          if (!(options[k]['values'] as List).contains(vals[k])) throw DemoError('القيمة «${vals[k]}» مش موجودة في «${options[k]['name']}»');
        }
        final label = [for (var k = 0; k < vals.length; k++) '${options[k]['name']}: ${vals[k]}'].join(' • ');
        if (!seen.add(vals.join('\u0001'))) throw DemoError('النوع «$label» متكرر');
        final price = _num(v['price']);
        if (price == null || price < 0) throw DemoError('اكتب سعر صحيح لـ «$label»');
        final cmp = _num(v['compare_at_price']);
        if (cmp != null && cmp <= price) throw DemoError('السعر قبل الخصم لـ «$label» لازم يكون أكبر من سعره');
        final stock = _num(v['stock']);
        if (stock != null && (stock < 0 || stock != stock.truncate())) throw DemoError('الكمية لـ «$label» لازم تكون رقم صحيح من 0');
        final sku = (v['sku'] as String?)?.trim();
        if (sku != null && sku.isNotEmpty && (!skus.add(sku.toLowerCase()) || _skuTaken(shopId, sku, id))) throw DemoError('الـ SKU «$sku» مستخدم قبل كده');
        final img = v['image_url'] as String?;
        if (img != null && !images.contains(img)) throw DemoError('صورة «$label» لازم تكون من صور المنتج');
        variants.add({
          'option_values': vals,
          'sku': sku == null || sku.isEmpty ? null : sku,
          'barcode': (v['barcode'] as String?)?.trim().isEmpty ?? true ? null : (v['barcode'] as String).trim(),
          'price': price,
          'compare_at_price': cmp,
          'stock': stock?.toInt(),
          'image_url': img,
          'is_available': v['is_available'] != false,
        });
      }
    } else if (variantsIn.isNotEmpty) {
      throw DemoError('الأنواع محتاجة خيارات (زي المقاس أو اللون)');
    }
    num? price, oldPrice;
    int? stock;
    String? sku;
    if (!has) {
      price = _num(p['price']);
      if (price == null || price < 0) throw DemoError('اكتب سعر صحيح');
      oldPrice = _num(p['old_price']);
      if (oldPrice != null && oldPrice <= price) throw DemoError('السعر قبل الخصم لازم يكون أكبر من السعر الحالي');
      stock = _num(p['stock'])?.toInt();
      sku = (p['sku'] as String?)?.trim();
      if (sku != null && sku.isEmpty) sku = null;
      if (_skuTaken(shopId, sku, id)) throw DemoError('الـ SKU «$sku» مستخدم لمنتج تاني');
    }
    String? blank(Object? v) => v is String && v.trim().isNotEmpty ? v.trim() : null;
    final fields = <String, dynamic>{
      'name': name,
      'description': blank(p['description']),
      'images': images,
      'image_url': images.isEmpty ? null : images.first,
      'highlights': [for (final h in (p['highlights'] as List? ?? const [])) '$h'],
      'category': blank(p['category']),
      'options': options,
      'status': status,
      'is_available': status == 'active',
      'sku': has ? null : sku,
      'barcode': has ? null : blank(p['barcode']),
      'tags': [for (final x in (p['tags'] as List? ?? const [])) '$x'],
      'seo_title': blank(p['seo_title']),
      'seo_description': blank(p['seo_description']),
      'video_url': blank(p['video_url']),
      if (!has) ...{'price': price, 'old_price': oldPrice, 'stock': stock},
    };
    late final String pid;
    if (old == null) {
      if (t('shop_products').where((x) => x['shop_id'] == shopId).length >= 5000) throw DemoError('وصلت للحد الأقصى (5,000 منتج للمتجر)');
      final row = <String, dynamic>{
        'id': newId(),
        'shop_id': shopId,
        'currency': 'EGP',
        'created_at': DemoStore.nowIso(),
        'price': 0,
        'old_price': null,
        'stock': null,
        ...fields,
        'slug': slug,
      };
      _beforeInsert('shop_products', row);
      t('shop_products').add(row);
      pid = row['id'] as String;
    } else {
      old.addAll(fields);
      if (slug != null) old['slug'] = slug;
      pid = old['id'] as String;
    }
    // Variants by combination (ids kept).
    final existing = {for (final v in _variantsOf(pid)) (v['option_values'] as List).join('\u0001'): v};
    final keep = <DemoRow>[];
    for (final (i, v) in variants.indexed) {
      final key = (v['option_values'] as List).join('\u0001');
      final row = existing[key] ?? {'id': newId(), 'product_id': pid, 'shop_id': shopId, 'created_at': DemoStore.nowIso()};
      row.addAll({...v, 'position': i});
      keep.add(row);
    }
    t('shop_product_variants')
      ..removeWhere((v) => v['product_id'] == pid)
      ..addAll(keep);
    _rollup(pid);
    if (collections != null) {
      final ids = collections.map((c) => '$c').toSet();
      t('shop_collection_products').removeWhere((m) {
        final c = _firstWhere('shop_collections', (x) => x['id'] == m['collection_id']);
        return m['product_id'] == pid && c?['shop_id'] == shopId && !ids.contains(m['collection_id']);
      });
      for (final cid in ids) {
        final c = _firstWhere('shop_collections', (x) => x['id'] == cid && x['shop_id'] == shopId && x['rules'] == null);
        if (c == null || t('shop_collection_products').any((m) => m['collection_id'] == cid && m['product_id'] == pid)) continue;
        final last = t('shop_collection_products').where((m) => m['collection_id'] == cid).fold<int>(-1, (a, m) => ((m['position'] as num?) ?? 0).toInt() > a ? (m['position'] as num).toInt() : a);
        t('shop_collection_products').add({'collection_id': cid, 'product_id': pid, 'position': last + 1});
      }
    }
    return pid;
  }

  /// After an order took [qty] of a variant / product: the low-stock alert.
  void _lowStockAlert(DemoRow shop, DemoRow product, DemoRow? variant, int? before, int? after) {
    final thr = ((shop['low_stock_threshold'] as num?) ?? 3).toInt();
    if (after == null || thr <= 0 || after > thr || (before != null && before <= thr)) return;
    final label = variant == null ? '' : ' — ${_label(product, variant['option_values'] as List)}';
    _notify([shop['owner_id'] as String], '📦 منتج قرب يخلص — ${product['name']}',
        '${after == 0 ? 'خلصت الكمية من «' : 'فاضل $after بس من «'}${product['name']}$label». زوّد الكمية من «المنتجات» في متجري.', '/#/products/${product['id']}');
  }

  Object? _catalogRpc(String fn, Map<String, dynamic> p) {
    switch (fn) {
      case 'store_catalog':
        final shopId = p['p_shop'] as String?;
        final products = t('shop_products').where((x) => x['shop_id'] == shopId && x['is_available'] == true).toList()..sort(_byPosition);
        final collections = t('shop_collections').where((c) => c['shop_id'] == shopId && c['is_visible'] != false).toList()
          ..sort((a, b) => ((a['position'] as num?) ?? 0).compareTo((b['position'] as num?) ?? 0));
        return {
          'products': [for (final x in products) _productJson(x, public: true)],
          'collections': [
            for (final c in collections)
              if (_members(c, public: true).isNotEmpty) _collectionJson(c, public: true),
          ],
        };

      case 'merchant_catalog':
        final s = _myShop(p['p_shop'] as String?);
        final products = t('shop_products').where((x) => x['shop_id'] == s['id']).toList()..sort(_byPosition);
        final collections = t('shop_collections').where((c) => c['shop_id'] == s['id']).toList()
          ..sort((a, b) => ((a['position'] as num?) ?? 0).compareTo((b['position'] as num?) ?? 0));
        return {
          'products': [for (final x in products) _productJson(x)],
          'collections': [for (final c in collections) _collectionJson(c)],
          'low_stock_threshold': s['low_stock_threshold'] ?? 3,
        };

      case 'merchant_product':
        final x = _firstWhere('shop_products', (r) => r['id'] == p['p_product']);
        if (x == null) return null;
        final shop = _firstWhere('shops', (s) => s['id'] == x['shop_id']);
        if (shop?['owner_id'] != _uid) return null;
        return {
          ..._productJson(x),
          'collection_ids': [for (final m in t('shop_collection_products').where((m) => m['product_id'] == x['id'])) m['collection_id']],
        };

      case 'merchant_save_product':
        final s = _myShop(p['p_shop'] as String?);
        return _saveProduct(s['id'] as String, Map<String, dynamic>.from(p['p_product'] as Map), p['p_variants'] as List? ?? const [], p['p_collections'] as List?);

      case 'merchant_duplicate_product':
        final x = _firstWhere('shop_products', (r) => r['id'] == p['p_product']) ?? (throw DemoError('المنتج ده مش بتاعك'));
        _myShop(x['shop_id'] as String?);
        final copy = <String, dynamic>{
          ...x,
          'id': newId(),
          'name': '${x['name']} (نسخة)',
          'status': 'draft',
          'is_available': false,
          'sku': null,
          'barcode': null,
          'slug': null,
          'created_at': DemoStore.nowIso(),
        };
        copy['slug'] = _uniqueSlug('shop_products', x['shop_id'] as String, copy['name'] as String, copy['id'] as String);
        t('shop_products').add(copy);
        for (final v in _variantsOf(x['id'] as String)) {
          t('shop_product_variants').add({...v, 'id': newId(), 'product_id': copy['id'], 'sku': null, 'barcode': null});
        }
        for (final m in t('shop_collection_products').where((m) => m['product_id'] == x['id']).toList()) {
          t('shop_collection_products').add({...m, 'product_id': copy['id']});
        }
        return copy['id'];

      case 'merchant_reorder_products':
        final s = _myShop(p['p_shop'] as String?);
        for (final (i, id) in (p['p_ids'] as List? ?? const []).indexed) {
          _firstWhere('shop_products', (x) => x['id'] == id && x['shop_id'] == s['id'])?['position'] = i;
        }
        return null;

      case 'merchant_bulk_products':
        final s = _myShop(p['p_shop'] as String?);
        final ids = [for (final id in (p['p_ids'] as List? ?? const [])) '$id'];
        if (ids.isEmpty) throw DemoError('اختار منتجات الأول');
        final rows = t('shop_products').where((x) => x['shop_id'] == s['id'] && ids.contains(x['id'])).toList();
        var updated = 0, skipped = ids.length - rows.length, deleted = 0, archived = 0;
        final action = p['p_action'] as String?;
        final value = p['p_value'];
        switch (action) {
          case 'status':
            if (!const ['active', 'draft', 'archived'].contains(value)) throw DemoError('حالة المنتج غير معروفة');
            for (final r in rows) {
              if (r['status'] == value) continue;
              r['status'] = value;
              r['is_available'] = value == 'active';
              updated++;
            }
          case 'add_collection':
          case 'remove_collection':
            final c = _firstWhere('shop_collections', (x) => x['id'] == value && x['shop_id'] == s['id'] && x['rules'] == null) ??
                (throw DemoError('القسم ده مش موجود (أو قسم ذكي بيتملا لوحده)'));
            for (final r in rows) {
              final has = t('shop_collection_products').any((m) => m['collection_id'] == c['id'] && m['product_id'] == r['id']);
              if (action == 'add_collection' && !has) {
                t('shop_collection_products').add({'collection_id': c['id'], 'product_id': r['id'], 'position': 1000 + updated});
                updated++;
              } else if (action == 'remove_collection' && has) {
                t('shop_collection_products').removeWhere((m) => m['collection_id'] == c['id'] && m['product_id'] == r['id']);
                updated++;
              }
            }
          case 'price':
          case 'stock':
            final n = _num(value);
            if (action == 'price' && (n == null || n < 0)) throw DemoError('اكتب سعر صحيح');
            for (final r in rows) {
              final vs = _variantsOf(r['id'] as String);
              if (vs.length > 1) {
                skipped++;
                continue;
              }
              final target = vs.isEmpty ? r : vs.single;
              if (action == 'price') {
                target['price'] = n;
                final cmpKey = vs.isEmpty ? 'old_price' : 'compare_at_price';
                if (((target[cmpKey] as num?) ?? 0) <= n!) target[cmpKey] = null;
              } else {
                target['stock'] = n?.toInt();
              }
              if (vs.isNotEmpty) _rollup(r['id'] as String);
              updated++;
            }
          case 'delete':
            for (final r in rows) {
              if (t('shop_order_items').any((i) => i['product_id'] == r['id'])) {
                r['status'] = 'archived';
                r['is_available'] = false;
                archived++;
              } else {
                t('shop_products').remove(r);
                t('shop_product_variants').removeWhere((v) => v['product_id'] == r['id']);
                t('shop_collection_products').removeWhere((m) => m['product_id'] == r['id']);
                deleted++;
              }
            }
          default:
            throw DemoError('إجراء غير معروف');
        }
        return {'updated': updated, 'skipped': skipped, 'deleted': deleted, 'archived': archived};

      case 'merchant_save_collection':
        final s = _myShop(p['p_shop'] as String?);
        final c = Map<String, dynamic>.from(p['p_collection'] as Map);
        final name = (c['name'] as String? ?? '').trim();
        if (name.isEmpty) throw DemoError('اكتب اسم القسم');
        final rules = c['rules'] is Map ? Map<String, dynamic>.from(c['rules'] as Map) : null;
        if (rules != null && !(rules.containsKey('tag') || rules.containsKey('min_price') || rules.containsKey('max_price') || rules['in_stock'] == true)) {
          throw DemoError('القسم الذكي محتاج شرط واحد على الأقل');
        }
        final id = c['id'] as String?;
        final fields = {
          'name': name,
          'description': (c['description'] as String?)?.trim(),
          'image_url': c['image_url'],
          'is_visible': c['is_visible'] != false,
          'rules': rules,
        };
        if (id == null) {
          final mine = t('shop_collections').where((x) => x['shop_id'] == s['id']).toList();
          final row = <String, dynamic>{
            'id': newId(),
            'shop_id': s['id'],
            'slug': _uniqueSlug('shop_collections', s['id'] as String, name, null),
            'position': mine.isEmpty ? 0 : mine.map((x) => (x['position'] as num?) ?? 0).reduce((a, b) => a > b ? a : b) + 1,
            'created_at': DemoStore.nowIso(),
            ...fields,
          };
          t('shop_collections').add(row);
          return row['id'];
        }
        final row = _firstWhere('shop_collections', (x) => x['id'] == id && x['shop_id'] == s['id']) ?? (throw DemoError('القسم ده مش موجود'));
        row.addAll(fields);
        if (rules != null) t('shop_collection_products').removeWhere((m) => m['collection_id'] == id);
        return id;

      case 'merchant_delete_collection':
        final c = _firstWhere('shop_collections', (x) => x['id'] == p['p_collection']) ?? (throw DemoError('القسم ده مش موجود'));
        _myShop(c['shop_id'] as String?);
        t('shop_collections').remove(c);
        t('shop_collection_products').removeWhere((m) => m['collection_id'] == c['id']);
        return null;

      case 'merchant_set_collection_products':
        final c = _firstWhere('shop_collections', (x) => x['id'] == p['p_collection']) ?? (throw DemoError('القسم ده مش موجود'));
        _myShop(c['shop_id'] as String?);
        if (c['rules'] != null) throw DemoError('القسم الذكي بيتملا لوحده من الشروط');
        final ids = <String>[];
        for (final id in (p['p_product_ids'] as List? ?? const [])) {
          if (!ids.contains('$id') && t('shop_products').any((x) => x['id'] == id && x['shop_id'] == c['shop_id'])) ids.add('$id');
        }
        t('shop_collection_products')
          ..removeWhere((m) => m['collection_id'] == c['id'])
          ..addAll([for (final (i, id) in ids.indexed) {'collection_id': c['id'], 'product_id': id, 'position': i}]);
        return null;

      case 'merchant_reorder_collections':
        final s = _myShop(p['p_shop'] as String?);
        for (final (i, id) in (p['p_ids'] as List? ?? const []).indexed) {
          _firstWhere('shop_collections', (x) => x['id'] == id && x['shop_id'] == s['id'])?['position'] = i;
        }
        return null;

      case 'merchant_low_stock':
        final s = _myShop(p['p_shop'] as String?);
        final thr = ((s['low_stock_threshold'] as num?) ?? 3).toInt();
        final items = <DemoRow>[];
        for (final x in t('shop_products').where((x) => x['shop_id'] == s['id'] && x['status'] != 'archived')) {
          final vs = _variantsOf(x['id'] as String);
          final img = (x['images'] as List?)?.firstOrNull ?? x['image_url'];
          if (vs.isEmpty) {
            final st = x['stock'] as num?;
            if (st != null && st <= thr) items.add({'product_id': x['id'], 'variant_id': null, 'name': x['name'], 'variant_label': null, 'sku': x['sku'], 'stock': st, 'image_url': img});
          } else {
            for (final v in vs) {
              final st = v['stock'] as num?;
              if (v['is_available'] != false && st != null && st <= thr) {
                items.add({'product_id': x['id'], 'variant_id': v['id'], 'name': x['name'], 'variant_label': _label(x, v['option_values'] as List), 'sku': v['sku'], 'stock': st, 'image_url': v['image_url'] ?? img});
              }
            }
          }
        }
        items.sort((a, b) => (a['stock'] as num).compareTo(b['stock'] as num));
        return {'threshold': thr, 'items': items.take(50).toList()};

      case 'merchant_set_low_stock_threshold':
        final s = _myShop(p['p_shop'] as String?);
        final n = (p['p_threshold'] as num?)?.toInt();
        if (n == null || n < 0 || n > 1000) throw DemoError('الحد لازم يكون من 0 لـ 1,000');
        s['low_stock_threshold'] = n;
        return null;

      case 'merchant_import_products':
        final s = _myShop(p['p_shop'] as String?);
        final rows = [for (final r in (p['p_rows'] as List? ?? const [])) Map<String, dynamic>.from(r as Map)];
        if (rows.isEmpty) throw DemoError('الملف فاضي');
        if (rows.length > 500) throw DemoError('الدفعة الواحدة لحد 500 سطر');
        final dry = p['p_dry_run'] != false;
        const touched = ['shop_products', 'shop_product_variants', 'shop_collections', 'shop_collection_products'];
        final snapshot = {for (final k in touched) k: [for (final r in t(k)) jsonDecode(jsonEncode(r)) as Map<String, dynamic>]};
        final result = _import(s['id'] as String, rows);
        if (dry) {
          for (final k in touched) {
            tables[k] = snapshot[k]!;
          }
        }
        return {...result, 'dry_run': dry};
    }
    return _notCatalog;
  }

  /// The CSV import (private.catalog_import, simplified the same way).
  Map<String, dynamic> _import(String shopId, List<Map<String, dynamic>> rows) {
    final groups = <String, List<Map<String, dynamic>>>{};
    for (final (i, r) in rows.indexed) {
      r['_row'] = int.tryParse('${r['_row'] ?? ''}') ?? i + 2;
      String handle = '';
      if ((r['handle'] as String?)?.trim().isNotEmpty ?? false) {
        handle = DemoTajerCatalog.catalogSlug(r['handle'] as String);
      } else if ((r['title'] as String?)?.trim().isNotEmpty ?? false) {
        handle = DemoTajerCatalog.catalogSlug(r['title'] as String);
      } else if ((r['sku'] as String?)?.trim().isNotEmpty ?? false) {
        final sku = (r['sku'] as String).trim().toLowerCase();
        final v = _firstWhere('shop_product_variants', (v) => v['shop_id'] == shopId && (v['sku'] as String?)?.toLowerCase() == sku);
        final pr = _firstWhere('shop_products', (x) => x['shop_id'] == shopId && (x['id'] == v?['product_id'] || (x['sku'] as String?)?.toLowerCase() == sku));
        handle = pr?['slug'] as String? ?? '';
      }
      (groups[handle] ??= []).add(r);
    }
    var created = 0, updated = 0, failed = 0;
    final errors = <Map<String, dynamic>>[];
    final items = <Map<String, dynamic>>[];
    for (final e in groups.entries) {
      final first = e.value.first['_row'];
      try {
        if (e.key.isEmpty) throw DemoError('سطر $first: اكتب الـ handle أو اسم المنتج (Title)');
        final cur = '${_firstWhere('shops', (s) => s['id'] == shopId)?['currency'] ?? 'EGP'}';
        for (final r in e.value) {
          final c = (r['currency'] as String?)?.trim().toUpperCase() ?? '';
          if (c.isNotEmpty && c != cur) throw DemoError('سطر ${r['_row']}: العملة «$c» مش عملة متجرك ($cur) — الأسعار لازم تكون بعملة المتجر');
        }
        final old = _firstWhere('shop_products', (x) => x['shop_id'] == shopId && x['slug'] == e.key);
        String? pick(String k) => e.value.map((r) => (r[k] as String?)?.trim()).firstWhere((v) => v != null && v.isNotEmpty, orElse: () => null);
        final title = pick('title');
        if (title == null && old == null) throw DemoError('سطر $first: اكتب اسم المنتج (Title)');
        final names = [for (var k = 1; k <= 3; k++) pick('option${k}_name')];
        if ((names[0]?.toLowerCase() == 'title') && names[1] == null) names[0] = null;
        final nOpts = names.indexWhere((n) => n == null) < 0 ? 3 : names.indexWhere((n) => n == null);
        final images = <String>[];
        for (final r in e.value) {
          for (final u in '${r['image_src'] ?? ''} ${r['image_urls'] ?? ''} ${r['variant_image'] ?? ''}'.split(RegExp(r'[\s|,]+'))) {
            if (u.isNotEmpty && !images.contains(u)) images.add(u);
          }
        }
        final options = <Map<String, dynamic>>[];
        final variants = <Map<String, dynamic>>[];
        num? price, cmp;
        int? stock;
        if (nOpts > 0) {
          for (var k = 0; k < nOpts; k++) {
            final vals = <String>[];
            for (final r in e.value) {
              final v = (r['option${k + 1}_value'] as String?)?.trim() ?? '';
              if (v.isNotEmpty && !vals.contains(v)) vals.add(v);
            }
            options.add({'name': names[k], 'values': vals});
          }
          for (final r in e.value) {
            final vals = [for (var k = 0; k < nOpts; k++) (r['option${k + 1}_value'] as String?)?.trim() ?? ''];
            if (vals.every((v) => v.isEmpty)) continue;
            if (vals.any((v) => v.isEmpty)) throw DemoError('سطر ${r['_row']}: ناقص قيمة');
            num? vp, vc;
            try {
              vp = _num(r['price']);
              vc = _num(r['compare_at']);
            } on DemoError {
              throw DemoError('سطر ${r['_row']}: السعر أو الكمية مش رقم');
            }
            final existing = old == null ? null : _variantsOf(old['id'] as String).where((v) => (v['option_values'] as List).join('|') == vals.join('|')).firstOrNull;
            vp ??= (existing?['price']) as num?;
            if (vp == null) throw DemoError('سطر ${r['_row']}: اكتب السعر (Variant Price)');
            final st = (r['stock'] as String?)?.trim();
            variants.add({
              'option_values': vals,
              'price': vp,
              'compare_at_price': vc != null && vc > vp ? vc : null,
              'stock': st == null || st.isEmpty ? (existing?['stock']) : int.tryParse(latinDigits(st)),
              'sku': (r['sku'] as String?)?.trim() ?? (existing?['sku']),
              'barcode': (r['barcode'] as String?)?.trim() ?? (existing?['barcode']),
              'image_url': (r['variant_image'] as String?)?.trim(),
            });
          }
        } else {
          final r = e.value.first;
          try {
            price = _num(r['price']) ?? (old?['price']) as num?;
            cmp = _num(r['compare_at']);
          } on DemoError {
            throw DemoError('سطر $first: السعر أو الكمية مش رقم');
          }
          if (price == null) throw DemoError('سطر $first: اكتب السعر (Variant Price)');
          final st = (r['stock'] as String?)?.trim();
          stock = st == null || st.isEmpty ? (old?['stock']) as int? : int.tryParse(latinDigits(st));
        }
        final status = switch ((pick('status') ?? '').toLowerCase()) {
          '' => (old?['status']) ?? 'active',
          'active' || 'نشط' => 'active',
          'draft' || 'مسودة' => 'draft',
          'archived' || 'مؤرشف' => 'archived',
          _ => throw DemoError('سطر $first: الحالة لازم تكون active أو draft أو archived'),
        };
        List? colls;
        final collText = pick('collection');
        if (collText != null) {
          colls = [];
          for (final name in collText.split(RegExp('[,،]')).map((x) => x.trim()).where((x) => x.isNotEmpty)) {
            final c = _firstWhere('shop_collections', (x) => x['shop_id'] == shopId && x['rules'] == null && '${x['name']}'.toLowerCase() == name.toLowerCase());
            colls.add(c?['id'] ?? _catalogRpc('merchant_save_collection', {'p_shop': shopId, 'p_collection': {'name': name}}));
          }
        }
        final tags = pick('tags');
        final id = _saveProduct(shopId, {
          'id': (old?['id']),
          'name': title ?? old!['name'],
          'description': (pick('description') ?? '').replaceAll(RegExp(r'<[^>]*>'), '').trim().isEmpty ? (old?['description']) : pick('description')!.replaceAll(RegExp(r'<[^>]*>'), '').trim(),
          'images': images.isEmpty ? (old?['images'] ?? const []) : images,
          'highlights': (old?['highlights']) ?? const [],
          'category': (old?['category']),
          'options': options,
          'status': status,
          'tags': tags == null ? (old?['tags'] ?? const []) : tags.split(RegExp('[,،]')).map((x) => x.trim()).where((x) => x.isNotEmpty).toList(),
          'slug': old == null ? e.key : old['slug'],
          'seo_title': pick('seo_title') ?? (old?['seo_title']),
          'seo_description': pick('seo_description') ?? (old?['seo_description']),
          'video_url': pick('video_url') ?? (old?['video_url']),
          'price': price,
          'old_price': cmp != null && price != null && cmp > price ? cmp : null,
          'stock': stock,
          'sku': nOpts == 0 ? (e.value.first['sku'] as String?)?.trim() ?? (old?['sku']) : null,
          'barcode': nOpts == 0 ? (e.value.first['barcode'] as String?)?.trim() ?? (old?['barcode']) : null,
        }, variants, colls ?? (old == null ? const [] : null));
        if (old == null) {
          created++;
        } else {
          updated++;
        }
        items.add({'row': first, 'handle': e.key, 'title': title ?? (old?['name']), 'action': old == null ? 'create' : 'update', 'variants': variants.length, 'id': id});
      } on DemoError catch (err) {
        failed++;
        errors.add({'row': first, 'handle': e.key, 'message': err.message.startsWith('سطر') ? err.message : 'سطر $first: ${err.message}'});
      }
    }
    return {'created': created, 'updated': updated, 'failed': failed, 'errors': errors, 'items': items};
  }
}
