/// التقويم الهجري — Umm al-Qura month lengths for 1420–1500 AH (1999–2077),
/// the tabular "Kuwaiti" arithmetic calendar outside that range.
///
/// The Umm al-Qura table is the published Saudi calendar (the same data the
/// .NET / ICU `UmAlQuraCalendar` uses). Egypt's Dar al-Ifta announces
/// Ramadan and the Eids by moon sighting, which can differ by a day, so the
/// UI offers a ±day adjustment and says so.
library;

class HijriDate {
  const HijriDate(this.year, this.month, this.day);
  final int year;
  final int month;
  final int day;

  @override
  bool operator ==(Object other) => other is HijriDate && other.year == year && other.month == month && other.day == day;

  @override
  int get hashCode => Object.hash(year, month, day);

  @override
  String toString() => '$year-$month-$day';
}

const hijriMonthNames = [
  'محرم', 'صفر', 'ربيع الأول', 'ربيع الآخر', 'جمادى الأولى', 'جمادى الآخرة',
  'رجب', 'شعبان', 'رمضان', 'شوال', 'ذو القعدة', 'ذو الحجة',
];

const gregorianMonthNames = ['يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو', 'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'];

/// DateTime.weekday (1 = Monday) → Arabic day name.
const weekdayNamesAr = {1: 'الإثنين', 2: 'الثلاثاء', 3: 'الأربعاء', 4: 'الخميس', 5: 'الجمعة', 6: 'السبت', 7: 'الأحد'};

// ------------------------------------------------------------ julian day
/// Julian Day Number (integer, noon-based) of a proleptic Gregorian date.
int gregorianToJdn(int y, int m, int d) {
  final a = (14 - m) ~/ 12;
  final yy = y + 4800 - a;
  final mm = m + 12 * a - 3;
  return d + (153 * mm + 2) ~/ 5 + 365 * yy + yy ~/ 4 - yy ~/ 100 + yy ~/ 400 - 32045;
}

DateTime jdnToGregorian(int jdn) {
  final a = jdn + 32044;
  final b = (4 * a + 3) ~/ 146097;
  final c = a - 146097 * b ~/ 4;
  final d = (4 * c + 3) ~/ 1461;
  final e = c - 1461 * d ~/ 4;
  final m = (5 * e + 2) ~/ 153;
  return DateTime.utc(100 * b + d - 4800 + m ~/ 10, m + 3 - 12 * (m ~/ 10), e - (153 * m + 2) ~/ 5 + 1);
}

int _jdnOf(DateTime g) => gregorianToJdn(g.year, g.month, g.day);

// ------------------------------------------------------- tabular (Kuwaiti)
const _tabularEpoch = 1948439; // 1 Muharram 1 AH, Thursday 15 July 622 (Julian) — the "Kuwaiti" epoch

int _tabularToJdn(int y, int m, int d) => d + ((29.5 * (m - 1)).ceil()) + (y - 1) * 354 + ((3 + 11 * y) / 30).floor() + _tabularEpoch - 1;

HijriDate _tabularFromJdn(int jdn) {
  final y = ((30 * (jdn - _tabularEpoch) + 10646) / 10631).floor();
  var m = (((jdn - (29 + _tabularToJdn(y, 1, 1))) / 29.5).ceil() + 1);
  if (m > 12) m = 12;
  if (m < 1) m = 1;
  final d = jdn - _tabularToJdn(y, m, 1) + 1;
  return HijriDate(y, m, d);
}

// ------------------------------------------------------------ Umm al-Qura
const _uqFirstYear = 1420;
const _uqStartJdn = 2451286; // 1 Muharram 1420 = 17 April 1999

/// One string per year from 1420: '1' = 30-day month, '0' = 29-day month.
const _uqMonths = [
  '010010111101', '001000111101', '100100011101', '101010010101', '101101001010', '101101011010', '010101101101', '001010110110',
  '100100111011', '010010011011', '011001010101', '011010101001', '011101010100', '101101101010', '010101101100', '101010101101',
  '010101010101', '101100101001', '101110010010', '101110101001', '010111010100', '101011011010', '010101011010', '101010101011',
  '010110010101', '011101001001', '011101100100', '101110101010', '010110110101', '001010110110', '101001010110', '110100101010',
  '111010010101', '011100101010', '011101010101', '001101011010', '100101011101', '010010011011', '101001001101', '110100100110',
  '110101010011', '010110101010', '101010101101', '010010110110', '101001010111', '010100100111', '101010010101', '101101001010',
  '101101010101', '001101101100', '100110101110', '010010110110', '101010010110', '101101001010', '110110100101', '010111010010',
  '010111011001', '001011011100', '100101101101', '010010101101', '011001010101', '011011010010', '101101101001', '001101110100',
  '100110110110', '010011010111', '001010101011', '010101001011', '011010100101', '011101010010', '101101101001', '010101101011',
  '001010101101', '100101001101', '110010010101', '110101001010', '111010100101', '011011001010', '101011010101', '010101010110',
  '110010010111',
];

