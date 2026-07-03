import 'package:expense_tracker/core/configuration/constants.dart';
import 'package:expense_tracker/core/presentation/providers/app_localizations_provider.dart';
import 'package:expense_tracker/features/statistics/presentation/pages/income_statistics_page/income_average_monthly_section.dart';
import 'package:expense_tracker/features/statistics/presentation/pages/income_statistics_page/income_by_category_section.dart';
import 'package:expense_tracker/features/statistics/presentation/pages/income_statistics_page/income_monthly_trend_section.dart';
import 'package:expense_tracker/features/statistics/presentation/widgets/statistics_layout.dart';
import 'package:expense_tracker/features/statistics/presentation/widgets/statistics_period_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class IncomeStatisticsPage extends ConsumerWidget {
  static const routeName = '/statisticsIncomePage';

  const IncomeStatisticsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocalizations = ref.watch(appLocalizationsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations.statisticsIncomeTitle),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          Constants.horizontalPadding,
          Constants.horizontalPadding,
          Constants.horizontalPadding,
          Constants.horizontalPadding,
        ),
        children: const [
          StatisticsPeriodSelector(),
          SizedBox(height: StatisticsLayout.periodSectionSpacing),
          IncomeAverageMonthlySection(),
          SizedBox(height: StatisticsLayout.sectionSpacing),
          IncomeByCategorySection(),
          SizedBox(height: StatisticsLayout.sectionSpacing),
          IncomeMonthlyTrendSection(),
        ],
      ),
    );
  }
}
