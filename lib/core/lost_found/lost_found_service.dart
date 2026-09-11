import 'package:crypto/crypto.dart' show sha256;
import 'dart:convert';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../auth/auth_service.dart';
import '../union/union_service.dart';

/// Real lost & found items, scoped to the reporter's own building — see
/// backend/migrations/0005_lost_found.sql.
class LostFoundService {
  LostFoundService._();

  static SupabaseClient get _client => Supabase.instance.client;

  /// Items reported in the current user's building, newest first. Returns
  /// an empty list if they haven't joined/founded a building yet.
  static Future<List<Map<String, dynamic>>> fetchItems() async {
    final membership = await UnionService.fetchMyMembership();
    final buildingId = membership?['building_id'] as String?;
    if (buildingId == null) return [];
    final rows = await _client
        .from('lost_found_items')
        .select()
        .eq('building_id', buildingId)
        .eq('is_resolved', false)
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(rows as List);
  }

  /// Reports a lost or found item for the current user's building.
  /// [secretMark], if provided, is hashed (never stored in plain text) —
  /// matching lost_found_items.secret_mark_hash in the schema.
  static Future<void> reportItem({
    required String type, // 'lost' | 'found'
    required String category,
    required String title,
    required String locationNote,
    String? secretMark,
    double? rewardAmount,
  }) async {
    final userId = AuthService.currentUser?.id;
    if (userId == null) {
      throw Exception('يجب تسجيل الدخول أولاً');
    }
    final membership = await UnionService.fetchMyMembership();
    final buildingId = membership?['building_id'] as String?;
    if (buildingId == null) {
      throw Exception('يجب الانضمام لعمارتك أولاً قبل نشر بلاغ');
    }
    await _client.from('lost_found_items').insert({
      'building_id': buildingId,
      'reporter_id': userId,
      'type': type,
      'category': category,
      'title': title,
      'location_note': locationNote,
      if (secretMark != null && secretMark.trim().isNotEmpty)
        'secret_mark_hash': sha256.convert(utf8.encode(secretMark.trim())).toString(),
      'reward_amount': ?rewardAmount,
    });
  }

  static Future<void> markResolved(String itemId) async {
    await _client.from('lost_found_items').update({'is_resolved': true}).eq('id', itemId);
  }
}
