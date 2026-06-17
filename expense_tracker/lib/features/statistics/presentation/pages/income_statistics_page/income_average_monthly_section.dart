import 'package:expense_tracker/core/presentation/providers/app_localizations_provider.dart';
import 'package:expense_tracker/core/style/app_theme.dart';
import 'package:expense_tracker/features/statistics/presentation/providers/queries/average_monthly_income_notifier.dart';
import 'package:expense_tracker/features/statistics/presentation/widgets/average_monthly_amount_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class IncomeAverageMonthlySection extends ConsumerWidget {
  const IncomeAverageMonthlySection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocalizations = ref.watch(appLocalizationsProvider);
    final averageAsync = ref.watch(averageMonthlyIncomeProvider);

    return averageAsync.when(
      data: (average) {
        if (average.isEmpty) {
          return AverageMonthlyAmountCard(
            title: appLocalizations.statisticsIncomeAverageMonthly,
            child: AverageMonthlyAmountEmptyMessage(
              message: appLocalizations.statisticsNoIncomeInPeriod,
            ),
          );
        }

        return AverageMonthlyAmountCard(
          title: appLocalizations.statisticsIncomeAverageMonthly,
          child: AverageMonthlyAmountContent(
            average: average,
            valueColor: context.appColors.income,
            monthsLabel: appLocalizations.statisticsAverageMonthlyMonths(
              average.monthsConsidered,
            ),
            description:
                appLocalizations.statisticsIncomeAverageMonthlyDescription,
          ),
        );
      },
      loading: () => AverageMonthlyAmountCard(
        title: appLocalizations.statisticsIncomeAverageMonthly,
        child: const SizedBox(
          height: 96,
          child: Center(child: CircularProgressIndicator()),
        ),
      ),
      error: (_, __) => AverageMonthlyAmountCard(
        title: appLocalizations.statisticsIncomeAverageMonthly,
        child: AverageMonthlyAmountEmptyMessage(
          message: appLocalizations.statisticsIncomeAverageMonthlyError,
        ),
      ),
    );
  }
}