/// JDN of the first day of every Umm al-Qura month (plus one past the end).
final List<int> _uqStarts = () {
  final out = <int>[_uqStartJdn];
  var j = _uqStartJdn;
  for (final y in _uqMonths) {
    for (var i = 0; i < 12; i++) {
      j += y.codeUnitAt(i) == 0x31 ? 30 : 29;
      out.add(j);
    }
  }
  return out;
}();

int get _uqLastYear => _uqFirstYear + _uqMonths.length - 1;

/// Julian Day Number of a Hijri date.
int hijriToJdn(int y, int m, int d) {
  if (y >= _uqFirstYear && y <= _uqLastYear) {
    return _uqStarts[(y - _uqFirstYear) * 12 + (m - 1)] + d - 1;
  }
  return _tabularToJdn(y, m, d);
}

HijriDate jdnToHijri(int jdn) {
  if (jdn >= _uqStarts.first && jdn < _uqStarts.last) {
    var lo = 0, hi = _uqStarts.length - 2;
    while (lo < hi) {
      final mid = (lo + hi + 1) >> 1;
      if (_uqStarts[mid] <= jdn) {
        lo = mid;
      } else {
        hi = mid - 1;
      }
    }
    return HijriDate(_uqFirstYear + lo ~/ 12, lo % 12 + 1, jdn - _uqStarts[lo] + 1);
  }
  return _tabularFromJdn(jdn);
}

/// Hijri date of a Gregorian calendar date (only y/m/d are used), shifted
/// by [adjustDays] (the user's ±day correction).
HijriDate toHijri(DateTime g, {int adjustDays = 0}) => jdnToHijri(_jdnOf(g) + adjustDays);

/// Gregorian date (UTC midnight) of a Hijri date, with the same correction.
DateTime toGregorian(int y, int m, int d, {int adjustDays = 0}) => jdnToGregorian(hijriToJdn(y, m, d) - adjustDays);

int hijriMonthLength(int y, int m) {
  final ny = m == 12 ? y + 1 : y;
  final nm = m == 12 ? 1 : m + 1;
  return hijriToJdn(ny, nm, 1) - hijriToJdn(y, m, 1);
}

/// «٢٨ ربيع الآخر ١٤٤٨ هـ».
String formatHijri(HijriDate h, {bool arabicDigits = true}) {
  String n(int v) => arabicDigits ? toArabicDigits(v) : '$v';
  return '${n(h.day)} ${hijriMonthNames[h.month - 1]} ${n(h.year)} هـ';
}

String formatGregorian(DateTime g, {bool arabicDigits = true}) {
  String n(int v) => arabicDigits ? toArabicDigits(v) : '$v';
  return '${n(g.day)} ${gregorianMonthNames[g.month - 1]} ${n(g.year)}';
}

String toArabicDigits(Object v) {
  const d = '٠١٢٣٤٥٦٧٨٩';
  return v.toString().replaceAllMapped(RegExp('[0-9]'), (m) => d[m[0]!.codeUnitAt(0) - 48]);
}

// ------------------------------------------------------------- occasions
class HijriOccasion {
  const HijriOccasion(this.name, this.month, this.day);
  final String name;
  final int month;
  final int day;
}

const hijriOccasions = [
  HijriOccasion('أول رمضان', 9, 1),
  HijriOccasion('عيد الفطر', 10, 1),
  HijriOccasion('يوم عرفة', 12, 9),
  HijriOccasion('عيد الأضحى', 12, 10),
  HijriOccasion('رأس السنة الهجرية (١ محرم)', 1, 1),
];

/// The next date of [o] on or after [today] (Gregorian, date only) and how
/// many days are left (0 = today).
({DateTime date, int daysLeft, HijriDate hijri}) nextOccasion(HijriOccasion o, DateTime today, {int adjustDays = 0}) {
  final t = _jdnOf(today);
  final h = toHijri(today, adjustDays: adjustDays);
  for (var y = h.year; y <= h.year + 1; y++) {
    final j = hijriToJdn(y, o.month, o.day) - adjustDays;
    if (j >= t) return (date: jdnToGregorian(j), daysLeft: j - t, hijri: HijriDate(y, o.month, o.day));
  }
  final j = hijriToJdn(h.year + 2, o.month, o.day) - adjustDays;
  return (date: jdnToGregorian(j), daysLeft: j - t, hijri: HijriDate(h.year + 2, o.month, o.day));
}

/// «باقي ١٢ يوم» / «النهارده» / «بكرة».
String daysLeftText(int days) {
  if (days == 0) return 'النهارده';
  if (days == 1) return 'بكرة';
  if (days == 2) return 'بعد يومين';
  if (days <= 10) return 'باقي ${toArabicDigits(days)} أيام';
  return 'باقي ${toArabicDigits(days)} يوم';
}
