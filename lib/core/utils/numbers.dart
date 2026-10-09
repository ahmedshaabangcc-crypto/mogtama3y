/// Number parsing for what people actually type: an Arabic keyboard gives
/// Arabic-Indic digits (٢٥) and ٫ / ٬ separators, which Dart's tryParse
/// rejects — so a price typed as «٢٥» used to read as "no price".
String latinDigits(String raw) {
  final b = StringBuffer();
  for (final r in raw.trim().runes) {
    if (r >= 0x0660 && r <= 0x0669) {
      b.writeCharCode(0x30 + r - 0x0660); // ٠-٩
    } else if (r >= 0x06F0 && r <= 0x06F9) {
      b.writeCharCode(0x30 + r - 0x06F0); // ۰-۹ (Persian keyboard)
    } else if (r == 0x066B) {
      b.write('.'); // ٫ decimal separator
    } else if (r == 0x066C || r == 0x2C || r == 0x60C || r == 0x20 || r == 0xA0) {
      // thousands separators (٬ , ،) and spaces: dropped
    } else {
      b.writeCharCode(r);
    }
  }
  return b.toString();
}

double? looseDouble(String? raw) => raw == null ? null : double.tryParse(latinDigits(raw));
num? looseNum(String? raw) => raw == null ? null : num.tryParse(latinDigits(raw));
int? looseInt(String? raw) => raw == null ? null : int.tryParse(latinDigits(raw));
