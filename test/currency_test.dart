// Phase 2 of the Arab world (0092): every price is shown in its own
// currency — the listing's, the shop's, the building's — and Egyptian
// rows (no currency, or EGP) look exactly as before.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mogtama3y/core/cars/car_service.dart';
import 'package:mogtama3y/core/geo/money.dart';
import 'package:mogtama3y/core/geo/user_country.dart';
import 'package:mogtama3y/core/halls/hall_service.dart';
import 'package:mogtama3y/core/kids/kids_service.dart';
import 'package:mogtama3y/core/pets/pet_service.dart';
import 'package:mogtama3y/core/shops/store_service.dart';
import 'package:mogtama3y/core/tutoring/tutoring_service.dart';
import 'package:mogtama3y/core/union/union_service.dart';
import 'package:mogtama3y/features/cars/cars_market_screen.dart';
import 'package:mogtama3y/features/halls/halls_market_screen.dart';
import 'package:mogtama3y/features/kids/kids_market_screen.dart';
import 'package:mogtama3y/features/store/store_cart.dart';

void main() {
  group('row currency', () {
    test('a row without a currency is Egyptian', () {
      expect(currencyOf(null), 'EGP');
      expect(currencyOf({'price': 5}), 'EGP');
      expect(currencyOf({'currency': 'sar'}), 'SAR');
      expect(currencyOf({'currency': 'bogus'}), 'EGP');
      expect(moneyOf({'currency': 'AED'}, 1250.5), '1,250.5 د.إ');
      expect(moneyOf({}, 9000), '9,000 ج.م');
      expect(currencyLabelOf({'currency': 'KWD'}), 'د.ك');
    });

    test('caps scale up for small currencies, never down', () {
      expect(moneyCap(1000), 1000);
      expect(moneyCap(1000, 'KWD'), 1000);
      expect(moneyCap(1000, 'LBP'), 2000000);
      expect(moneyCap(100000, 'iqd'), 3000000);
    });

    test('the feed follows the user\'s country unless overridden', () {
      UserCountry.iso.value = 'SA';
      expect(UserCountry.feedCountry, 'SA');
      expect(UserCountry.currency, 'SAR');
      expect(UserCountry.currencyText, 'ر.س');
      UserCountry.feedOverride = 'EG';
      expect(UserCountry.feedCountry, 'EG');
      UserCountry.feedOverride = null;
      UserCountry.iso.value = 'EG';
      expect(UserCountry.currencyText, 'ج.م');
    });
  });

  group('section price labels', () {
    test('cars / tutors / halls / pets / kids in the listing currency', () {
      expect(carPrice(650000), '650,000 ج.م');
      expect(carPrice(85000, 'SAR'), '85,000 ر.س');
      expect(tutorPrice(250, 'session'), '250 ج.م / الحصة');
      expect(tutorPrice(12.5, 'month', 'KWD'), '12.5 د.ك / الشهر');
      expect(hallPrice({'price_from': 30000}), 'يبدأ من 30,000 ج.م');
      expect(hallPrice({'price_from': 450, 'price_per_person': true, 'currency': 'AED'}), 'يبدأ من 450 د.إ للفرد');
      expect(petPrice({'kind': 'sale', 'price': 2500}), '2,500 ج.م');
      expect(petPrice({'kind': 'sale', 'price': 900, 'currency': 'QAR'}), '900 ر.ق');
      expect(kidsPrice({'is_free': false, 'price': 40, 'currency': 'MAD'}), '40 د.م');
      expect(kidsPrice({'is_free': true, 'currency': 'MAD'}), 'ببلاش');
    });

    test('stores: the shop currency (was egp())', () {
      expect(shopMoney(89), '89 ج.م');
      expect(shopMoney(12.5, 'AED'), '12.5 د.إ');
      expect(StoreService.deliveryLabel({'delivery_fee': 25, 'free_delivery_over': 500}), 'التوصيل 25 ج.م • مجاني فوق 500 ج.م');
      expect(StoreService.deliveryLabel({'delivery_fee': 15, 'currency': 'AED'}), 'التوصيل 15 د.إ');
      expect(StoreService.deliveryLabel({'delivery_fee': 0, 'currency': 'AED'}), 'التوصيل مجاني');
    });

    test('union: the building currency', () {
      expect(buildingMoney(350), '350 ج.م');
      UnionService.buildingCurrency = 'KWD';
      expect(buildingMoney(12.5), '12.5 د.ك');
      expect(UnionService.buildingCurrencyText, 'د.ك');
      UnionService.buildingCurrency = 'EGP';
    });
  });

  group('cards', () {
    Future<void> pump(WidgetTester t, Widget child) =>
        t.pumpWidget(MaterialApp(
          home: Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(body: Center(child: SizedBox(width: 240, height: 360, child: child))),
          ),
        ));

    testWidgets('a Saudi car card shows «ر.س»', (t) async {
      await pump(t, CarCard(item: const {'title': 'كامري', 'price': 85000, 'offer_type': 'sale', 'currency': 'SAR', 'km': 120000}));
      expect(find.textContaining('85,000 ر.س'), findsOneWidget);
      expect(find.textContaining('120,000 كم'), findsOneWidget);
      expect(find.textContaining('ج.م'), findsNothing);
    });

    testWidgets('an Egyptian car card is unchanged', (t) async {
      await pump(t, CarCard(item: const {'title': 'لانسر', 'price': 650000, 'offer_type': 'sale'}));
      expect(find.textContaining('650,000 ج.م'), findsOneWidget);
    });

    testWidgets('a hall card in AED', (t) async {
      await pump(t, HallCard(item: const {'name': 'قاعة الماسة', 'price_from': 30000, 'currency': 'AED', 'hall_type': 'hall', 'capacity_max': 300}));
      expect(find.textContaining('يبدأ من 30,000 د.إ'), findsOneWidget);
    });

    testWidgets('a kids card in MAD', (t) async {
      await pump(t, KidsItemCard(item: const {'title': 'عربية أطفال', 'price': 400, 'currency': 'MAD', 'category': 'stroller', 'is_free': false}));
      expect(find.textContaining('400 د.م'), findsOneWidget);
    });
  });
}
