class RatioRangeCheck {
  const RatioRangeCheck({
    required this.key,
    required this.label,
    required this.actual,
    required this.minimum,
    required this.maximum,
  });

  final String key;
  final String label;
  final int actual;
  final int minimum;
  final int maximum;
}

int parseRatio(String text) => _parseFixed(text, '比例', max: 10000);

int parseWeight(String text) => _parseFixed(text, '重量');

String formatFixed(int value) =>
    '${value ~/ 100}.${(value % 100).toString().padLeft(2, '0')}';

List<int> allocatePlannedWeights(int total, List<int> ratios) {
  if (total <= 0) throw ArgumentError.value(total, 'total', '目标总重必须大于 0');
  if (ratios.isEmpty || ratios.any((ratio) => ratio < 0)) {
    throw ArgumentError.value(ratios, 'ratios', '比例无效');
  }
  if (ratios.fold(0, (sum, ratio) => sum + ratio) != 10000) {
    throw ArgumentError.value(ratios, 'ratios', '比例合计必须为 100.00%');
  }
  final result = <int>[
    for (final ratio in ratios) (total * ratio + 5000) ~/ 10000,
  ];
  final delta = total - result.fold<int>(0, (sum, value) => sum + value);
  final target = _largestIndex(result);
  result[target] += delta;
  if (result[target] < 0) throw StateError('计划克重无法分配');
  return result;
}

List<int> projectFinalWeights(List<int> planned, List<int?> entered) {
  if (planned.length != entered.length || planned.isEmpty) {
    throw ArgumentError('计划和实际克重数量不一致');
  }
  return [for (var i = 0; i < planned.length; i++) entered[i] ?? planned[i]];
}

List<int> calculateFinalRatios(List<int> weights) {
  if (weights.isEmpty || weights.any((weight) => weight < 0)) {
    throw ArgumentError.value(weights, 'weights', '最终克重无效');
  }
  final total = weights.fold<int>(0, (sum, weight) => sum + weight);
  if (total <= 0) throw ArgumentError.value(total, 'weights', '最终总重必须大于 0');
  final result = <int>[
    for (final weight in weights) (weight * 10000 + total ~/ 2) ~/ total,
  ];
  result[_largestIndex(weights)] +=
      10000 - result.fold<int>(0, (sum, value) => sum + value);
  return result;
}

List<RatioRangeCheck> checkRecommendationRanges({
  required Map<String, int> actualRatios,
  required Map<String, ({String label, int minimum, int maximum})> ranges,
}) => [
  for (final entry in actualRatios.entries)
    if (ranges[entry.key] case final range?
        when entry.value < range.minimum || entry.value > range.maximum)
      RatioRangeCheck(
        key: entry.key,
        label: range.label,
        actual: entry.value,
        minimum: range.minimum,
        maximum: range.maximum,
      ),
];

int _parseFixed(String text, String label, {int max = 2147483647}) {
  final normalized = text.trim();
  if (!RegExp(r'^\d+(?:\.\d{1,2})?$').hasMatch(normalized)) {
    throw FormatException('$label必须是最多两位小数的非负数字');
  }
  final parts = normalized.split('.');
  final value =
      int.parse(parts[0]) * 100 +
      (parts.length == 1 ? 0 : int.parse(parts[1].padRight(2, '0')));
  if (value > max) throw FormatException('$label超出允许范围');
  return value;
}

int _largestIndex(List<int> values) {
  var target = 0;
  for (var i = 1; i < values.length; i++) {
    if (values[i] > values[target]) target = i;
  }
  return target;
}
