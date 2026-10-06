import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

SupabaseClient get _db => Supabase.instance.client;

// Labels for the coded columns — keys must match the checks in
// migration 0066_car_listings.sql.

const carOfferTypes = <String, String>{
  'sale': 'بيع',
  'rent_daily': 'إيجار يومي',
  'rent_monthly': 'إيجار شهري',
  'parts': 'قطع غيار وإكسسوارات',
};

const carVehicleTypes = <String, String>{
  'car': 'ملاكي',
  'motorcycle': 'موتوسيكل',
  'tuktuk': 'توكتوك',
  'microbus': 'ميكروباص',
  'truck': 'نقل / ربع نقل',
};

const carTransmissions = <String, String>{
  'manual': 'مانيوال',
  'automatic': 'أوتوماتيك',
};

const carFuels = <String, String>{
  'benzine': 'بنزين',
  'diesel': 'سولار',
  'natural_gas': 'غاز طبيعي',
  'hybrid': 'هايبرد',
  'electric': 'كهربا',
};

const carBodyTypes = <String, String>{
  'sedan': 'سيدان',
  'hatchback': 'هاتشباك',
  'suv': 'SUV / جيب',
  'crossover': 'كروس أوفر',
  'coupe': 'كوبيه',
  'convertible': 'مكشوفة',
  'pickup': 'بيك أب',
  'van': 'فان',
};

const carConditions = <String, String>{
  'new': 'زيرو',
  'used': 'مستعمل',
};

const carPayments = <String, String>{
  'cash': 'كاش',
  'installments': 'تقسيط',
  'both': 'كاش أو تقسيط',
};

/// Brands sold in Egypt — cars first, then motorcycle / tuktuk makers.
const carBrands = <String>[
  'تويوتا (Toyota)',
  'هيونداي (Hyundai)',
  'كيا (Kia)',
  'نيسان (Nissan)',
  'شيفروليه (Chevrolet)',
  'ميتسوبيشي (Mitsubishi)',
  'سوزوكي (Suzuki)',
  'رينو (Renault)',
  'بيجو (Peugeot)',
  'سيتروين (Citroen)',
  'فيات (Fiat)',
  'أوبل (Opel)',
  'فولكس فاجن (Volkswagen)',
  'سكودا (Skoda)',
  'سيات (Seat)',
  'كوبرا (Cupra)',
  'فورد (Ford)',
  'جيب (Jeep)',
  'هوندا (Honda)',
  'مازدا (Mazda)',
  'سوبارو (Subaru)',
  'لكزس (Lexus)',
  'إنفينيتي (Infiniti)',
  'مرسيدس (Mercedes-Benz)',
  'بي إم دبليو (BMW)',
  'أودي (Audi)',
  'بورشه (Porsche)',
  'فولفو (Volvo)',
  'لاند روفر (Land Rover)',
  'جاكوار (Jaguar)',
  'ميني (Mini)',
  'دودج (Dodge)',
  'كرايسلر (Chrysler)',
  'كاديلاك (Cadillac)',
  'شيري (Chery)',
  'جيلي (Geely)',
  'إم جي (MG)',
  'بي واي دي (BYD)',
  'هافال (Haval)',
  'جيتور (Jetour)',
  'تشانجان (Changan)',
  'بايك (BAIC)',
  'دونج فينج (Dongfeng)',
  'جي إيه سي (GAC)',
  'أومودا (Omoda)',
  'إكسيد (Exeed)',
  'هونشي (Hongqi)',
  'جيه إيه سي (JAC)',
  'كايي (Kaiyi)',
  'سوكون (Sokon)',
  'دي إف إس كيه (DFSK)',
  'جريت وول (Great Wall)',
  'بروتون (Proton)',
  'داتسون (Datsun)',
  'لادا (Lada)',
  'سانج يونج (SsangYong)',
  'إيسوزو (Isuzu)',
  'دايو (Daewoo)',
  'سبيرانزا (Speranza)',
  'تسلا (Tesla)',
  'بجاج (Bajaj)',
  'تي في إس (TVS)',
  'ياماها (Yamaha)',
  'دايون (Dayun)',
  'هوجان (Haojue)',
  'كاواساكي (Kawasaki)',
  'فيسبا (Vespa)',
  'أخرى',
];

