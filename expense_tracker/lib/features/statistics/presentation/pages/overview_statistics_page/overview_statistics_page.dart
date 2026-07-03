import 'package:expense_tracker/core/configuration/constants.dart';
import 'package:expense_tracker/core/presentation/providers/app_localizations_provider.dart';
import 'package:expense_tracker/features/statistics/presentation/pages/overview_statistics_page/overview_kpi_section.dart';
import 'package:expense_tracker/features/statistics/presentation/pages/overview_statistics_page/overview_income_vs_expenses_section.dart';
import 'package:expense_tracker/features/statistics/presentation/pages/overview_statistics_page/overview_net_worth_trend_section.dart';
import 'package:expense_tracker/features/statistics/presentation/widgets/statistics_layout.dart';
import 'package:expense_tracker/features/statistics/presentation/widgets/statistics_period_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OverviewStatisticsPage extends ConsumerWidget {
  static const routeName = '/statisticsOverviewPage';

  const OverviewStatisticsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocalizations = ref.watch(appLocalizationsProvider);

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
          const StatisticsPeriodSelector(),
          const SizedBox(height: StatisticsLayout.periodSectionSpacing),
          const OverviewKpiSection(),
          const SizedBox(height: StatisticsLayout.sectionSpacing),
          const OverviewNetWorthTrendSection(),
          const SizedBox(height: StatisticsLayout.sectionSpacing),
          const OverviewIncomeVsExpensesSection(),
        ],
      ),
    );
  }
}
