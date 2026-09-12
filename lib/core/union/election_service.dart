import 'package:supabase_flutter/supabase_flutter.dart';

import '../auth/auth_service.dart';

/// Real president/board elections — see
/// backend/migrations/0021_elections.sql. Unlike founding a building
/// (instant president, no vote), this is for an existing building
/// running a real succession election; finalizing actually hands over
/// the union_members.role if quorum is met.
class ElectionService {
  ElectionService._();

  static SupabaseClient get _client => Supabase.instance.client;

  static Future<Map<String, dynamic>?> fetchLatestElection(String buildingId) async {
    return _client
        .from('union_elections')
        .select()
        .eq('building_id', buildingId)
        .order('created_at', ascending: false)
        .limit(1)
        .maybeSingle();
  }

  static Future<List<Map<String, dynamic>>> fetchCandidates(String electionId) async {
    final rows = await _client
        .from('union_candidates')
        .select('*, profile:profiles(full_name)')
        .eq('election_id', electionId)
        .order('vote_count', ascending: false);
    return List<Map<String, dynamic>>.from(rows as List);
  }

  static Future<String?> fetchMyVoteCandidateId(String electionId) async {
    final userId = AuthService.currentUser?.id;
    if (userId == null) return null;
    final row = await _client
        .from('union_votes')
        .select('candidate_id')
        .eq('election_id', electionId)
        .eq('voter_id', userId)
        .maybeSingle();
    return row?['candidate_id'] as String?;
  }

  static Future<String> createElection({
    required String title,
    required DateTime closesAt,
    double legalQuorumPct = 65.0,
  }) async {
    final result = await _client.rpc('create_election', params: {
      'p_title': title,
      'p_closes_at': closesAt.toUtc().toIso8601String(),
      'p_legal_quorum_pct': legalQuorumPct,
    });
    return result as String;
  }

  static Future<void> nominateSelf({required String electionId, required String pledge}) async {
    await _client.rpc('nominate_self', params: {'p_election_id': electionId, 'p_pledge': pledge});
  }

  static Future<void> castVote({required String electionId, required String candidateId}) async {
    await _client.rpc('cast_election_vote', params: {'p_election_id': electionId, 'p_candidate_id': candidateId});
  }

  static Future<void> finalizeElection(String electionId) async {
    await _client.rpc('finalize_election', params: {'p_election_id': electionId});
  }
}
