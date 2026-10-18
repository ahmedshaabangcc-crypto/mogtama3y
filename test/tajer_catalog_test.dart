import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mogtama3y/core/demo/demo_store.dart';
import 'package:mogtama3y/core/shops/catalog.dart';
import 'package:mogtama3y/features/merchant/variants_editor.dart';
import 'package:mogtama3y/features/store/product_screen.dart';
import 'package:mogtama3y/features/store/store_cart.dart';

/// متجري catalog pro (0098): the variant matrix / CSV helpers, the
/// editor's variants card, the storefront's variant picker, and the demo
/// backend's variants / collections.
Widget _app(Widget child, {Size size = const Size(1200, 900)}) => MediaQuery(
      data: MediaQueryData(size: size),
      child: MaterialApp(
        locale: const Locale('ar'),
        supportedLocales: const [Locale('ar')],
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
        home: child,
      ),
    );

Map<String, dynamic> _tee() => {
      'id': 'p1',
      'name': 'تيشيرت',
      'price': 90,
      'stock': 7,
      'images': <String>[],
      'currency': 'SAR',
      'options': [
        {'name': 'المقاس', 'values': ['S', 'M']},
        {'name': 'اللون', 'values': ['أسود', 'أبيض']},
      ],
      'variants': [
        {'id': 'v1', 'option_values': ['S', 'أسود'], 'price': 100, 'compare_at_price': 130, 'stock': 5, 'position': 0, 'is_available': true},
        {'id': 'v2', 'option_values': ['S', 'أبيض'], 'price': 110, 'stock': 2, 'position': 1, 'is_available': true},
        {'id': 'v3', 'option_values': ['M', 'أسود'], 'price': 120, 'stock': 0, 'position': 2, 'is_available': true},
        {'id': 'v4', 'option_values': ['M', 'أبيض'], 'price': 90, 'stock': null, 'position': 3, 'is_available': true},
      ],
    };

