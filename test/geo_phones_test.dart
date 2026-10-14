import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mogtama3y/core/geo/arab_countries.dart';
import 'package:mogtama3y/core/geo/money.dart';
import 'package:mogtama3y/core/geo/phones.dart';
import 'package:mogtama3y/core/geo/user_country.dart';
import 'package:mogtama3y/core/geo/world_time.dart';
import 'package:mogtama3y/features/shared/phone_field.dart';

void main() {
  tearDown(() => debugDeviceTimeZone = null);

  group('the 22 Arab states', () {
    test('every state is there once, with a dial code, currency, zone and a valid sample', () {
      const isos = ['EG', 'SA', 'AE', 'KW', 'QA', 'BH', 'OM', 'YE', 'JO', 'PS', 'LB', 'SY', 'IQ', 'SD', 'LY', 'TN', 'DZ', 'MA', 'MR', 'SO', 'DJ', 'KM'];
      expect(arabCountries.map((c) => c.iso).toList()..sort(), [...isos]..sort());
      for (final c in arabCountries) {
        expect(c.dial, matches(RegExp(r'^[1-9]\d{1,2}$')), reason: c.iso);
        expect(c.currency, matches(RegExp(r'^[A-Z]{3}$')), reason: c.iso);
        expect(normalizePhone(c.example, country: c.iso), isNotNull, reason: '${c.iso} sample ${c.example}');
        expect(phoneCountry(normalizePhone(c.example, country: c.iso)), c.iso, reason: c.iso);
        expect(countryOfTimeZone(c.tz), c.iso, reason: c.tz);
      }
      expect(arabCountry('sa')?.nameAr, 'السعودية');
      expect(arabCountry('FR'), isNull);
      expect(egypt.flag, '🇪🇬');
    });
  });

  group('normalizePhone', () {
    test('Egypt: local, +20, 0020, 20…, Arabic digits, spaces', () {
      for (final raw in ['01012345678', '+20 101 234 5678', '0020-1012345678', '201012345678', '٠١٠١٢٣٤٥٦٧٨', '۰۱۰۱۲۳۴۵۶۷۸', '+20 01012345678']) {
        expect(normalizePhone(raw), '+201012345678', reason: raw);
      }
      expect(normalizePhone('01312345678'), isNull); // no 013 operator
      expect(normalizePhone('0225551234'), isNull); // landline
    });

    test('other countries: local in the given country, and international anywhere', () {
      expect(normalizePhone('0512345678', country: 'SA'), '+966512345678');
      expect(normalizePhone('+966 51 234 5678', country: 'EG'), '+966512345678');
      expect(normalizePhone('966512345678'), '+966512345678');
      expect(normalizePhone('050-123-4567', country: 'AE'), '+971501234567');
      expect(normalizePhone('00971501234567'), '+971501234567');
      expect(normalizePhone('51234567', country: 'KW'), '+96551234567');
      expect(normalizePhone('0612345678', country: 'MA'), '+212612345678');
      expect(normalizePhone('07712345678', country: 'IQ'), '+9647712345678');
      expect(normalizePhone('0791234567', country: 'JO'), '+962791234567');
      expect(normalizePhone('03 123 456', country: 'LB'), '+9613123456');
      expect(normalizePhone('+44 7700 900123'), '+447700900123'); // diaspora numbers pass
    });

    test('junk is refused', () {
      expect(normalizePhone(null), isNull);
      expect(normalizePhone(''), isNull);
      expect(normalizePhone('12345'), isNull);
      expect(normalizePhone('0512345678', country: 'EG'), isNull);
      expect(normalizePhone('+96651234567'), isNull); // one digit short
      expect(normalizePhone('call 01012345678'), isNull);
    });

    test('stored form: 01… for Egypt, E.164 for the rest', () {
      expect(storePhone('+201012345678'), '01012345678');
      expect(storePhone('0512345678', country: 'SA'), '+966512345678');
      expect(canonicalPhone('01012345678'), '01012345678');
      expect(canonicalPhone('+971501234567'), '+971501234567');
      expect(isEgyptianPhone('01012345678'), isTrue);
      expect(isEgyptianPhone('+971501234567'), isFalse);
    });
  });

  group('WhatsApp / tel / display', () {
    test('waLink', () {
      expect(waLink('01012345678').toString(), 'https://wa.me/201012345678');
      expect(waLink('+966512345678', text: 'سلام').toString(), 'https://wa.me/966512345678?text=${Uri.encodeComponent('سلام')}');
      expect(waDigits('010 1234 5678'), '201012345678');
      expect(waDigits('01999'), '01999'); // old free text: its digits
      expect(waLink(null, text: 'x').toString(), 'https://wa.me/?text=x');
    });

    test('tel and display', () {
      expect(telLink('0512345678', country: 'SA').toString(), 'tel:+966512345678');
      expect(displayPhone('01012345678'), '01012345678');
      expect(displayPhone('+971501234567'), '+971 501234567');
      expect(splitPhone('+966512345678'), (country: 'SA', national: '0512345678'));
      expect(splitPhone('+96551234567'), (country: 'KW', national: '51234567'));
      expect(phoneHint('SA'), '0512345678');
      expect(intlPhoneHint('AE'), '+971501234567');
      expect(intlPhoneHint('EG'), '01xxxxxxxxx');
    });
  });

  group('money', () {
    test('currency labels, decimals, grouping', () {
      expect(money(150), '150 ج.م');
      expect(money(1250.5, 'AED'), '1,250.5 د.إ');
      expect(money(3.1256, 'KWD'), '3.126 د.ك');
      expect(money(1000000, 'SAR'), '1,000,000 ر.س');
      expect(money(-20, 'MAD'), '-20 د.م');
      expect(money(10, 'XYZ'), '10 XYZ');
    });
  });

  group('country guess', () {
    test('phone dial code → zone → location → Egypt', () {
      expect(guessCountry(phone: '+971501234567', timeZone: 'Africa/Cairo'), 'AE');
      expect(guessCountry(timeZone: 'Asia/Riyadh'), 'SA');
      expect(guessCountry(timeZone: 'Europe/London', locationCountry: 'ma'), 'MA');
      expect(guessCountry(timeZone: 'Europe/London'), 'EG');
    });
  });

  testWidgets('PhoneFormField: dial prefix, country hint, validation, stored value', (tester) async {
    final c = PhoneController(phone: '+966512345678');
    final key = GlobalKey<FormState>();
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(body: Form(key: key, child: PhoneFormField(controller: c, labelText: 'الموبايل'))),
    ));
    expect(find.text('+966'), findsOneWidget);
    expect(c.text, '0512345678');
    expect(c.stored, '+966512345678');
    await tester.enterText(find.byType(TextFormField), '12');
    expect(key.currentState!.validate(), isFalse);
    await tester.pump();
    expect(find.text(invalidPhoneMessage), findsOneWidget);
    c.country.value = 'EG';
    await tester.pump();
    expect(find.text('+20'), findsOneWidget);
    await tester.enterText(find.byType(TextFormField), '01012345678');
    expect(key.currentState!.validate(), isTrue);
    expect(c.stored, '01012345678');
  });
}
