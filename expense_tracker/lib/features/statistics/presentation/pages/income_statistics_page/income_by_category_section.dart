import 'package:expense_tracker/core/presentation/providers/app_localizations_provider.dart';
import 'package:expense_tracker/features/statistics/presentation/pages/spending_statistics_page/spending_expenses_by_category_section.dart';
import 'package:expense_tracker/features/statistics/presentation/providers/queries/income_by_category_notifier.dart';
import 'package:expense_tracker/features/statistics/presentation/widgets/statistics_empty_states.dart';
import 'package:expense_tracker/features/statistics/presentation/widgets/statistics_section_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class IncomeByCategorySection extends ConsumerWidget {
  const IncomeByCategorySection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocalizations = ref.watch(appLocalizationsProvider);
    final seriesAsync = ref.watch(incomeByCategoryProvider);

    return seriesAsync.when(
      data: (series) {
        if (series.isEmpty) {
          return StatisticsSectionCard(
            title: appLocalizations.statisticsIncomeByCategory,
            child: StatisticsChartEmptyMessage(
              message: appLocalizations.statisticsNoIncomeInPeriod,
            ),
          );
        }

        return StatisticsSectionCard(
          title: appLocalizations.statisticsIncomeByCategory,
          child: ExpensesByCategoryBarChart(series: series),
        );
      },
      loading: () => StatisticsSectionCard(
        title: appLocalizations.statisticsIncomeByCategory,
        child: const StatisticsChartLoading(),
      ),
      error: (_, __) => StatisticsSectionCard(
        title: appLocalizations.statisticsIncomeByCategory,
        child: StatisticsChartEmptyMessage(
          message: appLocalizations.statisticsIncomeByCategoryError,
        ),
      ),
    );
  }
}
