/// Pure rules of «الربط والتكاملات» (migration 0097) — the same checks
/// the database makes, so the merchant sees the problem before saving.
library;

// ------------------------------------------------------------- gateways

class GatewayField {
  const GatewayField(this.key, this.label, {this.hint = '', this.secret = false, this.required = false, required this.pattern});
  final String key;
  final String label;
  final String hint;
  final bool secret;
  final bool required;
  final String pattern;

  bool valid(String v) => RegExp(pattern).hasMatch(v.trim());
}

class GatewaySpec {
  const GatewaySpec({
    required this.id,
    required this.name,
    required this.countries,
    required this.signupUrl,
    required this.blurb,
    required this.webhookWhere,
    required this.fields,
    this.checkoutReady = false,
  });
  final String id;
  final String name;
  final List<String> countries;
  final String signupUrl;
  final String blurb;

  /// Where the merchant pastes our webhook URL in the gateway's dashboard
  /// ('' = nothing to paste: every invoice sends it itself).
  final String webhookWhere;
  final List<GatewayField> fields;

  /// Customers can already pay with it in the store (0100: Fawaterak).
  final bool checkoutReady;

  bool availableIn(String? country) => countries.contains((country ?? 'EG').toUpperCase());
}

const gatewaySpecs = <GatewaySpec>[
  GatewaySpec(
    id: 'fawaterak',
    name: 'فواتيرك',
    countries: ['EG'],
    signupUrl: 'https://app.fawaterk.com',
    blurb: 'فيزا وماستركارد وميزة، فوري وأمان، ومحافظ الموبايل — مصر. الزبون بيدفع أونلاين من صفحة متجرك على طول.',
    webhookWhere: '',
    checkoutReady: true,
    fields: [
      GatewayField('api_key', 'API Key', hint: 'لوحة فواتيرك ← Integrations ← Fawaterak ← API Key', secret: true, required: true, pattern: r'^[A-Za-z0-9]{20,200}$'),
      GatewayField('provider_key', 'Provider Key (اختياري)', hint: 'من نفس الصفحة', pattern: r'^[A-Za-z0-9_-]{6,120}$'),
    ],
  ),
  GatewaySpec(
    id: 'paymob',
    name: 'Paymob',
    countries: ['EG', 'SA', 'AE', 'OM'],
    signupUrl: 'https://paymob.com',
    blurb: 'كروت فيزا وماستركارد وميزة، ومحافظ الموبايل — مصر والسعودية والإمارات وعُمان',
    webhookWhere: 'لوحة Paymob ← Developers ← Payment Integrations ← كل integration ← «Transaction processed callback»',
    fields: [
      GatewayField('api_key', 'API Key', hint: 'Settings ← Account Info', secret: true, required: true, pattern: r'^[A-Za-z0-9+/=._-]{20,1000}$'),
      GatewayField('secret_key', 'Secret Key (اختياري)', hint: 'egy_sk_test_…', secret: true, pattern: r'^[a-z]{3}_sk_(test|live)_[A-Za-z0-9]{8,200}$'),
      GatewayField('public_key', 'Public Key (اختياري)', hint: 'egy_pk_test_…', pattern: r'^[a-z]{3}_pk_(test|live)_[A-Za-z0-9]{8,120}$'),
      GatewayField('hmac_secret', 'HMAC Secret', hint: 'Settings ← Account Info ← HMAC', secret: true, required: true, pattern: r'^[A-Za-z0-9]{16,128}$'),
      GatewayField('card_integration_id', 'Integration ID للكروت', hint: '1234567', required: true, pattern: r'^[0-9]{3,12}$'),
      GatewayField('wallet_integration_id', 'Integration ID للمحافظ (اختياري)', hint: '1234568', pattern: r'^[0-9]{3,12}$'),
      GatewayField('iframe_id', 'iFrame ID (اختياري)', hint: '812345', pattern: r'^[0-9]{2,12}$'),
    ],
  ),
  GatewaySpec(
    id: 'kashier',
    name: 'Kashier',
    countries: ['EG'],
    signupUrl: 'https://kashier.io',
    blurb: 'كروت ومحافظ وفوري — مصر',
    webhookWhere: 'لوحة Kashier ← Integrate now ← Webhook URL',
    fields: [
      GatewayField('merchant_id', 'Merchant ID', hint: 'MID-12345-678', required: true, pattern: r'^MID-[0-9]{1,10}-[0-9]{1,10}$'),
      GatewayField('api_key', 'Payment API Key', secret: true, required: true, pattern: r'^[A-Za-z0-9-]{16,100}$'),
      GatewayField('secret_key', 'Secret Key', secret: true, required: true, pattern: r'^[A-Za-z0-9$._/-]{16,200}$'),
    ],
  ),
  GatewaySpec(
    id: 'tap',
    name: 'Tap Payments',
    countries: ['SA', 'AE', 'KW', 'QA', 'BH', 'OM', 'EG', 'JO'],
    signupUrl: 'https://www.tap.company',
    blurb: 'كروت ومدى وKNET وApple Pay — الخليج ومصر والأردن',
    webhookWhere: 'لوحة Tap ← goSell ← API Credentials ← Webhook / Post URL',
    fields: [
      GatewayField('publishable_key', 'Publishable Key', hint: 'pk_test_…', required: true, pattern: r'^pk_(test|live)_[A-Za-z0-9]{10,64}$'),
      GatewayField('secret_key', 'Secret Key', hint: 'sk_test_…', secret: true, required: true, pattern: r'^sk_(test|live)_[A-Za-z0-9]{10,64}$'),
      GatewayField('merchant_id', 'Merchant ID (اختياري)', pattern: r'^[0-9]{3,20}$'),
    ],
  ),
  GatewaySpec(
    id: 'moyasar',
    name: 'Moyasar',
    countries: ['SA'],
    signupUrl: 'https://moyasar.com',
    blurb: 'مدى وفيزا وApple Pay وSTC Pay — السعودية',
    webhookWhere: 'لوحة Moyasar ← Settings ← Webhooks ← Add webhook (والصق «Secret token» اللي تحت)',
    fields: [
      GatewayField('publishable_key', 'Publishable Key', hint: 'pk_test_…', required: true, pattern: r'^pk_(test|live)_[A-Za-z0-9]{20,64}$'),
      GatewayField('secret_key', 'Secret Key', hint: 'sk_test_…', secret: true, required: true, pattern: r'^sk_(test|live)_[A-Za-z0-9]{20,64}$'),
    ],
  ),
];

