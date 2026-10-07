import 'package:supabase_flutter/supabase_flutter.dart';

/// Resident polls (تصويت السكان) and the board's official announcements —
/// see backend/migrations/0077_union_polls_and_fixes.sql. One vote per
/// apartment: the first household member to vote casts the unit's vote.
class PollsService {
  PollsService._();

  static SupabaseClient get _client => Supabase.instance.client;

  /// The building's polls (open first) with counts per option, turnout
  /// and the caller's apartment vote (`my_unit_choice`, null if not yet).
  static Future<List<Map<String, dynamic>>> fetchPolls(String buildingId) async {
    final rows = await _client.rpc('list_building_polls', params: {'p_building_id': buildingId});
    return List<Map<String, dynamic>>.from(rows as List);
  }

  static Future<void> createPoll({
    required String buildingId,
    required String question,
    required List<String> options,
    required DateTime endsAt,
  }) async {
    await _client.rpc('create_building_poll', params: {
      'p_question': question,
      'p_options': options,
      'p_ends_at': endsAt.toUtc().toIso8601String(),
      'p_building_id': buildingId,
    });
  }

  static Future<void> vote({required String pollId, required int option}) async {
    await _client.rpc('cast_poll_vote', params: {'p_poll_id': pollId, 'p_option': option});
  }

  static Future<void> closePoll(String pollId) async {
    await _client.rpc('close_building_poll', params: {'p_poll_id': pollId});
  }

  /// Posts a pinned «إعلان رسمي» and notifies every verified member.
  static Future<void> publishOfficialAnnouncement({required String buildingId, required String body}) async {
    await _client.rpc('publish_official_announcement', params: {'p_body': body, 'p_building_id': buildingId});
  }

  static Future<void> setPostPinned({required String postId, required bool pinned}) async {
    await _client.rpc('set_post_pinned', params: {'p_post_id': postId, 'p_pinned': pinned});
  }
}
