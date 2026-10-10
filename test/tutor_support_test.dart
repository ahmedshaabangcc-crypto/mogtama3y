import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mogtama3y/core/masjid_tools/platform/tutor_engine.dart';
import 'package:mogtama3y/features/masjid_tools/tutor_screens.dart';

void main() {
  group('«المحفّظ» failure reporting', () {
    test('watchdog codes have their own messages', () {
      expect(tutorErrorText(const TutorError('timeout')), contains('اتأخر'));
      expect(tutorErrorText(const TutorError('crashed')), contains('وقف'));
      expect(tutorErrorText(const TutorError('mic_denied')), const TutorError('mic_denied').message);
    });

    test('support report: no links (guests may not send them), under 2000 chars', () {
      final diag = jsonEncode({
        'errors': [
          {'message': 'Failed to fetch https://cdn.jsdelivr.net/npm/onnxruntime-web/dist/ort.wasm from huggingface.co ' * 40},
        ],
        'ua': 'Mozilla/5.0 (Linux; Android 14) Chrome/129 Mobile',
      });
      final r = tutorSupportReport(const TutorError('timeout', 'no result after 84 s www.example.org'), 'check 1:2', diag);
      expect(r.length, lessThanOrEqualTo(2000));
      expect(r, isNot(contains('https://')));
      expect(r, isNot(contains('www.')));
      expect(RegExp(r'\b[a-z0-9-]+\.(com|net|org|io|xyz|ru|info|me|link)\b', caseSensitive: false).hasMatch(r), isFalse);
      expect(r, startsWith('«المحفّظ» مشكلة على الجهاز (check 1:2)\ntimeout: '));
    });

    test('stage line from diagnostics', () {
      final line = tutorStageLine(jsonEncode({
        'safe': true,
        'rec': {'wall': 4.2, 'source': 'pcm', 'ctxRate': 48000, 'pcmPeak': 0.31, 'ctxState': 'running→running', 'stopMs': 3},
        'last': {'prepMs': 12, 'ms': 2100, 'featMs': 40, 'encMs': 600, 'decMs': 1400, 'wallMs': 2150, 'backend': 'wasm', 'threads': 1, 'recovered': 'timeout'},
      }));
      expect(line, contains('record 4.2 s (pcm, 48000 Hz'));
      expect(line, contains('resample 12 ms'));
      expect(line, contains('recovered from timeout'));
      expect(line, contains('safe mode'));
      expect(tutorStageLine('not json'), '');
    });

    testWidgets('«تفاصيل للدعم» expands to the report; send button present', (tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(body: TutorSupportDetails(error: TutorError('timeout', 'no result after 91 s'), where: 'check 1:2')),
      ));
      expect(find.text('ابعت التفاصيل للدعم'), findsOneWidget);
      expect(find.textContaining('no result after 91 s'), findsNothing);
      await tester.tap(find.text('تفاصيل للدعم'));
      await tester.pump();
      expect(find.textContaining('timeout: no result after 91 s'), findsOneWidget);
    });
  });
}
