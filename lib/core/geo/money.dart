/// Money in any currency — «150 ج.م», «75.5 ر.س», «1,250 د.إ». The Dart
/// twin of 0089's private.money_text (phase 2 moves every «ج.م» to it).
library;

import 'world_time.dart' show currencyLabel;

export 'world_time.dart' show currencyLabel;

/// Currencies whose minor unit is 3 digits (fils / baisa / millime / dirham).
const _threeDecimals = {'KWD', 'BHD', 'OMR', 'JOD', 'IQD', 'LYD', 'TND'};

String _group(String digits) {
  final b = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) b.write(',');
    b.write(digits[i]);
  }
  return b.toString();
}

/// [amount] with up to 2 (3 for KWD/BHD/OMR/JOD/IQD/LYD/TND) decimals,
/// trailing zeros dropped, thousands grouped, then the Arabic currency
/// label of [currency] (EGP when null).
String money(num amount, [String? currency]) {
  final code = (currency ?? 'EGP').toUpperCase();
  final places = _threeDecimals.contains(code) ? 3 : 2;
  final neg = amount < 0;
  var s = amount.abs().toStringAsFixed(places);
  if (s.contains('.')) s = s.replaceFirst(RegExp(r'\.?0+$'), '');
  final parts = s.split('.');
  final whole = _group(parts[0]);
  final text = parts.length > 1 ? '$whole.${parts[1]}' : whole;
  return '${neg ? '-' : ''}$text ${currencyLabel(code)}';
}

/// Rough units per 1 EGP of the currencies bigger than the pound — the
/// twin of 0092's private.currency_rate (only those ≥ 1 matter for caps).
const _unitsPerEgp = {
  'DZD': 3, 'DJF': 4, 'KMF': 10, 'SOS': 12, 'IQD': 30, 'YER': 35, 'SDG': 50, 'SYP': 300, 'LBP': 2000, 'IRR': 2000,
};

/// An EGP-scale upper limit (1000 ج.م delivery, 100,000 ج.م tutor…) in
/// [currency]: bigger for LBP / IQD / SYP…, never smaller than in EGP —
/// 0092's private.money_cap.
num moneyCap(num egp, [String? currency]) => egp * (_unitsPerEgp[(currency ?? 'EGP').toUpperCase()] ?? 1);

/// ISO currency of a row (its `currency` column, 0092), EGP when missing.
String currencyOf(Map<dynamic, dynamic>? row) {
  final c = row?['currency'];
  return c is String && c.length == 3 ? c.toUpperCase() : 'EGP';
}

/// [amount] in the currency of [row] (a listing, shop, product, order…).
String moneyOf(Map<dynamic, dynamic>? row, num amount) => money(amount, currencyOf(row));

/// Arabic label of [row]'s currency — «ج.م», «ر.س»…
String currencyLabelOf(Map<dynamic, dynamic>? row) => currencyLabel(currencyOf(row));

/// What a merchant can price their store in (0099 set_shop_currency): the
/// 22 Arab states' currencies (Palestine: ₪) plus USD / EUR / GBP. Same
/// list as private.shop_currencies().
const storeCurrencies = [
  'EGP', 'SAR', 'AED', 'KWD', 'QAR', 'BHD', 'OMR', 'JOD', 'LBP', 'SYP', 'IQD', 'YER', 'SDG', 'LYD',
  'TND', 'DZD', 'MAD', 'MRU', 'SOS', 'DJF', 'KMF', 'ILS', 'USD', 'EUR', 'GBP',
];

/// Arabic names of [storeCurrencies].
const currencyNames = <String, String>{
  'EGP': 'جنيه مصري', 'SAR': 'ريال سعودي', 'AED': 'درهم إماراتي', 'KWD': 'دينار كويتي', 'QAR': 'ريال قطري',
  'BHD': 'دينار بحريني', 'OMR': 'ريال عماني', 'JOD': 'دينار أردني', 'LBP': 'ليرة لبنانية', 'SYP': 'ليرة سورية',
  'IQD': 'دينار عراقي', 'YER': 'ريال يمني', 'SDG': 'جنيه سوداني', 'LYD': 'دينار ليبي', 'TND': 'دينار تونسي',
  'DZD': 'دينار جزائري', 'MAD': 'درهم مغربي', 'MRU': 'أوقية موريتانية', 'SOS': 'شلن صومالي', 'DJF': 'فرنك جيبوتي',
  'KMF': 'فرنك قمري', 'ILS': 'شيكل', 'USD': 'دولار أمريكي', 'EUR': 'يورو', 'GBP': 'جنيه إسترليني',
};
