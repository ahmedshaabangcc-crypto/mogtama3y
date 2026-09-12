import 'package:supabase_flutter/supabase_flutter.dart';

/// Real board-of-directors decisions — see
/// backend/migrations/0020_board_decisions.sql. Distinct from the
/// president/board election schema (union_elections) — this is the
/// "approve this expense/appointment" governance layer.
class BoardDecisionsService {
  BoardDecisionsService._();

  static SupabaseClient get _client => Supabase.instance.client;

  static Future<List<Map<String, dynamic>>> fetchDecisions(String buildingId) async {
    final rows = await _client
        .from('board_decisions')
        .select('*, proposer:profiles(full_name), votes:board_decision_votes(choice, voter_id, profile:profiles(full_name))')
        .eq('building_id', buildingId)
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(rows as List);
  }

  static Future<String> proposeDecision({
    required String title,
    String? description,
    required bool requiresUnanimous,
  }) async {
    final result = await _client.rpc('propose_board_decision', params: {
      'p_title': title,
      'p_description': description,
      'p_requires_unanimous': requiresUnanimous,
    });
    return result as String;
  }

  static Future<void> castVote({required String decisionId, required String choice}) async {
    await _client.rpc('cast_board_vote', params: {'p_decision_id': decisionId, 'p_choice': choice});
  }
}
