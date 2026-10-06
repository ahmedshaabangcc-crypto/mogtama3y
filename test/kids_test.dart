import 'package:flutter_test/flutter_test.dart';
import 'package:mogtama3y/core/kids/kids_service.dart';
import 'package:mogtama3y/core/routing/app_router.dart';

void main() {
  test('kids section and listing links open in the app', () {
    const id = '0f8fad5b-d9cb-469f-a165-70867728950e';
    expect(AppRoutes.kidsItem(id), '/kids/$id');
    expect(isInAppPath(AppRoutes.kids), isTrue);
    expect(isInAppPath(AppRoutes.kidsItem(id)), isTrue);
    expect(isInAppPath('/kids/not-an-id'), isFalse);
  });

  test('kids prices: giveaway vs sale', () {
    expect(kidsPrice({'is_free': true, 'price': null}), 'ببلاش');
    expect(kidsPrice({'is_free': false, 'price': 2500}), '2,500 ج.م');
  });

  test('filters count the sheet options only', () {
    const f = KidsFilters(category: 'toys', query: 'x', condition: 'new', freeOnly: true);
    expect(f.activeCount, 2);
    expect(f.copyWith(clearCategory: true).category, isNull);
  });
}
