part of 'demo_store.dart';

/// The demo shop's side of migration 0099 (checkout, shipping zones,
/// discounts, abandoned carts, COD confirmation, guest cancel) — the same
/// rules as private.checkout_quote & co., in Dart, on the in-memory tables.
class DemoTajerCheckout {
  DemoTajerCheckout._();

  /// Seeded discount codes (for recordings).
  static const codeTen = 'SHAI10';
  static const codeWelcome = 'WELCOME20';
  static const codeFreeShip = 'FREEDLV';
  static final codeTenId = DemoStore.fixedId('d', 501);

  static Map<String, List<DemoRow>> seed(String Function({int days, int hours, int minutes}) ago, String shopId) {
    var seq = 0;
    String id(String kind) => DemoStore.fixedId(kind, 500 + ++seq);
    final discounts = <DemoRow>[
      _discount(id('d'), shopId, 'code', codeTen, 'خصم 10% على كل المنيو', 'percent', 10, created: ago(days: 20), used: 2),
      _discount(id('d'), shopId, 'code', codeWelcome, 'أهلاً بيك — 20 ج.م', 'fixed', 20, min: 100, perPhone: 1, limit: 100, created: ago(days: 12), used: 1),
      _discount(id('d'), shopId, 'code', codeFreeShip, 'توصيل مجاني', 'free_shipping', 0, created: ago(days: 6), ends: DateTime.now().add(const Duration(days: 10)).toUtc().toIso8601String()),
      _discount(id('d'), shopId, 'auto', null, 'خصم 15% على الطلبات فوق 300 ج.م', 'percent', 15, min: 300, created: ago(days: 30)),
      _discount(id('d'), shopId, 'code', 'RAMADAN', 'عروض رمضان', 'percent', 20, created: ago(days: 200), active: false, used: 41),
    ];
    String lines(List<(int, int, String?)> l) => jsonEncode([
          for (final (n, q, o) in l) {'product_id': DemoTajer.productId(n), 'quantity': q, 'options': o},
        ]);
    DemoRow cart(String name, String phone, List<(int, int, String?)> l, String updated, {String? area, String? reminded}) => {
          'id': id('f'),
          'shop_id': shopId,
          'token': DemoStore.fixedId('f', 500 + seq).replaceAll('-', ''),
          'phone': phone,
          'name': name,
          'lines_input': lines(l),
          'area': area,
          'created_at': updated,
          'updated_at': updated,
          'reminded_at': reminded,
          'recovered_order_id': null,
        };
    return {
      'shop_shipping_settings': [
        {
          'shop_id': shopId,
          'default_mode': 'rate',
          'default_eta': '2-3 أيام',
          'pickup_enabled': true,
          'pickup_address': 'المحل: شارع 9، المعادي، القاهرة — جنب البنك',
          'pickup_instructions': 'الطلب بيبقى جاهز خلال 20 دقيقة من التأكيد',
          'accepting_orders': true,
          'vacation': false,
          'vacation_message': null,
          'hours': [
            for (var d = 0; d < 7; d++) {'open': d != 5, 'from': '09:00', 'to': '00:00'},
          ],
          'after_hours': 'accept',
          'min_order': 30,
          'require_confirmation': false,
        },
      ],
      'shop_shipping_zones': [
        {'id': id('z'), 'shop_id': shopId, 'name': 'القاهرة والجيزة', 'areas': ['القاهرة', 'الجيزة'], 'fee': 15, 'free_over': 200, 'eta': 'خلال ساعة', 'position': 0},
        {'id': id('z'), 'shop_id': shopId, 'name': 'الدلتا والقناة', 'areas': ['القليوبية', 'الشرقية', 'الدقهلية', 'الغربية', 'المنوفية', 'الإسماعيلية', 'السويس', 'بورسعيد'], 'fee': 45, 'free_over': 500, 'eta': 'يوم أو يومين', 'position': 1},
        {'id': id('z'), 'shop_id': shopId, 'name': 'الإسكندرية', 'areas': ['الإسكندرية', 'البحيرة'], 'fee': 50, 'free_over': null, 'eta': '2-3 أيام', 'position': 2},
      ],
      'shop_discounts': discounts,
      'shop_discount_uses': <DemoRow>[],
      'shop_carts': [
        cart('نورهان سعيد', '01000000311', [(3, 2, 'الحجم: كبير'), (6, 2, null)], ago(hours: 3), area: 'الجيزة'),
        cart('أحمد فتحي', '01100000312', [(4, 3, null), (5, 4, null)], ago(hours: 7), area: 'القاهرة', reminded: ago(hours: 5)),
        cart('مريم خالد', '01200000313', [(2, 2, 'الحجم: مظبوط'), (1, 2, null), (6, 1, null)], ago(days: 1, hours: 4), area: 'القاهرة'),
        cart('يوسف عادل', '01500000314', [(1, 1, null)], ago(minutes: 20), area: 'القاهرة'),
      ],
    };
  }

  static DemoRow _discount(String id, String shopId, String method, String? code, String title, String type, num value,
          {num? min, int? perPhone, int? limit, required String created, String? ends, bool active = true, int used = 0}) =>
      {
        'id': id,
        'shop_id': shopId,
        'method': method,
        'code': code,
        'title': title,
        'type': type,
        'value': value,
        'applies_to': 'all',
        'product_ids': <String>[],
        'collection_ids': <String>[],
        'min_subtotal': min,
        'usage_limit': limit,
        'per_phone_limit': perPhone,
        'starts_at': created,
        'ends_at': ends,
        'active': active,
        'combines': false,
        'used_count': used,
        'created_at': created,
        'updated_at': created,
      };

  /// private.area_key.
  static String? areaKey(String? s) {
    final v = (s ?? '').trim().replaceAll(RegExp(r'\s+'), ' ').toLowerCase()
        .replaceAll(RegExp('[أإآ]'), 'ا').replaceAll('ة', 'ه').replaceAll('ى', 'ي');
    return v.isEmpty ? null : v;
  }

