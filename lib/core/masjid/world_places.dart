/// Compact world tables for «مسجدي» outside Egypt: time-zone rules (the
/// fallback when the browser's Intl isn't there — tests, non-web), the
/// main city of each zone (default place when location is off, the
/// qibla / reminders city pickers), and countries by bounding box (for the
/// prayer-time method and the currency). Kept small on purpose.
library;

/// DST rule families for the fallback offset computation.
enum TzRule { none, eu, us, eg, au, il }

class TzZone {
  const TzZone(this.tz, this.std, this.rule, this.iso, this.city, this.lat, this.lng);

  /// IANA name.
  final String tz;

  /// Standard offset, minutes east of UTC.
  final int std;
  final TzRule rule;

  /// ISO 3166-1 alpha-2 of the zone's country.
  final String iso;

  /// Main city (Arabic) and its coordinates.
  final String city;
  final double lat;
  final double lng;
}

const tzZones = <TzZone>[
  TzZone('Africa/Cairo', 120, TzRule.eg, 'EG', 'القاهرة', 30.0444, 31.2357),
  TzZone('Asia/Dubai', 240, TzRule.none, 'AE', 'دبي', 25.2048, 55.2708),
  TzZone('Asia/Riyadh', 180, TzRule.none, 'SA', 'الرياض', 24.7136, 46.6753),
  TzZone('Asia/Kuwait', 180, TzRule.none, 'KW', 'الكويت', 29.3759, 47.9774),
  TzZone('Asia/Qatar', 180, TzRule.none, 'QA', 'الدوحة', 25.2854, 51.5310),
  TzZone('Asia/Bahrain', 180, TzRule.none, 'BH', 'المنامة', 26.2285, 50.5860),
  TzZone('Asia/Muscat', 240, TzRule.none, 'OM', 'مسقط', 23.5880, 58.3829),
  TzZone('Asia/Aden', 180, TzRule.none, 'YE', 'صنعاء', 15.3694, 44.1910),
  TzZone('Asia/Baghdad', 180, TzRule.none, 'IQ', 'بغداد', 33.3152, 44.3661),
  TzZone('Asia/Amman', 180, TzRule.none, 'JO', 'عمّان', 31.9539, 35.9106),
  TzZone('Asia/Damascus', 180, TzRule.none, 'SY', 'دمشق', 33.5138, 36.2765),
  TzZone('Asia/Beirut', 120, TzRule.eu, 'LB', 'بيروت', 33.8938, 35.5018),
  TzZone('Asia/Gaza', 120, TzRule.il, 'PS', 'غزة', 31.5017, 34.4668),
  TzZone('Asia/Hebron', 120, TzRule.il, 'PS', 'القدس', 31.7683, 35.2137),
  TzZone('Asia/Jerusalem', 120, TzRule.il, 'IL', 'القدس', 31.7683, 35.2137),
  TzZone('Africa/Khartoum', 120, TzRule.none, 'SD', 'الخرطوم', 15.5007, 32.5599),
  TzZone('Africa/Tripoli', 120, TzRule.none, 'LY', 'طرابلس', 32.8872, 13.1913),
  TzZone('Africa/Tunis', 60, TzRule.none, 'TN', 'تونس', 36.8065, 10.1815),
  TzZone('Africa/Algiers', 60, TzRule.none, 'DZ', 'الجزائر', 36.7538, 3.0588),
  TzZone('Africa/Casablanca', 60, TzRule.none, 'MA', 'الدار البيضاء', 33.5731, -7.5898),
  TzZone('Africa/Nouakchott', 0, TzRule.none, 'MR', 'نواكشوط', 18.0735, -15.9582),
  TzZone('Africa/Mogadishu', 180, TzRule.none, 'SO', 'مقديشو', 2.0469, 45.3182),
  TzZone('Africa/Djibouti', 180, TzRule.none, 'DJ', 'جيبوتي', 11.5721, 43.1456),
  TzZone('Africa/Addis_Ababa', 180, TzRule.none, 'ET', 'أديس أبابا', 9.0300, 38.7400),
  TzZone('Africa/Nairobi', 180, TzRule.none, 'KE', 'نيروبي', -1.2921, 36.8219),
  TzZone('Africa/Dar_es_Salaam', 180, TzRule.none, 'TZ', 'دار السلام', -6.7924, 39.2083),
  TzZone('Africa/Lagos', 60, TzRule.none, 'NG', 'لاجوس', 6.5244, 3.3792),
  TzZone('Africa/Dakar', 0, TzRule.none, 'SN', 'داكار', 14.7167, -17.4677),
  TzZone('Africa/Bamako', 0, TzRule.none, 'ML', 'باماكو', 12.6392, -8.0029),
  TzZone('Africa/Niamey', 60, TzRule.none, 'NE', 'نيامي', 13.5116, 2.1254),
  TzZone('Africa/Ndjamena', 60, TzRule.none, 'TD', 'انجامينا', 12.1348, 15.0557),
  TzZone('Africa/Johannesburg', 120, TzRule.none, 'ZA', 'جوهانسبرج', -26.2041, 28.0473),
  TzZone('Europe/Istanbul', 180, TzRule.none, 'TR', 'إسطنبول', 41.0082, 28.9784),
  TzZone('Asia/Tehran', 210, TzRule.none, 'IR', 'طهران', 35.6892, 51.3890),
  TzZone('Asia/Kabul', 270, TzRule.none, 'AF', 'كابول', 34.5553, 69.2075),
  TzZone('Asia/Karachi', 300, TzRule.none, 'PK', 'كراتشي', 24.8607, 67.0011),
  TzZone('Asia/Kolkata', 330, TzRule.none, 'IN', 'دلهي', 28.6139, 77.2090),
  TzZone('Asia/Calcutta', 330, TzRule.none, 'IN', 'دلهي', 28.6139, 77.2090),
  TzZone('Asia/Dhaka', 360, TzRule.none, 'BD', 'دكا', 23.8103, 90.4125),
  TzZone('Asia/Colombo', 330, TzRule.none, 'LK', 'كولومبو', 6.9271, 79.8612),
  TzZone('Indian/Maldives', 300, TzRule.none, 'MV', 'ماليه', 4.1755, 73.5093),
  TzZone('Asia/Tashkent', 300, TzRule.none, 'UZ', 'طشقند', 41.2995, 69.2401),
  TzZone('Asia/Almaty', 300, TzRule.none, 'KZ', 'ألماتي', 43.2220, 76.8512),
  TzZone('Asia/Baku', 240, TzRule.none, 'AZ', 'باكو', 40.4093, 49.8671),
  TzZone('Asia/Jakarta', 420, TzRule.none, 'ID', 'جاكرتا', -6.2088, 106.8456),
  TzZone('Asia/Makassar', 480, TzRule.none, 'ID', 'مكاسر', -5.1477, 119.4327),
  TzZone('Asia/Kuala_Lumpur', 480, TzRule.none, 'MY', 'كوالالمبور', 3.1390, 101.6869),
  TzZone('Asia/Singapore', 480, TzRule.none, 'SG', 'سنغافورة', 1.3521, 103.8198),
  TzZone('Asia/Brunei', 480, TzRule.none, 'BN', 'بندر سري بكاوان', 4.9031, 114.9398),
  TzZone('Asia/Manila', 480, TzRule.none, 'PH', 'مانيلا', 14.5995, 120.9842),
  TzZone('Asia/Bangkok', 420, TzRule.none, 'TH', 'بانكوك', 13.7563, 100.5018),
  TzZone('Asia/Shanghai', 480, TzRule.none, 'CN', 'بكين', 39.9042, 116.4074),
  TzZone('Asia/Tokyo', 540, TzRule.none, 'JP', 'طوكيو', 35.6762, 139.6503),
  TzZone('Asia/Seoul', 540, TzRule.none, 'KR', 'سول', 37.5665, 126.9780),
  TzZone('Australia/Sydney', 600, TzRule.au, 'AU', 'سيدني', -33.8688, 151.2093),
  TzZone('Australia/Melbourne', 600, TzRule.au, 'AU', 'ملبورن', -37.8136, 144.9631),
  TzZone('Australia/Perth', 480, TzRule.none, 'AU', 'بيرث', -31.9505, 115.8605),
  TzZone('Europe/London', 0, TzRule.eu, 'GB', 'لندن', 51.5074, -0.1278),
  TzZone('Europe/Dublin', 0, TzRule.eu, 'IE', 'دبلن', 53.3498, -6.2603),
  TzZone('Europe/Lisbon', 0, TzRule.eu, 'PT', 'لشبونة', 38.7223, -9.1393),
  TzZone('Europe/Paris', 60, TzRule.eu, 'FR', 'باريس', 48.8566, 2.3522),
  TzZone('Europe/Brussels', 60, TzRule.eu, 'BE', 'بروكسل', 50.8503, 4.3517),
  TzZone('Europe/Amsterdam', 60, TzRule.eu, 'NL', 'أمستردام', 52.3676, 4.9041),
  TzZone('Europe/Berlin', 60, TzRule.eu, 'DE', 'برلين', 52.5200, 13.4050),
  TzZone('Europe/Vienna', 60, TzRule.eu, 'AT', 'فيينا', 48.2082, 16.3738),
  TzZone('Europe/Zurich', 60, TzRule.eu, 'CH', 'زيورخ', 47.3769, 8.5417),
  TzZone('Europe/Rome', 60, TzRule.eu, 'IT', 'روما', 41.9028, 12.4964),
  TzZone('Europe/Madrid', 60, TzRule.eu, 'ES', 'مدريد', 40.4168, -3.7038),
  TzZone('Europe/Stockholm', 60, TzRule.eu, 'SE', 'ستوكهولم', 59.3293, 18.0686),
  TzZone('Europe/Oslo', 60, TzRule.eu, 'NO', 'أوسلو', 59.9139, 10.7522),
  TzZone('Europe/Copenhagen', 60, TzRule.eu, 'DK', 'كوبنهاجن', 55.6761, 12.5683),
  TzZone('Europe/Warsaw', 60, TzRule.eu, 'PL', 'وارسو', 52.2297, 21.0122),
  TzZone('Europe/Sarajevo', 60, TzRule.eu, 'BA', 'سراييفو', 43.8563, 18.4131),
  TzZone('Europe/Tirane', 60, TzRule.eu, 'AL', 'تيرانا', 41.3275, 19.8187),
  TzZone('Europe/Skopje', 60, TzRule.eu, 'MK', 'سكوبيه', 41.9981, 21.4254),
  TzZone('Europe/Athens', 120, TzRule.eu, 'GR', 'أثينا', 37.9838, 23.7275),
  TzZone('Europe/Sofia', 120, TzRule.eu, 'BG', 'صوفيا', 42.6977, 23.3219),
  TzZone('Europe/Bucharest', 120, TzRule.eu, 'RO', 'بوخارست', 44.4268, 26.1025),
  TzZone('Asia/Nicosia', 120, TzRule.eu, 'CY', 'نيقوسيا', 35.1856, 33.3823),
  TzZone('Europe/Moscow', 180, TzRule.none, 'RU', 'موسكو', 55.7558, 37.6173),
  TzZone('America/New_York', -300, TzRule.us, 'US', 'نيويورك', 40.7128, -74.0060),
  TzZone('America/Detroit', -300, TzRule.us, 'US', 'ديترويت', 42.3314, -83.0458),
  TzZone('America/Chicago', -360, TzRule.us, 'US', 'شيكاغو', 41.8781, -87.6298),
  TzZone('America/Denver', -420, TzRule.us, 'US', 'دنفر', 39.7392, -104.9903),
  TzZone('America/Phoenix', -420, TzRule.none, 'US', 'فينيكس', 33.4484, -112.0740),
  TzZone('America/Los_Angeles', -480, TzRule.us, 'US', 'لوس أنجلوس', 34.0522, -118.2437),
  TzZone('America/Toronto', -300, TzRule.us, 'CA', 'تورونتو', 43.6532, -79.3832),
  TzZone('America/Vancouver', -480, TzRule.us, 'CA', 'فانكوفر', 49.2827, -123.1207),
  TzZone('America/Mexico_City', -360, TzRule.none, 'MX', 'مكسيكو سيتي', 19.4326, -99.1332),
  TzZone('America/Sao_Paulo', -180, TzRule.none, 'BR', 'ساو باولو', -23.5505, -46.6333),
  TzZone('America/Argentina/Buenos_Aires', -180, TzRule.none, 'AR', 'بوينس آيرس', -34.6037, -58.3816),
];

