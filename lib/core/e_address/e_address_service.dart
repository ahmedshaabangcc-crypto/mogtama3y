import 'package:supabase_flutter/supabase_flutter.dart';

/// "عنوانك الإلكتروني": a saved address behind a short code, shared as a
/// link + QR at `mogtama3y.com/#/a/<code>`. All writes go through RPCs in
/// migration 0048 (the server owns the code and the visit counter).
class EAddressService {
  EAddressService._();

  static SupabaseClient get _client => Supabase.instance.client;

  static const publicBaseUrl = 'https://mogtama3y.com/#/a/';
  static String linkFor(String code) => '$publicBaseUrl$code';

  /// The link to share: the easy name when set, else the random code.
  /// (QR codes always use the code link, so a printed QR survives a name change.)
  static String shareLinkFor(Map<String, dynamic> a) => linkFor((a['handle'] as String?) ?? a['code'] as String);

  /// Easy names: English letters/digits, at least two words joined by -.
  /// Single-word names are premium and reserved by the platform.
  static final handlePattern = RegExp(r'^[a-z][a-z0-9]*(-[a-z0-9]+)+$');

  static Future<bool> handleAvailable(String handle, {String? selfId}) async {
    final ok = await _client.rpc('e_address_handle_available', params: {'p_handle': handle, 'p_self': selfId});
    return ok == true;
  }

  /// K7P2X9QM → MG-K7P2-X9QM (how the code is printed and read aloud).
  static String display(String code) => code.length == 8 ? 'MG-${code.substring(0, 4)}-${code.substring(4)}' : code;

  static const governorates = [
    'القاهرة', 'الجيزة', 'الإسكندرية', 'القليوبية', 'الشرقية', 'الدقهلية', 'الغربية', 'المنوفية', 'البحيرة',
    'كفر الشيخ', 'دمياط', 'بورسعيد', 'الإسماعيلية', 'السويس', 'الفيوم', 'بني سويف', 'المنيا', 'أسيوط',
    'سوهاج', 'قنا', 'الأقصر', 'أسوان', 'البحر الأحمر', 'الوادي الجديد', 'مطروح', 'شمال سيناء', 'جنوب سيناء',
  ];

  static Future<List<Map<String, dynamic>>> myAddresses() async {
    final rows = await _client.from('e_addresses').select().order('created_at');
    return List<Map<String, dynamic>>.from(rows as List);
  }

  /// Creates (id == null) or updates an address; returns its code.
  static Future<String> save({String? id, required Map<String, dynamic> fields}) async {
    final code = await _client.rpc('save_my_e_address', params: {'p_id': id, 'p': fields});
    return code as String;
  }

  static Future<String> regenerateCode(String id) async {
    final code = await _client.rpc('regenerate_e_address_code', params: {'p_id': id});
    return code as String;
  }

  static Future<void> delete(String id) => _client.from('e_addresses').delete().eq('id', id);

  /// Public lookup (guests too). Null when the code is wrong or disabled.
  static Future<Map<String, dynamic>?> lookup(String code) async {
    final result = await _client.rpc('get_e_address', params: {'p_code': code});
    return result == null ? null : Map<String, dynamic>.from(result as Map);
  }

  /// One readable line, e.g. "عمارة 12، شارع 9، المعادي، القاهرة".
  static String oneLine(Map<String, dynamic> a) {
    String? v(String k) {
      final s = (a[k] as String?)?.trim();
      return (s == null || s.isEmpty) ? null : s;
    }

    return [
      if (v('building') != null) 'عمارة ${v('building')}',
      if (v('floor') != null) 'الدور ${v('floor')}',
      if (v('apartment') != null) 'شقة ${v('apartment')}',
      v('street'),
      v('district'),
      v('city'),
      v('governorate'),
    ].whereType<String>().join('، ');
  }

  static Uri? mapsUri(Map<String, dynamic> a) {
    final lat = (a['lat'] as num?)?.toDouble();
    final lng = (a['lng'] as num?)?.toDouble();
    if (lat == null || lng == null) return null;
    return Uri.parse('https://www.google.com/maps/dir/?api=1&destination=$lat,$lng');
  }
}