  /// private.discount_code_norm.
  static String? codeNorm(String? s) {
    final v = latinDigits(s ?? '').replaceAll(RegExp(r'\s'), '').toUpperCase();
    return v.isEmpty ? null : v;
  }

  /// Fixed UTC offsets (the server uses the real time zones).
  static const _utcOffset = {'EG': 3, 'SA': 3, 'AE': 4, 'KW': 3, 'QA': 3, 'BH': 3, 'OM': 4, 'JO': 3, 'IQ': 3, 'MA': 1, 'DZ': 1, 'TN': 1, 'LY': 2};

  static String _hm(DateTime t) => '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  /// private.shop_open_state.
  static DemoRow openState(DemoRow? s, String? country, [DateTime? nowUtc]) {
    const ok = {'can_order': true, 'open_now': true, 'code': 'ok'};
    if (s == null) return {...ok};
    if (s['accepting_orders'] == false) {
      return {'can_order': false, 'open_now': false, 'code': 'paused', 'message': 'المحل موقّف استقبال الطلبات مؤقتاً — جرّب بعد شوية'};
    }
    if (s['vacation'] == true) {
      final m = (s['vacation_message'] as String?)?.trim();
      return {'can_order': false, 'open_now': false, 'code': 'vacation', 'message': m == null || m.isEmpty ? 'المحل في إجازة دلوقتي — ارجعلنا قريب' : m};
    }
    final hours = s['hours'];
    if (hours is! List || hours.length != 7) return {...ok};
    final local = (nowUtc ?? DateTime.now().toUtc()).add(Duration(hours: _utcOffset[country ?? 'EG'] ?? 3));
    final dow = local.weekday % 7; // Sunday = 0
    final t = _hm(local);
    final d = Map<String, dynamic>.from(hours[dow] as Map);
    final p = Map<String, dynamic>.from(hours[(dow + 6) % 7] as Map);
    var open = false;
    String? from;
    if (d['open'] == true) {
      from = d['from'] as String;
      final to = d['to'] as String;
      open = from == to || (from.compareTo(to) < 0 && t.compareTo(from) >= 0 && t.compareTo(to) < 0) || (from.compareTo(to) > 0 && t.compareTo(from) >= 0);
    }
    if (!open && p['open'] == true && (p['from'] as String).compareTo(p['to'] as String) > 0 && t.compareTo(p['to'] as String) < 0) open = true;
    if (open) return {...ok};
    final msg = from != null && t.compareTo(from) < 0
        ? 'المحل قافل دلوقتي — بيفتح النهارده الساعة $from'
        : d['open'] != true
            ? 'النهارده إجازة المحل'
            : 'المحل قافل دلوقتي';
    if (s['after_hours'] == 'refuse') return {'can_order': false, 'open_now': false, 'code': 'closed_hours', 'message': msg};
    return {'can_order': true, 'open_now': false, 'code': 'after_hours', 'message': '$msg — اطلب عادي وطلبك هيتجهّز أول ما يفتح'};
  }
}

extension _TajerCheckoutBackend on DemoStore {
  static String _m(num v) => '${v == v.roundToDouble() ? v.toInt() : v.toStringAsFixed(2)} ج.م';

  DemoRow? _shipSettings(String shopId) => _firstWhere('shop_shipping_settings', (s) => s['shop_id'] == shopId);

  /// private.checkout_lines.
  List<DemoRow> _priceLines(DemoRow shop, List lines, {bool lenient = false}) {
    if (lines.isEmpty) {
      if (lenient) return [];
      throw DemoError('السلة فاضية');
    }
    if (lines.length > 50) throw DemoError('الطلب فيه منتجات كتير، قسّمه على أكتر من طلب');
    final out = <DemoRow>[];
    for (final raw in lines) {
      final line = Map<String, dynamic>.from(raw as Map);
      var qty = (line['quantity'] as num?)?.toInt() ?? 0;
      if (qty < 1 || qty > 99) {
        if (lenient) continue;
        throw DemoError('الكمية غير صحيحة');
      }
      final product = _firstWhere('shop_products', (x) => x['id'] == line['product_id'] && x['shop_id'] == shop['id'] && x['is_available'] == true);
      if (product == null) {
        if (lenient) continue;
        throw DemoError('فيه منتج في السلة مبقاش متاح، حدّث الصفحة');
      }
      // 0098: a line may name a variant; old clients' options text matches
      // one by its label (or the only variant) — as private.store_line.
      var opts = (line['options'] as String? ?? '').trim();
      final variants = _variantsOf(product['id'] as String).where((v) => v['is_available'] != false).toList();
      DemoRow? variant;
      if (line['variant_id'] != null) {
        variant = variants.where((v) => v['id'] == line['variant_id']).firstOrNull;
        if (variant == null) {
          if (lenient) continue;
          throw DemoError('فيه نوع في السلة مبقاش متاح، حدّث الصفحة');
        }
      } else if (_variantsOf(product['id'] as String).isNotEmpty) {
        variant = variants.where((v) => _label(product, v['option_values'] as List) == opts).firstOrNull ?? (variants.length == 1 ? variants.single : null);
        if (variant == null) {
          if (lenient) continue;
          throw DemoError('اختار النوع (المقاس/اللون…) لـ «${product['name']}» من صفحة المنتج');
        }
      }
      if (variant != null) opts = _label(product, variant['option_values'] as List);
      final holder = variant ?? product;
      final stock = holder['stock'] as num?;
      if (stock != null && stock < qty) {
        if (!lenient) throw DemoError('الكمية المتاحة من «${product['name']}${variant == null ? '' : ' — $opts'}» هي ${stock.toInt()} بس');
        if (stock <= 0) continue;
        qty = stock.toInt();
      }
      final price = holder['price'] as num;
      out.add({
        'product_id': product['id'],
        'variant_id': variant?['id'],
        'sku': holder['sku'],
        'quantity': qty,
        'options': opts.isEmpty ? null : opts,
        'unit_price': price,
        'line_total': price * qty,
        'name': product['name'],
        'image_url': variant?['image_url'] ?? (product['images'] as List?)?.firstOrNull ?? product['image_url'],
      });
    }
    return out;
  }