/// More cities for the pickers (same zone as an entry above).
const extraCities = <(String, String, double, double)>[
  // (name, tz, lat, lng)
  ('مكة المكرمة', 'Asia/Riyadh', 21.4225, 39.8262),
  ('المدينة المنورة', 'Asia/Riyadh', 24.4672, 39.6024),
  ('جدة', 'Asia/Riyadh', 21.4858, 39.1925),
  ('الدمام', 'Asia/Riyadh', 26.4207, 50.0888),
  ('أبوظبي', 'Asia/Dubai', 24.4539, 54.3773),
  ('الشارقة', 'Asia/Dubai', 25.3463, 55.4209),
  ('العين', 'Asia/Dubai', 24.2075, 55.7447),
  ('البصرة', 'Asia/Baghdad', 30.5085, 47.7804),
  ('حلب', 'Asia/Damascus', 36.2021, 37.1343),
  ('أنقرة', 'Europe/Istanbul', 39.9334, 32.8597),
  ('لاهور', 'Asia/Karachi', 31.5204, 74.3587),
  ('إسلام آباد', 'Asia/Karachi', 33.6844, 73.0479),
  ('مانشستر', 'Europe/London', 53.4808, -2.2426),
  ('برمنجهام', 'Europe/London', 52.4862, -1.8904),
  ('ميلانو', 'Europe/Rome', 45.4642, 9.1900),
  ('هامبورج', 'Europe/Berlin', 53.5511, 9.9937),
  ('مارسيليا', 'Europe/Paris', 43.2965, 5.3698),
];

