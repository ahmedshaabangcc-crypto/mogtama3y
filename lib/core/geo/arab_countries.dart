/// The 22 Arab League states the platform serves (owner decision, phase 0
/// of the Arab-world plan — see backend/migrations/0089). One table for
/// names, dial codes, currencies, default zone, capital and the national
/// mobile-number plan; the SQL twin is private.arab_phone_plan() in 0089.
library;

class ArabCountry {
  const ArabCountry({
    required this.iso,
    required this.nameAr,
    required this.dial,
    required this.currency,
    required this.tz,
    required this.capitalAr,
    required this.lat,
    required this.lng,
    required this.mobile,
    required this.example,
  });

  /// ISO 3166-1 alpha-2.
  final String iso;
  final String nameAr;

  /// Country calling code without "+" ("966").
  final String dial;

  /// ISO 4217.
  final String currency;

  /// Default IANA zone (the capital's).
  final String tz;
  final String capitalAr;
  final double lat;
  final double lng;

  /// Mobile national significant number (after the country code, no
  /// trunk 0), as a regex body — same as the SQL plan.
  final String mobile;

  /// A sample mobile number in the local (as-dialled) form, for hints.
  final String example;

  /// 🇸🇦 from the ISO code (regional-indicator letters).
  String get flag => String.fromCharCodes(iso.codeUnits.map((c) => 0x1F1E6 + c - 0x41));

  /// "+966".
  String get dialPlus => '+$dial';

  RegExp get mobilePattern => RegExp('^(?:$mobile)\$');
}