  num _eligible(DemoRow d, List<DemoRow> lines) => lines
      .where((l) =>
          d['applies_to'] == 'all' ||
          (d['applies_to'] == 'products' && (d['product_ids'] as List).contains(l['product_id'])) ||
          // 0098 «الأقسام» (manual lists in the demo).
          (d['applies_to'] == 'collections' &&
              t('shop_collection_products').any((cp) => (d['collection_ids'] as List).contains(cp['collection_id']) && cp['product_id'] == l['product_id'])))
      .fold<num>(0, (a, l) => a + (l['line_total'] as num));

  num _saving(DemoRow d, List<DemoRow> lines, num ship) => switch (d['type']) {
        'percent' => ((_eligible(d, lines) * (d['value'] as num) / 100) * 100).round() / 100,
        'fixed' => min(d['value'] as num, _eligible(d, lines)),
        _ => ship,
      };

  String? _discountProblem(DemoRow d, List<DemoRow> lines, num sub, num ship, String ful, String? phone) {
    final now = DateTime.now();
    if (d['active'] != true || DateTime.parse(d['starts_at'] as String).isAfter(now)) return 'الكود ده مش شغال دلوقتي';
    final ends = DateTime.tryParse(d['ends_at'] as String? ?? '');
    if (ends != null && !ends.isAfter(now)) return 'الكود ده خلصت مدته';
    final limit = d['usage_limit'] as num?;
    if (limit != null && (d['used_count'] as num) >= limit) return 'الكود ده خلص عدد استخداماته';
    final perPhone = d['per_phone_limit'] as num?;
    if (perPhone != null && phone != null && t('shop_discount_uses').where((u) => u['discount_id'] == d['id'] && u['phone'] == phone).length >= perPhone) {
      return 'استخدمت الكود ده قبل كده';
    }
    final minSub = d['min_subtotal'] as num?;
    if (minSub != null && sub < minSub) return 'الكود ده لطلبات من ${_m(minSub)} — زوّد ${_m(minSub - sub)}';
    if (d['type'] == 'free_shipping') {
      if (ful == 'pickup') return 'الكود ده للتوصيل المجاني — اختار التوصيل';
      if (ship == 0) return 'التوصيل مجاني أصلاً على طلبك';
    } else if (d['applies_to'] != 'all' && _eligible(d, lines) == 0) {
      return 'الكود ده مش على المنتجات اللي في سلتك';
    }
    return null;
  }

  /// private.checkout_quote (the demo has no brute-force counter).
  DemoRow _quote(DemoRow shop, List<DemoRow> lines, {String? area, String ful = 'delivery', String? code, String? phone, bool strict = false}) {
    if (ful != 'delivery' && ful != 'pickup') throw DemoError('طريقة الاستلام مش معروفة');
    final set = _shipSettings(shop['id'] as String);
    final sub = lines.fold<num>(0, (a, l) => a + (l['line_total'] as num));
    final errors = <DemoRow>[];
    final open = DemoTajerCheckout.openState(set, shop['country'] as String?);
    if (open['can_order'] != true) errors.add({'code': open['code'], 'message': open['message']});
    final minOrder = set?['min_order'] as num?;
    if (minOrder != null && sub < minOrder) errors.add({'code': 'min_order', 'message': 'أقل طلب ${_m(minOrder)} — زوّد ${_m(minOrder - sub)}'});
    final a = (area ?? '').trim().isEmpty ? null : area!.trim();
    num ship = 0;
    num? freeOver;
    String? zoneName, eta;
    if (ful == 'pickup') {
      if (set?['pickup_enabled'] != true) errors.add({'code': 'pickup_unavailable', 'message': 'الاستلام من المحل مش متاح في المحل ده'});
      zoneName = 'استلام من المحل';
    } else {
      final zones = t('shop_shipping_zones').where((z) => z['shop_id'] == shop['id']).toList()..sort((x, y) => (x['position'] as num).compareTo(y['position'] as num));
      final zone = a == null ? null : zones.where((z) => (z['areas'] as List).any((n) => DemoTajerCheckout.areaKey(n as String) == DemoTajerCheckout.areaKey(a))).firstOrNull;
      if (zone != null) {
        ship = zone['fee'] as num;
        freeOver = zone['free_over'] as num?;
        eta = zone['eta'] as String?;
        zoneName = zone['name'] as String;
      } else if ((set?['default_mode'] ?? 'rate') == 'rate') {
        ship = (shop['delivery_fee'] as num?) ?? 0;
        freeOver = shop['free_delivery_over'] as num?;
        eta = set?['default_eta'] as String?;
        zoneName = zones.isEmpty ? null : 'باقي المناطق';
      } else if (a == null) {
        errors.add({'code': 'area_required', 'message': 'اختار المحافظة / المنطقة عشان نحسب التوصيل'});
      } else {
        errors.add({'code': 'not_served', 'message': 'للأسف المحل مش بيوصّل لـ«$a»${set?['pickup_enabled'] == true ? ' — تقدر تستلم طلبك من المحل' : ''}'});
      }
      if (freeOver != null && sub >= freeOver) ship = 0;
    }
    final mine = t('shop_discounts').where((d) => d['shop_id'] == shop['id']).toList();
    DemoRow? auto;
    num autoSaving = 0;
    for (final d in mine.where((d) => d['method'] == 'auto' && d['active'] == true)) {
      if (_discountProblem(d, lines, sub, ship, ful, phone) == null) {
        final s = _saving(d, lines, ship);
        if (s > autoSaving) {
          auto = d;
          autoSaving = s;
        }
      }
    }
    final c = DemoTajerCheckout.codeNorm(code);
    DemoRow? cd;
    num codeSaving = 0;
    String? status, msg;
    if (c != null) {
      cd = mine.where((d) => d['method'] == 'code' && d['code'] == c).firstOrNull;
      if (cd == null) {
        status = 'invalid';
        msg = 'الكود ده مش صحيح';
      } else {
        msg = _discountProblem(cd, lines, sub, ship, ful, phone);
        status = msg == null ? 'applied' : 'not_applicable';
        if (msg == null) codeSaving = _saving(cd, lines, ship);
      }
    }
    var useCode = false, useAuto = false;
    if (status == 'applied' && auto != null && cd!['combines'] != true) {
      if (codeSaving >= autoSaving) {
        useCode = true;
      } else {
        useAuto = true;
        status = 'not_better';
        msg = 'عندك خصم تلقائي أحسن من الكود ده — طبّقناه بداله';
      }
    } else {
      useCode = status == 'applied';
      useAuto = auto != null;
    }
    num amount = 0;
    var freeShip = false;
    if (useCode) {
      if (cd!['type'] == 'free_shipping') {
        freeShip = true;
      } else {
        amount += codeSaving;
      }
    }
    if (useAuto) {
      if (auto!['type'] == 'free_shipping') {
        freeShip = true;
      } else {
        amount += autoSaving;
      }
    }
    amount = (min(amount, sub) * 100).round() / 100;
    final title = [if (useCode) cd!['title'], if (useAuto) auto!['title']].join(' + ');
    final next = mine
        .where((d) => d['method'] == 'auto' && d['active'] == true && (d['min_subtotal'] as num? ?? 0) > sub && d != auto)
        .toList()
      ..sort((x, y) => (x['min_subtotal'] as num).compareTo(y['min_subtotal'] as num));
    if (strict) {
      if (errors.isNotEmpty) throw DemoError(errors.first['message'] as String);
      if (c != null && status != 'applied' && status != 'not_better') throw DemoError(msg!);
    }
    final shipping = freeShip ? 0 : ship;
    return {
      'currency': shop['currency'] ?? 'EGP',
      'subtotal': sub,
      'item_count': lines.fold<int>(0, (a, l) => a + (l['quantity'] as int)),
      'fulfillment': ful,
      'shipping_area': ful == 'delivery' ? a : null,
      'shipping_zone': zoneName,
      'shipping_eta': eta,
      'shipping_base': ship,
      'shipping_fee': shipping,
      'free_over': freeOver,
      'free_shipping': freeShip,
      'discount_amount': amount,
      'discount_title': title.isEmpty ? null : title,
      'discount_code': useCode ? cd!['code'] : null,
      'discount_id': useCode ? cd!['id'] : null,
      'auto_discount_id': useAuto ? auto!['id'] : null,
      'auto_title': useAuto ? auto!['title'] : null,
      'code_status': status,
      'code_message': msg,
      'hint': next.isEmpty ? null : 'زوّد ${_m((next.first['min_subtotal'] as num) - sub)} وخد «${next.first['title']}»',
      'total': sub - amount + shipping,
      'errors': errors,
      'can_order': errors.isEmpty,
      'open': open,
      'min_order': minOrder,
    };
  }

