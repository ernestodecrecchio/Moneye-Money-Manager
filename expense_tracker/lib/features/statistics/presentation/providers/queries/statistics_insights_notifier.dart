import 'package:expense_tracker/core/presentation/providers/app_localizations_provider.dart';
import 'package:expense_tracker/core/presentation/providers/currency_provider.dart';
import 'package:expense_tracker/features/statistics/domain/logic/best_worst_month_insight_calculator.dart';
import 'package:expense_tracker/features/statistics/domain/logic/spending_change_insight_calculator.dart';
import 'package:expense_tracker/features/statistics/domain/logic/top_category_weight_insight_calculator.dart';
import 'package:expense_tracker/features/statistics/domain/models/statistics_insight.dart';
import 'package:expense_tracker/features/statistics/presentation/mappers/best_worst_month_insight_mapper.dart';
import 'package:expense_tracker/features/statistics/presentation/mappers/spending_change_insight_mapper.dart';
import 'package:expense_tracker/features/statistics/presentation/mappers/top_category_weight_insight_mapper.dart';
import 'package:expense_tracker/features/statistics/presentation/providers/queries/expenses_by_category_notifier.dart';
import 'package:expense_tracker/features/statistics/presentation/providers/queries/monthly_cashflow_notifier.dart';
import 'package:expense_tracker/features/statistics/presentation/providers/statistics_period_provider.dart';
import 'package:expense_tracker/features/transactions/presentation/providers/transactions_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StatisticsInsightsNotifier extends AsyncNotifier<List<StatisticsInsight>> {
  @override
  Future<List<StatisticsInsight>> build() async {
    final period = ref.watch(statisticsPeriodProvider);
    final appLocalizations = ref.watch(appLocalizationsProvider);
    final currency = ref.watch(currentCurrencyProvider);
    final currencyPosition = ref.watch(currentCurrencySymbolPositionProvider);
    final repository = ref.read(transactionsRepositoryProvider);

    final insights = <StatisticsInsight>[];

    final currentTotals = await repository.sumIncomeAndExpensesForPeriod(
      start: period.startDate,
      end: period.endDate,
    );
    final previousPeriod = period.previous;
    final previousTotals = await repository.sumIncomeAndExpensesForPeriod(
      start: previousPeriod.startDate,
      end: previousPeriod.endDate,
    );

    final spendingChange = SpendingChangeInsightCalculator.evaluate(
      currentExpenses: currentTotals.expenses,
      previousExpenses: previousTotals.expenses,
    );
    if (spendingChange != null) {
      insights.add(
        SpendingChangeInsightMapper.toStatisticsInsight(
          insight: spendingChange,
          appLocalizations: appLocalizations,
          currency: currency,
          currencyPosition: currencyPosition,
        ),
      );
    }

    final expensesByCategory =
        await ref.watch(expensesByCategoryProvider.future);
    final topCategoryWeight =
        TopCategoryWeightInsightCalculator.evaluate(expensesByCategory);
    if (topCategoryWeight != null) {
      insights.add(
        TopCategoryWeightInsightMapper.toStatisticsInsight(
          insight: topCategoryWeight,
          appLocalizations: appLocalizations,
        ),
      );
    }

    final monthlyCashflow = await ref.watch(monthlyCashflowProvider.future);
    final bestWorstMonth =
        BestWorstMonthInsightCalculator.evaluate(monthlyCashflow);
    if (bestWorstMonth != null) {
      insights.addAll(
        BestWorstMonthInsightMapper.toStatisticsInsights(
          insight: bestWorstMonth,
          appLocalizations: appLocalizations,
          currency: currency,
          currencyPosition: currencyPosition,
        ),
      );
    }

    return insights;
  }
}

final statisticsInsightsProvider =
    AsyncNotifierProvider<StatisticsInsightsNotifier, List<StatisticsInsight>>(
  StatisticsInsightsNotifier.new,
);
