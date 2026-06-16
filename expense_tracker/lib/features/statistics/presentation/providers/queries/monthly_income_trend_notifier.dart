import 'package:expense_tracker/core/presentation/providers/app_localizations_provider.dart';
import 'package:expense_tracker/features/statistics/domain/logic/monthly_income_trend_calculator.dart';
import 'package:expense_tracker/features/statistics/domain/models/daily_income_expense.dart';
import 'package:expense_tracker/features/statistics/domain/models/monthly_spending_trend_series.dart';
import 'package:expense_tracker/features/statistics/presentation/providers/statistics_period_provider.dart';
import 'package:expense_tracker/features/transactions/presentation/providers/transactions_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MonthlyIncomeTrendNotifier extends AsyncNotifier<MonthlySpendingTrendSeries> {
  @override
  Future<MonthlySpendingTrendSeries> build() async {
    final period = ref.watch(statisticsPeriodProvider);
    final appLocalizations = ref.watch(appLocalizationsProvider);
    final repository = ref.read(transactionsRepositoryProvider);

    final dailyRecords = await repository.getDailyIncomeAndExpensesInPeriod(
      start: period.startDate,
      end: period.endDate,
    );

    return MonthlyIncomeTrendCalculator.build(
      period: period,
      dailyRecords: dailyRecords
          .map(
            (record) => DailyIncomeExpense(
              date: record.date,
              income: record.income,
              expenses: record.expenses,
            ),
          )
          .toList(),
      locale: appLocalizations.localeName,
    );
  }
}

final monthlyIncomeTrendProvider =
    AsyncNotifierProvider<MonthlyIncomeTrendNotifier, MonthlySpendingTrendSeries>(
  MonthlyIncomeTrendNotifier.new,
);
