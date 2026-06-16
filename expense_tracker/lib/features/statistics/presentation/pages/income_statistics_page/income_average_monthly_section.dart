import 'package:expense_tracker/core/presentation/providers/app_localizations_provider.dart';
import 'package:expense_tracker/core/style/app_theme.dart';
import 'package:expense_tracker/features/statistics/presentation/widgets/statistics_kpi_card.dart';
import 'package:expense_tracker/features/statistics/presentation/widgets/statistics_surface_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class IncomeAverageMonthlySection extends ConsumerWidget {
  const IncomeAverageMonthlySection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocalizations = ref.watch(appLocalizationsProvider);
    final colors = context.appColors;

    return StatisticsSurfaceCard(
      padding: const EdgeInsets.all(20),
      child: StatisticsKpiCard(
        label: appLocalizations.statisticsIncomeAverageMonthly,
        value: appLocalizations.statisticsPlaceholderValue,
        valueColor: colors.income,
      ),
    );
  }
}