GatewaySpec? gatewaySpec(String id) => gatewaySpecs.where((g) => g.id == id).firstOrNull;

/// Problems with what the merchant typed for a gateway ('' = ok).
/// [hasSecret]: secrets already saved may stay empty (kept server-side).
String gatewayProblem(GatewaySpec spec, Map<String, String> values, String mode, {bool hasSecret = false}) {
  for (final f in spec.fields) {
    final v = (values[f.key] ?? '').trim();
    if (v.isEmpty) {
      if (f.required && !(f.secret && hasSecret)) return 'اكتب «${f.label}»';
      continue;
    }
    if (!f.valid(v)) return '«${f.label}» مش بالشكل الصحيح — انسخه زي ما هو من لوحة ${spec.name}';
    final saysTest = RegExp(r'(^|_)(pk|sk)_test_').hasMatch(v);
    final saysLive = RegExp(r'(^|_)(pk|sk)_live_').hasMatch(v);
    if (saysTest && mode == 'live' || saysLive && mode == 'test') {
      return '«${f.label}» مفتاح ${saysTest ? 'تجريبي' : 'حقيقي'} — غيّر الوضع أو المفتاح';
    }
  }
  return '';
}

/// The webhook URL each merchant pastes in their gateway (Phase 4).
String paymentsWebhookUrl(String supabaseUrl, String shopId, String provider, {String slug = 'payments-webhook'}) =>
    '$supabaseUrl/functions/v1/$slug?shop=$shopId&provider=$provider';