/// Prices like "650,000 ج.م".
String carPrice(num? price) => '${NumberFormat('#,##0').format(price ?? 0)} ج.م';

/// "/ يوم" or "/ شهر" after a rental price.
String carPriceSuffix(String? offerType) => switch (offerType) {
      'rent_daily' => ' / يوم',
      'rent_monthly' => ' / شهر',
      _ => '',
    };

/// Filters for [CarService.fetch]; nulls mean "any".
class CarFilters {
  const CarFilters({
    this.offerTypes,
    this.vehicleType,
    this.brand,
    this.yearFrom,
    this.yearTo,
    this.priceMax,
    this.transmission,
    this.fuel,
    this.governorate,
    this.query,
  });

  final List<String>? offerTypes;
  final String? vehicleType;
  final String? brand;
  final int? yearFrom;
  final int? yearTo;
  final num? priceMax;
  final String? transmission;
  final String? fuel;
  final String? governorate;
  final String? query;

  /// How many filters (beyond the offer-type tab) are on.
  int get activeCount => [vehicleType, brand, yearFrom, yearTo, priceMax, transmission, fuel, governorate].where((v) => v != null).length;

  CarFilters copyWith({List<String>? offerTypes, String? query}) => CarFilters(
        offerTypes: offerTypes ?? this.offerTypes,
        vehicleType: vehicleType,
        brand: brand,
        yearFrom: yearFrom,
        yearTo: yearTo,
        priceMax: priceMax,
        transmission: transmission,
        fuel: fuel,
        governorate: governorate,
        query: query ?? this.query,
      );
}

/// Cars marketplace — migration 0066.
class CarService {
  CarService._();

  static const _table = 'car_listings';

  static String shareUrl(String id) => 'https://mogtama3y.com/#/cars/$id';

  /// Active listings matching [f], featured first then newest.
  static Future<List<Map<String, dynamic>>> fetch([CarFilters f = const CarFilters(), int limit = 60]) async {
    var q = _db.from(_table).select().eq('status', 'active');
    if (f.offerTypes != null && f.offerTypes!.isNotEmpty) q = q.inFilter('offer_type', f.offerTypes!);
    if (f.vehicleType != null) q = q.eq('vehicle_type', f.vehicleType!);
    if (f.brand != null) q = q.eq('brand', f.brand!);
    if (f.yearFrom != null) q = q.gte('year', f.yearFrom!);
    if (f.yearTo != null) q = q.lte('year', f.yearTo!);
    if (f.priceMax != null) q = q.lte('price', f.priceMax!);
    if (f.transmission != null) q = q.eq('transmission', f.transmission!);
    if (f.fuel != null) q = q.eq('fuel', f.fuel!);
    if (f.governorate != null) q = q.eq('governorate', f.governorate!);
    final text = f.query?.trim().replaceAll(RegExp(r'[%,()*]'), ' ') ?? '';
    if (text.isNotEmpty) q = q.ilike('title', '%$text%');
    final rows = await q.order('is_featured', ascending: false).order('created_at', ascending: false).limit(limit);
    return List<Map<String, dynamic>>.from(rows);
  }

  static Future<Map<String, dynamic>?> get(String id) async =>
      await _db.from(_table).select().eq('id', id).maybeSingle();

  /// The signed-in user's listings (active, sold and removed).
  static Future<List<Map<String, dynamic>>> fetchMine() async {
    final uid = _db.auth.currentUser?.id;
    if (uid == null) return [];
    final rows = await _db.from(_table).select().eq('owner_id', uid).order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(rows);
  }

  /// Posts a listing for the signed-in user; returns its id.
  static Future<String> create(Map<String, dynamic> data) async {
    final uid = _db.auth.currentUser?.id;
    if (uid == null) throw StateError('not signed in');
    final row = await _db.from(_table).insert({...data, 'owner_id': uid}).select('id').single();
    return row['id'] as String;
  }

  static Future<void> markSold(String id) => _setStatus(id, 'sold');

  static Future<void> remove(String id) => _setStatus(id, 'removed');

  static Future<void> _setStatus(String id, String status) async {
    await _db.from(_table).update({'status': status}).eq('id', id);
  }

  /// "أنا مهتم" — notifies the owner.
  static Future<void> expressInterest(String id) async {
    await _db.rpc('express_interest_in_car', params: {'p_listing_id': id});
  }
}
