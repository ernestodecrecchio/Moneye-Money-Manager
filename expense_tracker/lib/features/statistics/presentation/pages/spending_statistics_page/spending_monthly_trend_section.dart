import 'package:expense_tracker/core/presentation/providers/app_localizations_provider.dart';
import 'package:expense_tracker/features/statistics/presentation/widgets/statistics_chart_placeholder_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SpendingMonthlyTrendSection extends ConsumerWidget {
  const SpendingMonthlyTrendSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocalizations = ref.watch(appLocalizationsProvider);

    return StatisticsChartPlaceholderCard(
      title: appLocalizations.statisticsSpendingMonthlyTrend,
      placeholderText: appLocalizations.statisticsChartsComingSoon,
    );
  }
}
