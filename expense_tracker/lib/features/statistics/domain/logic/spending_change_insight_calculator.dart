import 'package:expense_tracker/core/utils/double_helper.dart';
import 'package:expense_tracker/features/statistics/domain/models/spending_change_insight.dart';

class SpendingChangeInsightCalculator {
  const SpendingChangeInsightCalculator._();

  /// Minimum previous-period spending required to compare periods.
  static const minPreviousExpenses = 1.0;

  /// Minimum absolute percentage change to surface an insight.
  static const minPercentChange = 10.0;

  static SpendingChangeInsight? evaluate({
    required double currentExpenses,
    required double previousExpenses,
  }) {
    if (previousExpenses < minPreviousExpenses) {
      return null;
    }

    final absoluteChange =
        (currentExpenses - previousExpenses).withPrecision(2);
    if (absoluteChange == 0) {
      return null;
    }

    final percentChange =
        ((absoluteChange / previousExpenses) * 100).withPrecision(1);
    if (percentChange.abs() < minPercentChange) {
      return null;
    }

    return SpendingChangeInsight(
      currentExpenses: currentExpenses.withPrecision(2),
      previousExpenses: previousExpenses.withPrecision(2),
      absoluteChange: absoluteChange,
      percentChange: percentChange,
    );
  }
}
