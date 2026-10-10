import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mogtama3y/core/masjid_tools/listen_queue.dart';
import 'package:mogtama3y/core/masjid_tools/recitations.dart';

// A trimmed sample in the exact shape of mp3quran.net /api/v3/reciters.
const _sample = r'''
{"reciters":[
 {"id":118,"name":"محمود خليل الحصري","letter":"م","date":"2025-01-01","moshaf":[
   {"id":1,"name":"قالون عن نافع - مرتل","rewaya_id":5,"server":"https:\/\/cdn.mp3quran.net\/audio\/husary\/qalon","surah_total":3,"moshaf_type":51,"surah_list":"1,2,3"},
   {"id":2,"name":"المصحف المجود - المصحف المجود","rewaya_id":22,"server":"https:\/\/cdn.mp3quran.net\/audio\/husary\/mjwd\/","surah_total":114,"moshaf_type":222,"surah_list":"1,2,3"},
   {"id":3,"name":"حفص عن عاصم - مرتل","rewaya_id":1,"server":"http:\/\/cdn.mp3quran.net\/audio\/husary\/r1\/","surah_total":4,"moshaf_type":11,"surah_list":"114,1,2, 3,2,999,x"}
 ]},
 {"id":5,"name":"أحمد بن علي العجمي","letter":"أ","moshaf":[
   {"id":7,"name":"حفص عن عاصم - مرتل","rewaya_id":1,"server":"https:\/\/cdn.mp3quran.net\/audio\/ajm\/","surah_total":2,"moshaf_type":11,"surah_list":"1,112"}
 ]},
 {"id":9,"name":"قارئ بلا مصحف","moshaf":[]},
 {"id":10,"name":"إبراهيم الأخضر","moshaf":[
   {"id":8,"name":"ورش عن نافع من طريق الأزرق - مرتل","rewaya_id":18,"server":"https:\/\/cdn.mp3quran.net\/audio\/akhdar\/","surah_list":"1,2"},
   {"id":9,"name":"البزي وقنبل عن ابن كثير - مرتل","rewaya_id":11,"server":"https:\/\/cdn.mp3quran.net\/audio\/akhdar\/b\/","surah_list":"1"},
   {"id":10,"name":"حفص عن عاصم - تسجيل عام 1387 هـ - 1967م","rewaya_id":1,"server":"https:\/\/cdn.mp3quran.net\/audio\/akhdar\/old\/","surah_list":"1"}
 ]},
 {"id":51,"name":"عبدالباسط عبدالصمد","moshaf":[
   {"id":11,"name":"المصحف المعلم - المصحف المعلم","rewaya_id":21,"server":"https:\/\/cdn.mp3quran.net\/audio\/basit\/mlm\/","surah_list":"1"}
 ]}
]}
''';

