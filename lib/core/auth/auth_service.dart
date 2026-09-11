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
    final res = await _client.auth.signUp(email: email, password: password);
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

  static Future<Map<String, dynamic>?> fetchCurrentProfile() async {
    final user = currentUser;
    if (user == null) return null;
    return _client.from('profiles').select().eq('id', user.id).maybeSingle();
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
      await _client.from('profiles').insert({
        'id': userId,
        'full_name': (fallbackName == null || fallbackName.trim().isEmpty) ? 'عضو مُجتمعي' : fallbackName.trim(),
        if (fallbackPhone != null && fallbackPhone.trim().isNotEmpty) 'phone': fallbackPhone.trim(),
      });
    }
    final existingWallet = await _client.from('wallets').select('id').eq('user_id', userId).maybeSingle();
    if (existingWallet == null) {
      await _client.from('wallets').insert({'user_id': userId});
    }
  }
}
