import 'package:expense_tracker/core/configuration/constants.dart';
import 'package:expense_tracker/core/presentation/providers/app_localizations_provider.dart';
import 'package:expense_tracker/features/statistics/presentation/pages/cashflow_statistics_page/cashflow_cumulative_chart_section.dart';
import 'package:expense_tracker/features/statistics/presentation/pages/cashflow_statistics_page/cashflow_monthly_chart_section.dart';
import 'package:expense_tracker/features/statistics/presentation/pages/cashflow_statistics_page/cashflow_monthly_list_section.dart';
import 'package:expense_tracker/features/statistics/presentation/widgets/statistics_layout.dart';
import 'package:expense_tracker/features/statistics/presentation/widgets/statistics_period_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CashflowStatisticsPage extends ConsumerWidget {
  static const routeName = '/statisticsCashflowPage';

  const CashflowStatisticsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocalizations = ref.watch(appLocalizationsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations.statisticsCashflowTitle),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          Constants.horizontalPadding,
          Constants.horizontalPadding,
          Constants.horizontalPadding,
          Constants.horizontalPadding,
        ),
        children: const [
          StatisticsPeriodIndicator(),
          SizedBox(height: StatisticsLayout.periodSectionSpacing),
          CashflowMonthlyChartSection(),
          SizedBox(height: StatisticsLayout.sectionSpacing),
          CashflowMonthlyListSection(),
          SizedBox(height: StatisticsLayout.sectionSpacing),
          CashflowCumulativeChartSection(),
        ],
      ),
    );
  }
}
