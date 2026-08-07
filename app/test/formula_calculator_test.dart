import 'package:flutter_test/flutter_test.dart';
import 'package:xiangfangbu/services/formula_calculator.dart';

void main() {
  test('parses fixed values without floating point', () {
    expect(parseRatio('2.1'), 210);
    expect(parseWeight('2.10'), 210);
    expect(() => parseRatio('1.234'), throwsFormatException);
    expect(() => parseRatio('-1'), throwsFormatException);
    expect(() => parseRatio('100.01'), throwsFormatException);
  });

  test('allocates rounding delta to the first largest item', () {
    expect(allocatePlannedWeights(1000, [3333, 3333, 3334]), [334, 333, 333]);
    expect(allocatePlannedWeights(1, [5000, 5000]), [0, 1]);
  });

  test('frozen 10.00g to 10.10g sample stays deterministic', () {
    final weights = projectFinalWeights([200, 600, 200], [210, null, null]);
    expect(weights, [210, 600, 200]);
    expect(calculateFinalRatios(weights), [2079, 5941, 1980]);
  });

  test('range checks report only exceeded values', () {
    final checks = checkRecommendationRanges(
      actualRatios: {'category:wood': 2079, 'sku:a': 5941},
      ranges: {
        'category:wood': (label: '木类', minimum: 1000, maximum: 2000),
        'sku:a': (label: '沉香', minimum: 5000, maximum: 6000),
      },
    );
    expect(checks.map((item) => item.label), ['木类']);
  });
}
