import 'package:expense_tracker/core/presentation/providers/app_localizations_provider.dart';
import 'package:expense_tracker/core/style/app_theme.dart';
import 'package:expense_tracker/features/statistics/presentation/pages/spending_statistics_page/spending_monthly_trend_section.dart';
import 'package:expense_tracker/features/statistics/presentation/providers/queries/monthly_income_trend_notifier.dart';
import 'package:expense_tracker/features/statistics/presentation/providers/statistics_period_provider.dart';
import 'package:expense_tracker/features/statistics/presentation/widgets/statistics_empty_states.dart';
import 'package:expense_tracker/features/statistics/presentation/widgets/statistics_period_chart_support.dart';
import 'package:expense_tracker/features/statistics/presentation/widgets/statistics_surface_card.dart';
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
          return _MonthlyTrendCard(
            title: appLocalizations.statisticsIncomeMonthlyTrend,
            child: StatisticsChartEmptyMessage(
              height: 200,
              message: appLocalizations.statisticsNoIncomeInPeriod,
            ),
          );
        }

        if (series.hasInsufficientData) {
          return _MonthlyTrendCard(
            title: appLocalizations.statisticsIncomeMonthlyTrend,
            child: StatisticsChartEmptyMessage(
              height: 200,
              message:
                  appLocalizations.statisticsIncomeMonthlyTrendInsufficientData,
            ),
          );
        }

        return _MonthlyTrendCard(
          title: appLocalizations.statisticsIncomeMonthlyTrend,
          child: MonthlySpendingTrendLineChart(
            series: series,
            lineColor: colors.income,
          ),
        );
      },
      loading: () => _MonthlyTrendCard(
        title: appLocalizations.statisticsIncomeMonthlyTrend,
        child: const StatisticsChartLoading(height: 200),
      ),
      error: (_, __) => _MonthlyTrendCard(
        title: appLocalizations.statisticsIncomeMonthlyTrend,
        child: StatisticsChartEmptyMessage(
          height: 200,
          message: appLocalizations.statisticsIncomeMonthlyTrendError,
        ),
      ),
    );
  }
}

class _MonthlyTrendCard extends StatelessWidget {
  const _MonthlyTrendCard({
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return StatisticsSurfaceCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
          child,
        ],
      ),
    );
  }
}