/// Egypt first (most users), then the Gulf, the Levant & Iraq, Africa.
const arabCountries = <ArabCountry>[
  ArabCountry(iso: 'EG', nameAr: 'مصر', dial: '20', currency: 'EGP', tz: 'Africa/Cairo', capitalAr: 'القاهرة', lat: 30.0444, lng: 31.2357, mobile: r'1[0125]\d{8}', example: '01012345678'),
  ArabCountry(iso: 'SA', nameAr: 'السعودية', dial: '966', currency: 'SAR', tz: 'Asia/Riyadh', capitalAr: 'الرياض', lat: 24.7136, lng: 46.6753, mobile: r'5\d{8}', example: '0512345678'),
  ArabCountry(iso: 'AE', nameAr: 'الإمارات', dial: '971', currency: 'AED', tz: 'Asia/Dubai', capitalAr: 'أبوظبي', lat: 24.4539, lng: 54.3773, mobile: r'5[0-9]\d{7}', example: '0501234567'),
  ArabCountry(iso: 'KW', nameAr: 'الكويت', dial: '965', currency: 'KWD', tz: 'Asia/Kuwait', capitalAr: 'الكويت', lat: 29.3759, lng: 47.9774, mobile: r'[4569]\d{7}', example: '51234567'),
  ArabCountry(iso: 'QA', nameAr: 'قطر', dial: '974', currency: 'QAR', tz: 'Asia/Qatar', capitalAr: 'الدوحة', lat: 25.2854, lng: 51.5310, mobile: r'[3567]\d{7}', example: '33123456'),
  ArabCountry(iso: 'BH', nameAr: 'البحرين', dial: '973', currency: 'BHD', tz: 'Asia/Bahrain', capitalAr: 'المنامة', lat: 26.2285, lng: 50.5860, mobile: r'[36]\d{7}', example: '36001234'),
  ArabCountry(iso: 'OM', nameAr: 'عُمان', dial: '968', currency: 'OMR', tz: 'Asia/Muscat', capitalAr: 'مسقط', lat: 23.5880, lng: 58.3829, mobile: r'[79]\d{7}', example: '92123456'),
  ArabCountry(iso: 'YE', nameAr: 'اليمن', dial: '967', currency: 'YER', tz: 'Asia/Aden', capitalAr: 'صنعاء', lat: 15.3694, lng: 44.1910, mobile: r'7\d{8}', example: '0712345678'),
  ArabCountry(iso: 'JO', nameAr: 'الأردن', dial: '962', currency: 'JOD', tz: 'Asia/Amman', capitalAr: 'عمّان', lat: 31.9539, lng: 35.9106, mobile: r'7[789]\d{7}', example: '0791234567'),
  ArabCountry(iso: 'PS', nameAr: 'فلسطين', dial: '970', currency: 'ILS', tz: 'Asia/Hebron', capitalAr: 'القدس', lat: 31.7683, lng: 35.2137, mobile: r'5[69]\d{7}', example: '0591234567'),
  ArabCountry(iso: 'LB', nameAr: 'لبنان', dial: '961', currency: 'LBP', tz: 'Asia/Beirut', capitalAr: 'بيروت', lat: 33.8938, lng: 35.5018, mobile: r'3\d{6}|7[0-9]\d{6}|8[01]\d{6}', example: '03123456'),
  ArabCountry(iso: 'SY', nameAr: 'سوريا', dial: '963', currency: 'SYP', tz: 'Asia/Damascus', capitalAr: 'دمشق', lat: 33.5138, lng: 36.2765, mobile: r'9\d{8}', example: '0912345678'),
  ArabCountry(iso: 'IQ', nameAr: 'العراق', dial: '964', currency: 'IQD', tz: 'Asia/Baghdad', capitalAr: 'بغداد', lat: 33.3152, lng: 44.3661, mobile: r'7[3-9]\d{8}', example: '07712345678'),
  ArabCountry(iso: 'SD', nameAr: 'السودان', dial: '249', currency: 'SDG', tz: 'Africa/Khartoum', capitalAr: 'الخرطوم', lat: 15.5007, lng: 32.5599, mobile: r'[19]\d{8}', example: '0912345678'),
  ArabCountry(iso: 'LY', nameAr: 'ليبيا', dial: '218', currency: 'LYD', tz: 'Africa/Tripoli', capitalAr: 'طرابلس', lat: 32.8872, lng: 13.1913, mobile: r'9[1-6]\d{7}', example: '0912345678'),
  ArabCountry(iso: 'TN', nameAr: 'تونس', dial: '216', currency: 'TND', tz: 'Africa/Tunis', capitalAr: 'تونس', lat: 36.8065, lng: 10.1815, mobile: r'[2459]\d{7}', example: '20123456'),
  ArabCountry(iso: 'DZ', nameAr: 'الجزائر', dial: '213', currency: 'DZD', tz: 'Africa/Algiers', capitalAr: 'الجزائر', lat: 36.7538, lng: 3.0588, mobile: r'[567]\d{8}', example: '0551234567'),
  ArabCountry(iso: 'MA', nameAr: 'المغرب', dial: '212', currency: 'MAD', tz: 'Africa/Casablanca', capitalAr: 'الرباط', lat: 34.0209, lng: -6.8416, mobile: r'[67]\d{8}', example: '0612345678'),
  ArabCountry(iso: 'MR', nameAr: 'موريتانيا', dial: '222', currency: 'MRU', tz: 'Africa/Nouakchott', capitalAr: 'نواكشوط', lat: 18.0735, lng: -15.9582, mobile: r'[234]\d{7}', example: '22123456'),
  ArabCountry(iso: 'SO', nameAr: 'الصومال', dial: '252', currency: 'SOS', tz: 'Africa/Mogadishu', capitalAr: 'مقديشو', lat: 2.0469, lng: 45.3182, mobile: r'[679]\d{7,8}', example: '0612345678'),
  ArabCountry(iso: 'DJ', nameAr: 'جيبوتي', dial: '253', currency: 'DJF', tz: 'Africa/Djibouti', capitalAr: 'جيبوتي', lat: 11.5721, lng: 43.1456, mobile: r'77\d{6}', example: '77123456'),
  ArabCountry(iso: 'KM', nameAr: 'جزر القمر', dial: '269', currency: 'KMF', tz: 'Indian/Comoro', capitalAr: 'موروني', lat: -11.7172, lng: 43.2473, mobile: r'[34]\d{6}', example: '3212345'),
];

final Map<String, ArabCountry> arabCountryByIso = {for (final c in arabCountries) c.iso: c};

/// The Arab country of an ISO code (null for others / unknown).
ArabCountry? arabCountry(String? iso) => iso == null ? null : arabCountryByIso[iso.toUpperCase()];

/// Whether [iso] is one of the 22 states.
bool isArabCountry(String? iso) => arabCountry(iso) != null;

/// Egypt (the default when nothing else is known).
ArabCountry get egypt => arabCountryByIso['EG']!;

/// The Arab country whose calling code starts [digits] (longest match).
ArabCountry? arabCountryOfDialDigits(String digits) {
  ArabCountry? best;
  for (final c in arabCountries) {
    if (digits.startsWith(c.dial) && (best == null || c.dial.length > best.dial.length)) best = c;
  }
  return best;
}
