import 'package:supabase_flutter/supabase_flutter.dart';

import '../auth/auth_service.dart';
import '../auth/contact_phones.dart';
import 'package:mogtama3y/core/geo/money.dart';

/// Real featured-ad token economy — see
/// backend/migrations/0026_ad_tokens.sql. Works across any of the
/// three ad-shaped tables (marketplace_listings, real_estate_listings,
/// job_postings) via [featureListing]'s `listingTable` argument.
class AdTokenService {
  AdTokenService._();

  static SupabaseClient get _client => Supabase.instance.client;

  static Future<int> fetchMyBalance() async {
    final userId = AuthService.currentUser?.id;
    if (userId == null) return 0;
    final row = await _client.from('profiles').select('ad_token_balance').eq('id', userId).maybeSingle();
    return (row?['ad_token_balance'] as int?) ?? 0;
  }

  static Future<Map<String, dynamic>> fetchSettings() async {
    final row = await _client.from('ad_token_settings').select().eq('id', 1).single();
    return row;
  }

  /// Merges approved/spent activity with still-pending top-up requests
  /// into one reverse-chronological list for the wallet screen.
  static Future<List<Map<String, dynamic>>> fetchMyActivity() async {
    final userId = AuthService.currentUser?.id;
    if (userId == null) return [];

    final activity = await _client.from('ad_token_activity').select().eq('user_id', userId).order('created_at', ascending: false).limit(30);
    final pending = await _client.from('ad_token_topup_requests').select().eq('user_id', userId).eq('status', 'pending').order('created_at', ascending: false);

    final merged = [
      ...List<Map<String, dynamic>>.from(activity as List).map((a) => {
            'kind': a['kind'],
            'tokens': a['tokens'],
            'description': a['description'],
            'created_at': a['created_at'],
          }),
      ...List<Map<String, dynamic>>.from(pending as List).map((p) => {
            'kind': 'pending',
            'tokens': p['tokens_requested'],
            'description': 'طلب شحن قيد المراجعة (${money((p['amount_egp'] as num?) ?? 0, 'EGP')})',
            'created_at': p['created_at'],
          }),
    ];
    merged.sort((a, b) => (b['created_at'] as String).compareTo(a['created_at'] as String));
    return merged;
  }

  static Future<void> requestTopup({required int tokens, required String proofNote}) async {
    await _client.rpc('request_token_topup', params: {'p_tokens': tokens, 'p_proof_note': proofNote});
  }

  /// «اشحن أونلاين» (0102): starts a top-up on the platform's Fawaterak
  /// and returns its hosted checkout link. Throws [TopupProblem].
  static Future<String> startOnlineTopup(int tokens) async {
    final r = await _invoke({'action': 'pay', 'tokens': tokens});
    final url = r['redirect_to'] as String?;
    if (url == null) throw const TopupProblem('فواتيرك ماردّتش بلينك الدفع — جرّب تاني');
    return url;
  }

  /// Back from Fawaterak: asks about my online top-ups still waiting for
  /// payment (last 2 days) and credits the paid ones. True when any was
  /// credited. Never throws.
  static Future<bool> checkOnlineTopups() async {
    final userId = AuthService.currentUser?.id;
    if (userId == null) return false;
    try {
      final rows = await _client
          .from('ad_token_topup_requests')
          .select('id')
          .eq('user_id', userId)
          .eq('method', 'online')
          .eq('status', 'awaiting_payment')
          .not('intent_key', 'is', null)
          .gte('created_at', DateTime.now().toUtc().subtract(const Duration(days: 2)).toIso8601String())
          .order('created_at', ascending: false)
          .limit(3);
      var credited = false;
      for (final r in List<Map<String, dynamic>>.from(rows as List)) {
        final s = await _invoke({'action': 'status', 'id': r['id']});
        if (s['status'] == 'approved') credited = true;
      }
      return credited;
    } catch (_) {
      return false;
    }
  }

  static Future<Map<String, dynamic>> _invoke(Map<String, dynamic> body) async {
    try {
      final r = await _client.functions.invoke('tokens-checkout', body: body);
      final m = Map<String, dynamic>.from(r.data as Map? ?? const {});
      if (m['error'] is String) throw TopupProblem(m['error'] as String);
      return m;
    } on FunctionException catch (e) {
      final d = e.details;
      throw TopupProblem((d is Map ? d['error'] as String? : null) ?? 'مقدرناش نوصل للدفع دلوقتي — جرّب تاني بعد شوية');
    }
  }

  static Future<void> featureListing({required String listingTable, required String listingId, required int days}) async {
    await _client.rpc('feature_listing', params: {'p_listing_table': listingTable, 'p_listing_id': listingId, 'p_days': days});
  }

  /// Whether a fetched ad row (marketplace_listings, real_estate_listings,
  /// or job_postings) is currently within its paid feature window —
  /// checked against `featured_until` rather than trusting the raw
  /// `is_featured` flag, which stays true forever once set (there's no
  /// scheduled job anywhere in this app to flip it back off on expiry).
  static bool isCurrentlyFeatured(Map<String, dynamic> row) {
    final until = DateTime.tryParse(row['featured_until'] as String? ?? '');
    return row['is_featured'] == true && until != null && until.isAfter(DateTime.now());
  }

  /// Stable-sorts featured (and still-within-window) rows first,
  /// preserving each group's existing relative order (typically
  /// newest-first from the query).
  static List<Map<String, dynamic>> sortFeaturedFirst(List<Map<String, dynamic>> rows) {
    final featured = rows.where(isCurrentlyFeatured).toList();
    final rest = rows.where((r) => !isCurrentlyFeatured(r)).toList();
    return [...featured, ...rest];
  }

  // ---- superadmin ----

  static Future<List<Map<String, dynamic>>> fetchPendingTopups() async {
    final rows = await _client
        .from('ad_token_topup_requests')
        // ad_token_topup_requests has two FKs to profiles (user_id,
        // reviewed_by) — an unqualified 'profiles(...)' embed is
        // ambiguous to PostgREST (PGRST201).
        .select('*, requester:profiles!ad_token_topup_requests_user_id_fkey(full_name)')
        .eq('status', 'pending')
        .order('created_at', ascending: true);
    final topups = List<Map<String, dynamic>>.from(rows as List);
    await ContactPhones.attach(topups, userIdKey: 'user_id', profileKey: 'requester');
    return topups;
  }

  static Future<void> reviewTopup({required String requestId, required bool approve}) async {
    await _client.rpc('review_token_topup', params: {'p_request_id': requestId, 'p_approve': approve});
  }
}

/// A refusal to show as is.
class TopupProblem implements Exception {
  const TopupProblem(this.message);
  final String message;
  @override
  String toString() => message;
}
