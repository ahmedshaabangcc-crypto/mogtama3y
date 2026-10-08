part of 'demo_store.dart';

/// The merchant app's (متجري, APP_FLAVOR=tajer) side of the local demo:
/// a fictional tea house «محل بيت الشاي — تجريبي» with six products,
/// orders in every status, two customers' digital addresses, and the
/// RPCs the merchant panel / store page / checkout / order tracking call
/// (same rules as migrations 0047, 0054, 0057, 0068, 0074).
///
/// Photos are the bundled CC0 pictures under web/catalog/, served by the
/// local server — nothing is fetched from the internet.
class DemoTajer {
  DemoTajer._();

  static final shopId = DemoStore.fixedId('b', 21);
  static final uMerchant = DemoStore.fixedId('a', 21);
  static final uNewMerchant = DemoStore.fixedId('a', 22);
  static final uMona = DemoStore.fixedId('a', 23);
  static final uSalma = DemoStore.fixedId('a', 24);

  /// The `customer` role is a guest (customers order without an account):
  /// this id has no profile and no session.
  static final uGuest = DemoStore.fixedId('a', 99);

  static final roleUsers = {'merchant': uMerchant, 'new': uNewMerchant, 'customer': uGuest};

  static const slug = demoShopSlug;
  static const shopName = 'محل بيت الشاي — تجريبي';
  static const shopWhatsapp = '01000000201';

  static String productId(int n) => DemoStore.fixedId('7', n);

  /// Seeded order codes by status (for `/#/o/<code>` shortcuts).
  static const orderPlaced = 'T7K4M2QX';
  static const orderPlaced2 = 'T9H3W5PA';
  static const orderPreparing = 'T2N8R6DC';
  static const orderDelivering = 'T5B7L3JY';
  static const orderDelivered = 'T8F2V9KE';
  static const orderCancelled = 'T3Z6X4HM';

  /// Digital-address names a merchant can type in «عنوان زبون للتوصيل».
  static const monaAddress = 'mona-maadi';
  static const salmaAddress = 'salma-nasr';

  /// A bundled photo under web/catalog/, as a URL on this local server.
  static String asset(String name) => Uri.base.resolve('/catalog/$name.jpg').toString();

  /// The fictional customer the checkout's «املأ بيانات تجريبية» fills in.
  static const sampleCustomerName = 'سلمى حسن';
  static const sampleCustomerPhone = '01000000307';
  static const sampleCustomerAddress =
      'عمارة 22، الدور 5، شقة 12، شارع مكرم عبيد، مدينة نصر، القاهرة\n'
      'علامة مميزة: قدام مخبز النور — تجريبي\n'
      'العنوان على الخريطة: https://mogtama3y.com/#/a/$salmaAddress';
  static const sampleCustomerNote = 'رنّ قبل ما توصل لو سمحت';

  static const _monaAddressText =
      'عمارة 14، الدور 3، شقة 7، شارع 9، دجلة، المعادي، القاهرة\n'
      'علامة مميزة: جنب صيدلية الشفاء — تجريبي\n'
      'العنوان على الخريطة: https://mogtama3y.com/#/a/$monaAddress';

