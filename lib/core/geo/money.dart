/// Money in any currency — «150 ج.م», «75.5 ر.س», «1,250 د.إ». The Dart
/// twin of 0089's private.money_text (phase 2 moves every «ج.م» to it).
library;

import 'world_time.dart' show currencyLabel;

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
