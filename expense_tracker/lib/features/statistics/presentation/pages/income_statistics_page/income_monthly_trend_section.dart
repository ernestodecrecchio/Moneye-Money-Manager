import 'package:expense_tracker/core/presentation/providers/app_localizations_provider.dart';
import 'package:expense_tracker/core/style/app_theme.dart';
import 'package:expense_tracker/features/statistics/presentation/pages/spending_statistics_page/spending_monthly_trend_section.dart';
import 'package:expense_tracker/features/statistics/presentation/providers/queries/monthly_income_trend_notifier.dart';
import 'package:expense_tracker/features/statistics/presentation/providers/statistics_period_provider.dart';
import 'package:expense_tracker/features/statistics/presentation/widgets/statistics_empty_states.dart';
import 'package:expense_tracker/features/statistics/presentation/widgets/statistics_period_chart_support.dart';
import 'package:expense_tracker/features/statistics/presentation/widgets/statistics_section_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class IncomeMonthlyTrendSection extends ConsumerWidget {
  const IncomeMonthlyTrendSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final period = ref.watch(statisticsPeriodProvider);
    if (!statisticsPeriodSupportsMultipleMonths(period)) {
      return const SizedBox.shrink();
    }

    final appLocalizations = ref.watch(appLocalizationsProvider);
    final colors = context.appColors;
    final seriesAsync = ref.watch(monthlyIncomeTrendProvider);

    return seriesAsync.when(
      data: (series) {
        if (series.isEmpty) {
          return StatisticsSectionCard(
            title: appLocalizations.statisticsIncomeMonthlyTrend,
            child: StatisticsChartEmptyMessage(
              message: appLocalizations.statisticsNoIncomeInPeriod,
            ),
          );
        }

        if (series.hasInsufficientData) {
          return StatisticsSectionCard(
            title: appLocalizations.statisticsIncomeMonthlyTrend,
            child: StatisticsChartEmptyMessage(
              message:
                  appLocalizations.statisticsIncomeMonthlyTrendInsufficientData,
            ),
          );
        }

        return StatisticsSectionCard(
          title: appLocalizations.statisticsIncomeMonthlyTrend,
          fullscreenChartBuilder: ({required bool expanded}) => MonthlySpendingTrendLineChart(
            series: series,
            lineColor: colors.income,
            expanded: expanded,
          ),
          child: MonthlySpendingTrendLineChart(
            series: series,
            lineColor: colors.income,
          ),
        );
      },
      loading: () => StatisticsSectionCard(
        title: appLocalizations.statisticsIncomeMonthlyTrend,
        child: const StatisticsChartLoading(),
      ),
      error: (_, __) => StatisticsSectionCard(
        title: appLocalizations.statisticsIncomeMonthlyTrend,
        child: StatisticsChartEmptyMessage(
          message: appLocalizations.statisticsIncomeMonthlyTrendError,
        ),
      ),
    );
  }
}
