import 'package:flutter_test/flutter_test.dart';
import 'package:mogtama3y/core/masjid/masjid_live.dart';

void main() {
  final now = DateTime(2026, 10, 10, 18, 0); // Saturday 6 PM (local)

  Map<String, dynamic> lesson({String status = 'scheduled', DateTime? at, DateTime? started, int minutes = 60, bool canJoin = true}) => {
        'status': status,
        'scheduled_at': (at ?? now).toIso8601String(),
        if (started != null) 'started_at': started.toIso8601String(),
        'duration_minutes': minutes,
        'can_join': canJoin,
      };

  group('liveLessonUri', () {
    test('same origin, lesson id in ?s=', () {
      expect(liveLessonUri('abc-123', Uri.parse('https://masjidi.mogtama3y.com/#/masjid/x')).toString(), 'https://masjidi.mogtama3y.com/live/?s=abc-123');
      expect(liveLessonUri('id', Uri.parse('http://localhost:5000/')).toString(), 'http://localhost:5000/live/?s=id');
    });
    test('the id is encoded', () {
      expect(liveLessonUri('a&b=c', Uri.parse('https://mogtama3y.com/')).query, 's=a%26b%3Dc');
    });
  });

  group('liveIsLive / liveCanEnter', () {
    test('live within its time', () {
      final s = lesson(status: 'live', started: now.subtract(const Duration(minutes: 30)));
      expect(liveIsLive(s, now), isTrue);
      expect(liveCanEnter(s, now), isTrue);
    });
    test('a forgotten live lesson (3 h past its end) is not live', () {
      final s = lesson(status: 'live', started: now.subtract(const Duration(hours: 5)));
      expect(liveIsLive(s, now), isFalse);
      expect(liveWhenLabel(s, now), 'خلص');
    });
    test('scheduled / ended are not live; members-only without membership cannot enter', () {
      expect(liveIsLive(lesson(), now), isFalse);
      expect(liveIsLive(lesson(status: 'ended'), now), isFalse);
      expect(liveCanEnter(lesson(status: 'live', started: now, canJoin: false), now), isFalse);
    });
  });

  group('liveWhenLabel', () {
    test('status labels', () {
      expect(liveWhenLabel(lesson(status: 'live', started: now), now), 'مباشر دلوقتي');
      expect(liveWhenLabel(lesson(status: 'ended'), now), 'خلص');
      expect(liveWhenLabel(lesson(status: 'cancelled'), now), 'اتلغى');
    });
    test('soon, today, tomorrow, later', () {
      expect(liveWhenLabel(lesson(at: now.add(const Duration(minutes: 20))), now), 'كمان 20 دقيقة');
      expect(liveWhenLabel(lesson(at: now.subtract(const Duration(minutes: 2))), now), 'هيبدأ دلوقتي');
      expect(liveWhenLabel(lesson(at: DateTime(2026, 10, 10, 20, 30)), now), 'النهارده 8:30 م');
      expect(liveWhenLabel(lesson(at: DateTime(2026, 10, 11, 7, 5)), now), 'بكرة 7:05 ص');
      expect(liveWhenLabel(lesson(at: DateTime(2026, 10, 15, 12, 0)), now), 'الخميس 15/10 — 12:00 م');
    });
  });

  test('clock12', () {
    expect(clock12(DateTime(2026, 1, 1, 0, 0)), '12:00 ص');
    expect(clock12(DateTime(2026, 1, 1, 12, 15)), '12:15 م');
    expect(clock12(DateTime(2026, 1, 1, 23, 9)), '11:09 م');
  });

  test('compareLive: live first, then the soonest', () {
    final later = lesson(at: DateTime.now().add(const Duration(days: 2)));
    final sooner = lesson(at: DateTime.now().add(const Duration(hours: 2)));
    final live = lesson(status: 'live', started: DateTime.now());
    final list = [later, sooner, live]..sort(compareLive);
    expect(list, [live, sooner, later]);
  });

  group('liveFormError', () {
    test('title and time are checked like the server', () {
      expect(liveFormError(title: ' ', at: now, now: now), isNotNull);
      expect(liveFormError(title: 'د' * 121, at: now, now: now), isNotNull);
      expect(liveFormError(title: 'درس', at: null, now: now), isNotNull);
      expect(liveFormError(title: 'درس', at: now.subtract(const Duration(hours: 1)), now: now), contains('فات'));
      expect(liveFormError(title: 'درس', at: now.add(const Duration(days: 61)), now: now), contains('شهرين'));
      expect(liveFormError(title: 'درس الفقه', at: now.add(const Duration(hours: 1)), now: now), isNull);
    });
  });

  test('liveDayLabel', () {
    expect(liveDayLabel(now, now), 'النهارده');
    expect(liveDayLabel(now.add(const Duration(days: 1)), now), 'بكرة');
    expect(liveDayLabel(DateTime(2026, 10, 15), now), 'الخميس 15/10');
  });

  test('labels', () {
    expect(liveModeLabels['audio'], 'صوت بس');
    expect(liveVisibilityLabels['members'], 'لأعضاء المسجد');
    expect(liveNotRecordedNote, 'الدرس مباشر ومش بيتسجّل');
  });
}
