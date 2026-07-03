import 'package:expense_tracker/core/configuration/constants.dart';
import 'package:expense_tracker/core/presentation/providers/app_localizations_provider.dart';
import 'package:expense_tracker/features/statistics/presentation/pages/spending_statistics_page/spending_average_monthly_section.dart';
import 'package:expense_tracker/features/statistics/presentation/pages/spending_statistics_page/spending_category_comparison_section.dart';
import 'package:expense_tracker/features/statistics/presentation/pages/spending_statistics_page/spending_expenses_by_category_section.dart';
import 'package:expense_tracker/features/statistics/presentation/pages/spending_statistics_page/spending_insights_preview_section.dart';
import 'package:expense_tracker/features/statistics/presentation/pages/spending_statistics_page/spending_monthly_trend_section.dart';
import 'package:expense_tracker/features/statistics/presentation/widgets/statistics_layout.dart';
import 'package:expense_tracker/features/statistics/presentation/widgets/statistics_period_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SpendingStatisticsPage extends ConsumerWidget {
  static const routeName = '/statisticsSpendingPage';

  const SpendingStatisticsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocalizations = ref.watch(appLocalizationsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations.statisticsSpendingTitle),
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
          SpendingAverageMonthlySection(),
          SizedBox(height: StatisticsLayout.sectionSpacing),
          SpendingExpensesByCategorySection(),
          SizedBox(height: StatisticsLayout.sectionSpacing),
          SpendingMonthlyTrendSection(),
          SizedBox(height: StatisticsLayout.sectionSpacing),
          SpendingCategoryComparisonSection(),
          SizedBox(height: StatisticsLayout.sectionSpacing),
          SpendingInsightsPreviewSection(),
        ],
      ),
    );
  }
}