  DemoRow _discountJson(DemoRow d) {
    final now = DateTime.now();
    final ends = DateTime.tryParse(d['ends_at'] as String? ?? '');
    final uses = t('shop_orders').where((o) => o['discount_id'] == d['id'] || o['auto_discount_id'] == d['id']);
    return {
      ...d,
      'state': d['active'] != true
          ? 'disabled'
          : ends != null && !ends.isAfter(now)
              ? 'expired'
              : d['usage_limit'] != null && (d['used_count'] as num) >= (d['usage_limit'] as num)
                  ? 'used_up'
                  : DateTime.parse(d['starts_at'] as String).isAfter(now)
                      ? 'scheduled'
                      : 'active',
      'sales': uses.fold<num>(0, (a, o) => a + (o['total_amount'] as num)),
      'saved': uses.fold<num>(0, (a, o) => a + ((o['discount_amount'] as num?) ?? 0)),
    };
  }

  /// A seeded cart's lines are priced on first read (products may change).
  DemoRow _cartRow(DemoRow c) {
    final shop = _shop(c['shop_id'] as String);
    final input = c['lines_input'];
    if (input is String) {
      final lines = _priceLines(shop, jsonDecode(input) as List, lenient: true);
      c
        ..remove('lines_input')
        ..['lines'] = lines
        ..['subtotal'] = lines.fold<num>(0, (a, l) => a + (l['line_total'] as num))
        ..['item_count'] = lines.fold<int>(0, (a, l) => a + (l['quantity'] as int))
        ..['currency'] = shop['currency'] ?? 'EGP';
    }
    return c;
  }