  static Map<String, List<DemoRow>> seed(DateTime now) {
    String ago({int days = 0, int hours = 0, int minutes = 0}) => now.subtract(Duration(days: days, hours: hours, minutes: minutes)).toUtc().toIso8601String();
    var seq = 0;
    String id(String kind) => DemoStore.fixedId(kind, ++seq);

    final people = <String, (String, String)>{
      uMerchant: ('حسن عبد العزيز', shopWhatsapp),
      uNewMerchant: ('مصطفى كمال', '01000000202'),
      uMona: ('منى عادل', '01000000301'),
      uSalma: (sampleCustomerName, sampleCustomerPhone),
    };
    final profiles = [
      for (final e in people.entries)
        {
          'id': e.key,
          'full_name': e.value.$1,
          'phone': e.value.$2,
          'phone_hidden': false,
          'avatar_url': null,
          'is_verified': true,
          'role': 'user',
          'ad_token_balance': 0,
          'created_at': ago(days: 90),
          'updated_at': ago(days: 2),
          'phone_verified_at': ago(days: 80),
        },
    ];

    final shops = [
      {
        'id': shopId,
        'owner_id': uMerchant,
        'source': 'claimed',
        'name': shopName,
        'category': 'مطعم / كافيه',
        'description': 'شاي وقهوة ومشروبات فريش وحلويات بيتي — بنوصّل لحد البيت في المعادي ودجلة من 9 الصبح لـ 12 بالليل.',
        'address': 'شارع 9، المعادي، القاهرة',
        'slug': slug,
        'whatsapp': shopWhatsapp,
        'is_claimed': true,
        'claimed_at': ago(days: 60),
        'scan_count': 248,
        'cover_image_url': asset('tea'),
        'logo_url': asset('tea-cup'),
        'lat': null,
        'lng': null,
        'delivery_fee': 15,
        'free_delivery_over': 200,
        'created_at': ago(days: 60),
      },
    ];

    DemoRow product(int n, String name, num price, String image, String category, String description,
            {num? oldPrice, List<String> highlights = const [], List<String> sizes = const [], int? stock}) =>
        {
          'id': productId(n),
          'shop_id': shopId,
          'name': name,
          'price': price,
          'old_price': oldPrice,
          'description': description,
          'images': [asset(image)],
          'image_url': asset(image),
          'highlights': highlights,
          'category': category,
          'stock': stock,
          'options': [
            if (sizes.isNotEmpty) {'name': 'الحجم', 'values': sizes},
          ],
          'is_available': true,
          'created_at': ago(days: 50, minutes: n),
        };

    final products = [
      product(1, 'شاي بالنعناع', 15, 'tea-cup', 'مشروبات سخنة', 'شاي كشري بالنعناع الفريش في كوباية كبيرة، زي ما بتحبه بالظبط.',
          highlights: ['نعناع فريش', 'سكر على مزاجك']),
      product(2, 'قهوة تركي', 20, 'turkish-coffee', 'مشروبات سخنة', 'قهوة تركي محوّجة بتتعمل على الفحم، وشها مظبوط.',
          oldPrice: 25, highlights: ['بن طازة', 'بالوش'], sizes: ['سادة', 'مظبوط', 'زيادة']),
      product(3, 'نسكافيه باللبن', 25, 'coffee', 'مشروبات سخنة', 'نسكافيه كريمي باللبن الطازة، يدفّيك في أي وقت.', sizes: ['وسط', 'كبير']),
      product(4, 'عصير برتقال فريش', 30, 'juice', 'مشروبات ساقعة', 'برتقال بلدي معصور ساعتها من غير سكر ولا مياه.',
          highlights: ['معصور ساعتها', 'من غير إضافات'], stock: 12),
      product(5, 'كرواسون بالزبدة', 18, 'croissant', 'حلويات ومخبوزات', 'كرواسون هش بالزبدة الفلاحي، طالع من الفرن على طول.'),
      product(6, 'بسبوسة بالقشطة', 22, 'basbousa', 'حلويات ومخبوزات', 'بسبوسة بيتي بالسمنة البلدي محشية قشطة.',
          oldPrice: 28, highlights: ['سمنة بلدي', 'قشطة طازة']),
    ];
    final priceOf = {for (final p in products) p['id']: p['price'] as num};

    final orders = <DemoRow>[];
    final items = <DemoRow>[];
    void order(String code, String status, String name, String phone, String address, List<(int, int, String?)> lines, String createdAt, {String? note}) {
      final orderId = id('8');
      num subtotal = 0;
      for (final (n, qty, opts) in lines) {
        final pid = productId(n);
        items.add({'id': id('9'), 'order_id': orderId, 'product_id': pid, 'quantity': qty, 'unit_price': priceOf[pid], 'chosen_options': opts, 'created_at': createdAt});
        subtotal += priceOf[pid]! * qty;
      }
      final delivery = subtotal >= 200 ? 0 : 15;
      orders.add({
        'id': orderId,
        'shop_id': shopId,
        'buyer_id': null,
        'status': status,
        'total_amount': subtotal + delivery,
        'delivery_fee': delivery,
        'customer_name': name,
        'customer_phone': phone,
        'delivery_address': address,
        'note': note,
        'order_code': code,
        'created_at': createdAt,
      });
    }

    order(orderPlaced, 'placed', 'منى عادل', '01000000301', _monaAddressText, [(1, 2, null), (6, 2, null)], ago(minutes: 12),
        note: 'من غير سكر في الشاي لو سمحت');
    order(orderPlaced2, 'placed', 'شريف حمدي', '01100000302', 'عمارة 5، الدور 2، شارع 233، المعادي، القاهرة', [(2, 2, 'الحجم: مظبوط'), (5, 3, null)], ago(minutes: 35));
    order(orderPreparing, 'preparing', 'دينا مجدي', '01200000303', 'فيلا 8، شارع 77، المعادي الجديدة، القاهرة', [(4, 2, null), (3, 1, 'الحجم: كبير')], ago(hours: 1, minutes: 10));
    order(orderDelivering, 'delivering', 'عمر طارق', '01500000304', 'مكتب 4، برج النيل، كورنيش المعادي، القاهرة — شركة تجريبية', [(3, 4, 'الحجم: وسط'), (6, 6, null)],
        ago(hours: 2, minutes: 5), note: 'اجتماع الساعة 1، ياريت قبلها');
    order(orderDelivered, 'delivered', 'هبة سامي', '01000000305', 'عمارة 30، شارع النصر، المعادي، القاهرة', [(1, 4, null), (5, 2, null)], ago(days: 1, hours: 3));
    order(orderCancelled, 'cancelled', 'كريم فؤاد', '01100000306', 'عمارة 2، شارع 100، المعادي، القاهرة', [(2, 1, 'الحجم: سادة')], ago(days: 2, hours: 5));
    order('T4P7S2GN', 'delivered', 'منى عادل', '01000000301', _monaAddressText, [(1, 3, null), (6, 3, null), (5, 2, null)], ago(days: 4, hours: 2));
    order('T6R3C8WB', 'delivered', 'ياسمين علي', '01200000308', 'عمارة 9، شارع 250، دجلة، المعادي، القاهرة', [(4, 3, null), (2, 2, 'الحجم: زيادة')], ago(days: 9, hours: 6));

    DemoRow eAddress(String owner, String code, String handle, Map<String, Object?> fields, String createdAt) => {
          'id': id('c'),
          'owner_id': owner,
          'code': code,
          'handle': handle,
          'label': 'البيت',
          'is_active': true,
          'show_name': true,
          'show_phone': true,
          'phone_lookup': true,
          'scan_count': 3,
          'notes': null,
          'created_at': createdAt,
          ...fields,
        };

    return {
      'profiles': profiles,
      'shops': shops,
      'shop_products': products,
      'shop_orders': orders,
      'shop_order_items': items,
      'e_addresses': [
        eAddress(uMona, 'K7P2X9QM', monaAddress, {
          'governorate': 'القاهرة',
          'city': 'المعادي',
          'district': 'دجلة',
          'street': 'شارع 9',
          'building': '14',
          'floor': '3',
          'apartment': '7',
          'landmark': 'جنب صيدلية الشفاء — تجريبي',
          'notes': 'الجرس التاني من فوق',
          'lat': 29.9602,
          'lng': 31.2569,
        }, ago(days: 40)),
        eAddress(uSalma, 'R4T8W2NB', salmaAddress, {
          'governorate': 'القاهرة',
          'city': 'مدينة نصر',
          'district': 'الحي السابع',
          'street': 'شارع مكرم عبيد',
          'building': '22',
          'floor': '5',
          'apartment': '12',
          'landmark': 'قدام مخبز النور — تجريبي',
          'lat': 30.0561,
          'lng': 31.3455,
        }, ago(days: 20)),
      ],
      'e_address_views': <DemoRow>[],
      'notifications': [
        {
          'id': id('1'),
          'user_id': uMerchant,
          'title': '🛒 طلب جديد $orderPlaced — $shopName',
          'body': 'منى عادل طلب 4 منتج بإجمالي 89 ج.م (شامل التوصيل). افتح «الطلبات» في متجري.',
          'deep_link': null,
          'is_read': false,
          'created_at': ago(minutes: 12),
        },
      ],
    };
  }
}

