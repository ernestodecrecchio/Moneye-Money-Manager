import 'package:expense_tracker/core/presentation/providers/app_localizations_provider.dart';
import 'package:expense_tracker/features/statistics/domain/logic/income_vs_expenses_calculator.dart';
import 'package:expense_tracker/features/statistics/domain/models/daily_income_expense.dart';
import 'package:expense_tracker/features/statistics/domain/models/income_vs_expenses_series.dart';
import 'package:expense_tracker/features/statistics/presentation/providers/statistics_period_provider.dart';
import 'package:expense_tracker/features/transactions/presentation/providers/transactions_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class IncomeVsExpensesNotifier extends AsyncNotifier<IncomeVsExpensesSeries> {
  @override
  Future<IncomeVsExpensesSeries> build() async {
    final period = ref.watch(statisticsPeriodProvider);
    final appLocalizations = ref.watch(appLocalizationsProvider);
    final repository = ref.read(transactionsRepositoryProvider);

    final dailyRecords = await repository.getDailyIncomeAndExpensesInPeriod(
      start: period.startDate,
      end: period.endDate,
    );

    return IncomeVsExpensesCalculator.build(
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

final incomeVsExpensesProvider =
    AsyncNotifierProvider<IncomeVsExpensesNotifier, IncomeVsExpensesSeries>(
  IncomeVsExpensesNotifier.new,
);
