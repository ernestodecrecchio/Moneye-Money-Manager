import 'package:expense_tracker/features/statistics/domain/logic/average_monthly_amount_calculator.dart';
import 'package:expense_tracker/features/statistics/domain/models/average_monthly_amount.dart';
import 'package:expense_tracker/features/statistics/presentation/providers/queries/monthly_spending_trend_notifier.dart';
import 'package:expense_tracker/features/statistics/presentation/providers/statistics_period_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AverageMonthlyExpenseNotifier extends AsyncNotifier<AverageMonthlyAmount> {
  @override
  Future<AverageMonthlyAmount> build() async {
    ref.watch(statisticsPeriodProvider);
    final series = await ref.watch(monthlySpendingTrendProvider.future);

    return AverageMonthlyAmountCalculator.build(series);
  }
}

final averageMonthlyExpenseProvider =
    AsyncNotifierProvider<AverageMonthlyExpenseNotifier, AverageMonthlyAmount>(
  AverageMonthlyExpenseNotifier.new,
);