/// Canned «✨ اكتبلي» copy for the demo (the real one asks Gemini through
/// the product-ai Edge Function — never called in the demo build).
({String name, String description, List<String> highlights}) demoProductCopy({String? name, String? category}) {
  final n = (name ?? '').trim();
  bool has(List<String> words) => words.any(n.contains);
  if (has(['كنافة', 'كنافه'])) {
    return (
      name: n,
      description: 'كنافة بالقشطة الطازة متحمّرة في السمنة البلدي ومتسقية شربات خفيف — قرمشة من برّه وطراوة من جوّه. تتاكل سخنة أو ساقعة، ومناسبة للعزومات والسهرة.',
      highlights: ['سمنة بلدي', 'قشطة طازة', 'شربات خفيف'],
    );
  }
  if (has(['شاي', 'قهوة', 'نسكافيه', 'كابتشينو', 'لاتيه', 'مشروب'])) {
    return (
      name: n,
      description: 'مشروب سخن متحضّر ساعة الطلب بخامات طازة، وبيوصلك سخن في كوباية محكمة القفل. ظبّط السكر على مزاجك في ملاحظة الطلب.',
      highlights: ['بيتعمل ساعة الطلب', 'بيوصل سخن', 'السكر على مزاجك'],
    );
  }
  if (has(['عصير', 'سموذي', 'ليمون', 'مانجا', 'فراولة'])) {
    return (
      name: n,
      description: 'عصير فريش معصور ساعتها من فاكهة طازة، من غير مياه ولا مواد حافظة. منعش وبيوصلك ساقع.',
      highlights: ['معصور ساعتها', 'من غير مواد حافظة', 'بيوصل ساقع'],
    );
  }
  return (
    name: n.isEmpty ? 'كنافة بالقشطة' : n,
    description: 'منتج طازة متحضّر في محلنا كل يوم بأجود الخامات، وطعمه هيعجبك من أول مرة. اطلبه دلوقتي ويوصلك لحد باب البيت والدفع عند الاستلام.',
    highlights: ['طازة يومياً', 'خامات ممتازة', 'توصيل سريع'],
  );
}