  /// Handles the 0099 RPCs; [_unhandled] for the others.
  Object? _checkoutRpc(String fn, Map<String, dynamic> p) {
    switch (fn) {
      case 'store_checkout_info':
        final shop = _firstWhere('shops', (s) => s['id'] == p['p_shop_id'] && s['owner_id'] != null);
        if (shop == null) return null;
        final set = _shipSettings(shop['id'] as String);
        final now = DateTime.now();
        bool live(DemoRow d) =>
            d['active'] == true && (DateTime.tryParse(d['ends_at'] as String? ?? '')?.isAfter(now) ?? true) && !DateTime.parse(d['starts_at'] as String).isAfter(now);
        final mine = t('shop_discounts').where((d) => d['shop_id'] == shop['id']);
        return {
          'country': shop['country'] ?? 'EG',
          'currency': shop['currency'] ?? 'EGP',
          'default_mode': set?['default_mode'] ?? 'rate',
          'default_fee': shop['delivery_fee'] ?? 0,
          'default_free_over': shop['free_delivery_over'],
          'default_eta': set?['default_eta'],
          'zones': [
            for (final z in t('shop_shipping_zones').where((z) => z['shop_id'] == shop['id']).toList()..sort((a, b) => (a['position'] as num).compareTo(b['position'] as num)))
              {'name': z['name'], 'areas': z['areas'], 'fee': z['fee'], 'free_over': z['free_over'], 'eta': z['eta']},
          ],
          'pickup': set?['pickup_enabled'] == true ? {'address': set!['pickup_address'], 'instructions': set['pickup_instructions']} : null,
          'open': DemoTajerCheckout.openState(set, shop['country'] as String?),
          'min_order': set?['min_order'],
          'require_confirmation': set?['require_confirmation'] == true,
          'has_codes': mine.any((d) => d['method'] == 'code' && live(d)),
          'auto_discounts': [
            for (final d in mine.where((d) => d['method'] == 'auto' && live(d))) {'title': d['title'], 'type': d['type'], 'value': d['value'], 'min_subtotal': d['min_subtotal']},
          ],
        };

      case 'quote_store_checkout':
        final shop = _firstWhere('shops', (s) => s['id'] == p['p_shop_id'] && s['owner_id'] != null) ?? (throw DemoError('المحل ده مش مستقبل طلبات حالياً'));
        final lines = _priceLines(shop, p['p_items'] as List? ?? const []);
        final phone = canonicalPhone(p['p_customer_phone'] as String?);
        return {
          ..._quote(shop, lines, area: p['p_area'] as String?, ful: p['p_fulfillment'] as String? ?? 'delivery', code: p['p_discount_code'] as String?, phone: phone),
          'lines': lines,
        };

      case 'place_store_order':
        return _checkoutPlace(p);

      case 'guest_cancel_store_order':
        final code = (p['p_code'] as String? ?? '').trim().toUpperCase();
        final o = _firstWhere('shop_orders', (x) => x['order_code'] == code) ?? (throw DemoError('مفيش طلب بالرقم ده'));
        final last4 = latinDigits(p['p_phone_last4'] as String? ?? '').replaceAll(RegExp(r'\D'), '');
        final digits = (o['customer_phone'] as String? ?? '').replaceAll(RegExp(r'\D'), '');
        if (last4.length != 4 || !digits.endsWith(last4)) return {'ok': false, 'error': 'آخر 4 أرقام من الموبايل مش مطابقين لرقم الطلب'};
        if (o['status'] != 'placed') throw DemoError('مينفعش تلغي الطلب بعد ما المحل بدأ يجهّزه — كلّم المحل');
        final reason = (p['p_reason'] as String? ?? '').trim();
        o['cancel_reason'] = reason.isEmpty ? 'الزبون لغى الطلب' : reason;
        o['status'] = 'cancelled';
        _releaseDiscounts(o);
        _restockOrder(o);
        _orderEvent(o['id'] as String, o['shop_id'] as String, 'cancel', from: 'placed', to: 'cancelled', body: o['cancel_reason'] as String, role: 'customer');
        final shop = _shop(o['shop_id'] as String);
        _notify([shop['owner_id'] as String], '❌ الزبون لغى الطلب $code — ${shop['name']}', '${o['customer_name']} لغى طلبه من صفحة المتابعة.', '/#/');
        return {...(_tajerRpc('get_store_order', {'p_code': code}) as Map<String, dynamic>), 'ok': true};

      case 'save_store_cart':
        final shop = _firstWhere('shops', (s) => s['id'] == p['p_shop_id'] && s['owner_id'] != null) ?? (throw DemoError('المحل ده مش مستقبل طلبات حالياً'));
        final phone = canonicalPhone(p['p_customer_phone'] as String?) ?? (throw DemoError(invalidPhoneMessage));
        if (_uid != null && shop['owner_id'] == _uid) return null;
        final lines = _priceLines(shop, p['p_items'] as List? ?? const [], lenient: true);
        if (lines.isEmpty) return null;
        final name = (p['p_customer_name'] as String? ?? '').trim();
        final area = (p['p_area'] as String? ?? '').trim();
        var c = _firstWhere('shop_carts', (c) => c['shop_id'] == shop['id'] && c['phone'] == phone);
        if (c != null && c['recovered_order_id'] != null) {
          t('shop_carts').remove(c);
          c = null;
        }
        c ??= (t('shop_carts')..add({'id': newId(), 'shop_id': shop['id'], 'token': newId().replaceAll('-', ''), 'phone': phone, 'created_at': DemoStore.nowIso(), 'recovered_order_id': null, 'reminded_at': null})).last;
        c
          ..remove('lines_input')
          ..['name'] = name.isEmpty ? c['name'] : name
          ..['lines'] = lines
          ..['subtotal'] = lines.fold<num>(0, (a, l) => a + (l['line_total'] as num))
          ..['item_count'] = lines.fold<int>(0, (a, l) => a + (l['quantity'] as int))
          ..['currency'] = shop['currency'] ?? 'EGP'
          ..['area'] = area.isEmpty ? c['area'] : area
          ..['updated_at'] = DemoStore.nowIso();
        return c['token'];

      case 'get_store_cart':
        final c = _firstWhere('shop_carts', (c) => c['token'] == (p['p_token'] as String? ?? '').trim().toLowerCase() && c['recovered_order_id'] == null);
        if (c == null) return null;
        _cartRow(c);
        return {
          'shop_slug': _shop(c['shop_id'] as String)['slug'],
          'lines': [
            for (final l in c['lines'] as List) {'product_id': l['product_id'], 'variant_id': l['variant_id'], 'quantity': l['quantity'], 'options': l['options']},
          ],
        };

      case 'merchant_abandoned_carts':
        final s = _myShop(p['p_shop'] as String?);
        final hourAgo = DateTime.now().subtract(const Duration(hours: 1));
        final mine = t('shop_carts').where((c) => c['shop_id'] == s['id']).toList();
        final open = mine.where((c) => c['recovered_order_id'] == null && DateTime.parse(c['updated_at'] as String).isBefore(hourAgo)).toList()
          ..sort((a, b) => (b['updated_at'] as String).compareTo(a['updated_at'] as String));
        final back = mine.where((c) => c['recovered_order_id'] != null && c['reminded_at'] != null);
        return {
          'carts': [
            for (final c in open)
              {for (final k in const ['id', 'token', 'name', 'phone', 'lines', 'subtotal', 'item_count', 'currency', 'area', 'created_at', 'updated_at', 'reminded_at']) k: _cartRow(c)[k]},
          ],
          'recovered_count': back.length,
          'recovered_value': back.fold<num>(0, (a, c) => a + ((_firstWhere('shop_orders', (o) => o['id'] == c['recovered_order_id'])?['total_amount'] as num?) ?? 0)),
        };

      case 'merchant_mark_cart_reminded':
        final c = _firstWhere('shop_carts', (c) => c['id'] == p['p_cart']) ?? (throw DemoError('السلة دي مش موجودة'));
        _myShop(c['shop_id'] as String?);
        c['reminded_at'] = DemoStore.nowIso();
        return null;

      case 'merchant_confirm_order':
        final o = _myOrder(p['p_order'] as String?);
        if (o['status'] == 'cancelled') throw DemoError('الطلب ده اتلغى');
        if (o['confirmation_status'] == 'confirmed') return null;
        o['confirmation_status'] = 'confirmed';
        o['confirmed_at'] = DemoStore.nowIso();
        _orderEvent(o['id'] as String, o['shop_id'] as String, 'confirm', body: 'الزبون أكّد الطلب', role: 'merchant');
        return null;

      case 'get_shop_shipping':
        return _shippingJson(_myShop(p['p_shop'] as String?));

      case 'set_shop_shipping':
        final s = _myShop(p['p_shop'] as String?);
        final v = Map<String, dynamic>.from(p['p'] as Map);
        final fee = (v['default_fee'] as num?) ?? 0;
        final free = v['default_free_over'] as num?;
        if (fee < 0 || fee > 1000) throw DemoError('قيمة التوصيل لازم تكون من 0 لـ 1,000 ج.م');
        if (free != null && free <= 0) throw DemoError('حد التوصيل المجاني لازم يكون أكبر من صفر');
        final pickup = v['pickup_enabled'] == true;
        final pickupAddress = (v['pickup_address'] as String? ?? '').trim();
        if (pickup && pickupAddress.length < 5) throw DemoError('اكتب عنوان الاستلام من المحل');
        final zones = [for (final z in v['zones'] as List? ?? const []) Map<String, dynamic>.from(z as Map)];
        final seen = <String>{};
        for (final z in zones) {
          final name = (z['name'] as String? ?? '').trim();
          if (name.isEmpty) throw DemoError('اكتب اسم لكل منطقة شحن');
          final areas = List<String>.from(z['areas'] as List? ?? const []);
          if (areas.isEmpty) throw DemoError('اختار محافظة / منطقة واحدة على الأقل في «$name»');
          for (final a in areas) {
            if (!seen.add(DemoTajerCheckout.areaKey(a)!)) throw DemoError('«$a» موجودة في أكتر من منطقة شحن');
          }
          if (((z['fee'] as num?) ?? 0) < 0) throw DemoError('سعر التوصيل في «$name» مش صحيح');
        }
        s['delivery_fee'] = fee;
        s['free_delivery_over'] = free;
        t('shop_shipping_settings').removeWhere((x) => x['shop_id'] == s['id']);
        String? blank(Object? x) => (x as String? ?? '').trim().isEmpty ? null : (x as String).trim();
        t('shop_shipping_settings').add({
          'shop_id': s['id'],
          'default_mode': v['default_mode'] ?? 'rate',
          'default_eta': blank(v['default_eta']),
          'pickup_enabled': pickup,
          'pickup_address': blank(pickupAddress),
          'pickup_instructions': blank(v['pickup_instructions']),
          'accepting_orders': v['accepting_orders'] ?? true,
          'vacation': v['vacation'] ?? false,
          'vacation_message': blank(v['vacation_message']),
          'hours': v['hours'],
          'after_hours': v['after_hours'] ?? 'accept',
          'min_order': v['min_order'],
          'require_confirmation': v['require_confirmation'] ?? false,
        });
        t('shop_shipping_zones').removeWhere((x) => x['shop_id'] == s['id']);
        for (final (i, z) in zones.indexed) {
          t('shop_shipping_zones').add({
            'id': newId(),
            'shop_id': s['id'],
            'name': (z['name'] as String).trim(),
            'areas': List<String>.from(z['areas'] as List),
            'fee': (z['fee'] as num?) ?? 0,
            'free_over': z['free_over'],
            'eta': blank(z['eta']),
            'position': i,
          });
        }
        return _shippingJson(s);

      case 'set_shop_currency':
        final s = _myShop(p['p_shop'] as String?);
        final c = (p['p_currency'] as String? ?? '').trim().toUpperCase();
        if (!storeCurrencies.contains(c)) throw DemoError('العملة دي مش متاحة للمتاجر');
        s['currency'] = c;
        for (final x in t('shop_products').where((x) => x['shop_id'] == s['id'])) {
          x['currency'] = c;
        }
        return {'currency': c, 'changed': true};

      case 'merchant_discounts':
        final s = _myShop(p['p_shop'] as String?);
        return [
          for (final d in t('shop_discounts').where((d) => d['shop_id'] == s['id']).toList()..sort((a, b) => (b['created_at'] as String).compareTo(a['created_at'] as String)))
            _discountJson(d),
        ];

      case 'save_shop_discount':
        final s = _myShop(p['p_shop'] as String?);
        final v = Map<String, dynamic>.from(p['p'] as Map);
        final method = v['method'] as String? ?? 'code';
        final type = v['type'] as String? ?? 'percent';
        var code = method == 'code' ? DemoTajerCheckout.codeNorm(v['code'] as String?) : null;
        var title = (v['title'] as String? ?? '').trim();
        if (method == 'code') {
          if (code == null || !RegExp(r'^[A-Z0-9_ء-ي-]{3,30}$').hasMatch(code)) throw DemoError('الكود لازم يكون من 3 لـ 30 حرف أو رقم (من غير مسافات)');
          if (title.isEmpty) title = code;
        } else if (title.isEmpty) {
          throw DemoError('اكتب اسم للخصم التلقائي (الزبون بيشوفه)');
        }
        final value = type == 'free_shipping' ? 0 : ((v['value'] as num?) ?? 0);
        if (type == 'percent' && (value <= 0 || value > 100)) throw DemoError('النسبة لازم تكون من 1 لـ 100%');
        if (type == 'fixed' && value <= 0) throw DemoError('اكتب قيمة الخصم');
        final applies = type == 'free_shipping' ? 'all' : (v['applies_to'] as String? ?? 'all');
        final products = [
          for (final id in v['product_ids'] as List? ?? const [])
            if (t('shop_products').any((x) => x['id'] == id && x['shop_id'] == s['id'])) id,
        ];
        if (applies == 'products' && products.isEmpty) throw DemoError('اختار المنتجات اللي عليها الخصم');
        final starts = (v['starts_at'] as String?) ?? DemoStore.nowIso();
        final ends = v['ends_at'] as String?;
        if (ends != null && !DateTime.parse(ends).isAfter(DateTime.parse(starts))) throw DemoError('تاريخ النهاية لازم يكون بعد البداية');
        final id = v['id'] as String?;
        if (code != null && t('shop_discounts').any((d) => d['shop_id'] == s['id'] && d['code'] == code && d['id'] != id)) throw DemoError('الكود «$code» موجود قبل كده');
        final row = id == null
            ? (t('shop_discounts')..add({'id': newId(), 'shop_id': s['id'], 'used_count': 0, 'created_at': DemoStore.nowIso()})).last
            : (_firstWhere('shop_discounts', (d) => d['id'] == id && d['shop_id'] == s['id']) ?? (throw DemoError('الخصم ده مش موجود')));
        row.addAll({
          'method': method,
          'code': code,
          'title': title,
          'type': type,
          'value': value,
          'applies_to': applies,
          'product_ids': applies == 'products' ? products : <String>[],
          'collection_ids': applies == 'collections' ? List<String>.from(v['collection_ids'] as List? ?? const []) : <String>[],
          'min_subtotal': (v['min_subtotal'] as num?) != null && (v['min_subtotal'] as num) > 0 ? v['min_subtotal'] : null,
          'usage_limit': v['usage_limit'],
          'per_phone_limit': v['per_phone_limit'],
          'starts_at': starts,
          'ends_at': ends,
          'active': v['active'] ?? row['active'] ?? true,
          'combines': v['combines'] ?? row['combines'] ?? false,
          'updated_at': DemoStore.nowIso(),
        });
        return _discountJson(row);

      case 'delete_shop_discount':
        final d = _firstWhere('shop_discounts', (d) => d['id'] == p['p_discount']) ?? (throw DemoError('الخصم ده مش موجود'));
        _myShop(d['shop_id'] as String?);
        if ((d['used_count'] as num) > 0 || t('shop_orders').any((o) => o['discount_id'] == d['id'] || o['auto_discount_id'] == d['id'])) {
          d['active'] = false;
          return {'deleted': false, 'deactivated': true};
        }
        t('shop_discounts').remove(d);
        return {'deleted': true, 'deactivated': false};

      case 'merchant_discount_orders':
        final d = _firstWhere('shop_discounts', (d) => d['id'] == p['p_discount']) ?? (throw DemoError('الخصم ده مش موجود'));
        _myShop(d['shop_id'] as String?);
        return [
          for (final o in t('shop_orders').where((o) => o['discount_id'] == d['id'] || o['auto_discount_id'] == d['id']).toList()
            ..sort((a, b) => (b['created_at'] as String).compareTo(a['created_at'] as String)))
            {for (final k in const ['id', 'order_code', 'customer_name', 'status', 'created_at', 'total_amount', 'discount_amount', 'currency']) k: o[k]},
        ];
    }
    return _unhandled;
  }

