import 'package:supabase_flutter/supabase_flutter.dart';

/// Real "found a building" / "join with invite code" flow, backed by the
/// two SECURITY DEFINER functions in
/// backend/migrations/0003_union_building_flow.sql (found_building,
/// join_building_with_code) rather than raw table access — a joining
/// user never needs direct write rights on other people's rows.
class UnionService {
  UnionService._();

  static SupabaseClient get _client => Supabase.instance.client;

  /// The current user's most recent union membership, with the building
  /// embedded, or null if they haven't founded/joined one yet.
  static Future<Map<String, dynamic>?> fetchMyMembership() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return null;
    return _client
        .from('union_members')
        .select('*, building:buildings(name, district, city, governorate)')
        .eq('user_id', userId)
        .order('created_at', ascending: false)
        .limit(1)
        .maybeSingle();
  }

  /// Creates a new building with the caller as its founding, verified
  /// president. Returns the invite code to share with neighbors.
  /// If [googlePlaceId] matches a building someone else already
  /// registered, this does NOT create a duplicate — it submits a
  /// pending join request on the existing building instead, and
  /// returns 'PENDING_EXISTING' rather than an invite code.
  static Future<String> foundBuilding({
    required String name,
    required String district,
    required String city,
    required String governorate,
    required String unitNumber,
    required String floorLabel,
    String? googlePlaceId,
    double? lat,
    double? lng,
  }) async {
    final result = await _client.rpc('found_building', params: {
      'p_name': name,
      'p_district': district,
      'p_city': city,
      'p_governorate': governorate,
      'p_unit_number': unitNumber,
      'p_floor_label': floorLabel,
      'p_google_place_id': googlePlaceId,
      'p_lat': lat,
      'p_lng': lng,
    });
    return result as String;
  }

  /// Validates [code] and creates a pending union_members row for the
  /// caller (pending until the union president approves it).
  static Future<void> joinWithCode({
    required String code,
    required String unitNumber,
    required String floorLabel,
    required String residencyType,
  }) async {
    await _client.rpc('join_building_with_code', params: {
      'p_code': code,
      'p_unit_number': unitNumber,
      'p_floor_label': floorLabel,
      'p_residency_type': residencyType,
    });
  }

  /// Pending union_members rows for [buildingId], with the applicant's
  /// profile and unit embedded. Only returns rows the caller is allowed
  /// to see under the "building members can view roster" policy (i.e.
  /// the caller must already be a verified member of that building).
  static Future<List<Map<String, dynamic>>> fetchPendingMembers(String buildingId) async {
    final rows = await _client
        .from('union_members')
        .select('*, profile:profiles(full_name, phone), unit:units(unit_number, floor_label)')
        .eq('building_id', buildingId)
        .eq('status', 'pending')
        .order('created_at', ascending: true);
    return List<Map<String, dynamic>>.from(rows as List);
  }

  /// Approves or rejects a pending member — only succeeds server-side if
  /// the caller is a verified president/board_member of that building.
  static Future<void> reviewMember({required String memberId, required bool approve}) async {
    await _client.rpc('review_union_member', params: {
      'p_member_id': memberId,
      'p_approve': approve,
    });
  }

  /// All verified members of [buildingId], with their profile and unit
  /// embedded — used by the president/board to pick a guard candidate.
  static Future<List<Map<String, dynamic>>> fetchVerifiedMembers(String buildingId) async {
    final rows = await _client
        .from('union_members')
        .select('*, profile:profiles(full_name, phone), unit:units(unit_number, floor_label)')
        .eq('building_id', buildingId)
        .eq('status', 'verified')
        .order('created_at', ascending: true);
    return List<Map<String, dynamic>>.from(rows as List);
  }

  // ---- Tenant sub-accounts — see backend/migrations/0018_tenant_accounts.sql ----

  /// The units the caller owns (is the primary owner of), with the
  /// building name embedded — the units they're allowed to manage
  /// tenants for.
  static Future<List<Map<String, dynamic>>> fetchMyOwnedUnits() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return [];
    final rows = await _client
        .from('unit_residents')
        .select('unit:units(id, unit_number, floor_label, building:buildings(name))')
        .eq('user_id', userId)
        .eq('residency_type', 'owner')
        .eq('is_primary', true);
    return List<Map<String, dynamic>>.from(rows as List);
  }

  /// Generates a single-use tenant invite code for [unitId] — only
  /// succeeds server-side if the caller is that unit's primary owner.
  static Future<String> inviteTenant({required String unitId}) async {
    final result = await _client.rpc('invite_tenant_for_unit', params: {'p_unit_id': unitId});
    return result as String;
  }

  /// Redeems a tenant invite code — instantly verified, no president
  /// review, since the inviting owner already vouched for the tenant.
  static Future<void> joinAsTenant({required String code}) async {
    await _client.rpc('join_as_tenant_with_code', params: {'p_code': code});
  }

  /// The current tenants living in [unitId], with their profile embedded.
  static Future<List<Map<String, dynamic>>> fetchUnitTenants({required String unitId}) async {
    final rows = await _client
        .from('unit_residents')
        .select('*, profile:profiles(full_name, phone)')
        .eq('unit_id', unitId)
        .eq('residency_type', 'tenant');
    return List<Map<String, dynamic>>.from(rows as List);
  }

  /// Revokes a tenant's access to [unitId] — only succeeds server-side
  /// if the caller is that unit's primary owner.
  static Future<void> revokeTenant({required String unitId, required String tenantUserId}) async {
    await _client.rpc('revoke_tenant', params: {'p_unit_id': unitId, 'p_tenant_user_id': tenantUserId});
  }
}