/// Bundled sample photos for the demo-only «صورة تجريبية» button (picked
/// by the product name when it matches, else the next unused one).
String demoSamplePhoto({String name = '', List<String> taken = const []}) {
  const byWord = {
    'كنافة': 'kunafa',
    'كنافه': 'kunafa',
    'كيك': 'cake',
    'تورتة': 'cake',
    'فطير': 'pastry',
    'شاي': 'tea-cup',
    'قهوة': 'turkish-coffee',
    'نسكافيه': 'coffee',
    'عصير': 'juice',
    'كرواسون': 'croissant',
    'بسبوسة': 'basbousa',
  };
  const cycle = ['kunafa', 'cake', 'pastry', 'tea-cup', 'juice', 'croissant', 'basbousa', 'turkish-coffee', 'coffee'];
  for (final e in byWord.entries) {
    final url = DemoTajer.asset(e.value);
    if (name.contains(e.key) && !taken.contains(url)) return url;
  }
  for (final c in cycle) {
    final url = DemoTajer.asset(c);
    if (!taken.contains(url)) return url;
  }
  return DemoTajer.asset(cycle.first);
}

extension _TajerBackend on DemoStore {
  String? get _uid => guest ? null : me;

  DemoRow _shop(String? id) => _firstWhere('shops', (s) => s['id'] == id) ?? (throw DemoError('المحل مش موجود'));

  DemoRow _myShop(String? id) {
    final s = _firstWhere('shops', (s) => s['id'] == id);
    if (s == null || s['owner_id'] != _uid) throw DemoError('المحل ده مش بتاعك');
    return s;
  }

  static const _codeChars = '23456789ABCDEFGHJKLMNPQRSTUVWXYZ';

  String _orderCode() {
    while (true) {
      final code = 'T${List.generate(7, (_) => _codeChars[_rand.nextInt(_codeChars.length)]).join()}';
      if (!t('shop_orders').any((o) => o['order_code'] == code)) return code;
    }
  }

  static String _money(num v) => v == v.roundToDouble() ? '${v.toInt()}' : v.toStringAsFixed(2);

