import 'package:expense_tracker/core/presentation/providers/app_localizations_provider.dart';
import 'package:expense_tracker/core/style/app_theme.dart';
import 'package:expense_tracker/features/statistics/presentation/providers/queries/average_monthly_expense_notifier.dart';
import 'package:expense_tracker/features/statistics/presentation/widgets/average_monthly_amount_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SpendingAverageMonthlySection extends ConsumerWidget {
  const SpendingAverageMonthlySection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocalizations = ref.watch(appLocalizationsProvider);
    final averageAsync = ref.watch(averageMonthlyExpenseProvider);

    return averageAsync.when(
      data: (average) {
        if (average.isEmpty) {
          return AverageMonthlyAmountCard(
            title: appLocalizations.statisticsSpendingAverageMonthly,
            child: AverageMonthlyAmountEmptyMessage(
              message: appLocalizations.statisticsNoTransactionsInPeriod,
            ),
          );
        }

        return AverageMonthlyAmountCard(
          title: appLocalizations.statisticsSpendingAverageMonthly,
          child: AverageMonthlyAmountContent(
            average: average,
            valueColor: context.appColors.expense,
            monthsLabel: appLocalizations.statisticsAverageMonthlyMonths(
              average.monthsConsidered,
            ),
            description:
                appLocalizations.statisticsSpendingAverageMonthlyDescription,
          ),
        );
      },
      loading: () => AverageMonthlyAmountCard(
        title: appLocalizations.statisticsSpendingAverageMonthly,
        child: const SizedBox(
          height: 96,
          child: Center(child: CircularProgressIndicator()),
        ),
      ),
      error: (_, __) => AverageMonthlyAmountCard(
        title: appLocalizations.statisticsSpendingAverageMonthly,
        child: AverageMonthlyAmountEmptyMessage(
          message: appLocalizations.statisticsSpendingAverageMonthlyError,
        ),
      ),
    );
  }
}
