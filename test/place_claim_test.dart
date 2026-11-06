import 'package:flutter_test/flutter_test.dart';
import 'package:mogtama3y/core/routing/app_router.dart';
import 'package:mogtama3y/core/shops/place_claim_service.dart';

/// «استلم محلك جاهز» (0111): the claim link opens in the app.
void main() {
  test('/claim/<place id> is an in-app path; junk is not', () {
    expect(isInAppPath('/claim/0001185f-5e18-4a42-8a63-5bf73dd20ee2'), isTrue);
    expect(isInAppPath('/claim/shop-0b1c2d3e4f'), isTrue);
    expect(isInAppPath('/claim/x'), isFalse);
    expect(isInAppPath('/claim/../../etc'), isFalse);
  });

  test('the outreach link points at متجري', () {
    expect(PlaceClaimService.claimUrl('abc12345'), 'https://tajer.mogtama3y.com/#/claim/abc12345');
  });
}