void main() {
  final reciters = parseReciters(jsonDecode(_sample));

  group('mp3quran parsing', () {
    test('drops reciters without a usable mushaf', () {
      expect(reciters.map((r) => r.id), [118, 5, 10, 51]);
    });

    test('moshaf names → riwayah, kind, note', () {
      expect(parseMoshafName('حفص عن عاصم - مرتل'), ('حفص عن عاصم', RecitationKind.murattal, null));
      expect(parseMoshafName('المصحف المجود - المصحف المجود'), ('حفص عن عاصم', RecitationKind.mujawwad, null));
      expect(parseMoshafName('المصحف المعلم - المصحف المعلم'), ('حفص عن عاصم', RecitationKind.muallim, null));
      expect(parseMoshafName('حفص عن عاصم - المصحف المعلم'), ('حفص عن عاصم', RecitationKind.muallim, null));
      expect(parseMoshafName('قالون عن نافع - المصحف المجود'), ('قالون عن نافع', RecitationKind.mujawwad, null));
      expect(parseMoshafName('حفص عن عاصم - تلاوة مميزة'), ('حفص عن عاصم', RecitationKind.murattal, 'تلاوة مميزة'));
      expect(parseMoshafName('حفص عن عاصم - تسجيل عام 1387 هـ - 1967م'), ('حفص عن عاصم', RecitationKind.murattal, 'تسجيل عام 1387 هـ - 1967م'));
    });

    test('riwayah grouping and mushaf order (Hafs first)', () {
      final husary = reciters.first;
      expect(husary.riwayat, {'حفص عن عاصم', 'قالون عن نافع'});
      expect(husary.kinds, {RecitationKind.murattal, RecitationKind.mujawwad});
      expect(husary.moshafs.map((m) => m.id), [3, 2, 1]); // Hafs murattal, Hafs mujawwad, Qalun
      expect(husary.moshafs.first.title, 'حفص عن عاصم — مرتل');
    });

    test('surah_list parsing: sorted, unique, in range; ranges', () {
      expect(parseSurahList('114,1,2, 3,2,999,x'), [1, 2, 3, 114]);
      expect(parseSurahList([3, '1', 2.0]), [1, 2, 3]);
      expect(parseSurahList(null), isEmpty);
      expect(parseSurahList('1-3,5,110-120'), [1, 2, 3, 5, 110, 111, 112, 113, 114]);
      final full = List.generate(114, (i) => i + 1);
      expect(compactSurahList(full), '1-114');
      expect(compactSurahList([1, 2, 3, 5, 7, 8]), '1-3,5,7-8');
      expect(parseSurahList(compactSurahList([1, 2, 3, 5, 7, 8])), [1, 2, 3, 5, 7, 8]);
      final m = reciters.first.moshafs.first;
      expect(m.has(114), isTrue);
      expect(m.has(4), isFalse);
      expect(m.complete, isFalse);
    });

    test('URL building: https, trailing slash, 3-digit surah', () {
      expect(surahUrl('https://cdn.mp3quran.net/audio/husary/qalon', 1), 'https://cdn.mp3quran.net/audio/husary/qalon/001.mp3');
      expect(surahUrl('http://server8.mp3quran.net/afs/', 18), 'https://server8.mp3quran.net/afs/018.mp3');
      expect(reciters.first.moshafs.first.url(114), 'https://cdn.mp3quran.net/audio/husary/r1/114.mp3');
    });

    test('compact cache round-trip keeps everything', () {
      final again = parseReciters(jsonDecode(jsonEncode({'reciters': [for (final r in reciters) r.toJson()]})));
      expect(again.length, reciters.length);
      for (var i = 0; i < again.length; i++) {
        expect(again[i].name, reciters[i].name);
        expect([for (final m in again[i].moshafs) (m.id, m.riwayah, m.kind, m.note, m.server, m.surahs.join(','))],
            [for (final m in reciters[i].moshafs) (m.id, m.riwayah, m.kind, m.note, m.server, m.surahs.join(','))]);
      }
    });
  });

  group('search & filters', () {
    test('Arabic folding: hamza forms, spaces, taa marbuta', () {
      expect(foldArabic('عبد الباسط'), foldArabic('عبدالباسط'));
      expect(foldArabic('أحمد'), foldArabic('احمد'));
      expect(foldArabic('شعبة'), foldArabic('شعبه'));
    });

    test('search by name', () {
      expect(filterReciters(reciters, query: 'عبد الباسط').map((r) => r.id), [51]);
      expect(filterReciters(reciters, query: 'احمد').map((r) => r.id), [5]);
    });

    test('riwayah filter chips match variants', () {
      expect(filterReciters(reciters, riwayah: 'ورش').map((r) => r.id), [10]);
      expect(filterReciters(reciters, riwayah: 'قنبل').map((r) => r.id), [10]);
      expect(filterReciters(reciters, riwayah: 'البزي').map((r) => r.id), [10]);
      expect(filterReciters(reciters, riwayah: 'قالون').map((r) => r.id), [118]);
      expect(filterReciters(reciters, riwayah: 'حفص').length, 4);
    });

    test('kind filter and favourites', () {
      expect(filterReciters(reciters, kind: RecitationKind.muallim).map((r) => r.id), [51]);
      expect(filterReciters(reciters, kind: RecitationKind.mujawwad).map((r) => r.id), [118]);
      expect(filterReciters(reciters, onlyIds: {5, 51}).map((r) => r.id), [5, 51]);
      expect(matchingMoshafs(reciters.first, riwayah: 'حفص', kind: RecitationKind.mujawwad).map((m) => m.id), [2]);
    });

    test('popular reciters pinned first, in order', () {
      final sorted = sortReciters(reciters);
      expect(sorted.map((r) => r.id), [118, 51, 5, 10]); // الحصري، عبد الباسط، العجمي، then the rest
    });

    test('formatBytes', () {
      expect(formatBytes(375643), '367 كيلو');
      expect(formatBytes(5 * 1024 * 1024 + 300000), '5.3 ميجا');
      expect(formatBytes(56622866), '54 ميجا');
    });
  });

  group('player queue', () {
    test('next / previous skip missing surahs', () {
      final q = ListenQueue([1, 2, 5, 114], 2);
      expect(q.next(), 5);
      expect(q.previous(), 1);
      q.current = 114;
      expect(q.next(), isNull);
      expect(q.hasNext, isFalse);
      expect(q.next(wrap: true), 1);
      q.current = 1;
      expect(q.previous(), isNull);
      expect(q.hasPrevious, isFalse);
    });

    test('after a surah ends, per mode', () {
      final q = ListenQueue([1, 2, 3], 3);
      expect(q.afterEnd(PlayMode.continuous), isNull);
      expect(q.afterEnd(PlayMode.repeatAll), 1);
      expect(q.afterEnd(PlayMode.repeatOne), 3);
      expect(q.afterEnd(PlayMode.once), isNull);
      q.current = 1;
      expect(q.afterEnd(PlayMode.continuous), 2);
      expect(q.afterEnd(PlayMode.repeatAll), 2);
    });

    test('previous restarts the surah after a few seconds', () {
      final q = ListenQueue([1, 2, 3], 2);
      expect(q.previousOrRestart(30), 2);
      expect(q.previousOrRestart(2), 1);
      q.current = 1;
      expect(q.previousOrRestart(2), isNull);
    });

    test('a current surah outside the list still navigates', () {
      final q = ListenQueue([1, 10, 20], 5);
      expect(q.next(), 10);
      expect(q.previous(), 1);
    });

    test('resume point and clock', () {
      expect(resumePoint(5, 600), isNull); // just started
      expect(resumePoint(120, 600), 120);
      expect(resumePoint(590, 600), isNull); // practically finished
      expect(formatClock(65), '1:05');
      expect(formatClock(3723), '1:02:03');
      expect(formatClock(double.nan), '0:00');
    });
  });
}