void main() {
  group('catalog helpers', () {
    test('matrix, labels, ranges, stock, availability', () {
      final p = _tee();
      expect(optionsMatrix(productOptions(p)), [
        ['S', 'أسود'],
        ['S', 'أبيض'],
        ['M', 'أسود'],
        ['M', 'أبيض'],
      ]);
      expect(variantLabelOf(p, variantsOf(p).first), 'المقاس: S • اللون: أسود');
      expect(priceRange(p), (min: 90, max: 120));
      expect(stockTotal(p), isNull); // one unlimited variant
      expect(findVariant(p, {'المقاس': 'M', 'اللون': 'أسود'})?['id'], 'v3');
      // M + أسود is sold out: أسود is still possible with S, not with M.
      expect(valueAvailable(p, 1, 'أسود', {'المقاس': 'M'}), isFalse);
      expect(valueAvailable(p, 1, 'أسود', {'المقاس': 'S'}), isTrue);
      final shown = productWithVariant(p, variantsOf(p).first);
      expect(shown['price'], 100);
      expect(shown['old_price'], 130);
      expect(shown['variant_id'], 'v1');
      expect(youtubeId('https://youtu.be/dQw4w9WgXcQ'), 'dQw4w9WgXcQ');
      expect(youtubeId('https://vimeo.com/1'), isNull);
      expect(catalogSlugify('شاي بالنعناع  Big!'), 'شاي-بالنعناع-big');
    });

    test('currency decimals: 3 for KWD / BHD / OMR / JOD, else 2', () {
      expect(currencyDecimals('KWD'), 3);
      expect(currencyDecimals('omr'), 3);
      expect(currencyDecimals('USD'), 2);
      expect(currencyDecimals('SAR'), 2);
      expect(priceFitsCurrency(12.375, 'KWD'), isTrue);
      expect(priceFitsCurrency(12.375, 'EUR'), isFalse);
      expect(priceFitsCurrency(12.5, 'GBP'), isTrue);
    });

    test('CSV export → parse → import rows round-trip (BOM, quotes, currency, batches keep a product)', () {
      final p = {..._tee(), 'slug': 'tee', 'status': 'active', 'tags': ['قطن', 'صيفي'], 'description': 'خامة "ممتازة", ناعمة', 'images': ['https://x.test/1.jpg']};
      final csv = catalogCsv([p], [
        {'id': 'c1', 'name': 'تيشيرتات', 'rules': null, 'product_ids': ['p1']},
      ], currency: 'SAR');
      expect(csv.startsWith('﻿'), isTrue);
      final r = csvToImportRows(csv);
      expect(r.missing, isEmpty);
      expect(r.ignored, isEmpty);
      expect(r.rows.length, 4);
      expect(r.rows.first['handle'], 'tee');
      expect(r.rows.first['description'], 'خامة "ممتازة", ناعمة');
      expect(r.rows.first['collection'], 'تيشيرتات');
      expect(r.rows.first['option1_name'], 'المقاس');
      expect(r.rows[2]['option2_value'], 'أسود');
      expect(r.rows.first['currency'], 'SAR');
      expect(r.rows.first['_row'], '2');
      final template = csvToImportRows(catalogCsvTemplate(currency: 'KWD'));
      expect(template.rows.first['price'], '25.000');
      expect(template.rows.first['currency'], 'KWD');
      final rows = [
        for (var i = 0; i < 5; i++) {'handle': 'a', 'price': '1'},
        {'handle': 'b', 'price': '1'},
      ];
      final batches = importBatches(rows, size: 3);
      expect(batches.map((b) => b.length).toList(), [5, 1]);
    });
  });

  group('variants editor', () {
    testWidgets('options → the matrix; bulk price; validation', (tester) async {
      tester.view.physicalSize = const Size(1200, 1600);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      final model = VariantsModel()..defaultPrice = '50';
      await tester.pumpWidget(_app(Scaffold(body: SingleChildScrollView(child: VariantsEditor(model: model, images: const [], currencyLabel: 'ر.س')))));
      await tester.tap(find.byKey(const ValueKey('add-option')));
      await tester.pump();
      expect(model.options.single.name.text, 'المقاس');
      await tester.enterText(find.byKey(const ValueKey('option-input-0')), 'S، M');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();
      expect(model.variants.length, 2);
      await tester.tap(find.byKey(const ValueKey('add-option')));
      await tester.pump();
      await tester.enterText(find.byKey(const ValueKey('option-input-1')), 'أسود, أبيض');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();
      expect(model.options[1].name.text, 'اللون');
      expect(model.variants.length, 4);
      expect(find.text('4 نوع'), findsOneWidget);
      // New rows start at the product's price.
      expect(model.variants.every((v) => v.price.text == '50'), isTrue);

      // Edit one row, then bulk-set the price of all.
      await tester.enterText(find.byKey(ValueKey('vstock-${comboKey(['M', 'أبيض'])}')), '3');
      await tester.tap(find.byKey(const ValueKey('bulk-price')));
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(const ValueKey('ask-value')), '75');
      await tester.tap(find.byKey(const ValueKey('ask-ok')));
      await tester.pumpAndSettle();
      expect(model.variants.every((v) => v.price.text == '75'), isTrue);
      expect(model.validate(currency: 'SAR'), isNull);

      // Removing a value keeps the other rows (and what was typed in them).
      await tester.tap(find.descendant(of: find.byKey(const ValueKey('value-0-S')), matching: find.byTooltip('امسح')));
      await tester.pump();
      expect(model.variants.length, 2);
      expect(model.variants.firstWhere((v) => v.values.last == 'أبيض').stock.text, '3');
      final json = model.toJson();
      expect(json.first['option_values'], ['M', 'أسود']);
      expect(json.first['price'], 75);
      expect(json.last['stock'], 3);

      model.variants.first.compareAt.text = '10';
      expect(model.validate(currency: 'SAR'), contains('قبل الخصم'));
      model.variants.first.compareAt.text = '';
      model.variants.first.price.text = '1.255';
      expect(model.validate(currency: 'SAR'), isNotNull);
      expect(model.validate(currency: 'KWD'), isNull);
    });
  });

  group('storefront variant picker', () {
    testWidgets('picks switch the price / sold-out; the cart gets the variant', (tester) async {
      final cart = StoreCart();
      await tester.pumpWidget(_app(ProductScreen(shop: const {'id': 's', 'name': 'محل', 'currency': 'SAR'}, product: _tee(), cart: cart, canOrder: true), size: const Size(420, 900)));
      await tester.pump();
      // Nothing chosen: the lowest price «من».
      expect(find.textContaining('من'), findsWidgets);
      await tester.tap(find.byKey(const ValueKey('opt-المقاس-M')));
      await tester.pump();
      // M + أسود is sold out → its chip is crossed out.
      final black = tester.widget<Text>(find.descendant(of: find.byKey(const ValueKey('opt-اللون-أسود')), matching: find.byType(Text)));
      expect(black.style?.decoration, TextDecoration.lineThrough);
      await tester.tap(find.byKey(const ValueKey('opt-اللون-أبيض')));
      await tester.pump();
      final price = tester.widget<Text>(find.byKey(const ValueKey('product-price')));
      expect(price.data, contains('90'));
      await tester.tap(find.text('أضف للسلة'));
      await tester.pumpAndSettle();
      expect(cart.lines.single.variantId, 'v4');
      expect(cart.lines.single.unitPrice, 90);
      expect(cart.lines.single.variantLabel, 'المقاس: M • اللون: أبيض');
      expect(cart.toOrderLines().single['variant_id'], 'v4');
    });

    testWidgets('a sold-out variant can\'t be ordered', (tester) async {
      final cart = StoreCart();
      await tester.pumpWidget(_app(ProductScreen(shop: const {'id': 's', 'name': 'محل'}, product: _tee(), cart: cart, canOrder: true), size: const Size(420, 900)));
      await tester.tap(find.byKey(const ValueKey('opt-المقاس-M')));
      await tester.pump();
      await tester.tap(find.byKey(const ValueKey('opt-اللون-أسود')));
      await tester.pump();
      expect(find.text('النوع ده خلص'), findsOneWidget);
      expect(find.text('أضف للسلة'), findsNothing);
    });
  });

  group('demo backend', () {
    test('variants, collections, an order on a variant, restock on cancel, low stock', () {
      final store = DemoStore.boot(role: 'customer', flavor: 'tajer', persist: false);
      final cat = Map<String, dynamic>.from(store.rpc('store_catalog', {'p_shop': DemoTajer.shopId}) as Map);
      final products = List<Map<String, dynamic>>.from(cat['products'] as List);
      final nescafe = products.firstWhere((p) => p['id'] == DemoTajer.productId(3));
      expect(variantsOf(nescafe).length, 4);
      expect(stockTotal(nescafe), 15);
      final collections = List<Map<String, dynamic>>.from(cat['collections'] as List);
      expect(collections.map((c) => c['name']), containsAll(['مشروبات سخنة', 'عروض']));
      final deals = collections.firstWhere((c) => c['name'] == 'عروض');
      expect(deals['product_ids'], containsAll([DemoTajer.productId(2), DemoTajer.productId(6)]));

      final big = variantsOf(nescafe).firstWhere((v) => valuesOf(v).join() == 'كبيركامل الدسم');
      final mid = variantsOf(nescafe).firstWhere((v) => valuesOf(v).join() == 'وسطكامل الدسم');
      final code = store.rpc('place_store_order', {
        'p_shop_id': DemoTajer.shopId,
        'p_items': [
          {'product_id': nescafe['id'], 'variant_id': mid['id'], 'quantity': 5, 'options': 'x'},
        ],
        'p_customer_name': DemoTajer.sampleCustomerName,
        'p_customer_phone': DemoTajer.sampleCustomerPhone,
        'p_address': DemoTajer.sampleCustomerAddress,
      }) as String;
      final line = store.t('shop_order_items').lastWhere((i) => i['variant_id'] == mid['id']);
      expect(line['unit_price'], 25);
      expect(line['sku'], 'NS-M-F');
      expect(line['variant_label'], 'الحجم: وسط • اللبن: كامل الدسم');
      expect(store.t('shop_product_variants').firstWhere((v) => v['id'] == mid['id'])['stock'], 3);
      expect(store.t('notifications').any((n) => '${n['title']}'.contains('قرب يخلص')), isTrue);
      expect(
        () => store.rpc('place_store_order', {
          'p_shop_id': DemoTajer.shopId,
          'p_items': [
            {'product_id': nescafe['id'], 'variant_id': big['id'], 'quantity': 3},
          ],
          'p_customer_name': DemoTajer.sampleCustomerName,
          'p_customer_phone': DemoTajer.sampleCustomerPhone,
          'p_address': DemoTajer.sampleCustomerAddress,
        }),
        throwsA(isA<DemoError>()),
      );

      final merchant = store.asRole('merchant');
      final order = merchant.t('shop_orders').firstWhere((o) => o['order_code'] == code);
      merchant.rpc('merchant_cancel_order', {'p_order': order['id'], 'p_reason': 'تجربة'});
      expect(merchant.t('shop_product_variants').firstWhere((v) => v['id'] == mid['id'])['stock'], 8);
      final low = Map<String, dynamic>.from(merchant.rpc('merchant_low_stock', {'p_shop': DemoTajer.shopId}) as Map);
      expect((low['items'] as List).any((i) => i['variant_id'] == big['id']), isTrue);
    });

    test('save with variants, duplicate, bulk, CSV dry run writes nothing', () {
      final store = DemoStore.boot(role: 'merchant', flavor: 'tajer', persist: false);
      final id = store.rpc('merchant_save_product', {
        'p_shop': DemoTajer.shopId,
        'p_product': {'name': 'تيشيرت', 'status': 'active', 'options': [
          {'name': 'المقاس', 'values': ['S', 'M']},
        ]},
        'p_variants': [
          {'option_values': ['S'], 'price': 100, 'stock': 3},
          {'option_values': ['M'], 'price': 120, 'stock': 4},
        ],
        'p_collections': null,
      }) as String;
      final p = store.t('shop_products').firstWhere((x) => x['id'] == id);
      expect(p['price'], 100);
      expect(p['stock'], 7);
      expect(p['slug'], 'تيشيرت');
      expect(() => store.rpc('merchant_save_product', {
            'p_shop': DemoTajer.shopId,
            'p_product': {'name': 'x', 'status': 'active', 'options': [
              {'name': 'المقاس', 'values': ['S']},
            ]},
            'p_variants': [
              {'option_values': ['XL'], 'price': 1},
            ],
          }), throwsA(isA<DemoError>()));
      final copy = store.rpc('merchant_duplicate_product', {'p_product': id}) as String;
      expect(store.t('shop_products').firstWhere((x) => x['id'] == copy)['status'], 'draft');
      final bulk = Map<String, dynamic>.from(store.rpc('merchant_bulk_products', {
        'p_shop': DemoTajer.shopId,
        'p_ids': [id, DemoTajer.productId(4)],
        'p_action': 'price',
        'p_value': 33,
      }) as Map);
      expect(bulk['updated'], 1);
      expect(bulk['skipped'], 1);
      final before = store.t('shop_products').length;
      final dry = Map<String, dynamic>.from(store.rpc('merchant_import_products', {
        'p_shop': DemoTajer.shopId,
        'p_rows': [
          {'_row': '2', 'handle': 'cap', 'title': 'كاب', 'price': '80'},
          {'_row': '3', 'handle': 'bad', 'title': 'غلط', 'price': 'x'},
          {'_row': '4', 'handle': 'usd', 'title': 'دولار', 'price': '5', 'currency': 'USD'},
        ],
        'p_dry_run': true,
      }) as Map);
      expect(dry['created'], 1);
      expect(dry['failed'], 2);
      expect(store.t('shop_products').length, before);
    });
  });
}
