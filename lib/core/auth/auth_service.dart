import 'package:supabase_flutter/supabase_flutter.dart';

import 'contact_phones.dart';

/// Thin wrapper around Supabase Auth for مُجتمعي: email/password sign-up
/// and sign-in, plus creating the matching `profiles` + `wallets` rows
/// the rest of the app expects to exist for every signed-in user.
class AuthService {
  AuthService._();

  static SupabaseClient get _client => Supabase.instance.client;

  static User? get currentUser => _client.auth.currentUser;
  static bool get isSignedIn => currentUser != null;
  static Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;

  /// Returns true if the account is signed in immediately (no email
  /// confirmation required by the project's Auth settings), false if a
  /// confirmation email was sent and the session isn't active yet.
  static Future<bool> signUpWithEmail({
    required String fullName,
    required String phone,
    required String email,
    required String password,
  }) async {
    final res = await _client.auth.signUp(
      email: email,
      password: password,
      data: {'full_name': fullName, 'phone': phone},
    );
    final user = res.user;
    if (user == null) {
      throw Exception('تعذر إنشاء الحساب، حاول مرة أخرى.');
    }
    if (res.session != null) {
      await _ensureProfileAndWallet();
    }
    return res.session != null;
  }

  static Future<void> signInWithEmail({required String email, required String password}) async {
    final res = await _client.auth.signInWithPassword(email: email, password: password);
    if (res.user != null) {
      await _ensureProfileAndWallet();
    }
  }

  static Future<void> signOut() => _client.auth.signOut();

  /// Redirects the whole page to Google, then back to this app's own
  /// origin — Supabase picks up the resulting session automatically
  /// from the URL fragment. The `profiles`/`wallets` rows for the
  /// signed-in user are created by [listenAndSyncProfile]'s global
  /// listener (started once in main.dart), not here — signInWithOAuth
  /// is a full page redirect, so there's no "after this call" moment
  /// to hook into on web.
  static Future<void> signInWithGoogle() {
    return _client.auth.signInWithOAuth(OAuthProvider.google, redirectTo: Uri.base.origin);
  }

  /// Starts a process-lifetime listener that creates the profiles/
  /// wallets rows for ANY sign-in, including Google OAuth (which has
  /// no name/phone to fall back to — see _ensureProfileAndWallet).
  /// Safe to leave running alongside the explicit calls in
  /// signUpWithEmail/signInWithEmail — ensure_my_profile is idempotent.
  static void listenAndSyncProfile() {
    _client.auth.onAuthStateChange.listen((data) async {
      if (data.event == AuthChangeEvent.signedIn && data.session?.user != null) {
        try {
          await _ensureProfileAndWallet();
        } catch (_) {
          // Never let a profile/wallet sync failure take down the auth
          // listener — the rest of the app already handles a missing
          // profile/wallet gracefully on the screens that need one.
        }
      }
    });
  }

  static Future<Map<String, dynamic>?> fetchCurrentProfile() async {
    final user = currentUser;
    if (user == null) return null;
    // Explicit columns: `phone` isn't selectable directly (migration
    // 0038), so `select()` / `*` would fail — the user's own number comes
    // back through get_contact_phones instead.
    final profile = await _client
        .from('profiles')
        .select('id, full_name, phone_hidden, avatar_url, is_verified, role, ad_token_balance, created_at, updated_at')
        .eq('id', user.id)
        .maybeSingle();
    if (profile == null) return null;
    final phones = await ContactPhones.fetch([user.id]);
    return {...profile, 'phone': phones[user.id]};
  }

  static Future<void> updateProfile({String? fullName, String? phone, bool? phoneHidden, String? avatarUrl}) async {
    final user = currentUser;
    if (user == null) throw Exception('يجب تسجيل الدخول أولاً');
    await _client.from('profiles').update({
      'full_name': ?fullName,
      'phone': ?phone,
      'phone_hidden': ?phoneHidden,
      'avatar_url': ?avatarUrl,
      'updated_at': DateTime.now().toUtc().toIso8601String(),
    }).eq('id', user.id);
  }

  /// Makes sure the signed-in user has their `profiles` + `wallets` rows.
  /// They're created server-side (a trigger on auth.users, migration
  /// 0037) from the name/phone/avatar in the auth user's metadata — the
  /// client is no longer allowed to insert them itself. This RPC is the
  /// idempotent fallback for accounts created before that trigger
  /// existed, so calling it on every sign-in is safe.
  static Future<void> _ensureProfileAndWallet() async {
    await _client.rpc('ensure_my_profile');
  }
}
