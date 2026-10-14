import 'package:flutter_test/flutter_test.dart';
import 'package:mogtama3y/core/geo/admin_areas.dart';
import 'package:mogtama3y/core/geo/arab_countries.dart';
import 'package:mogtama3y/core/geo/emergency_numbers.dart';
import 'package:mogtama3y/core/geo/user_country.dart';
import 'package:mogtama3y/core/reports/report_service.dart';

void main() {
  group('admin areas (0093)', () {
    test('every one of the 22 states has its divisions, no duplicates', () {
      for (final c in arabCountries) {
        final names = adminAreaNames(c.iso);
        expect(names, isNotEmpty, reason: c.iso);
        expect(names.toSet().length, names.length, reason: '${c.iso} has a duplicate');
        for (final a in adminAreasOf(c.iso)) {
          expect(a.lat, inInclusiveRange(-13, 38), reason: '${c.iso} ${a.name}');
          expect(a.lng, inInclusiveRange(-18, 61), reason: '${c.iso} ${a.name}');
        }
      }
      expect(adminAreaCountries.length, 22);
    });

    test("Egypt's list is exactly the old 27 governorates", () {
      final eg = adminAreaNames('EG');
      expect(eg.length, 27);
      expect(eg.first, 'القاهرة');
      expect(eg, containsAll(['الجيزة', 'الإسكندرية', 'الوادي الجديد', 'جنوب سيناء', 'شمال سيناء', 'مطروح']));
      expect(adminAreaNames(null), eg);
      expect(adminAreaNames('XX'), eg);
    });

    test('counts of a few states', () {
      expect(adminAreaNames('SA').length, 13);
      expect(adminAreaNames('AE').length, 7);
      expect(adminAreaNames('KW').length, 6);
      expect(adminAreaNames('JO').length, 12);
      expect(adminAreaNames('MA').length, 12);
      expect(adminAreaNames('TN').length, 24);
      expect(adminAreaNames('KM').length, 3);
    });

    test('governorateOf: Egypt unchanged', () {
      expect(governorateOf(30.0444, 31.2357), 'القاهرة');
      expect(governorateOf(30.06, 31.33), 'القاهرة'); // مدينة نصر
      expect(governorateOf(31.2, 29.9), 'الإسكندرية');
      expect(governorateOf(24.0889, 32.8998), 'أسوان');
      expect(governorateOf(27.25, 33.81), 'البحر الأحمر'); // الغردقة
    });

    test('governorateOf: the division inside the point\'s own country', () {
      expect(governorateOf(24.7136, 46.6753), 'الرياض');
      expect(governorateOf(21.54, 39.17), 'مكة المكرمة'); // جدة
      expect(governorateOf(26.42, 50.09), 'المنطقة الشرقية'); // الدمام
      expect(governorateOf(25.2048, 55.2708), 'دبي');
      expect(governorateOf(24.21, 55.74), 'أبوظبي'); // العين
      expect(governorateOf(25.35, 55.40), 'الشارقة');
      expect(governorateOf(29.37, 47.98), 'العاصمة'); // الكويت
      expect(governorateOf(31.95, 35.93), 'العاصمة'); // عمّان
      expect(governorateOf(33.57, -7.59), 'الدار البيضاء سطات');
      expect(governorateOf(33.31, 44.37), 'بغداد');
      expect(governorateOf(36.75, 3.06), 'الجزائر');
      expect(governorateOf(36.81, 10.18), 'تونس');
      expect(governorateOf(28.43, 45.97), 'المنطقة الشرقية'); // حفر الباطن (Iran's box overlaps)
    });

    test('arabCountryAt', () {
      expect(arabCountryAt(26.42, 50.09), 'SA'); // الدمام
      expect(arabCountryAt(30.04, 31.24), 'EG');
      expect(arabCountryAt(31.77, 35.23), 'PS');
      expect(arabCountryAt(51.5, -0.1), isNull);    });

    test('divisionAt with an explicit country', () {
      expect(divisionAt(24.71, 46.68, country: 'SA'), 'الرياض');
      // Unknown country → the point's country.
      expect(divisionAt(25.2, 55.27, country: 'ZZ'), 'دبي');
      // Outside the Arab world → Egypt's nearest (as before).
      expect(adminAreaNames('EG'), contains(divisionAt(51.5, -0.1)));
    });

    test('labels', () {
      expect(adminAreaLabel('EG'), 'المحافظة');
      expect(adminAreaLabel('SA'), 'المنطقة');
      expect(adminAreaLabel('AE'), 'الإمارة');
    });

    test('pickers follow the user / feed country', () {
      UserCountry.iso.value = 'SA';
      expect(myGovernorates, adminAreaNames('SA'));
      expect(reportGovernorates, adminAreaNames('SA'));
      UserCountry.feedOverride = 'AE';
      expect(reportGovernorates, adminAreaNames('AE'));
      expect(myGovernorates, adminAreaNames('SA'));
      UserCountry.feedOverride = 'SA'; // own country → no override
      expect(UserCountry.feedOverride, isNull);
      UserCountry.iso.value = 'EG';
      expect(reportGovernorates, adminAreaNames('EG'));
      expect(governoratesFor('JO'), adminAreaNames('JO'));
    });
  });

  group('emergency numbers (0093)', () {
    test('all 22 states are covered', () {
      for (final c in arabCountries) {
        expect(emergencyByCountry.containsKey(c.iso), isTrue, reason: c.iso);
        expect(emergencyLines(c.iso), isNotEmpty, reason: c.iso);
        for (final (_, n) in emergencyLines(c.iso)) {
          expect(RegExp(r'^\d{2,5}$').hasMatch(n), isTrue, reason: '${c.iso} $n');
        }
      }
    });

    test("Egypt's numbers and sentence are unchanged", () {
      final eg = emergencyNumbersOf('EG');
      expect([eg.police, eg.ambulance, eg.fire], ['122', '123', '180']);
      expect(emergencySentence('EG'), 'الإسعاف 123، النجدة 122، المطافئ 180، طوارئ الغاز 129');
      expect(emergencySentence(null), emergencySentence('EG'));
    });

    test('a few states', () {
      expect(emergencyNumbersOf('SA').ambulance, '997');
      expect(emergencyNumbersOf('SA').unified, '911');
      expect(emergencyNumbersOf('AE').police, '999');
      expect(emergencyNumbersOf('AE').ambulance, '998');
      expect(emergencyNumbersOf('KW').unified, '112');
      expect(emergencyNumbersOf('OM').unified, '9999');
      expect(emergencyNumbersOf('JO').unified, '911');
      expect(emergencyNumbersOf('MA').police, '19');
      expect(emergencyNumbersOf('TN').ambulance, '190');
      expect(emergencySentence('KW'), contains('112'));
    });

    test('unconfirmed states say so honestly', () {
      for (final iso in ['YE', 'SD', 'LY', 'SO', 'KM']) {
        expect(emergencyNumbersOf(iso).uncertain, isTrue, reason: iso);
        expect(emergencySentence(iso), contains('اتأكد'), reason: iso);
      }
      expect(emergencyNumbersOf('SA').uncertain, isFalse);
    });
  });
}
