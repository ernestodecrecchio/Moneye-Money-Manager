import 'package:expense_tracker/core/utils/double_helper.dart';
import 'package:expense_tracker/features/statistics/domain/models/average_monthly_amount.dart';
import 'package:expense_tracker/features/statistics/domain/models/monthly_spending_trend_series.dart';

class AverageMonthlyAmountCalculator {
  const AverageMonthlyAmountCalculator._();

  static AverageMonthlyAmount build(MonthlySpendingTrendSeries series) {
    final monthsConsidered = series.points.length;
    if (monthsConsidered == 0) {
      return const AverageMonthlyAmount(
        averageAmount: 0,
        monthsConsidered: 0,
        totalAmount: 0,
      );
    }

    final totalAmount = series.points
        .fold<double>(0, (sum, point) => sum + point.expenses)
        .withPrecision(2);
    final averageAmount = (totalAmount / monthsConsidered).withPrecision(2);

    return AverageMonthlyAmount(
      averageAmount: averageAmount,
      monthsConsidered: monthsConsidered,
      totalAmount: totalAmount,
    );
  }
}
