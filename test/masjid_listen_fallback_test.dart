import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mogtama3y/core/masjid_tools/recitations.dart';
import 'package:mogtama3y/core/theme/app_theme.dart';
import 'package:mogtama3y/features/masjid_tools/listen_screens.dart';
import 'package:mogtama3y/features/masjid_tools/tools_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('reciters snapshot', () {
    test('bundled asset is small and complete', () async {
      final f = File(recitationsSnapshotAsset);
      expect(f.existsSync(), isTrue);
      expect(f.lengthSync(), lessThan(150 * 1024));
      final list = await ListenStore.loadSnapshot();
      expect(list.length, greaterThan(200));
      for (final r in list) {
        for (final m in r.moshafs) {
          expect(m.server, startsWith('https://'));
          expect(m.surahs, isNotEmpty);
        }
      }
      final husary = list.where((r) => foldArabic(r.name).contains(foldArabic('محمود خليل الحصري')));
      expect(husary, isNotEmpty);
      expect(husary.first.moshafs.first.url(1), endsWith('/001.mp3'));
    });

    test('API down + nothing cached → snapshot, with the error details', () async {
      SharedPreferences.setMockInitialValues({});
      final tried = <String>[];
      ListenStore.httpGetOverride = (uri, _) async {
        tried.add(uri.host);
        throw const SocketException('Failed host lookup');
      };
      final list = await ListenStore.load(force: true);
      expect(list.length, greaterThan(200));
      expect(ListenStore.fromSnapshot, isTrue);
      expect(ListenStore.stale, isTrue);
      expect(tried, ['www.mp3quran.net', 'mp3quran.net']);
      expect(ListenStore.lastError, contains('Failed host lookup'));
      expect(ListenStore.lastError, contains('mp3quran.net:'));
    });

    test('second host answers when the first is blocked', () async {
      SharedPreferences.setMockInitialValues({});
      ListenStore.httpGetOverride = (uri, _) async {
        if (uri.host.startsWith('www.')) throw TimeoutException();
        final body = jsonEncode({
          'reciters': [
            {
              'id': 5,
              'name': 'قارئ',
              'moshaf': [
                {'id': 1, 'name': 'حفص عن عاصم - مرتل', 'server': 'https://cdn.example/r/', 'surah_list': '1,2'},
              ],
            },
          ],
        });
        return http.Response.bytes(utf8.encode(body), 200);
      };
      final list = await ListenStore.load(force: true);
      expect(list.single.id, 5);
      expect(ListenStore.fromSnapshot, isFalse);
      expect(ListenStore.stale, isFalse);
      ListenStore.httpGetOverride = null;
    });
  });

  testWidgets('night app bars: back arrow and actions are white', (tester) async {
    await tester.pumpWidget(MaterialApp(
      theme: AppTheme.light,
      home: Builder(
        builder: (context) => TextButton(
          onPressed: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => ToolScaffold(
              title: 'x',
              actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.info_outline_rounded))],
              children: const [],
            ),
          )),
          child: const Text('go'),
        ),
      ),
    ));
    await tester.tap(find.text('go'));
    await tester.pumpAndSettle();
    Color? colorOf(Finder f) {
      final rich = tester.widget<RichText>(find.descendant(of: f, matching: find.byType(RichText)).first);
      return rich.text.style?.color;
    }

    expect(colorOf(find.byType(BackButton)), Colors.white);
    expect(colorOf(find.byIcon(Icons.info_outline_rounded)), Colors.white);
  });
}

class TimeoutException implements Exception {
  @override
  String toString() => 'TimeoutException after 0:00:20';
}
