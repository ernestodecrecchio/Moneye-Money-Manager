import 'package:expense_tracker/features/statistics/domain/models/expenses_by_category_series.dart';
import 'package:expense_tracker/features/statistics/domain/models/top_category_weight_insight.dart';

class TopCategoryWeightInsightCalculator {
  const TopCategoryWeightInsightCalculator._();

  /// Minimum share of total expenses required to surface an insight.
  static const minSharePercent = 40.0;

  static TopCategoryWeightInsight? evaluate(ExpensesByCategorySeries series) {
    if (series.isEmpty || series.entries.isEmpty) {
      return null;
    }

    final topEntry = series.entries.first;
    if (topEntry.percentage < minSharePercent) {
      return null;
    }

    return TopCategoryWeightInsight(
      category: topEntry.category,
      amount: topEntry.amount,
      sharePercent: topEntry.percentage,
      totalExpenses: series.totalExpenses,
    );
  }
}