// ------------------------------------------------------- manual methods

/// «name@instapay» (we add @instapay) or an ipn.eg link; null when invalid.
String? normalizeInstapay(String input) {
  var v = input.trim();
  if (v.isEmpty) return null;
  // Payment links keep their case (the path may be case-sensitive).
  if (RegExp(r'^https://ipn\.eg/s/[a-z0-9/_.-]{3,120}$', caseSensitive: false).hasMatch(v)) return v;
  v = v.toLowerCase();
  if (!v.startsWith('https://') && !v.contains('@')) v = '$v@instapay';
  return RegExp(r'^[a-z0-9._-]{2,40}@instapay$').hasMatch(v) ? v : null;
}

/// IBAN (ISO 13616): shape + mod-97.
bool ibanValid(String input) {
  final s = input.replaceAll(RegExp(r'\s'), '').toUpperCase();
  if (!RegExp(r'^[A-Z]{2}[0-9]{2}[A-Z0-9]{10,30}$').hasMatch(s)) return false;
  final r = s.substring(4) + s.substring(0, 4);
  var mod = 0;
  for (final c in r.codeUnits) {
    final digits = c >= 65 ? '${c - 55}' : String.fromCharCode(c);
    for (final d in digits.codeUnits) {
      mod = (mod * 10 + (d - 48)) % 97;
    }
  }
  return mod == 1;
}

// --------------------------------------------------------------- domains

const domainCnameTarget = 'stores.mogtama3y.com';

const _twoLabelSuffixes = {
  'com.eg', 'net.eg', 'org.eg', 'edu.eg', 'gov.eg', 'sci.eg',
  'com.sa', 'net.sa', 'org.sa', 'edu.sa', 'med.sa',
  'co.ae', 'net.ae', 'org.ae', 'com.kw', 'net.kw', 'org.kw', 'com.qa', 'net.qa', 'com.bh', 'net.bh',
  'com.om', 'co.om', 'net.om', 'com.jo', 'net.jo', 'com.lb', 'net.lb', 'com.iq', 'com.ly', 'com.tn',
  'com.dz', 'co.ma', 'net.ma', 'com.sd', 'com.sy', 'com.ye', 'com.ps', 'co.uk', 'org.uk', 'com.tr', 'com.au',
};

/// What the merchant typed → the ASCII hostname (scheme / path / dot
/// stripped, Arabic labels → punycode). Validity: [hostnameProblem].
String normalizeHostname(String input) {
  var h = input.trim().toLowerCase();
  h = h.replaceFirst(RegExp(r'^[a-z]+://'), '');
  h = h.replaceFirst(RegExp(r'[/?#].*$'), '');
  h = h.replaceFirst(RegExp(r'\.+$'), '');
  return h.split('.').map((l) => RegExp(r'^[\x00-\x7f]*$').hasMatch(l) ? l : 'xn--${punycodeEncode(l)}').join('.');
}

