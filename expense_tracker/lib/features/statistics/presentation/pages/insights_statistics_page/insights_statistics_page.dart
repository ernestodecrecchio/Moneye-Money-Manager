import 'package:expense_tracker/core/configuration/constants.dart';
import 'package:expense_tracker/core/presentation/providers/app_localizations_provider.dart';
import 'package:expense_tracker/features/statistics/presentation/pages/insights_statistics_page/insights_list_section.dart';
import 'package:expense_tracker/features/statistics/presentation/widgets/statistics_layout.dart';
import 'package:expense_tracker/features/statistics/presentation/widgets/statistics_period_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InsightsStatisticsPage extends ConsumerWidget {
  static const routeName = '/statisticsInsightsPage';

  const InsightsStatisticsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocalizations = ref.watch(appLocalizationsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations.statisticsInsightsTitle),
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
          InsightsListSection(),
        ],
      ),
    );
  }
}
