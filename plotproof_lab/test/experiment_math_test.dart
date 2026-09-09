import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:plotproof_lab/domain/experiment_math.dart';

void main() {
  group('ExperimentMath', () {
    test('truncated baseline exposes visual amplification', () {
      final amplification = ExperimentMath.visibleDifferenceRatio(
        lowValue: 96,
        highValue: 99,
        axisMinimum: 95,
        axisMaximum: 100,
      );

      expect(amplification, closeTo(20, 0.001));
    });

    test('precision plot uses its explicit axis maximum', () {
      expect(
        ExperimentMath.visibleDifferenceRatio(
          lowValue: 74,
          highValue: 78,
          axisMinimum: 70,
          axisMaximum: 82,
        ),
        closeTo(82 / 12, 0.001),
      );
      expect(
        ExperimentMath.visibleDifferenceRatio(
          lowValue: 74,
          highValue: 78,
          axisMinimum: 0,
          axisMaximum: 82,
        ),
        closeTo(1, 0.001),
      );
    });

    test('correlation reacts to a high leverage point', () {
      final aligned = <math.Point<double>>[
        const math.Point<double>(1, 1),
        const math.Point<double>(2, 2),
        const math.Point<double>(3, 3),
        const math.Point<double>(4, 4),
      ];
      final withOutlier = [...aligned, const math.Point<double>(9, 1)];

      expect(ExperimentMath.correlation(aligned), closeTo(1, 0.001));
      expect(ExperimentMath.correlation(withOutlier), lessThan(0.3));
    });

    test('weighted sample estimate follows composition', () {
      expect(
        ExperimentMath.weightedRate(
          firstRate: 0.9,
          secondRate: 0.3,
          firstWeight: 0.95,
        ),
        closeTo(0.87, 0.001),
      );
      expect(
        ExperimentMath.weightedRate(
          firstRate: 0.9,
          secondRate: 0.3,
          firstWeight: 0.2,
        ),
        closeTo(0.42, 0.001),
      );
    });

    test('relative and absolute risk remain distinct', () {
      final relative = ExperimentMath.relativeRiskReduction(
        baseline: 0.02,
        observed: 0.01,
      );

      expect(relative, 0.5);
      expect(0.02 - 0.01, 0.01);
    });
  });
}
