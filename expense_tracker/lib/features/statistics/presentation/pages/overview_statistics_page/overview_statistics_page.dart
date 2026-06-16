import 'package:expense_tracker/core/configuration/constants.dart';
import 'package:expense_tracker/core/presentation/providers/app_localizations_provider.dart';
import 'package:expense_tracker/core/style/app_theme.dart';
import 'package:expense_tracker/features/statistics/presentation/widgets/statistics_chart_placeholder_card.dart';
import 'package:expense_tracker/features/statistics/presentation/widgets/statistics_kpi_card.dart';
import 'package:expense_tracker/features/statistics/presentation/widgets/statistics_period_indicator.dart';
import 'package:expense_tracker/features/statistics/presentation/widgets/statistics_surface_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OverviewStatisticsPage extends ConsumerWidget {
  static const routeName = '/statisticsOverviewPage';

  const OverviewStatisticsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocalizations = ref.watch(appLocalizationsProvider);
    final colors = context.appColors;
    final placeholder = appLocalizations.statisticsPlaceholderValue;

    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations.statisticsOverviewTitle),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          Constants.horizontalPadding,
          Constants.horizontalPadding,
          Constants.horizontalPadding,
          Constants.horizontalPadding,
        ),
        children: [
          const StatisticsPeriodIndicator(),
          const SizedBox(height: 20),
          Text(
            appLocalizations.statisticsKeyFigures,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: colors.primary,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 10),
          StatisticsSurfaceCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: StatisticsKpiCard(
                        label: appLocalizations.income,
                        value: placeholder,
                        valueColor: colors.income,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: StatisticsKpiCard(
                        label: appLocalizations.statisticsExpenses,
                        value: placeholder,
                        valueColor: colors.expense,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: StatisticsKpiCard(
                        label: appLocalizations.statisticsNetResult,
                        value: placeholder,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: StatisticsKpiCard(
                        label: appLocalizations.statisticsSavingsRate,
                        value: placeholder,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          StatisticsChartPlaceholderCard(
            title: appLocalizations.statisticsNetWorthTrend,
            placeholderText: appLocalizations.statisticsChartsComingSoon,
          ),
          const SizedBox(height: 16),
          StatisticsChartPlaceholderCard(
            title: appLocalizations.statisticsIncomeVsExpenses,
            placeholderText: appLocalizations.statisticsChartsComingSoon,
          ),
        ],
      ),
    );
  }
}