  DemoRow _shippingJson(DemoRow s) {
    final set = _shipSettings(s['id'] as String) ?? const {};
    return {
      'shop_id': s['id'],
      'country': s['country'] ?? 'EG',
      'currency': s['currency'] ?? 'EGP',
      'default_mode': set['default_mode'] ?? 'rate',
      'default_fee': s['delivery_fee'] ?? 0,
      'default_free_over': s['free_delivery_over'],
      'default_eta': set['default_eta'],
      'pickup_enabled': set['pickup_enabled'] ?? false,
      'pickup_address': set['pickup_address'],
      'pickup_instructions': set['pickup_instructions'],
      'accepting_orders': set['accepting_orders'] ?? true,
      'vacation': set['vacation'] ?? false,
      'vacation_message': set['vacation_message'],
      'hours': set['hours'],
      'after_hours': set['after_hours'] ?? 'accept',
      'min_order': set['min_order'],
      'require_confirmation': set['require_confirmation'] ?? false,
      'open': DemoTajerCheckout.openState(set.isEmpty ? null : set, s['country'] as String?),
      'zones': [
        for (final z in t('shop_shipping_zones').where((z) => z['shop_id'] == s['id']).toList()..sort((a, b) => (a['position'] as num).compareTo(b['position'] as num)))
          {'id': z['id'], 'name': z['name'], 'areas': z['areas'], 'fee': z['fee'], 'free_over': z['free_over'], 'eta': z['eta']},
      ],
    };
  }

