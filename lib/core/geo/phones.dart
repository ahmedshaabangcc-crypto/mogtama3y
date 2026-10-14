/// Phone numbers for the 22 Arab states — the Dart twin of 0089's
/// private.norm_phone / phone_store / phone_country / wa_digits.
///
/// Storage decision (0089): Egyptian mobiles keep their historic local
/// form «01xxxxxxxxx» (every existing row, login, lookup and the SMS
/// verification use it); every other number is stored in E.164
/// («+9665xxxxxxxx»). [storePhone] gives that form, [normalizePhone] always
/// E.164. Both accept local input in the given country (with or without the
/// trunk 0), +/00 international input, spaces/dashes and Arabic-Indic
/// digits. Numbers of the 22 states must be mobiles of that country; other
/// countries' numbers are accepted when they look like E.164.
library;

import 'arab_countries.dart';

/// Spaces, dashes, dots, brackets, slashes, no-break space, direction marks.
const _separators = {0x20, 0x2D, 0x2E, 0x28, 0x29, 0x2F, 0xA0, 0x200E, 0x200F, 0x202A, 0x202C};

/// «٠١٢» / «۰۱۲» → «012», and drops spaces, dashes, dots, brackets, slashes.
String phoneDigitsOnly(String raw) {
  final b = StringBuffer();
  for (final r in raw.trim().runes) {
    if (r >= 0x660 && r <= 0x669) {
      b.writeCharCode(0x30 + r - 0x660);
    } else if (r >= 0x6F0 && r <= 0x6F9) {
      b.writeCharCode(0x30 + r - 0x6F0);
    } else if (r == 0x2B /* + */ || (r >= 0x30 && r <= 0x39)) {
      b.writeCharCode(r);
    } else if (_separators.contains(r)) {
      continue;
    } else {
      return '?'; // letters etc. → invalid
    }
  }
  return b.toString();
}

String? _fromInternational(String d, {required bool arabOnly}) {
  final c = arabCountryOfDialDigits(d);
  if (c != null) {
    var n = d.substring(c.dial.length);
    if (n.startsWith('0')) n = n.substring(1);
    return c.mobilePattern.hasMatch(n) ? '+${c.dial}$n' : null;
  }
  if (!arabOnly && RegExp(r'^[1-9]\d{7,14}$').hasMatch(d)) return '+$d';
  return null;
}

/// E.164 («+201012345678», «+966512345678») or null when it isn't a valid
/// mobile. Local input is read in [country] (ISO2, default Egypt).
String? normalizePhone(String? raw, {String? country}) {
  if (raw == null) return null;
  final v = phoneDigitsOnly(raw);
  if (v.isEmpty || v.contains('?')) return null;
  if (v.startsWith('+')) {
    final d = v.substring(1);
    return RegExp(r'^\d+$').hasMatch(d) ? _fromInternational(d, arabOnly: false) : null;
  }
  if (!RegExp(r'^\d+$').hasMatch(v)) return null;
  if (v.startsWith('00')) return _fromInternational(v.substring(2), arabOnly: false);
  final c = arabCountry(country) ?? egypt;
  final n = v.startsWith('0') ? v.substring(1) : v;
  if (c.mobilePattern.hasMatch(n)) return '+${c.dial}$n';
  // Country code typed without "+" («2010…», «9665…»).
  return _fromInternational(v, arabOnly: true);
}

/// The stored form: «01xxxxxxxxx» for Egypt, E.164 for everyone else.
String? storePhone(String? raw, {String? country}) {
  final e = normalizePhone(raw, country: country);
  if (e == null) return null;
  return e.startsWith('+20') ? '0${e.substring(3)}' : e;
}

/// A value read back from the database (already 01… / E.164, or an old
/// free-text row) in the stored form, or null when it isn't a mobile.
/// «01…» always means Egypt here, whatever the reader's country.
String? canonicalPhone(String? stored) => storePhone(stored, country: 'EG');

/// Whether [raw] is a valid mobile (in [country] when written locally).
bool isValidPhone(String? raw, {String? country}) => normalizePhone(raw, country: country) != null;

/// ISO country of a stored / E.164 number (null when unknown or not one
/// of the 22 states).
String? phoneCountry(String? phone) {
  final e = normalizePhone(phone, country: 'EG');
  if (e == null) return null;
  return arabCountryOfDialDigits(e.substring(1))?.iso;
}

/// Egyptian number (the only ones we can verify by SMS)?
bool isEgyptianPhone(String? phone) => phoneCountry(phone) == 'EG';

/// Digits for wa.me («201012345678», «971501234567»). Unparseable values
/// fall back to their digits (old free-text rows) — null when none.
String? waDigits(String? phone, {String? country}) {
  if (phone == null) return null;
  final e = normalizePhone(phone, country: country);
  if (e != null) return e.substring(1);
  final d = phoneDigitsOnly(phone).replaceAll(RegExp(r'[^0-9]'), '');
  if (d.isEmpty) return null;
  if (RegExp(r'^01\d{9}$').hasMatch(d)) return '2$d';
  return d;
}

/// `https://wa.me/<digits>?text=…` (just the share link when no number).
Uri waLink(String? phone, {String? text, String? country}) {
  final d = waDigits(phone, country: country) ?? '';
  final q = text == null || text.isEmpty ? '' : '?text=${Uri.encodeComponent(text)}';
  return Uri.parse('https://wa.me/$d$q');
}

/// tel: link (E.164 when parseable, else as typed without spaces).
Uri telLink(String phone, {String? country}) =>
    Uri.parse('tel:${normalizePhone(phone, country: country) ?? phone.replaceAll(' ', '')}');

/// For display: Egyptian numbers as stored (01…), others «+966 512345678».
String displayPhone(String? phone) {
  if (phone == null || phone.isEmpty) return '';
  final e = normalizePhone(phone, country: 'EG');
  if (e == null) return phone;
  if (e.startsWith('+20')) return '0${e.substring(3)}';
  final c = arabCountryOfDialDigits(e.substring(1));
  if (c == null) return e;
  return '+${c.dial} ${e.substring(1 + c.dial.length)}';
}

/// The national part of a stored number in [country] («+966512345678» →
/// «0512345678» / «01012345678» stays). Used to pre-fill a phone field.
({String country, String national})? splitPhone(String? phone) {
  final e = normalizePhone(phone, country: 'EG');
  if (e == null) return null;
  final c = arabCountryOfDialDigits(e.substring(1));
  if (c == null) return (country: '', national: e);
  final n = e.substring(1 + c.dial.length);
  final trunk = c.example.startsWith('0') ? '0' : '';
  return (country: c.iso, national: '$trunk$n');
}

/// Hint for a phone field in [country]: «01012345678», «0512345678»…
String phoneHint(String? country) => (arabCountry(country) ?? egypt).example;

/// International-form hint («+971501234567»; Egypt keeps «01xxxxxxxxx»).
String intlPhoneHint(String? country) {
  final c = arabCountry(country) ?? egypt;
  if (c.iso == 'EG') return '01xxxxxxxxx';
  final n = c.example.startsWith('0') ? c.example.substring(1) : c.example;
  return '+${c.dial}$n';
}

/// The one validation message (no country in it).
const invalidPhoneMessage = 'رقم موبايل مش صحيح';
