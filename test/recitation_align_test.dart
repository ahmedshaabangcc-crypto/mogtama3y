import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mogtama3y/core/masjid_tools/quran_text.dart';
import 'package:mogtama3y/core/masjid_tools/recitation_align.dart';
import 'package:mogtama3y/core/masjid_tools/tutor_progress.dart';

List<WordStatus> st(String ref, String hyp) => alignRecitation(ref, hyp).statuses;

void main() {
  late QuranText quran;
  setUpAll(() {
    quran = QuranText.parse(utf8.decode(gzip.decode(File('assets/quran/quran-uthmani.txt.gz').readAsBytesSync())));
  });

  group('normalise', () {
    test('Uthmani dagger alef after tatweel is a written alef', () {
      expect(normalizeRecitation('مَـٰلِكِ'), 'مالك');
      expect(normalizeRecitation('ٱلْعَـٰلَمِينَ'), 'العالمين');
    });
    test('tashkeel, wasla, waqf marks and ayah numbers go', () {
      expect(normalizeRecitation('ٱللَّهُ ٱلصَّمَدُ ۝١٢'), 'الله الصمد');
      expect(normalizeRecitation('لَّهُۥ مَا فِى ۚ'), 'له ما في');
    });
    test('alef / ya / ta marbuta / hamza seats unified', () {
      expect(normalizeRecitation('أَإِآٱ'), 'اااا');
      expect(normalizeRecitation('عَلَىٰ'), 'علي');
      expect(normalizeRecitation('رَحْمَةٌ'), 'رحمه');
      expect(normalizeRecitation('يَـُٔودُهُۥ'), normalizeRecitation('يَئُودُهُ'));
      expect(normalizeRecitation('ٱلْأَفْـِٔدَةَ'), normalizeRecitation('الأفئدة'));
    });
    test('waw + dagger alef reads as alef (الصلوة)', () {
      expect(normalizeRecitation('ٱلصَّلَوٰةَ'), 'الصلاه');
      expect(normalizeRecitation('ٱلسَّمَـٰوَٰتِ'), 'السماوت'); // a real waw here
    });
    test('skeleton ignores alef/hamza spelling', () {
      expect(recitationSkeleton('الرحمان'), recitationSkeleton('الرحمن'));
      expect(wordSimilarity('الرحمان', 'الرحمن'), 1);
      expect(wordSimilarity('السماوت', 'السماوات'), 1);
      expect(wordSimilarity(normalizeRecitation('ءَامَنُوا۟'), normalizeRecitation('آمَنُوا')), 1);
    });
  });

  group('align', () {
    test('مَـٰلِكِ vs مالك', () {
      expect(st('مَـٰلِكِ يَوْمِ ٱلدِّينِ', 'مَالِكِ يَوْمِ الدِّينِ'), everyElement(WordStatus.ok));
      expect(st('مَـٰلِكِ يَوْمِ ٱلدِّينِ', 'ملك يوم الدين'), everyElement(WordStatus.ok)); // ملك is a valid qira'a spelling skeleton
    });
    test('الرحمان / الرحمن skeleton match', () {
      expect(st('ٱلرَّحْمَـٰنِ ٱلرَّحِيمِ', 'الرحمن الرحيم'), [WordStatus.ok, WordStatus.ok]);
      expect(alignRecitation('ٱلرَّحْمَـٰنِ ٱلرَّحِيمِ', 'الرحمن الرحيم').perfect, isTrue);
    });
    test('a one-letter error is near or wrong, never ok', () {
      for (final (ref, hyp) in [
        ('ٱلْحَمْدُ لِلَّهِ رَبِّ ٱلْعَـٰلَمِينَ', 'الحمد لله رب العالمون'),
        ('قُلْ هُوَ ٱللَّهُ أَحَدٌ', 'قل هو الله أحاط'),
        ('ٱهْدِنَا ٱلصِّرَٰطَ ٱلْمُسْتَقِيمَ', 'اهدنا السراط المستقيم'),
        ('لَمْ يَلِدْ وَلَمْ يُولَدْ', 'لم يلد ولم يولج'),
      ]) {
        final r = alignRecitation(ref, hyp);
        expect(r.perfect, isFalse, reason: hyp);
        expect(r.statuses.where((s) => s == WordStatus.ok).length, r.words.length - 1, reason: hyp);
        expect(r.statuses.firstWhere((s) => s != WordStatus.ok), anyOf(WordStatus.near, WordStatus.wrong), reason: hyp);
      }
      expect(st('لَمْ يَلِدْ وَلَمْ يُولَدْ', 'لم يلد ولم يولج').last, WordStatus.near);
    });
    test('a different word is wrong', () {
      expect(st('قُلْ هُوَ ٱللَّهُ أَحَدٌ', 'قل هو الله الصمد'), [WordStatus.ok, WordStatus.ok, WordStatus.ok, WordStatus.wrong]);
    });
    test('missing words', () {
      final r = alignRecitation('ٱلْحَمْدُ لِلَّهِ رَبِّ ٱلْعَـٰلَمِينَ', 'الحمد لله العالمين');
      expect(r.statuses, [WordStatus.ok, WordStatus.ok, WordStatus.missing, WordStatus.ok]);
      expect(r.perfect, isFalse);
      expect(st('قُلْ هُوَ ٱللَّهُ أَحَدٌ', ''), everyElement(WordStatus.missing));
      expect(alignRecitation('قُلْ هُوَ ٱللَّهُ أَحَدٌ', '').empty, isTrue);
    });
    test('extra words', () {
      final r = alignRecitation('ٱللَّهُ ٱلصَّمَدُ', 'الله الله الصمد');
      expect(r.statuses, everyElement(WordStatus.ok));
      expect(r.extras, ['الله']);
      expect(r.perfect, isFalse);
      expect(r.ops.map((o) => o.status), contains(WordStatus.extra));
    });
    test('words split differently (يَـٰٓأَيُّهَا ↔ يا أيها)', () {
      final ref = quran.ayah(2, 21); // يَـٰٓأَيُّهَا ٱلنَّاسُ ٱعْبُدُوا۟ رَبَّكُمُ …
      final r = alignRecitation(ref, 'يَا أَيُّهَا النَّاسُ اعْبُدُوا رَبَّكُمُ الَّذِي خَلَقَكُمْ وَالَّذِينَ مِنْ قَبْلِكُمْ لَعَلَّكُمْ تَتَّقُونَ');
      expect(r.perfect, isTrue, reason: r.ops.toString());
    });
    test('an opening isti\'adha / basmala is not an extra', () {
      final ref = splitBasmala(112, 1, quran.ayah(112, 1)).text;
      expect(alignRecitation(ref, 'أعوذ بالله من الشيطان الرجيم بسم الله الرحمن الرحيم قل هو الله أحد').perfect, isTrue);
      expect(alignRecitation(ref, 'بسم الله الرحمن الرحيم قل هو الله أحد').perfect, isTrue);
      // …but in al-Fatiha the basmala is the ayah itself.
      expect(alignRecitation(quran.ayah(1, 1), 'بسم الله الرحمن الرحيم').perfect, isTrue);
      expect(alignRecitation(quran.ayah(1, 1), 'الرحمن الرحيم').perfect, isFalse);
    });
    test('waqf marks stick to the word before them', () {
      final words = recitationWords(quran.ayah(2, 255));
      expect(words.first.norm, 'الله');
      expect(words.any((w) => w.norm.isEmpty), isFalse);
      expect(words.firstWhere((w) => w.norm == 'القيوم').display, endsWith('ۚ'));
    });

    // Real transcripts of the model (q8, WASM) on everyayah.com clips —
    // from the feasibility spike — against the app's own Tanzil text.
    final real = <(String, int, int, String)>[
      ('Alafasy', 1, 1, 'بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ'),
      ('Alafasy', 1, 2, 'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ'),
      ('Alafasy', 1, 3, 'الرَّحْمَنِ الرَّحِيمِ'),
      ('Alafasy', 1, 4, 'مَالِكِ يَوْمِ الدِّينِ'),
      ('Alafasy', 1, 5, 'إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ'),
      ('Alafasy', 1, 6, 'اهْدِنَا الصِّرَاطَ الْمُسْتَقِيمَ'),
      ('Alafasy', 1, 7, 'صِرَاطَ الَّذِينَ أَنْعَمْتَ عَلَيْهِمْ غَيْرِ الْمَغْضُوبِ عَلَيْهِمْ وَلَا الضَّالِّينَ'),
      ('Alafasy', 2, 255,
          'اللَّهُ لَا إِلَهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ لَا تَأْخُذُهُ سِنَةٌ وَلَا نَوْمٌ لَهُ مَا فِي السَّمَاوَاتِ وَمَا فِي الْأَرْضِ مَنْ ذَا الَّذِي يَشْفَعُ عِنْدَهُ إِلَّا بِإِذْنِهِ يَعْلَمُ مَا بَيْنَ أَيْدِيهِمْ وَمَا خَلْفَهُمْ وَلَا يُحِيطُونَ بِشَيْءٍ مِنْ عِلْمِهِ إِلَّا بِمَا شَاءُ وَسِعَ كُرْسِيُّهُ السَّمَاوَاتِ وَالْأَرْضِ وَلَا يَئُودُهُ حِفْظُهُمَا وَهُوَ الْعَلِيُّ الْعَظِيمُ'),
      ('Alafasy', 112, 1, 'قُلْ هُوَ اللَّهُ أَحَدٌ'),
      ('Alafasy', 112, 2, 'اللَّهُ الصَّمَدُ'),
      ('Alafasy', 112, 3, 'لَمْ يَلِدْ وَلَمْ يُولَدْ'),
      ('Alafasy', 112, 4, 'وَلَمْ يَكُنْ لَهُ كُفُوًا أَحَدٌ'),
      ('Husary', 1, 7, 'صِرَاطَ الَّذِينَ أَنْعَمْتَ عَلَيْهِمْ غَيْرِ الْمَغْضُوبِ عَلَيْهِمْ وَلَا الضَّالِّينَ'),
      ('Husary', 112, 4, 'وَلَمْ يَكُنْ لَهُ كُفُوًا أَحَدٌ'),
      // In the browser (Chrome, WASM, the app's worker) on Husary «المعلّم» clips.
      ('Husary Muallim', 78, 1, 'عَمَّ يَتَسَاءَلُونَ'),
      ('Husary Muallim', 103, 3, 'إِلَّا الَّذِينَ آمَنُوا وَعَمِلُوا الصَّالِحَاتِ وَتَوَاصَوْا بِالْحَقِّ وَتَوَاصَوْا بِالصَّبْرِ'),
    ];
    for (final (who, s, a, hyp) in real) {
      test('real transcript $who $s:$a is perfect', () {
        final r = alignRecitation(splitBasmala(s, a, quran.ayah(s, a)).text, hyp);
        expect(r.perfect, isTrue, reason: r.ops.where((o) => o.status != WordStatus.ok).toString());
      });
    }
    test('real transcript Husary 2:255 flags exactly the misheard words', () {
      const hyp =
          'اللَّهُ لَا إِلَهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ لَا تَأْخُذُهُ سِنَةٌ وَلَا نَوْمٌ لَهُ مَا فِي السَّمَاوَاتِ وَمَا فِي الْأَرْضِ مَنْ ذَا الَّذِي يَشْفَعُ عِنْدَهُ إِلَّا بِإِذْنِهِ يَعْلَمُ مَا بَيْنَ أَيْدِيهِمْ وَمَا خَلْفَهُمْ وَلَا يُحِيطُونَ بِشَيْءٍ مِنْ عِلْمِهِ إِلَّا بِمَا شَاءُ وَسِعَ قُرْسِيُّهُ السَّمَاوَاتِ وَالْأَرْضَ وَلَا يَأُولُهُ حِفْرُهُمَا وَهُوَ الْعَلِيُّ الْعَظِيمُ';
      final r = alignRecitation(quran.ayah(2, 255), hyp);
      final bad = [for (final o in r.ops) if (o.status != WordStatus.ok) o.ref];
      expect(bad, ['كرسيه', 'يءوده', 'حفظهما']);
      // قرسيه / يأوله / حفرهما: one or two letters off.
      expect([for (final o in r.ops) if (o.status != WordStatus.ok) o.status], [WordStatus.near, WordStatus.near, WordStatus.near]);
    });
  });

  group('progress', () {
    final day = DateTime(2026, 10, 10, 9);
    test('memorised after N perfect recitations in a row', () {
      final p = TutorProgress();
      p.record(112, 1, perfect: true, needed: 2, now: day);
      expect(p.of(112, 1).status, AyahStatus.learning);
      p.record(112, 1, perfect: false, needed: 2, now: day);
      expect(p.of(112, 1).perfectCount, 0);
      p.record(112, 1, perfect: true, needed: 2, now: day);
      p.record(112, 1, perfect: true, needed: 2, now: day);
      expect(p.of(112, 1).status, AyahStatus.memorized);
      expect(p.memorizedIn(112), 1);
      expect(p.percent(112), closeTo(0.25, 1e-9));
      // A mistake later sends it back to review.
      p.record(112, 1, perfect: false, needed: 2, now: day);
      expect(p.of(112, 1).status, AyahStatus.learning);
    });
    test('streak counts consecutive days', () {
      final p = TutorProgress();
      p.record(1, 1, perfect: true, needed: 2, now: day);
      p.record(1, 2, perfect: true, needed: 2, now: day.add(const Duration(hours: 3)));
      expect(p.streak, 1);
      p.record(1, 3, perfect: true, needed: 2, now: day.add(const Duration(days: 1)));
      expect(p.streak, 2);
      expect(p.currentStreak(day.add(const Duration(days: 2))), 2);
      expect(p.currentStreak(day.add(const Duration(days: 3))), 0);
      p.record(1, 4, perfect: true, needed: 2, now: day.add(const Duration(days: 5)));
      expect(p.streak, 1);
      expect(p.bestStreak, 2);
    });
    test('json round trip and merge keeps the newer row', () {
      final p = TutorProgress();
      p.record(1, 1, perfect: true, needed: 1, now: day);
      final q = TutorProgress.fromJson(jsonDecode(jsonEncode(p.toJson())) as Map<String, dynamic>);
      expect(q.of(1, 1).status, AyahStatus.memorized);
      expect(q.streak, 1);
      final changed = q.mergeRemote([
        {'surah': 1, 'ayah': 1, 'status': 'learning', 'perfect_count': 0, 'updated_at': day.subtract(const Duration(days: 1)).toUtc().toIso8601String()},
        {'surah': 1, 'ayah': 2, 'status': 'memorized', 'perfect_count': 3, 'updated_at': day.toUtc().toIso8601String()},
        {'surah': 999, 'ayah': 2, 'status': 'memorized', 'perfect_count': 3, 'updated_at': day.toUtc().toIso8601String()},
      ]);
      expect(changed, isTrue);
      expect(q.of(1, 1).status, AyahStatus.memorized);
      expect(q.of(1, 2).status, AyahStatus.memorized);
      expect(q.memorizedTotal, 2);
      expect(q.dirtyRows().map((r) => r['ayah']), [1]); // local-only change still to upload
    });
  });
}