/// '' when [h] (normalized) is fine, else the Arabic reason — mirrors
/// public.shop_hostname_problem().
String hostnameProblem(String h) {
  if (h.isEmpty) return 'اكتب الدومين';
  if (RegExp(r':[0-9]*$').hasMatch(h)) return 'اكتب الدومين من غير رقم بورت';
  if (!RegExp(r'^[a-z0-9.-]+$').hasMatch(h)) return 'اكتب الدومين بالحروف الإنجليزية (الدومين العربي يتكتب بصيغة xn--)';
  if (h.length > 253) return 'الدومين طويل قوي';
  final labels = h.split('.');
  for (final l in labels) {
    if (!RegExp(r'^[a-z0-9]([a-z0-9-]{0,61}[a-z0-9])?$').hasMatch(l)) return 'الدومين فيه جزء مش صحيح';
  }
  if (labels.length < 2) return 'الدومين لازم يبقى زي shop.example.com أو example.com';
  if (!RegExp(r'^([a-z]{2,63}|xn--[a-z0-9-]{1,59})$').hasMatch(labels.last)) return 'ده مش دومين (عناوين الـ IP مش مسموحة)';
  if (h == 'mogtama3y.com' || h.endsWith('.mogtama3y.com')) return 'ده دومين مُجتمعي نفسه — اكتب دومين بتاعك';
  if (const {'localhost', 'local', 'test', 'example', 'invalid', 'internal', 'lan', 'home', 'onion'}.contains(labels.last)) {
    return 'الدومين ده مينفعش يتوصل بالإنترنت';
  }
  return '';
}

/// A root domain (example.com, example.com.eg) can't take a CNAME.
bool isApexDomain(String h) {
  final l = h.split('.');
  return l.length == 2 || (l.length == 3 && _twoLabelSuffixes.contains('${l[1]}.${l[2]}'));
}

/// The name to type in the registrar's "Host" box for the CNAME
/// (shop.example.com → «shop»; shop.example.com.eg → «shop»).
String cnameHostLabel(String h) {
  final l = h.split('.');
  final apexLen = l.length >= 3 && _twoLabelSuffixes.contains('${l[l.length - 2]}.${l.last}') ? 3 : 2;
  return l.length > apexLen ? l.sublist(0, l.length - apexLen).join('.') : '@';
}

/// RFC 3492 Punycode (the part after «xn--») of one label.
String punycodeEncode(String input) {
  const base = 36, tMin = 1, tMax = 26, skew = 38, damp = 700;
  final cps = input.runes.toList();
  final out = StringBuffer();
  for (final c in cps) {
    if (c < 0x80) out.writeCharCode(c);
  }
  final b = out.length;
  var h = b;
  if (b > 0) out.write('-');
  int digit(int d) => d < 26 ? 97 + d : 22 + d;
  int adapt(int delta, int points, bool first) {
    delta = first ? delta ~/ damp : delta ~/ 2;
    delta += delta ~/ points;
    var k = 0;
    while (delta > ((base - tMin) * tMax) ~/ 2) {
      delta ~/= base - tMin;
      k += base;
    }
    return k + ((base - tMin + 1) * delta) ~/ (delta + skew);
  }

  var n = 128, delta = 0, bias = 72;
  while (h < cps.length) {
    var m = 0x10FFFF;
    for (final c in cps) {
      if (c >= n && c < m) m = c;
    }
    delta += (m - n) * (h + 1);
    n = m;
    for (final c in cps) {
      if (c < n) delta++;
      if (c == n) {
        var q = delta;
        for (var k = base;; k += base) {
          final t = k <= bias ? tMin : (k >= bias + tMax ? tMax : k - bias);
          if (q < t) break;
          out.writeCharCode(digit(t + (q - t) % (base - t)));
          q = (q - t) ~/ (base - t);
        }
        out.writeCharCode(digit(q));
        bias = adapt(delta, h + 1, h == b);
        delta = 0;
        h++;
      }
    }
    delta++;
    n++;
  }
  return out.toString();
}

// -------------------------------------------------------------- tracking

class TrackingField {
  const TrackingField(this.key, this.label, this.hint, this.pattern, this.help);
  final String key;
  final String label;
  final String hint;
  final String pattern;
  final String help;
}

