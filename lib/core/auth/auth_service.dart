import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../demo/demo_mode.dart';
import '../geo/phones.dart';
import '../geo/user_country.dart';
import '../geo/world_time.dart' show deviceTimeZone;
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
    String? country,
  }) async {
    // The phone goes in its stored form (01… in Egypt, else E.164) with the
    // country it was typed in, so the server (0089) sets profiles.country.
    final iso = country ?? UserCountry.iso.value;
    final res = await _client.auth.signUp(
      email: email,
      password: password,
      data: {
        'full_name': fullName,
        'phone': storePhone(phone, country: iso) ?? phone,
        'country': iso,
        'tz': _deviceTzOrNull(),
      },
      // The confirmation link returns to the app the user signed up in
      // (مُجتمعي, the union site or the merchant app), not the Site URL.
      emailRedirectTo: kIsWeb ? '${Uri.base.origin}/' : null,
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

  static Future<void> signOut() async {
    await _client.auth.signOut();
    UserCountry.reset();
  }

  static String? _stored(String? phone) =>
      phone == null || phone.trim().isEmpty ? phone : (storePhone(phone, country: UserCountry.iso.value) ?? phone);

  static String? _deviceTzOrNull() {
    try {
      return deviceTimeZone;
    } catch (_) {
      return null;
    }
  }

  /// Profile settings: the user's country (one of the 22 Arab states).
  static Future<void> setMyCountry(String iso) async {
    await _client.rpc('set_my_country', params: {'p_country': iso, 'p_tz': null});
    UserCountry.iso.value = iso;
  }

  /// «نسيت كلمة المرور؟»: emails a reset link that opens THIS app (its
  /// own origin — مُجتمعي, the union app or متجري). Supabase's PKCE flow
  /// keeps a verifier in this browser, so the link must be opened on the
  /// same device/browser. The trailing "/" matches the `https://<site>/**`
  /// redirect allow-list entries (see [signInWithGoogle]).
  static Future<void> sendPasswordReset(String email) =>
      _client.auth.resetPasswordForEmail(email, redirectTo: kIsWeb ? '${Uri.base.origin}/' : null);

  /// Sets a new password for the signed-in (recovery) session.
  static Future<void> updatePassword(String password) => _client.auth.updateUser(UserAttributes(password: password));

  /// True once the app was opened from a password-recovery link
  /// (AuthChangeEvent.passwordRecovery) until a new password is saved.
  static final passwordRecovery = ValueNotifier<bool>(false);

  /// Watches for the recovery event. The auth stream replays past events,
  /// so this also catches the one fired while Supabase was initialising.
  static void listenForPasswordRecovery() {
    _client.auth.onAuthStateChange.listen((data) {
      if (data.event == AuthChangeEvent.passwordRecovery) passwordRecovery.value = true;
    }, onError: (_) {});
  }

  /// Redirects the whole page to Google, then back to this app's own
  /// origin — Supabase picks up the resulting session automatically
  /// from the URL fragment. The `profiles`/`wallets` rows for the
  /// signed-in user are created by [listenAndSyncProfile]'s global
  /// listener (started once in main.dart), not here — signInWithOAuth
  /// is a full page redirect, so there's no "after this call" moment
  /// to hook into on web. The trailing "/" matters: the allow-list
  /// entries are `https://<site>/**`, which a bare origin does not match
  /// (Supabase would fall back to the Site URL, mogtama3y.com).
  static Future<void> signInWithGoogle() {
    // Demo build: never redirect anywhere — roles come from the switcher.
    if (kDemo) return Future.error(const AuthException('النسخة التجريبية: استخدم مبدّل الأدوار'));
    // select_account: always show Google's account picker, so on a shared
    // or family device nobody is signed in silently with the last account.
    return _client.auth.signInWithOAuth(
      OAuthProvider.google,
      redirectTo: '${Uri.base.origin}/',
      queryParams: const {'prompt': 'select_account'},
    );
  }

  /// Starts a process-lifetime listener that creates the profiles/
  /// wallets rows for ANY sign-in, including Google OAuth (which has
  /// no name/phone to fall back to — see _ensureProfileAndWallet).
  /// Safe to leave running alongside the explicit calls in
  /// signUpWithEmail/signInWithEmail — ensure_my_profile is idempotent.
  static void listenAndSyncProfile() {
    _client.auth.onAuthStateChange.listen((data) async {
      if (data.event == AuthChangeEvent.initialSession && data.session?.user != null) {
        await loadMyCountry();
      }
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
        .select('id, full_name, phone_hidden, avatar_url, is_verified, role, ad_token_balance, created_at, updated_at, phone_verified_at, country, currency, tz')
        .eq('id', user.id)
        .maybeSingle();
    if (profile == null) return null;
    UserCountry.fromProfile(profile);
    final phones = await ContactPhones.fetch([user.id]);
    return {...profile, 'phone': phones[user.id]};
  }

  static Future<void> updateProfile({String? fullName, String? phone, bool? phoneHidden, String? avatarUrl}) async {
    final user = currentUser;
    if (user == null) throw Exception('يجب تسجيل الدخول أولاً');
    await _client.from('profiles').update({
      'full_name': ?fullName,
      'phone': ?_stored(phone),
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
    await loadMyCountry();
  }

  /// Loads profiles.country into [UserCountry] (phone fields default to
  /// it). Quietly keeps the device guess when the column isn't there yet.
  static Future<void> loadMyCountry() async {
    final user = currentUser;
    if (user == null) return;
    try {
      final row = await _client.from('profiles').select('country').eq('id', user.id).maybeSingle();
      UserCountry.fromProfile(row);
    } catch (_) {}
  }
}
