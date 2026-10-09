import 'package:flutter_test/flutter_test.dart';
import 'package:mogtama3y/core/utils/numbers.dart';

void main() {
  test('Arabic-Indic digits and separators parse', () {
    expect(looseDouble('٢٥'), 25);
    expect(looseDouble(' ١٢٫٥ '), 12.5);
    expect(looseNum('١٬٢٠٠'), 1200);
    expect(looseInt('۳۵'), 35);
    expect(looseDouble('1,500.75'), 1500.75);
    expect(looseDouble('25'), 25);
    expect(looseDouble(''), null);
    expect(looseDouble('abc'), null);
  });
}
