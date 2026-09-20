import 'dart:math' as math;

class ExperimentMath {
  const ExperimentMath._();

  static double visibleDifferenceRatio({
    required double lowValue,
    required double highValue,
    required double axisMinimum,
    required double axisMaximum,
  }) {
    if (axisMaximum <= 0 || axisMaximum <= axisMinimum) {
      throw ArgumentError('Axis maximum must be positive and above minimum.');
    }
    if (highValue <= lowValue ||
        lowValue < axisMinimum ||
        highValue > axisMaximum) {
      throw ArgumentError('Values must be ordered and inside the axis range.');
    }
    final honestDifference = (highValue - lowValue) / axisMaximum;
    final visibleDifference =
        (highValue - lowValue) / (axisMaximum - axisMinimum);
    return visibleDifference / honestDifference;
  }

  static double correlation(List<math.Point<double>> points) {
    if (points.length < 2) {
      throw ArgumentError('At least two points are required.');
    }
    final xMean =
        points.map((point) => point.x).reduce((a, b) => a + b) / points.length;
    final yMean =
        points.map((point) => point.y).reduce((a, b) => a + b) / points.length;
    var numerator = 0.0;
    var xSquares = 0.0;
    var ySquares = 0.0;
    for (final point in points) {
      final x = point.x - xMean;
      final y = point.y - yMean;
      numerator += x * y;
      xSquares += x * x;
      ySquares += y * y;
    }
    final denominator = math.sqrt(xSquares * ySquares);
    return denominator == 0 ? 0 : numerator / denominator;
  }

  static double weightedRate({
    required double firstRate,
    required double secondRate,
    required double firstWeight,
  }) {
    if (firstWeight < 0 || firstWeight > 1) {
      throw RangeError.range(firstWeight, 0, 1, 'firstWeight');
    }
    return firstRate * firstWeight + secondRate * (1 - firstWeight);
  }

  static double relativeRiskReduction({
    required double baseline,
    required double observed,
  }) {
    if (baseline <= 0 || observed < 0) {
      throw ArgumentError('Rates must be non-negative and baseline positive.');
    }
    return (baseline - observed) / baseline;
  }
}
