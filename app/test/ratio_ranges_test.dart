import 'package:flutter_test/flutter_test.dart';
import 'package:xiangfangbu/features/ingredients/ratio_ranges_page.dart';

void main() {
  test('parses and formats percentage values without floating point', () {
    expect(parseRatioPercentage('12.5'), 1250);
    expect(parseRatioPercentage('0.01'), 1);
    expect(parseRatioPercentage('100'), 10000);
    expect(formatRatioPercentage(1250), '12.50');
    expect(() => parseRatioPercentage('100.01'), throwsFormatException);
    expect(() => parseRatioPercentage('1.234'), throwsFormatException);
    expect(() => parseRatioPercentage(''), throwsFormatException);
  });
}
