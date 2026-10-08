import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

import '../app_flavor.dart';
import 'demo_http_client.dart';
import 'demo_links.dart';
import 'demo_mode.dart';
import 'demo_platform.dart';
import 'demo_store.dart';

/// Boots the demo build: Supabase pointed at a dead host (`.invalid` never
/// resolves) with [DemoHttpClient] answering every request from memory,
/// and a signed-in session for the chosen `?role=` handed over through a
/// custom session storage — so the auth client never calls the network
/// (the token is valid for years and auto-refresh is off).
///
/// Only ever called from `if (kDemo)` in main.dart.
Future<void> initDemoBackend() async {
  final role = demoRoleFrom(Uri.base);
  final store = DemoStore.boot(role: role, elections: demoElectionsFrom(Uri.base), flavor: isTajerApp ? 'tajer' : 'ittihad');
  debugPrint('$kDemoMarker — local demo, role=$role, no backend.');
  // WhatsApp / calls / Google Maps / other sites: shown in a dialog, never opened.
  UrlLauncherPlatform.instance = DemoUrlLauncher();
  await Supabase.initialize(
    url: 'http://demo.invalid',
    publishableKey: 'demo-publishable-key',
    httpClient: DemoHttpClient(store),
    // The merchant app's `customer` role is a guest: no session at all.
    authOptions: FlutterAuthClientOptions(
      localStorage: _DemoSessionStorage(store.guest ? null : _sessionJson(store)),
      detectSessionInUri: false,
      autoRefreshToken: false,
    ),
  );
}

String _b64(Map<String, dynamic> json) => base64Url.encode(utf8.encode(jsonEncode(json))).replaceAll('=', '');

String _sessionJson(DemoStore store) {
  final profile = store.profileOf(store.me)!;
  final exp = DateTime.now().add(const Duration(days: 3650)).millisecondsSinceEpoch ~/ 1000;
  final token = '${_b64({'alg': 'none', 'typ': 'JWT'})}.${_b64({'sub': store.me, 'role': 'authenticated', 'aud': 'authenticated', 'exp': exp})}.demo';
  return jsonEncode({
    'access_token': token,
    'token_type': 'bearer',
    'expires_in': 3650 * 24 * 3600,
    'expires_at': exp,
    'refresh_token': 'demo-refresh-token',
    'user': {
      'id': store.me,
      'aud': 'authenticated',
      'role': 'authenticated',
      'email': 'demo-${store.role}@demo.invalid',
      'app_metadata': {'provider': 'email'},
      'user_metadata': {'full_name': profile['full_name']},
      'created_at': profile['created_at'],
    },
  });
}

/// Hands supabase_flutter the demo session; nothing is written to the
/// browser (signing out just forgets it until the next reload).
class _DemoSessionStorage extends LocalStorage {
  _DemoSessionStorage(this._session);
  String? _session;

  @override
  Future<void> initialize() async {}

  @override
  Future<bool> hasAccessToken() async => _session != null;

  @override
  Future<String?> accessToken() async => _session;

  @override
  Future<void> removePersistedSession() async => _session = null;

  @override
  Future<void> persistSession(String persistSessionString) async => _session = persistSessionString;
}

/// Shown instead of the app when the demo build is opened anywhere but
/// the local machine. Starts nothing else.
class DemoBlockedApp extends StatelessWidget {
  const DemoBlockedApp({super.key});

  @override
  Widget build(BuildContext context) => const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Demo build — local only',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
        ),
      ),
    ),
  );
}

/// A small floating "Demo role" switcher (hidden with `?panel=0`). Picking
/// a role reloads the page with `?role=…`; the data done so far in this
/// tab is kept (sessionStorage) unless «ابدأ من الأول» is pressed.
class DemoRolePanel extends StatefulWidget {
  const DemoRolePanel({super.key, required this.child});
  final Widget child;

  @override
  State<DemoRolePanel> createState() => _DemoRolePanelState();
}

class _DemoRolePanelState extends State<DemoRolePanel> {
  bool _open = false;
  final _role = demoRoleFrom(Uri.base);

  void _go(String role, {bool reset = false}) {
    if (reset) DemoStore.clearSaved();
    final base = Uri.base;
    final params = {...base.queryParameters, 'role': role};
    var fragment = base.fragment;
    if (isTajerApp) {
      // The customer lands on the demo store page; a merchant leaving the
      // customer's pages lands on their panel.
      final customerPage = fragment.startsWith('/s/') || fragment.startsWith('/o/') || fragment.startsWith('/checkout');
      if (role == 'customer' && !customerPage) fragment = '/s/$demoShopSlug';
      if (role != 'customer' && customerPage) fragment = '/';
    }
    final url = base.replace(queryParameters: params, fragment: fragment).toString();
    demoNavigate(url);
  }

  @override
  Widget build(BuildContext context) {
    if (!demoPanelVisible(Uri.base)) return widget.child;
    return Stack(
      children: [
        widget.child,
        Positioned(
          left: 6,
          top: 90,
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Material(
              color: Colors.black.withValues(alpha: 0.72),
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () => setState(() => _open = !_open),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                        child: Text(
                          'Demo: ${demoRoleLabels[_role]}',
                          style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                    if (_open) ...[
                      for (final r in demoRoles)
                        InkWell(
                          onTap: r == _role ? null : () => _go(r),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                            child: Text(
                              '${r == _role ? '● ' : ''}${demoRoleLabels[r]}',
                              style: TextStyle(color: r == _role ? Colors.amber : Colors.white, fontSize: 11.5),
                            ),
                          ),
                        ),
                      const Divider(color: Colors.white24, height: 8),
                      InkWell(
                        onTap: () => _go(_role, reset: true),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                          child: Text('↺ ابدأ من الأول', style: TextStyle(color: Colors.white70, fontSize: 11)),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// A placeholder receipt (clearly marked as a demo) for the seeded
/// expenses, shown in the fund ledger's «الإيصال».
class DemoReceiptCard extends StatelessWidget {
  const DemoReceiptCard({super.key, required this.tx});
  final Map<String, dynamic>? tx;

  @override
  Widget build(BuildContext context) {
    final amount = ((tx?['amount'] as num?) ?? 0).abs().round();
    final date = (tx?['created_at'] as String? ?? '').split('T').first;
    Widget line(String label, String value) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text('$label: ', style: const TextStyle(color: Colors.black54)),
          Expanded(
            child: Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFDF7),
        border: Border.all(color: const Color(0xFFD9D2C1)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'إيصال استلام نقدية',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
          const Text(
            'نسخة تجريبية — ليس مستنداً حقيقياً',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 11, color: Color(0xFF9A2B2B)),
          ),
          const Divider(height: 22),
          line('البيان', '${tx?['note'] ?? 'مصروف'}'),
          line('المبلغ', '$amount ج.م'),
          line('التاريخ', date),
          line('لصالح', 'عمارة النخيل — تجريبي'),
          const SizedBox(height: 12),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: Transform.rotate(
              angle: -0.2,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF22AA77), width: 2),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Text(
                  'تم الدفع',
                  style: TextStyle(color: Color(0xFF22AA77), fontWeight: FontWeight.w800),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
