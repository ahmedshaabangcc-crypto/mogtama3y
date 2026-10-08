import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mogtama3y/core/demo/demo_http_client.dart';
import 'package:mogtama3y/core/demo/demo_links.dart';
import 'package:mogtama3y/core/demo/demo_mode.dart';
import 'package:mogtama3y/core/demo/demo_store.dart';
import 'package:mogtama3y/core/shops/store_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// The merchant app's (متجري) side of the local demo build's fake backend,
/// driven through the real Supabase client like StoreService does.
void main() {
  SupabaseClient clientOf(DemoStore store) => SupabaseClient('http://demo.invalid', 'demo-key', httpClient: DemoHttpClient(store));

  DemoStore boot(String role) => DemoStore.boot(role: role, flavor: 'tajer', persist: false);

  final shopId = DemoTajer.shopId;
  final orderLines = '*, items:shop_order_items(quantity, unit_price, chosen_options, product:shop_products(name))';

  test('tajer roles', () {
    expect(tajerDemoRoles, ['merchant', 'new', 'customer']);
    expect(demoRoleFrom(Uri.parse('http://localhost:8739/'), tajer: true), 'merchant');
    expect(demoRoleFrom(Uri.parse('http://localhost:8739/?role=customer'), tajer: true), 'customer');
    expect(demoRoleFrom(Uri.parse('http://localhost:8739/?role=president'), tajer: true), 'merchant');
    expect(boot('customer').guest, isTrue);
    expect(boot('merchant').guest, isFalse);
  });

  test('the demo shop: 6 local photos, orders in every status, stats', () async {
    final store = boot('merchant');
    final c = clientOf(store);
    final shops = await c.from('shops').select('id, name, slug, whatsapp, delivery_fee').eq('owner_id', DemoTajer.uMerchant);
    expect((shops as List).single['slug'], demoShopSlug);
    expect(shops.single['name'], 'محل بيت الشاي — تجريبي');

    final products = List<Map<String, dynamic>>.from(await c.from('shop_products').select().eq('shop_id', shopId).eq('is_available', true).order('created_at', ascending: false) as List);
    expect(products.length, 6);
    for (final p in products) {
      final url = StoreService.imagesOf(p).single;
      expect(url, endsWith('.jpg'));
      expect(url, isNot(contains('mogtama3y.com')));
      expect(url, contains('/catalog/'));
    }

    final orders = List<Map<String, dynamic>>.from(await c.from('shop_orders').select(orderLines).eq('shop_id', shopId).neq('status', 'cart').order('created_at', ascending: false).limit(100) as List);
    expect(orders.map((o) => o['status']).toSet(), containsAll(['placed', 'preparing', 'delivering', 'delivered', 'cancelled']));
    final first = orders.first;
    expect(first['order_code'], DemoTajer.orderPlaced);
    expect((first['items'] as List).first['product']['name'], 'شاي بالنعناع');
    expect(first['delivery_address'], contains('/#/a/${DemoTajer.monaAddress}'));

    final stats = Map<String, dynamic>.from(await c.rpc('my_shop_stats', params: {'p_shop_id': shopId}) as Map);
    expect(stats['new_orders'], 2);
    expect(stats['products'], 6);
    expect(stats['sales_today'], greaterThan(0));
    expect((stats['top_products'] as List), isNotEmpty);
    // Only the owner sees the numbers.
    expect(() => clientOf(store.asRole('new')).rpc('my_shop_stats', params: {'p_shop_id': shopId}), throwsA(isA<PostgrestException>()));
  });

  test('a guest customer orders, the merchant moves it along, tracking follows', () async {
    final customer = clientOf(boot('customer'));
    final shop = await customer.from('shops').select('id, name, whatsapp, owner_id, delivery_fee, free_delivery_over').eq('slug', demoShopSlug).maybeSingle();
    expect(shop!['owner_id'], DemoTajer.uMerchant);
    final juice = DemoTajer.productId(4);
    final code = await customer.rpc(
      'place_store_order',
      params: {
        'p_shop_id': shopId,
        'p_items': [
          {'product_id': juice, 'quantity': 2, 'options': ''},
          {'product_id': DemoTajer.productId(2), 'quantity': 1, 'options': 'الحجم: مظبوط'},
        ],
        'p_customer_name': DemoTajer.sampleCustomerName,
        'p_customer_phone': '+20 100 000 0307',
        'p_address': DemoTajer.sampleCustomerAddress,
        'p_note': null,
      },
    ) as String;
    expect(RegExp(r'^T[0-9A-Z]{7}$').hasMatch(code), isTrue);
    final tracked = Map<String, dynamic>.from(await customer.rpc('get_store_order', params: {'p_code': code.toLowerCase()}) as Map);
    expect(tracked['status'], 'placed');
    expect(tracked['total'], 2 * 30 + 20 + 15); // + delivery (under 200)
    expect(tracked['shop_whatsapp'], DemoTajer.shopWhatsapp);
    expect(DemoStore.instance.t('shop_products').firstWhere((p) => p['id'] == juice)['stock'], 10);

    // Bad input is refused like the server does.
    expect(
      () => customer.rpc('place_store_order', params: {'p_shop_id': shopId, 'p_items': [], 'p_customer_name': 'س', 'p_customer_phone': '0100', 'p_address': 'x', 'p_note': null}),
      throwsA(isA<PostgrestException>()),
    );

    // Role switch: the merchant sees it and works on it.
    final merchant = clientOf(DemoStore.instance.asRole('merchant'));
    final orders = await merchant.from('shop_orders').select(orderLines).eq('shop_id', shopId).neq('status', 'cart').order('created_at', ascending: false).limit(100);
    final mine = (orders as List).firstWhere((o) => o['order_code'] == code);
    expect(mine['customer_name'], DemoTajer.sampleCustomerName);
    expect(mine['customer_phone'], DemoTajer.sampleCustomerPhone);
    expect((mine['items'] as List).length, 2);
    expect(() => merchant.rpc('update_shop_order_status', params: {'p_order_id': mine['id'], 'p_status': 'delivered'}), throwsA(isA<PostgrestException>()));
    await merchant.rpc('update_shop_order_status', params: {'p_order_id': mine['id'], 'p_status': 'preparing'});
    await merchant.rpc('update_shop_order_status', params: {'p_order_id': mine['id'], 'p_status': 'delivering'});
    expect(DemoStore.instance.t('notifications').any((n) => n['user_id'] == DemoTajer.uMerchant && '${n['title']}'.contains(code)), isTrue);

    final again = clientOf(DemoStore.instance.asRole('customer'));
    expect((await again.rpc('get_store_order', params: {'p_code': code}) as Map)['status'], 'delivering');
    // The merchant can't order from their own shop.
    expect(
      () => merchant.rpc('place_store_order', params: {
        'p_shop_id': shopId,
        'p_items': [{'product_id': juice, 'quantity': 1, 'options': ''}],
        'p_customer_name': 'حسن',
        'p_customer_phone': '01000000201',
        'p_address': 'عنوان طويل كفاية',
        'p_note': null,
      }),
      throwsA(isA<PostgrestException>()),
    );
  });

  test('a new merchant opens a shop from scratch and adds a product', () async {
    final store = boot('new');
    final c = clientOf(store);
    expect(await c.from('shops').select().eq('owner_id', DemoTajer.uNewMerchant), isEmpty);
    Future<Object?> create(String slug) =>
        c.rpc('create_my_shop', params: {'p_name': 'كنافة أم علي', 'p_category': 'حلويات ومخبوزات', 'p_slug': slug, 'p_whatsapp': '010 0000 0202', 'p_address': 'المعادي'});
    expect(() => create(demoShopSlug), throwsA(isA<PostgrestException>())); // taken
    expect(() => create('-x'), throwsA(isA<PostgrestException>()));
    final id = await create('konafa-om-ali') as String;
    await c.rpc('set_my_shop_delivery', params: {'p_shop_id': id, 'p_fee': 20, 'p_free_over': 300});
    await c.rpc('update_my_shop_profile', params: {'p_shop_id': id, 'p_name': 'كنافة أم علي', 'p_description': 'كنافة بيتي', 'p_logo_url': null, 'p_cover_url': demoSamplePhoto(name: 'كنافة')});
    final shop = (await c.from('shops').select('*').eq('owner_id', DemoTajer.uNewMerchant) as List).single;
    expect(shop['slug'], 'konafa-om-ali');
    expect(shop['whatsapp'], '01000000202');
    expect(shop['delivery_fee'], 20);
    expect(shop['cover_image_url'], endsWith('/catalog/kunafa.jpg'));

    await c.from('shop_products').insert({'shop_id': id, 'name': 'كنافة بالقشطة', 'price': 60, 'images': [demoSamplePhoto(name: 'كنافة')], 'is_available': true});
    final products = await c.from('shop_products').select().eq('shop_id', id);
    expect((products as List).single['options'], isEmpty);
    expect(await c.from('shops').select('id').eq('slug', 'konafa-om-ali').maybeSingle(), isNotNull);
  });

  test('a seeded product with orders can only be hidden', () async {
    final c = clientOf(boot('merchant'));
    expect(() => c.from('shop_products').delete().eq('id', DemoTajer.productId(1)), throwsA(isA<PostgrestException>()));
  });

  test('the merchant opens a customer digital address by name, mobile or code', () async {
    final c = clientOf(boot('merchant'));
    final byName = Map<String, dynamic>.from(await c.rpc('get_e_address', params: {'p_code': DemoTajer.monaAddress}) as Map);
    expect(byName['owner_name'], 'منى عادل');
    expect(byName['lat'], isNotNull);
    expect((await c.rpc('get_e_address', params: {'p_code': '01000000301'}) as Map)['handle'], DemoTajer.monaAddress);
    expect((await c.rpc('get_e_address', params: {'p_code': 'MG-R4T8-W2NB'}) as Map)['handle'], DemoTajer.salmaAddress);
    expect(await c.rpc('get_e_address', params: {'p_code': 'nobody-here'}), isNull);
    // Other people's saved addresses stay private.
    expect(await c.from('e_addresses').select(), isEmpty);
  });

  test('canned AI copy and local sample photos', () {
    final copy = demoProductCopy(name: 'كنافة بالقشطة');
    expect(copy.description, contains('كنافة'));
    expect(copy.highlights, isNotEmpty);
    expect(demoProductCopy().name, isNotEmpty);
    final first = demoSamplePhoto(name: 'شاي');
    expect(first, endsWith('/catalog/tea-cup.jpg'));
    expect(demoSamplePhoto(name: 'شاي', taken: [first]), isNot(first));
  });

  test('links: own pages open locally, the rest stay in a dialog', () {
    expect(demoLocalPath(Uri.parse('https://mogtama3y.com/#/s/$demoShopSlug')), '/s/$demoShopSlug');
    expect(demoLocalPath(Uri.parse('https://mogtama3y.com/#/o/${DemoTajer.orderPlaced}')), '/o/${DemoTajer.orderPlaced}');
    expect(demoLocalPath(Uri.parse('https://wa.me/201000000201?text=x')), isNull);
    expect(demoLocalPath(Uri.parse('https://evil.example/#/s/$demoShopSlug')), isNull);
  });

  testWidgets('the WhatsApp dialog shows the exact message, the map card draws', (tester) async {
    const message = 'أهلاً محل بيت الشاي\nرقم الطلب: T7K4M2QX';
    final uri = Uri.parse('https://wa.me/201000000201?text=${Uri.encodeComponent(message)}');
    await tester.pumpWidget(MaterialApp(home: Directionality(textDirection: TextDirection.rtl, child: Scaffold(body: DemoLinkDialog(uri: uri)))));
    expect(find.text('01000000201'), findsOneWidget);
    expect(find.text(message), findsOneWidget);
    final maps = Uri.parse('https://www.google.com/maps/dir/?api=1&destination=29.9602,31.2569');
    await tester.pumpWidget(MaterialApp(home: Directionality(textDirection: TextDirection.rtl, child: Scaffold(body: DemoLinkDialog(uri: maps)))));
    expect(find.byType(DemoMapCard), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
