import 'package:flutter_test/flutter_test.dart';
import 'package:mogtama3y/core/masjid/masjid_service.dart';
import 'package:mogtama3y/core/routing/app_router.dart';

void main() {
  test('«المساجد» routes are part of مُجتمعي (default flavor)', () {
    expect(isInAppPath(AppRoutes.masjid), isTrue);
    expect(isInAppPath(AppRoutes.mosque('0b6f4f8e-3c43-4c8e-9a8e-1f0c2d3e4f50')), isTrue);
    expect(isInAppPath('/masjid/not-a-uuid'), isFalse);
  });

  test('share links open the masjid app', () {
    expect(MasjidService.shareUrl('abc'), 'https://masjid.mogtama3y.com/#/masjid/abc');
  });

  test('need progress counts confirmed amounts', () {
    expect(needProgressText(500, 1000), 'اتدفع 500 من 1,000 — باقي 500 ج.م');
    expect(needProgressText(1200, 1000), startsWith('اكتمل'));
    expect(masjidMoney(1234567), '1,234,567');
    expect(masjidMoney(0), '0');
  });
}