  Object? _tajerRpc(String fn, Map<String, dynamic> p) {
    switch (fn) {
      case 'ensure_my_profile':
      case 'save_push_subscription':
        return null;

      case 'get_contact_phones':
        final ids = List<String>.from(p['p_user_ids'] as List? ?? const []);
        return [
          for (final id in ids)
            if (profileOf(id)?['phone'] != null) {'user_id': id, 'phone': profileOf(id)!['phone']},
        ];

      // ---- 0047: register a shop, count visits ----
      case 'create_my_shop':
        if (_uid == null) throw DemoError('يجب تسجيل الدخول أولاً');
        final name = (p['p_name'] as String? ?? '').trim();
        final slug = (p['p_slug'] as String? ?? '').trim().toLowerCase();
        final phone = (p['p_whatsapp'] as String? ?? '').replaceAll(RegExp(r'\s'), '');
        if (name.length < 2) throw DemoError('اكتب اسم المحل');
        if (!RegExp(r'^[a-z0-9](?:[a-z0-9-]{1,38}[a-z0-9])$').hasMatch(slug)) {
          throw DemoError('اسم الرابط لازم يكون بالإنجليزي (حروف وأرقام وشرطة) من 3 لـ 40 حرف');
        }
        if (t('shops').any((s) => s['slug'] == slug)) throw DemoError('اسم الرابط ده مستخدم، جرّب اسم تاني');
        if (!RegExp(r'^01[0125][0-9]{8}$').hasMatch(phone)) throw DemoError('رقم الواتساب غير صحيح (مثال: 01012345678)');
        if (t('shops').where((s) => s['owner_id'] == _uid).length >= 3) throw DemoError('وصلت للحد الأقصى (3 محلات لكل حساب)');
        final id = newId();
        final address = (p['p_address'] as String? ?? '').trim();
        t('shops').add({
          'id': id,
          'owner_id': _uid,
          'source': 'claimed',
          'name': name,
          'category': p['p_category'],
          'description': null,
          'address': address.isEmpty ? null : address,
          'slug': slug,
          'whatsapp': phone,
          'is_claimed': true,
          'claimed_at': DemoStore.nowIso(),
          'scan_count': 0,
          'cover_image_url': null,
          'logo_url': null,
          'lat': null,
          'lng': null,
          'delivery_fee': 0,
          'free_delivery_over': null,
          'created_at': DemoStore.nowIso(),
        });
        return id;

      case 'record_shop_scan':
        final slug = (p['p_slug'] as String? ?? '').toLowerCase();
        for (final s in t('shops').where((s) => s['slug'] == slug)) {
          s['scan_count'] = ((s['scan_count'] as num?) ?? 0) + 1;
        }
        return null;

      // ---- 0054 / 0057: store profile, delivery, stats ----
      case 'update_my_shop_profile':
        final name = (p['p_name'] as String? ?? '').trim();
        if (name.length < 2) throw DemoError('اكتب اسم المحل');
        final s = _myShop(p['p_shop_id'] as String?);
        String? blank(Object? v) {
          final x = (v as String? ?? '').trim();
          return x.isEmpty ? null : x;
        }
        s['name'] = name.length > 80 ? name.substring(0, 80) : name;
        s['description'] = blank(p['p_description']);
        s['logo_url'] = blank(p['p_logo_url']);
        s['cover_image_url'] = blank(p['p_cover_url']);
        return null;

      case 'set_my_shop_delivery':
        final fee = p['p_fee'] as num?;
        final freeOver = p['p_free_over'] as num?;
        if (fee == null || fee < 0 || fee > 1000) throw DemoError('قيمة التوصيل لازم تكون من 0 لـ 1000 جنيه');
        if (freeOver != null && freeOver <= 0) throw DemoError('حد التوصيل المجاني لازم يكون أكبر من صفر');
        final s = _myShop(p['p_shop_id'] as String?);
        s['delivery_fee'] = (fee * 100).round() / 100;
        s['free_delivery_over'] = freeOver;
        return null;

      case 'my_shop_stats':
        final s = _myShop(p['p_shop_id'] as String?);
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);
        final monthAgo = now.subtract(const Duration(days: 30));
        final orders = t('shop_orders').where((o) => o['shop_id'] == s['id'] && o['status'] != 'cart').toList();
        DateTime at(DemoRow o) => DateTime.parse(o['created_at'] as String).toLocal();
        final live = orders.where((o) => o['status'] != 'cancelled');
        final recent = live.where((o) => at(o).isAfter(monthAgo)).toList();
        final recentIds = recent.map((o) => o['id']).toSet();
        final sold = <String, int>{};
        for (final it in t('shop_order_items').where((i) => recentIds.contains(i['order_id']))) {
          final name = _firstWhere('shop_products', (x) => x['id'] == it['product_id'])?['name'] as String?;
          if (name != null) sold[name] = (sold[name] ?? 0) + (it['quantity'] as num).toInt();
        }
        final top = sold.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
        num sum(Iterable<DemoRow> rows) => rows.fold<num>(0, (a, o) => a + (o['total_amount'] as num));
        return {
          'visits': s['scan_count'] ?? 0,
          'new_orders': orders.where((o) => o['status'] == 'placed').length,
          'orders_today': orders.where((o) => !at(o).isBefore(today)).length,
          'sales_today': sum(live.where((o) => !at(o).isBefore(today))),
          'sales_30d': sum(recent),
          'orders_30d': recent.length,
          'products': t('shop_products').where((x) => x['shop_id'] == s['id']).length,
          'top_products': [
            for (final e in top.take(5)) {'name': e.key, 'sold': e.value},
          ],
        };

      // ---- 0054 / 0057: guest checkout & tracking ----
      case 'place_store_order':
        var phone = (p['p_customer_phone'] as String? ?? '').replaceAll(RegExp(r'[^0-9]'), '');
        if (RegExp(r'^201[0125][0-9]{8}$').hasMatch(phone)) phone = phone.substring(1);
        final name = (p['p_customer_name'] as String? ?? '').trim();
        final address = (p['p_address'] as String? ?? '').trim();
        final shop = _firstWhere('shops', (s) => s['id'] == p['p_shop_id']);
        if (shop == null || shop['owner_id'] == null) throw DemoError('المحل ده مش مستقبل طلبات حالياً');
        if (_uid != null && shop['owner_id'] == _uid) throw DemoError('مينفعش تطلب من محلك');
        if (name.length < 2) throw DemoError('اكتب اسمك');
        if (!RegExp(r'^01[0125][0-9]{8}$').hasMatch(phone)) throw DemoError('اكتب رقم موبايل صحيح (مثال: 01012345678)');
        if (address.length < 8) throw DemoError('اكتب العنوان بالتفصيل عشان الطلب يوصلك');
        final lines = p['p_items'] as List? ?? const [];
        if (lines.isEmpty) throw DemoError('السلة فاضية');
        if (lines.length > 50) throw DemoError('الطلب فيه منتجات كتير، قسّمه على أكتر من طلب');
        // (The real server also rate-limits by phone — left out so the
        // same sample customer can be recorded again and again.)
        final pending = <(DemoRow, int, String?)>[];
        for (final raw in lines) {
          final line = Map<String, dynamic>.from(raw as Map);
          final qty = (line['quantity'] as num?)?.toInt() ?? 0;
          if (qty < 1 || qty > 99) throw DemoError('الكمية غير صحيحة');
          final product = _firstWhere('shop_products', (x) => x['id'] == line['product_id'] && x['shop_id'] == shop['id'] && x['is_available'] == true);
          if (product == null) throw DemoError('فيه منتج في السلة مبقاش متاح، حدّث الصفحة');
          final already = pending.where((e) => e.$1 == product).fold<int>(0, (a, e) => a + e.$2);
          final stock = product['stock'] as num?;
          if (stock != null && stock < already + qty) throw DemoError('الكمية المتاحة من «${product['name']}» هي ${stock.toInt()} بس');
          final opts = (line['options'] as String? ?? '').trim();
          pending.add((product, qty, opts.isEmpty ? null : opts));
        }
        final orderId = newId();
        final code = _orderCode();
        num subtotal = 0;
        var count = 0;
        for (final (product, qty, opts) in pending) {
          if (product['stock'] != null) product['stock'] = (product['stock'] as num).toInt() - qty;
          t('shop_order_items').add({
            'id': newId(),
            'order_id': orderId,
            'product_id': product['id'],
            'quantity': qty,
            'unit_price': product['price'],
            'chosen_options': opts,
            'created_at': DemoStore.nowIso(),
          });
          subtotal += (product['price'] as num) * qty;
          count += qty;
        }
        final freeOver = shop['free_delivery_over'] as num?;
        final delivery = freeOver != null && subtotal >= freeOver ? 0 : ((shop['delivery_fee'] as num?) ?? 0);
        final note = (p['p_note'] as String? ?? '').trim();
        t('shop_orders').add({
          'id': orderId,
          'shop_id': shop['id'],
          'buyer_id': _uid,
          'status': 'placed',
          'total_amount': subtotal + delivery,
          'delivery_fee': delivery,
          'customer_name': name,
          'customer_phone': phone,
          'delivery_address': address,
          'note': note.isEmpty ? null : note,
          'order_code': code,
          'created_at': DemoStore.nowIso(),
        });
        _notify(
          [shop['owner_id'] as String],
          '🛒 طلب جديد $code — ${shop['name']}',
          '$name طلب $count منتج بإجمالي ${_money(subtotal + delivery)} ج.م (شامل التوصيل). افتح «الطلبات» في متجري.',
          '/#/',
        );
        return code;

      case 'get_store_order':
        final code = (p['p_code'] as String? ?? '').trim().toUpperCase();
        final o = _firstWhere('shop_orders', (x) => x['order_code'] == code);
        if (o == null) return null;
        final shop = _shop(o['shop_id'] as String);
        return {
          'code': o['order_code'],
          'status': o['status'],
          'total': o['total_amount'],
          'delivery_fee': o['delivery_fee'],
          'created_at': o['created_at'],
          'customer_name': o['customer_name'],
          'shop_name': shop['name'],
          'shop_slug': shop['slug'],
          'shop_whatsapp': shop['whatsapp'],
          'items': [
            for (final i in t('shop_order_items').where((i) => i['order_id'] == o['id']))
              {
                'name': _firstWhere('shop_products', (x) => x['id'] == i['product_id'])?['name'],
                'quantity': i['quantity'],
                'price': i['unit_price'],
                'options': i['chosen_options'],
              },
          ],
        };

      // ---- 0068: order status ----
      case 'update_shop_order_status':
        if (_uid == null) throw DemoError('يجب تسجيل الدخول أولاً');
        final o = _firstWhere('shop_orders', (x) => x['id'] == p['p_order_id']) ?? (throw DemoError('الطلب غير موجود'));
        final shop = _shop(o['shop_id'] as String);
        final status = p['p_status'] as String?;
        final from = o['status'];
        if (shop['owner_id'] == _uid) {
          final ok =
              (from == 'placed' && const ['preparing', 'cancelled'].contains(status)) ||
              (from == 'preparing' && const ['delivering', 'delivered', 'cancelled'].contains(status)) ||
              (from == 'delivering' && const ['delivered', 'cancelled'].contains(status));
          if (!ok) throw DemoError('مينفعش تغيّر حالة الطلب بالشكل ده');
        } else if (o['buyer_id'] == _uid) {
          if (!(from == 'placed' && status == 'cancelled')) throw DemoError('تقدر تلغي الطلب بس قبل ما المحل يبدأ يجهّزه');
        } else {
          throw DemoError('غير مصرح لك');
        }
        o['status'] = status;
        return null;

      // ---- 0048 / 0049 / 0052 / 0074: digital addresses ----
      case 'get_e_address':
        final raw = (p['p_code'] as String? ?? '').trim();
        var digits = raw.replaceAll(RegExp(r'[^0-9]'), '');
        var code = raw.replaceAll(RegExp(r'[^A-Za-z0-9]'), '').toUpperCase();
        DemoRow? a;
        if (RegExp(r'^[+0-9 -]+$').hasMatch(raw)) {
          if (RegExp(r'^201[0125][0-9]{8}$').hasMatch(digits)) digits = digits.substring(1);
          if (RegExp(r'^01[0125][0-9]{8}$').hasMatch(digits)) {
            a = _firstWhere('e_addresses', (x) {
              final owner = profileOf(x['owner_id'] as String?);
              return owner?['phone'] == digits && owner?['phone_verified_at'] != null && x['phone_lookup'] == true && x['is_active'] == true;
            });
          }
        }
        if (a == null) {
          if (code.startsWith('MG') && code.length == 10) code = code.substring(2);
          if (code.length == 8) a = _firstWhere('e_addresses', (x) => x['code'] == code && x['is_active'] == true);
        }
        a ??= _firstWhere('e_addresses', (x) => x['handle'] == raw.toLowerCase() && x['is_active'] == true);
        if (a == null) return null;
        a['scan_count'] = ((a['scan_count'] as num?) ?? 0) + 1;
        t('e_address_views').add({'id': newId(), 'address_id': a['id'], 'viewer_id': _uid, 'viewed_at': DemoStore.nowIso()});
        final owner = profileOf(a['owner_id'] as String?);
        return {
          for (final k in ['code', 'handle', 'label', 'governorate', 'city', 'district', 'street', 'building', 'floor', 'apartment', 'landmark', 'notes', 'lat', 'lng']) k: a[k],
          'owner_name': a['show_name'] == true ? (owner?['full_name']) : null,
          'owner_phone': a['show_phone'] == true ? (owner?['phone']) : null,
        };
    }
    throw DemoError('الخاصية دي مش متاحة في النسخة التجريبية', 404);
  }
}
