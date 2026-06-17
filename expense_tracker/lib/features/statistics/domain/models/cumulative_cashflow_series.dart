import 'dart:math';

import 'package:expense_tracker/features/statistics/domain/models/cumulative_cashflow_point.dart';

class CumulativeCashflowSeries {
  const CumulativeCashflowSeries({
    required this.points,
    this.isEmpty = false,
  });

  final List<CumulativeCashflowPoint> points;
  final bool isEmpty;

  bool get hasInsufficientData => points.length < 2;

  double get minCumulative {
    if (points.isEmpty) {
      return 0;
    }

    return points.map((point) => point.cumulativeNetCashflow).reduce(min);
  }

  double get maxCumulative {
    if (points.isEmpty) {
      return 0;
    }

    return points.map((point) => point.cumulativeNetCashflow).reduce(max);
  }

  double get chartMinY {
    final minValue = min(minCumulative, 0);
    if (minValue == 0) {
      return 0;
    }

    return minValue * 1.12;
  }

  double get chartMaxY {
    final maxValue = max(maxCumulative, 0);
    return max(maxValue, 1.0) * 1.12;
  }
}
