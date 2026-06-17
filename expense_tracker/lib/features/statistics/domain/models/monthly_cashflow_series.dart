import 'dart:math';

import 'package:expense_tracker/features/statistics/domain/models/monthly_cashflow_point.dart';

class MonthlyCashflowSeries {
  const MonthlyCashflowSeries({required this.points});

  final List<MonthlyCashflowPoint> points;

  static const int _maxMonthsForNetLine = 12;

  bool get hasInsufficientData => points.length < 2;

  bool get isEmpty {
    return points.isEmpty ||
        points.every((point) => point.income == 0 && point.expenses == 0);
  }

  bool get showNetLine {
    return points.length >= 2 && points.length <= _maxMonthsForNetLine;
  }

  double get maxBarValue {
    if (points.isEmpty) {
      return 0;
    }

    return points
        .map((point) => max(point.income, point.expenses))
        .reduce(max);
  }

  static const double _axisPaddingFactor = 1.15;

  double get chartMinY {
    if (!showNetLine) {
      return 0;
    }

    final minNet = points.map((point) => point.netCashflow).reduce(min);
    if (minNet >= 0) {
      return 0;
    }

    return minNet * _axisPaddingFactor;
  }

  double get chartMaxY {
    final maxBar = max(maxBarValue, 1.0);
    if (!showNetLine) {
      return maxBar * _axisPaddingFactor;
    }

    final maxNet = points.map((point) => point.netCashflow).reduce(max);
    return max(max(maxBar, maxNet), 1.0) * _axisPaddingFactor;
  }
}
