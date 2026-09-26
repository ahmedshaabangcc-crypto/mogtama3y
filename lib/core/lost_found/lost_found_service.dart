import 'package:supabase_flutter/supabase_flutter.dart';

import '../union/union_service.dart';

/// Real lost & found items, scoped to the reporter's own building — see
/// backend/migrations/0005_lost_found.sql.
class LostFoundService {
  LostFoundService._();

  static SupabaseClient get _client => Supabase.instance.client;

  /// Every column except secret_mark_hash, which clients can no longer
  /// read (migration 0042) — so never select `*` here.
  static const columns = 'id, building_id, reporter_id, type, category, title, description, image_url, '
      'location_note, is_resolved, reward_amount, created_at, has_secret_mark';

  /// Items reported in the current user's building, newest first. Returns
  /// an empty list if they haven't joined/founded a building yet.
  static Future<List<Map<String, dynamic>>> fetchItems() async {
    final membership = await UnionService.fetchMyMembership();
    final buildingId = membership?['building_id'] as String?;
    if (buildingId == null) return [];
    final rows = await _client
        .from('lost_found_items')
        .select(columns)
        .eq('building_id', buildingId)
        .eq('is_resolved', false)
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(rows as List);
  }

  /// Reports a lost or found item for the current user's building.
  /// [secretMark] is sent to the server, which stores only a salted hash
  /// of it and checks claims against it (migration 0042).
  static Future<void> reportItem({
    required String type, // 'lost' | 'found'
    required String category,
    required String title,
    required String locationNote,
    String? secretMark,
    double? rewardAmount,
    String? imageUrl,
  }) async {
    await _client.rpc('report_lost_found_item', params: {
      'p_type': type,
      'p_category': category,
      'p_title': title,
      'p_location_note': locationNote,
      'p_secret_mark': secretMark,
      'p_reward_amount': rewardAmount,
      'p_image_url': imageUrl,
    });
  }

  /// "This is mine" (found item) / "I know where it is" (lost item).
  /// Returns 'verified', 'notified', 'wrong' or 'locked' — see
  /// claim_lost_found_item() in migration 0042.
  static Future<String> claimItem({required String itemId, String? answer}) async {
    final result = await _client.rpc('claim_lost_found_item', params: {'p_item_id': itemId, 'p_answer': answer});
    return result as String;
  }

  static Future<void> markResolved(String itemId) async {
    await _client.from('lost_found_items').update({'is_resolved': true}).eq('id', itemId);
  }
}
