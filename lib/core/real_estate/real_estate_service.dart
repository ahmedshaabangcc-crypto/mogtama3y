import 'package:supabase_flutter/supabase_flutter.dart';

import '../auth/auth_service.dart';
import '../promote/ad_token_service.dart';
import '../union/union_service.dart';

/// Offer types (migration 0065) — value → Arabic label.
const realEstateOfferTypes = <String, String>{
  'sale': 'تمليك',
  'rent': 'إيجار',
  'rent_furnished': 'إيجار مفروش',
  'rent_old': 'إيجار قديم',
  'rent_daily': 'إيجار يومي / مصيفي',
};

/// Property types (migration 0065) — value → (Arabic label, group).
const realEstatePropertyTypes = <String, (String, String)>{
  'apartment': ('شقة', 'شقق'),
  'duplex': ('دوبلكس', 'شقق'),
  'penthouse': ('بنتهاوس', 'شقق'),
  'studio': ('ستوديو', 'شقق'),
  'roof': ('روف', 'شقق'),
  'villa': ('فيلا', 'فيلات وشاليهات'),
  'townhouse': ('تاون هاوس', 'فيلات وشاليهات'),
  'chalet': ('شاليه', 'فيلات وشاليهات'),
  'building': ('عمارة كاملة', 'عمارات'),
  'land_residential': ('أرض سكني', 'أراضي'),
  'land_agricultural': ('أرض زراعي', 'أراضي'),
  'land_commercial': ('أرض تجاري', 'أراضي'),
  'land_industrial': ('أرض صناعي', 'أراضي'),
  'shop': ('محل', 'تجاري وإداري'),
  'office': ('مكتب إداري', 'تجاري وإداري'),
  'clinic': ('عيادة', 'تجاري وإداري'),
  'warehouse': ('مخزن', 'تجاري وإداري'),
  'garage': ('جراج', 'تجاري وإداري'),
};

/// Property groups in display order.
const realEstateGroups = ['شقق', 'فيلات وشاليهات', 'عمارات', 'أراضي', 'تجاري وإداري'];

const realEstateFinishing = <String, String>{'super_lux': 'سوبر لوكس', 'lux': 'لوكس', 'semi': 'نص تشطيب', 'bare': 'على الطوب'};
const realEstatePayment = <String, String>{'cash': 'كاش', 'installments': 'تقسيط', 'both': 'كاش أو تقسيط'};

/// Land, warehouses and garages have no rooms/floor to ask about.
bool realEstateHasRooms(String propertyType) =>
    !propertyType.startsWith('land_') && !const {'warehouse', 'garage', 'building'}.contains(propertyType);

/// Real peer-to-peer real estate listings — see
/// backend/migrations/0023_real_estate.sql and 0065_real_estate_details.sql.
class RealEstateService {
  RealEstateService._();

  static SupabaseClient get _client => Supabase.instance.client;

  /// Active listings, with [hide_from_own_building] actually enforced
  /// client-side against the caller's own building (unlike the
  /// pre-existing marketplace flag, which nothing ever filters on).
  static Future<List<Map<String, dynamic>>> fetchListings({
    String? dealType,
    String? offerType,
    String? group,
    String? governorate,
    double? priceMax,
    int? bedroomsMin,
    String? search,
  }) async {
    var query = _client.from('real_estate_listings').select('*, owner:profiles(full_name), building:buildings(lat, lng)').eq('status', 'active');
    if (dealType != null) query = query.eq('deal_type', dealType);
    if (offerType != null) query = query.eq('offer_type', offerType);
    if (group != null) {
      query = query.inFilter('property_type', [for (final e in realEstatePropertyTypes.entries) if (e.value.$2 == group) e.key]);
    }
    if (governorate != null) query = query.eq('governorate', governorate);
    if (priceMax != null) query = query.lte('price', priceMax);
    if (bedroomsMin != null) query = query.gte('bedrooms', bedroomsMin);
    if (search != null && search.trim().length >= 2) {
      final q = search.trim().replaceAll(RegExp(r'[%,()]'), ' ');
      query = query.or('title.ilike.%$q%,area_name.ilike.%$q%,description.ilike.%$q%');
    }
    final rows = await query.order('created_at', ascending: false).limit(60);
    final listings = List<Map<String, dynamic>>.from(rows as List);

    final membership = await UnionService.fetchMyMembership();
    final myBuildingId = membership?['building_id'] as String?;
    final visible = myBuildingId == null
        ? listings
        : listings.where((l) => !(l['hide_from_own_building'] == true && l['building_id'] == myBuildingId)).toList();
    return AdTokenService.sortFeaturedFirst(visible);
  }

  static Future<List<Map<String, dynamic>>> fetchMyListings() async {
    final userId = AuthService.currentUser?.id;
    if (userId == null) return [];
    final rows = await _client.from('real_estate_listings').select().eq('owner_id', userId).order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(rows as List);
  }

  static Future<String> createListing({
    required String offerType,
    required String propertyType,
    int? floor,
    String? finishing,
    bool furnished = false,
    String? payment,
    String? governorate,
    String? areaName,
    required String title,
    required String description,
    required double price,
    double? areaSqm,
    int? bedrooms,
    int? bathrooms,
    required bool hideFromOwnBuilding,
    List<String> images = const [],
  }) async {
    final userId = AuthService.currentUser?.id;
    if (userId == null) throw Exception('يجب تسجيل الدخول أولاً');

    // Owners' unions moved to their own app: anyone signed in may list a
    // property. A verified building is still attached when there is one.
    final fetched = await UnionService.fetchMyMembership();
    final membership = fetched?['status'] == 'verified' ? fetched! : const <String, dynamic>{};

    final row = await _client.from('real_estate_listings').insert({
      'owner_id': userId,
      'building_id': membership['building_id'],
      'unit_id': membership['unit_id'],
      'offer_type': offerType,
      'property_type': propertyType,
      'floor': floor,
      'finishing': finishing,
      'furnished': furnished || offerType == 'rent_furnished',
      'payment': payment,
      'governorate': governorate,
      'area_name': areaName,
      'title': title,
      'description': description,
      'price': price,
      'area_sqm': areaSqm,
      'bedrooms': bedrooms,
      'bathrooms': bathrooms,
      'hide_from_own_building': hideFromOwnBuilding,
      'images': images,
    }).select('id').single();
    return row['id'] as String;
  }

  static Future<void> removeListing(String listingId) async {
    await _client.from('real_estate_listings').update({'status': 'removed'}).eq('id', listingId);
  }

  static Future<void> expressInterest(String listingId) async {
    await _client.rpc('express_interest_in_listing', params: {'p_listing_id': listingId});
  }
}