  /// 0068 / 0098: a cancelled order's stock comes back (per variant).
  void _restockOrder(DemoRow o) {
    for (final i in t('shop_order_items').where((i) => i['order_id'] == o['id'])) {
      final v = i['variant_id'] == null ? null : _firstWhere('shop_product_variants', (x) => x['id'] == i['variant_id']);
      final holder = v ?? (i['variant_id'] == null ? _firstWhere('shop_products', (x) => x['id'] == i['product_id']) : null);
      if (holder != null && holder['stock'] != null) holder['stock'] = (holder['stock'] as num).toInt() + (i['quantity'] as num).toInt();
      if (v != null) _rollup(v['product_id'] as String);
    }
  }

  /// A cancelled order gives its discount uses back.
  void _releaseDiscounts(DemoRow o) {
    final uses = t('shop_discount_uses').where((u) => u['order_id'] == o['id']).toList();
    for (final u in uses) {
      final d = _firstWhere('shop_discounts', (d) => d['id'] == u['discount_id']);
      if (d != null) d['used_count'] = max(0, (d['used_count'] as num).toInt() - 1);
      t('shop_discount_uses').remove(u);
    }
  }

  /// 0099's place_store_order on the demo tables.
  Object? _checkoutPlace(Map<String, dynamic> p) {
    final phone = canonicalPhone(p['p_customer_phone'] as String?) ?? '';
    final name = (p['p_customer_name'] as String? ?? '').trim();
    final ful = (p['p_fulfillment'] as String?) ?? 'delivery';
    var address = (p['p_address'] as String? ?? '').trim();
    final shop = _firstWhere('shops', (s) => s['id'] == p['p_shop_id']);
    if (shop == null || shop['owner_id'] == null) throw DemoError('المحل ده مش مستقبل طلبات حالياً');
    if (_uid != null && shop['owner_id'] == _uid) throw DemoError('مينفعش تطلب من محلك');
    if (name.length < 2) throw DemoError('اكتب اسمك');
    if (phone.isEmpty) throw DemoError(invalidPhoneMessage);
    if (ful == 'delivery' && address.length < 8) throw DemoError('اكتب العنوان بالتفصيل عشان الطلب يوصلك');
    if (ful == 'pickup' && address.isEmpty) address = 'استلام من المحل';
    final code = DemoTajerCheckout.codeNorm(p['p_discount_code'] as String?);
    if (code != null && !t('shop_discounts').any((d) => d['shop_id'] == shop['id'] && d['method'] == 'code' && d['code'] == code)) return null;
    // (The real server also rate-limits by phone — left out so the same
    // sample customer can be recorded again and again.)
    final lines = _priceLines(shop, p['p_items'] as List? ?? const []);
    final q = _quote(shop, lines, area: p['p_area'] as String?, ful: ful, code: code, phone: phone, strict: true);
    final expected = p['p_expected_total'] as num?;
    if (expected != null && (expected - (q['total'] as num)).abs() > 0.009) {
      throw DemoError('الأسعار أو التوصيل اتغيروا — الإجمالي دلوقتي ${_m(q['total'] as num)}، راجع طلبك وأكّد تاني');
    }
    final orderId = newId();
    final orderCode = _orderCode();
    var count = 0;
    for (final l in lines) {
      final product = _firstWhere('shop_products', (x) => x['id'] == l['product_id'])!;
      final variant = l['variant_id'] == null ? null : _firstWhere('shop_product_variants', (x) => x['id'] == l['variant_id']);
      final holder = variant ?? product;
      final before = (holder['stock'] as num?)?.toInt();
      if (before != null) holder['stock'] = before - (l['quantity'] as int);
      if (variant != null) _rollup(product['id'] as String);
      if (before != null) _lowStockAlert(shop, product, variant, before, before - (l['quantity'] as int));
      t('shop_order_items').add({
        'id': newId(),
        'order_id': orderId,
        'product_id': product['id'],
        'variant_id': l['variant_id'],
        'sku': l['sku'],
        'quantity': l['quantity'],
        'unit_price': l['unit_price'],
        'chosen_options': l['options'],
        'product_name': product['name'],
        'variant_label': l['options'],
        'image_url': l['image_url'],
        'created_at': DemoStore.nowIso(),
      });
      count += l['quantity'] as int;
    }
    for (final id in [q['discount_id'], q['auto_discount_id']].whereType<String>()) {
      final d = _firstWhere('shop_discounts', (d) => d['id'] == id)!;
      d['used_count'] = (d['used_count'] as num).toInt() + 1;
      t('shop_discount_uses').add({'discount_id': id, 'order_id': orderId, 'shop_id': shop['id'], 'phone': phone, 'amount': q['discount_amount'], 'created_at': DemoStore.nowIso()});
    }
    final token = p['p_cart_token'] as String?;
    final cart = _firstWhere('shop_carts', (c) => c['shop_id'] == shop['id'] && c['recovered_order_id'] == null && (c['phone'] == phone || (token != null && c['token'] == token)));
    if (cart != null) {
      cart['recovered_order_id'] = orderId;
      cart['recovered_at'] = DemoStore.nowIso();
    }
    final note = (p['p_note'] as String? ?? '').trim();
    t('shop_orders').add({
      'id': orderId,
      'shop_id': shop['id'],
      'buyer_id': _uid,
      'status': 'placed',
      'total_amount': q['total'],
      'subtotal': q['subtotal'],
      'delivery_fee': q['shipping_fee'],
      'discount_amount': q['discount_amount'],
      'discount_code': q['discount_code'],
      'discount_title': q['discount_title'],
      'discount_id': q['discount_id'],
      'auto_discount_id': q['auto_discount_id'],
      'shipping_zone': q['shipping_zone'],
      'shipping_area': q['shipping_area'],
      'fulfillment': ful,
      'confirmation_status': 'pending',
      'cart_id': cart?['id'],
      'customer_name': name,
      'customer_phone': phone,
      'delivery_address': address,
      'note': note.isEmpty ? null : note,
      'internal_note': null,
      'cancel_reason': null,
      'currency': shop['currency'] ?? 'EGP',
      'order_code': orderCode,
      'created_at': DemoStore.nowIso(),
    });
    _orderEvent(orderId, shop['id'] as String, 'created', to: 'placed', role: 'customer');
    final off = q['discount_amount'] as num;
    if (off > 0 || q['free_shipping'] == true) {
      _orderEvent(orderId, shop['id'] as String, 'discount',
          body: '${q['discount_title'] ?? 'خصم'}${q['discount_code'] != null ? ' (كود ${q['discount_code']})' : ''}${off > 0 ? ' — ${_m(off)}' : ''}${q['free_shipping'] == true ? ' — توصيل مجاني' : ''}',
          role: 'customer');
    }
    _notify(
      [shop['owner_id'] as String],
      '🛒 طلب جديد $orderCode — ${shop['name']}',
      '$name طلب $count منتج بإجمالي ${_m(q['total'] as num)}${ful == 'pickup' ? ' (استلام من المحل)' : ' (شامل التوصيل)'}. افتح «الطلبات» في متجري.',
      '/#/',
    );
    return orderCode;
  }
}

/// [_TajerCheckoutBackend._checkoutRpc]'s "not mine".
const _unhandled = Object();