/// Countries whose box contains a point; the smallest box wins (so Qatar
/// beats Saudi Arabia). Egypt uses [egyptPolygon] instead, checked first.
/// (iso, minLat, maxLat, minLng, maxLng)
const countryBoxes = <(String, double, double, double, double)>[
  ('SA', 16.3, 32.2, 34.5, 55.7), ('AE', 22.6, 26.1, 51.5, 56.4), ('OM', 16.6, 26.4, 52.0, 59.9),
  ('QA', 24.4, 26.2, 50.7, 51.7), ('BH', 25.5, 26.4, 50.3, 50.8), ('KW', 28.5, 30.1, 46.5, 48.5),
  ('IQ', 29.0, 37.4, 38.8, 48.6), ('JO', 29.2, 33.4, 34.9, 39.3), ('SY', 32.3, 37.3, 35.7, 42.4),
  ('LB', 33.0, 34.7, 35.1, 36.6), ('IL', 29.4, 33.3, 34.2, 35.9), ('PS', 31.2, 31.6, 34.2, 34.6),
  ('PS', 31.3, 32.6, 34.9, 35.6), ('YE', 12.1, 19.0, 42.5, 54.6), ('TR', 35.8, 42.1, 25.6, 44.8),
  ('CY', 34.5, 35.7, 32.2, 34.6), ('IR', 25.0, 39.8, 44.0, 63.4), ('AF', 29.3, 38.5, 60.5, 75.0),
  ('PK', 23.6, 37.1, 60.8, 77.9), ('IN', 6.7, 35.7, 68.1, 97.4), ('BD', 20.6, 26.7, 88.0, 92.7),
  ('LK', 5.9, 9.9, 79.6, 82.0), ('MV', -0.7, 7.1, 72.6, 73.8), ('NP', 26.3, 30.5, 80.0, 88.3),
  ('MY', 1.2, 6.8, 99.6, 104.5), ('MY', 0.8, 7.4, 109.6, 119.3), ('SG', 1.15, 1.48, 103.6, 104.1),
  ('BN', 4.0, 5.1, 114.0, 115.4), ('ID', -11.0, 6.1, 95.0, 141.0), ('PH', 4.5, 21.2, 116.9, 126.7),
  ('TH', 5.6, 20.5, 97.3, 105.7), ('MM', 9.6, 28.6, 92.2, 101.2), ('CN', 18.0, 53.6, 73.5, 135.0),
  ('JP', 24.0, 45.6, 122.9, 146.0), ('KR', 33.0, 38.7, 124.5, 131.0), ('KZ', 40.5, 55.5, 46.5, 87.4),
  ('UZ', 37.2, 45.6, 56.0, 73.2), ('TM', 35.1, 42.8, 52.4, 66.7), ('TJ', 36.7, 41.0, 67.3, 75.2),
  ('KG', 39.2, 43.3, 69.3, 80.3), ('AZ', 38.4, 41.9, 44.8, 50.4), ('RU', 41.2, 82.0, 19.6, 180.0),
  ('GB', 49.9, 60.9, -8.2, 1.8), ('IE', 51.4, 55.4, -10.5, -6.0), ('FR', 41.3, 51.1, -5.2, 9.6),
  ('DE', 47.3, 55.1, 5.9, 15.0), ('NL', 50.75, 53.6, 3.3, 7.2), ('BE', 49.5, 51.5, 2.5, 6.4),
  ('ES', 36.0, 43.8, -9.3, 3.3), ('PT', 36.9, 42.2, -9.5, -6.2), ('IT', 36.6, 47.1, 6.6, 18.5),
  ('CH', 45.8, 47.8, 5.9, 10.5), ('AT', 46.4, 49.0, 9.5, 17.2), ('SE', 55.3, 69.1, 11.0, 24.2),
  ('NO', 58.0, 71.2, 4.6, 31.1), ('DK', 54.5, 57.8, 8.0, 12.7), ('PL', 49.0, 54.8, 14.1, 24.2),
  ('GR', 34.8, 41.8, 19.4, 28.3), ('BA', 42.5, 45.3, 15.7, 19.7), ('AL', 39.6, 42.7, 19.2, 21.1),
  ('XK', 41.8, 43.3, 20.0, 21.8), ('MK', 40.8, 42.4, 20.4, 23.1), ('BG', 41.2, 44.2, 22.3, 28.6),
  ('RO', 43.6, 48.3, 20.2, 29.7), ('US', 24.5, 49.4, -125.0, -66.9), ('US', 51.0, 71.5, -170.0, -130.0),
  ('US', 18.9, 22.3, -160.3, -154.8), ('CA', 41.7, 83.0, -141.0, -52.6),
  // Canadian cities inside the US box (Toronto, Montreal, Ottawa, Vancouver).
  ('CA', 43.4, 44.2, -80.2, -78.8), ('CA', 45.3, 45.8, -74.1, -73.4), ('CA', 45.2, 45.6, -76.0, -75.4), ('CA', 49.0, 49.4, -123.4, -122.2), ('MX', 14.5, 32.7, -117.2, -86.7),
  ('BR', -33.8, 5.3, -74.0, -34.8), ('AR', -55.0, -21.8, -73.6, -53.6), ('AU', -43.7, -10.7, 113.0, 153.7),
  ('NZ', -47.3, -34.4, 166.4, 178.6), ('ZA', -34.9, -22.1, 16.4, 32.9), ('LY', 19.5, 33.2, 9.3, 25.2),
  ('TN', 30.2, 37.6, 7.5, 11.6), ('DZ', 18.9, 37.1, -8.7, 12.0), ('MA', 27.6, 35.9, -13.2, -1.0),
  ('MA', 20.7, 27.7, -17.1, -8.7), ('MR', 14.7, 27.3, -17.1, -4.8), ('SD', 8.6, 22.3, 21.8, 38.6),
  ('SS', 3.5, 12.3, 23.4, 36.0), ('ET', 3.4, 14.9, 33.0, 48.0), ('SO', -1.7, 12.0, 40.9, 51.4),
  ('DJ', 10.9, 12.7, 41.7, 43.4), ('ER', 12.3, 18.0, 36.4, 43.2), ('KE', -4.7, 5.0, 33.9, 41.9),
  ('TZ', -11.8, -1.0, 29.3, 40.4), ('NG', 4.2, 13.9, 2.7, 14.7), ('NE', 11.7, 23.5, 0.2, 16.0),
  ('TD', 7.4, 23.5, 13.5, 24.0), ('ML', 10.1, 25.0, -12.3, 4.3), ('SN', 12.3, 16.7, -17.6, -11.3),
  ('GM', 13.0, 13.9, -16.9, -13.8), ('GN', 7.2, 12.7, -15.1, -7.6), ('CI', 4.3, 10.8, -8.6, -2.5),
  ('GH', 4.7, 11.2, -3.3, 1.2), ('BF', 9.4, 15.1, -5.5, 2.4), ('CM', 1.6, 13.1, 8.4, 16.2),
];

