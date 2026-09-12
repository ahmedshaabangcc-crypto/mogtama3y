import 'package:supabase_flutter/supabase_flutter.dart';

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
      await _ensureProfileAndWallet(user.id, fallbackName: fullName, fallbackPhone: phone);
    }
    return res.session != null;
  }

  static Future<void> signInWithEmail({required String email, required String password}) async {
    final res = await _client.auth.signInWithPassword(email: email, password: password);
    final user = res.user;
    if (user != null) {
      await _ensureProfileAndWallet(user.id, fallbackName: null, fallbackPhone: null);
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
  /// signUpWithEmail/signInWithEmail — the underlying insert is
  /// idempotent (checks for an existing row first).
  static void listenAndSyncProfile() {
    _client.auth.onAuthStateChange.listen((data) {
      final user = data.session?.user;
      if (data.event == AuthChangeEvent.signedIn && user != null) {
        _ensureProfileAndWallet(user.id, fallbackName: null, fallbackPhone: null);
      }
    });
  }

  static Future<Map<String, dynamic>?> fetchCurrentProfile() async {
    final user = currentUser;
    if (user == null) return null;
    return _client.from('profiles').select().eq('id', user.id).maybeSingle();
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

  /// Creates the `profiles` and `wallets` rows for [userId] if they don't
  /// already exist — covers both the fresh-signup path and a first login
  /// after confirming an email (where sign-up never had an active session).
  static Future<void> _ensureProfileAndWallet(
    String userId, {
    required String? fallbackName,
    required String? fallbackPhone,
  }) async {
    final existingProfile = await _client.from('profiles').select('id').eq('id', userId).maybeSingle();
    if (existingProfile == null) {
      // Email confirmation delays profile creation until first login, by
      // which point the sign-up form's name/phone are long gone — fall
      // back to the metadata stashed on the auth user at sign-up time
      // (see signUpWithEmail's `data:` param) before the generic default.
      final metadata = currentUser?.userMetadata;
      final name = fallbackName ?? metadata?['full_name'] as String? ?? metadata?['name'] as String?;
      final phone = fallbackPhone ?? metadata?['phone'] as String?;
      // Google OAuth stashes the account photo under 'avatar_url' or
      // 'picture' depending on how Supabase mapped the provider's
      // response — a real profile picture on first login, for free.
      final avatarUrl = metadata?['avatar_url'] as String? ?? metadata?['picture'] as String?;
      await _client.from('profiles').insert({
        'id': userId,
        'full_name': (name == null || name.trim().isEmpty) ? 'عضو مُجتمعي' : name.trim(),
        if (phone != null && phone.trim().isNotEmpty) 'phone': phone.trim(),
        'avatar_url': ?avatarUrl,
      });
    }
    final existingWallet = await _client.from('wallets').select('id').eq('user_id', userId).maybeSingle();
    if (existingWallet == null) {
      await _client.from('wallets').insert({'user_id': userId});
    }
  }
}
