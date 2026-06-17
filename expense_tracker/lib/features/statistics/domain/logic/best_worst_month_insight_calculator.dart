import 'package:expense_tracker/core/utils/double_helper.dart';
import 'package:expense_tracker/features/statistics/domain/models/best_worst_month_insight.dart';
import 'package:expense_tracker/features/statistics/domain/models/monthly_cashflow_point.dart';
import 'package:expense_tracker/features/statistics/domain/models/monthly_cashflow_series.dart';

class BestWorstMonthInsightCalculator {
  const BestWorstMonthInsightCalculator._();

  static BestWorstMonthInsight? evaluate(MonthlyCashflowSeries series) {
    if (series.hasInsufficientData || series.isEmpty) {
      return null;
    }

    MonthlyCashflowPoint bestPoint = series.points.first;
    MonthlyCashflowPoint worstPoint = series.points.first;

    for (final point in series.points) {
      if (point.netCashflow > bestPoint.netCashflow) {
        bestPoint = point;
      }
      if (point.netCashflow < worstPoint.netCashflow) {
        worstPoint = point;
      }
    }

    if (bestPoint.netCashflow == worstPoint.netCashflow) {
      return null;
    }

    return BestWorstMonthInsight(
      best: _toSummary(bestPoint),
      worst: _toSummary(worstPoint),
    );
  }

  static MonthlyNetResultSummary _toSummary(MonthlyCashflowPoint point) {
    return MonthlyNetResultSummary(
      monthStart: point.monthStart,
      label: point.label,
      netResult: point.netCashflow.withPrecision(2),
    );
  }
}
