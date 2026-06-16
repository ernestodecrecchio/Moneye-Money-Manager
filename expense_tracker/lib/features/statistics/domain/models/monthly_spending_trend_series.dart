import 'dart:math';

import 'package:expense_tracker/features/statistics/domain/models/monthly_expense_point.dart';

class MonthlySpendingTrendSeries {
  const MonthlySpendingTrendSeries({required this.points});

  final List<MonthlyExpensePoint> points;

  bool get hasInsufficientData => points.length < 2;

  bool get isEmpty {
    return points.isEmpty || points.every((point) => point.expenses == 0);
  }

  double get maxExpenses {
    if (points.isEmpty) {
      return 0;
    }

    return points.map((point) => point.expenses).reduce(max);
  }
}
