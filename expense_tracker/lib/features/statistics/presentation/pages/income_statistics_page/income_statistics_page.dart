import 'package:expense_tracker/core/configuration/constants.dart';
import 'package:expense_tracker/core/presentation/providers/app_localizations_provider.dart';
import 'package:expense_tracker/features/statistics/presentation/pages/income_statistics_page/income_average_monthly_section.dart';
import 'package:expense_tracker/features/statistics/presentation/pages/income_statistics_page/income_by_category_section.dart';
import 'package:expense_tracker/features/statistics/presentation/pages/income_statistics_page/income_monthly_trend_section.dart';
import 'package:expense_tracker/features/statistics/presentation/widgets/statistics_period_indicator.dart';
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
          StatisticsPeriodIndicator(),
          SizedBox(height: 20),
          IncomeAverageMonthlySection(),
          SizedBox(height: 16),
          IncomeByCategorySection(),
          SizedBox(height: 16),
          IncomeMonthlyTrendSection(),
        ],
      ),
    );
  }
}
