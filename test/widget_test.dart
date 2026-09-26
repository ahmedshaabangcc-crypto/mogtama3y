import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:mogtama3y/main.dart';

/// In-memory PKCE storage so Supabase can initialize in tests without
/// shared_preferences / a real platform.
class _MemoryAsyncStorage extends GotrueAsyncStorage {
  final _items = <String, String>{};

  @override
  Future<String?> getItem({required String key}) async => _items[key];

  @override
  Future<void> setItem({required String key, required String value}) async => _items[key] = value;

  @override
  Future<void> removeItem({required String key}) async => _items.remove(key);
}

void main() {
  setUpAll(() async {
    // A signed-out client pointed at nowhere: every request fails (the
    // test HTTP client never reaches the network), which also exercises
    // the screens' error handling instead of hanging on a spinner.
    await Supabase.initialize(
      url: 'http://localhost:54321',
      publishableKey: 'test-key',
      authOptions: FlutterAuthClientOptions(
        localStorage: const EmptyLocalStorage(),
        pkceAsyncStorage: _MemoryAsyncStorage(),
        detectSessionInUri: false,
      ),
    );
  });

  testWidgets('Home screen renders the guest landing content', (WidgetTester tester) async {
    await tester.pumpWidget(const MogtamayApp());
    await tester.pump();

    expect(find.text('مُجتمعي'), findsOneWidget);
    expect(find.text('أقسام الحي والخدمات'), findsOneWidget);
  });
}