/// Egypt (incl. Sinai and the Halaib triangle), drawn a little into the
/// sea and along the land borders — (lat, lng). Same polygon as the
/// server's private.in_egypt() in backend/migrations/0087.
const egyptPolygon = <(double, double)>[
  (22.0, 25.0), (30.0, 25.0), (31.6, 25.15), (31.8, 25.2), (31.8, 32.5), (31.36, 34.2),
  (29.49, 34.9), (29.0, 34.75), (28.5, 34.62), (27.95, 34.47), (27.2, 34.8), (26.0, 35.3),
  (24.0, 36.4), (22.0, 37.3),
];

class CountryInfo {
  const CountryInfo(this.nameAr, this.currency, this.method);
  final String nameAr;

  /// ISO 4217.
  final String currency;

  /// Default prayer-time method id (see prayer_times.dart).
  final String method;
}

const countries = <String, CountryInfo>{
  'EG': CountryInfo('مصر', 'EGP', 'egypt'),
  'SA': CountryInfo('السعودية', 'SAR', 'umm_al_qura'),
  'AE': CountryInfo('الإمارات', 'AED', 'uae'),
  'KW': CountryInfo('الكويت', 'KWD', 'kuwait'),
  'QA': CountryInfo('قطر', 'QAR', 'qatar'),
  'BH': CountryInfo('البحرين', 'BHD', 'gulf'),
  'OM': CountryInfo('عُمان', 'OMR', 'gulf'),
  'YE': CountryInfo('اليمن', 'YER', 'umm_al_qura'),
  'IQ': CountryInfo('العراق', 'IQD', 'mwl'),
  'JO': CountryInfo('الأردن', 'JOD', 'mwl'),
  'SY': CountryInfo('سوريا', 'SYP', 'mwl'),
  'LB': CountryInfo('لبنان', 'LBP', 'mwl'),
  'PS': CountryInfo('فلسطين', 'ILS', 'mwl'),
  'IL': CountryInfo('فلسطين', 'ILS', 'mwl'),
  'SD': CountryInfo('السودان', 'SDG', 'egypt'),
  'LY': CountryInfo('ليبيا', 'LYD', 'mwl'),
  'TN': CountryInfo('تونس', 'TND', 'mwl'),
  'DZ': CountryInfo('الجزائر', 'DZD', 'mwl'),
  'MA': CountryInfo('المغرب', 'MAD', 'mwl'),
  'MR': CountryInfo('موريتانيا', 'MRU', 'mwl'),
  'TR': CountryInfo('تركيا', 'TRY', 'turkey'),
  'IR': CountryInfo('إيران', 'IRR', 'tehran'),
  'PK': CountryInfo('باكستان', 'PKR', 'karachi'),
  'IN': CountryInfo('الهند', 'INR', 'karachi'),
  'BD': CountryInfo('بنجلاديش', 'BDT', 'karachi'),
  'AF': CountryInfo('أفغانستان', 'AFN', 'karachi'),
  'MY': CountryInfo('ماليزيا', 'MYR', 'jakim'),
  'SG': CountryInfo('سنغافورة', 'SGD', 'singapore'),
  'BN': CountryInfo('بروناي', 'BND', 'singapore'),
  'ID': CountryInfo('إندونيسيا', 'IDR', 'kemenag'),
  'US': CountryInfo('أمريكا', 'USD', 'isna'),
  'CA': CountryInfo('كندا', 'CAD', 'isna'),
  'GB': CountryInfo('بريطانيا', 'GBP', 'mwl'),
  'FR': CountryInfo('فرنسا', 'EUR', 'mwl'),
  'DE': CountryInfo('ألمانيا', 'EUR', 'mwl'),
  'NL': CountryInfo('هولندا', 'EUR', 'mwl'),
  'BE': CountryInfo('بلجيكا', 'EUR', 'mwl'),
  'IT': CountryInfo('إيطاليا', 'EUR', 'mwl'),
  'ES': CountryInfo('إسبانيا', 'EUR', 'mwl'),
  'AT': CountryInfo('النمسا', 'EUR', 'mwl'),
  'IE': CountryInfo('أيرلندا', 'EUR', 'mwl'),
  'PT': CountryInfo('البرتغال', 'EUR', 'mwl'),
  'GR': CountryInfo('اليونان', 'EUR', 'mwl'),
  'CY': CountryInfo('قبرص', 'EUR', 'mwl'),
  'AU': CountryInfo('أستراليا', 'AUD', 'mwl'),
};

/// Arabic symbols for the common currencies (else the ISO code is shown).
const currencyLabels = <String, String>{
  'EGP': 'ج.م', 'AED': 'د.إ', 'SAR': 'ر.س', 'KWD': 'د.ك', 'QAR': 'ر.ق', 'BHD': 'د.ب', 'OMR': 'ر.ع',
  'JOD': 'د.أ', 'IQD': 'د.ع', 'LBP': 'ل.ل', 'SYP': 'ل.س', 'YER': 'ر.ي', 'LYD': 'د.ل', 'TND': 'د.ت',
  'DZD': 'د.ج', 'MAD': 'د.م', 'SDG': 'ج.س', 'USD': r'$', 'EUR': '€', 'GBP': '£', 'TRY': '₺',
};

/// Currencies an admin can pick for their mosque (most common first).
const pickableCurrencies = [
  'EGP', 'SAR', 'AED', 'KWD', 'QAR', 'BHD', 'OMR', 'JOD', 'IQD', 'LYD', 'TND', 'DZD', 'MAD', 'SDG',
  'TRY', 'USD', 'EUR', 'GBP', 'CAD', 'AUD', 'PKR', 'INR', 'MYR', 'IDR', 'SGD',
];