const trackingFields = <TrackingField>[
  TrackingField('meta_pixel', 'Meta Pixel (فيسبوك وإنستجرام)', '123456789012345', r'^[0-9]{10,20}$', 'Events Manager ← Data sources ← رقم الـ Pixel'),
  TrackingField('tiktok_pixel', 'TikTok Pixel', 'C4ABCDEFGHIJ1234567K', r'^[A-Z0-9]{16,24}$', 'TikTok Ads Manager ← Assets ← Events ← Pixel ID'),
  TrackingField('snap_pixel', 'Snapchat Pixel', 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx', r'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$', 'Snap Ads Manager ← Events Manager ← Pixel ID'),
  TrackingField('ga4', 'Google Analytics 4', 'G-XXXXXXXXXX', r'^G-[A-Z0-9]{6,12}$', 'Admin ← Data streams ← Measurement ID'),
  TrackingField('gtm', 'Google Tag Manager', 'GTM-XXXXXXX', r'^GTM-[A-Z0-9]{5,9}$', 'رقم الـ Container فوق في Tag Manager'),
  TrackingField('google_ads', 'Google Ads (تحويل الشراء)', 'AW-123456789/AbCdEfGh', r'^AW-[0-9]{8,12}(/[A-Za-z0-9_-]{6,40})?$', 'Goals ← Conversions ← الشراء ← Tag setup (الـ ID والـ label)'),
];

const fbDomainVerificationField = TrackingField('fb_domain_verification', 'تأكيد ملكية الدومين في فيسبوك', 'abcdefghij0123456789abcdefghij',
    r'^[a-z0-9]{20,40}$', 'Business Settings ← Brand safety ← Domains ← Meta-tag (الصق الـ content بس أو التاج كله)');

/// What the merchant pasted (an ID, or the whole snippet / meta tag) → the
/// ID itself, normalized the way the database stores it.
String normalizeTracking(String key, String input) {
  final v = input.trim();
  if (v.isEmpty) return '';
  String? find(String pattern, String s, {bool caseSensitive = true}) => RegExp(pattern, caseSensitive: caseSensitive).firstMatch(s)?.group(1);
  switch (key) {
    case 'meta_pixel':
      return find(r"""fbq\(\s*['"]init['"]\s*,\s*['"]?([0-9]{10,20})""", v) ?? v.replaceAll(RegExp(r'[\s-]'), '');
    case 'tiktok_pixel':
      return (find(r"""ttq\.load\(\s*['"]([A-Za-z0-9]{16,24})""", v) ?? v).toUpperCase();
    case 'snap_pixel':
      return (find(r'([0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12})', v) ?? v).toLowerCase();
    case 'ga4':
      return find(r'(G-[A-Z0-9]{6,12})\b', v.toUpperCase()) ?? v.toUpperCase();
    case 'gtm':
      return find(r'(GTM-[A-Z0-9]{5,9})\b', v.toUpperCase()) ?? v.toUpperCase();
    case 'google_ads':
      final m = RegExp(r'(AW-[0-9]{8,12})(?:\s*/\s*([A-Za-z0-9_-]{6,40}))?', caseSensitive: false).firstMatch(v);
      if (m == null) return v;
      return m.group(2) == null ? m.group(1)!.toUpperCase() : '${m.group(1)!.toUpperCase()}/${m.group(2)}';
    case 'fb_domain_verification':
      return (find(r"""content\s*=\s*["']([A-Za-z0-9]{20,40})["']""", v) ?? v).toLowerCase();
  }
  return v;
}

/// '' when ok, else the Arabic reason.
String trackingProblem(String key, String normalized) {
  if (normalized.isEmpty) return '';
  final f = [...trackingFields, fbDomainVerificationField].where((f) => f.key == key).firstOrNull;
  if (f == null) return 'حقل غير معروف';
  return RegExp(f.pattern).hasMatch(normalized) ? '' : '«${f.label}» مش بالشكل الصحيح — مثال: ${f.hint}';
}

/// The pixel IDs that actually load on the storefront (not the meta tag).
Map<String, String> activePixels(Map<String, dynamic>? tracking) => {
      for (final f in trackingFields)
        if (tracking?[f.key] is String && RegExp(f.pattern).hasMatch(tracking![f.key] as String)) f.key: tracking[f.key] as String,
    };
