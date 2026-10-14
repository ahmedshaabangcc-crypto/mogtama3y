// Phase 5 of the Arab world: copy that used to say «في مصر» names the
// user's country, and the Egypt-only payment features (wallet, top-ups,
// withdrawals, bills) show a clear note elsewhere — Egyptians see the app
// exactly as before.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mogtama3y/core/cars/car_service.dart';
import 'package:mogtama3y/core/geo/country_copy.dart';
import 'package:mogtama3y/core/geo/user_country.dart';
import 'package:mogtama3y/features/bills/bill_payment_hub_screen.dart';
import 'package:mogtama3y/features/wallet/wallet_region_note.dart';

void main() {
  tearDown(() => UserCountry.iso.value = 'EG');

  group('country names', () {
    test('names the country, Egypt for unknown codes', () {
      expect(countryNameAr('EG'), 'مصر');
      expect(countryNameAr('sa'), 'السعودية');
      expect(countryNameAr(null), 'مصر');
      expect(countryNameAr('FR'), 'مصر');
      expect(inCountryAr('MA'), 'في المغرب');
      expect(inCountryAr('EG'), 'في مصر');
    });
  });

  group('wallet is Egypt-only', () {
    test('available in Egypt only', () {
      expect(walletAvailableIn('EG'), isTrue);
      expect(walletAvailableIn('eg'), isTrue);
      expect(walletAvailableIn(null), isTrue);
      for (final iso in ['SA', 'AE', 'MA', 'IQ', 'KM']) {
        expect(walletAvailableIn(iso), isFalse, reason: iso);
      }
      expect(walletEgyptOnlyNote, contains('مصر بس حالياً'));
    });

    test('follows the user country', () {
      UserCountry.iso.value = 'EG';
      expect(walletAvailableHere, isTrue);
      UserCountry.iso.value = 'SA';
      expect(walletAvailableHere, isFalse);
    });

    testWidgets('bill payment shows the note outside Egypt', (tester) async {
      UserCountry.iso.value = 'AE';
      await tester.pumpWidget(const MaterialApp(home: BillPaymentHubScreen()));
      expect(find.text(walletEgyptOnlyNote), findsOneWidget);
      expect(find.text('سداد فوري وآمن بالتعاون مع فوري'), findsNothing);
    });

    testWidgets('bill payment is unchanged for Egyptians', (tester) async {
      UserCountry.iso.value = 'EG';
      await tester.pumpWidget(const MaterialApp(home: BillPaymentHubScreen()));
      expect(find.text(walletEgyptOnlyNote), findsNothing);
      expect(find.text('سداد فوري وآمن بالتعاون مع فوري'), findsOneWidget);
    });
  });

  test('car brands cover the Gulf too, Egyptian ones kept', () {
    expect(carBrands, contains('جي إم سي (GMC)'));
    expect(carBrands, contains('تويوتا (Toyota)'));
    expect(carBrands, contains('سبيرانزا (Speranza)'));
    expect(carBrands.last, 'أخرى');
    expect(carBrands.toSet().length, carBrands.length);
  });
}
