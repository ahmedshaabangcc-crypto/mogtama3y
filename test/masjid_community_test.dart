import 'package:flutter_test/flutter_test.dart';
import 'package:mogtama3y/core/masjid/masjid_community.dart';

void main() {
  group('formatMeters', () {
    test('metres under 1 km, km above', () {
      expect(formatMeters(0), '0 متر');
      expect(formatMeters(445.4), '445 متر');
      expect(formatMeters(999), '999 متر');
      expect(formatMeters(1400), '1.4 كم');
      expect(formatMeters(12345), '12 كم');
      expect(formatMeters(null), '');
    });
  });

  group('chat rules (0083)', () {
    test('nickname length, characters and letters', () {
      expect(mosqueChatNicknameError(''), isNull);
      expect(mosqueChatNicknameError('  أم   محمد '), isNull);
      expect(tidyChatNickname('  أم   محمد '), 'أم محمد');
      expect(mosqueChatNicknameError('Om_Ali 2'), isNull);
      expect(mosqueChatNicknameError('ا'), contains('2'));
      expect(mosqueChatNicknameError('ا' * 31), contains('30'));
      expect(mosqueChatNicknameError('1234'), isNotNull);
      expect(mosqueChatNicknameError('أم <b>'), isNotNull);
    });
    test('phone-unverified errors are recognised', () {
      expect(isPhoneUnverifiedError(hint: 'phone_unverified'), isTrue);
      expect(isPhoneUnverifiedError(message: 'لازم توثّق رقم موبايلك عشان تكتب في الشات'), isTrue);
      expect(isPhoneUnverifiedError(message: 'استنى ثانيتين'), isFalse);
    });
  });

  group('mosqueChatBodyError', () {
    test('empty and too long are refused', () {
      expect(mosqueChatBodyError('   '), isNotNull);
      expect(mosqueChatBodyError('ا' * 1001), contains('1000'));
    });
    test('normal text and exactly 1000 chars are fine', () {
      expect(mosqueChatBodyError(' السلام عليكم '), isNull);
      expect(mosqueChatBodyError('ا' * 1000), isNull);
    });
  });

  test('unreadBadge', () {
    expect(unreadBadge(null), '');
    expect(unreadBadge(0), '');
    expect(unreadBadge(7), '7');
    expect(unreadBadge(99), '99+');
    expect(unreadBadge(250), '99+');
  });

  test('membersLabel', () {
    expect(membersLabel(0), 'لسه مفيش أعضاء');
    expect(membersLabel(1), 'عضو واحد');
    expect(membersLabel(2), 'عضوين');
    expect(membersLabel(5), '5 أعضاء');
    expect(membersLabel(40), '40 عضو');
  });

  group('splitJoinCandidates', () {
    test('within the 500 m radius vs beyond, each nearest first', () {
      final split = splitJoinCandidates([
        {'id': 'c', 'distance_m': 480, 'within': true},
        {'id': 'a', 'distance_m': 20, 'within': true},
        {'id': 'far', 'distance_m': 900, 'within': false},
        {'id': 'edge', 'distance_m': 500},
      ]);
      expect(split.within.map((r) => r['id']), ['a', 'c', 'edge']);
      expect(split.beyond.map((r) => r['id']), ['far']);
    });
    test('nothing within → everything is beyond', () {
      final split = splitJoinCandidates([
        {'id': 'x', 'distance_m': 700, 'within': false},
        {'id': 'y', 'distance_m': 600, 'within': false},
      ]);
      expect(split.within, isEmpty);
      expect(split.beyond.map((r) => r['id']), ['y', 'x']);
    });
  });

  test('invite texts carry the mosque name and link', () {
    const url = 'https://masjidi.mogtama3y.com/#/masjid/abc';
    final imam = imamInviteText('مسجد النور', url);
    expect(imam, contains('مسجد النور'));
    expect(imam, contains('أنا مسؤول عن المسجد ده'));
    expect(imam, endsWith(url));
    final n = neighboursInviteText('مسجد النور', url);
    expect(n, contains('انضموا'));
    expect(n, endsWith(url));
    final wa = whatsappShareUri(n);
    expect(wa.host, 'wa.me');
    expect(wa.queryParameters['text'], n);
  });
}
