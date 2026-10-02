import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/auth/auth_service.dart';
import '../../core/e_address/e_address_service.dart';
import '../../core/theme/app_colors.dart';
import '../auth/auth_landing_screen.dart';
import '../shared/load_error_view.dart';
import 'e_address_card_screen.dart';
import 'e_address_form_screen.dart';
import 'e_address_widgets.dart';

/// mogtama3y.com/#/my-address — the owner's digital addresses.
class MyEAddressesScreen extends StatefulWidget {
  const MyEAddressesScreen({super.key});

  @override
  State<MyEAddressesScreen> createState() => _MyEAddressesScreenState();
}

class _MyEAddressesScreenState extends State<MyEAddressesScreen> {
  List<Map<String, dynamic>>? _items;
  bool _error = false;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    if (!AuthService.isSignedIn || _loading) return;
    _loading = true;
    if (mounted) setState(() => _error = false);
    try {
      final rows = await EAddressService.myAddresses();
      if (mounted) setState(() => _items = rows);
    } catch (_) {
      if (mounted) setState(() => _error = true);
    } finally {
      _loading = false;
    }
  }

  Future<void> _open(Map<String, dynamic> a) async {
    await Navigator.of(context).push(MaterialPageRoute(builder: (_) => EAddressCardScreen(address: a)));
    _load();
  }

  Future<void> _add() async {
    final saved = await Navigator.of(context).push<Map<String, dynamic>>(MaterialPageRoute(builder: (_) => const EAddressFormScreen()));
    await _load();
    if (saved != null && mounted) {
      final fresh = _items?.firstWhere((a) => a['code'] == saved['code'], orElse: () => saved) ?? saved;
      _open(fresh);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('عنوانك الإلكتروني')),
      body: StreamBuilder<AuthState>(
        stream: AuthService.authStateChanges,
        builder: (context, _) {
          if (!AuthService.isSignedIn) return _signedOut();
          if (_error) return LoadErrorView(onRetry: _load);
          final items = _items;
          if (items == null) {
            // Also covers signing in while this screen is open.
            WidgetsBinding.instance.addPostFrameCallback((_) => _load());
            return const Center(child: CircularProgressIndicator());
          }
          return RefreshIndicator(
            onRefresh: _load,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
              children: [
                const EAddressIntro(),
                const SizedBox(height: 18),
                if (items.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Text('لسه ماعملتش عنوان. دوس «أضف عنوان» وابدأ.',
                        textAlign: TextAlign.center, style: TextStyle(color: AppColors.inkMuted)),
                  ),
                for (final a in items) ...[
                  EAddressCard(address: a, showQr: false, onTap: () => _open(a)),
                  const SizedBox(height: 12),
                ],
              ],
            ),
          );
        },
      ),
      floatingActionButton: AuthService.isSignedIn && (_items?.length ?? 0) < 5
          ? FloatingActionButton.extended(
              onPressed: _add,
              icon: const Icon(Icons.add_location_alt_rounded),
              label: const Text('أضف عنوان'),
            )
          : null,
    );
  }

  Widget _signedOut() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const EAddressIntro(),
        const SizedBox(height: 20),
        ElevatedButton.icon(
          onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AuthLandingScreen())),
          icon: const Icon(Icons.login_rounded),
          label: const Text('سجّل دخول واعمل عنوانك ببلاش'),
        ),
      ],
    );
  }
}
