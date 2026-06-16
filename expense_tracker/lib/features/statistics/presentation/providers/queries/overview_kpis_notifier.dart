import 'package:expense_tracker/features/statistics/domain/models/overview_period_kpis.dart';
import 'package:expense_tracker/features/statistics/presentation/providers/statistics_period_provider.dart';
import 'package:expense_tracker/features/transactions/presentation/providers/transactions_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OverviewKpisNotifier extends AsyncNotifier<OverviewPeriodKpis> {
  @override
  Future<OverviewPeriodKpis> build() async {
    final period = ref.watch(statisticsPeriodProvider);
    final repository = ref.read(transactionsRepositoryProvider);
    final totals = await repository.sumIncomeAndExpensesForPeriod(
      start: period.startDate,
      end: period.endDate,
    );

    return OverviewPeriodKpis(
      totalIncome: totals.income,
      totalExpenses: totals.expenses,
    );
  }
}

final overviewKpisProvider =
    AsyncNotifierProvider<OverviewKpisNotifier, OverviewPeriodKpis>(
  OverviewKpisNotifier.new,
);
