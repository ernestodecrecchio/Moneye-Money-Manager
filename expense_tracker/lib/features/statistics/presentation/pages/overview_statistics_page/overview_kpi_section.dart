import 'package:expense_tracker/core/models/currency.dart';
import 'package:expense_tracker/core/presentation/providers/app_localizations_provider.dart';
import 'package:expense_tracker/core/presentation/providers/currency_provider.dart';
import 'package:expense_tracker/core/style/app_theme.dart';
import 'package:expense_tracker/core/utils/double_helper.dart';
import 'package:expense_tracker/features/statistics/domain/models/overview_period_kpis.dart';
import 'package:expense_tracker/features/statistics/presentation/providers/queries/overview_kpis_notifier.dart';
import 'package:expense_tracker/features/statistics/presentation/widgets/statistics_kpi_card.dart';
import 'package:expense_tracker/features/statistics/presentation/widgets/statistics_surface_card.dart';
import 'package:expense_tracker/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OverviewKpiSection extends ConsumerWidget {
  const OverviewKpiSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocalizations = ref.watch(appLocalizationsProvider);
    final colors = context.appColors;
    final kpisAsync = ref.watch(overviewKpisProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          appLocalizations.statisticsKeyFigures,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: colors.primary,
            letterSpacing: 1.1,
          ),
        ),
        const SizedBox(height: 10),
        kpisAsync.when(
          data: (kpis) => _OverviewKpiContent(
            appLocalizations: appLocalizations,
            kpis: kpis,
          ),
          loading: () => const StatisticsSurfaceCard(
            padding: EdgeInsets.all(32),
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (error, _) => StatisticsSurfaceCard(
            padding: const EdgeInsets.all(20),
            child: Text(
              appLocalizations.statisticsOverviewKpisError,
              style: TextStyle(color: colors.textSecondary),
            ),
          ),
        ),
      ],
    );
  }
}

class _OverviewKpiContent extends ConsumerWidget {
  const _OverviewKpiContent({
    required this.appLocalizations,
    required this.kpis,
  });

  final AppLocalizations appLocalizations;
  final OverviewPeriodKpis kpis;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final currency = ref.watch(currentCurrencyProvider);
    final currencyPosition = ref.watch(currentCurrencySymbolPositionProvider);
    final placeholder = appLocalizations.statisticsPlaceholderValue;

    final incomeLabel = _formatAmount(
      kpis.totalIncome,
      currency,
      currencyPosition,
    );
    final expensesLabel = _formatAmount(
      kpis.totalExpenses,
      currency,
      currencyPosition,
    );
    final netResultLabel = _formatAmount(
      kpis.netResult,
      currency,
      currencyPosition,
    );
    final savingsRateLabel = kpis.savingsRate == null
        ? placeholder
        : '${(kpis.savingsRate! * 100).toStringAsFixedRounded(0)}%';

    final netResultColor = kpis.netResult > 0
        ? colors.income
        : kpis.netResult < 0
            ? colors.expense
            : colors.textPrimary;

    return StatisticsSurfaceCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (kpis.isEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                appLocalizations.statisticsNoTransactionsInPeriod,
                style: TextStyle(
                  fontSize: 13,
                  color: colors.textSecondary,
                ),
              ),
            ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: StatisticsKpiCard(
                  label: appLocalizations.income,
                  value: incomeLabel,
                  valueColor: colors.income,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: StatisticsKpiCard(
                  label: appLocalizations.statisticsExpenses,
                  value: expensesLabel,
                  valueColor: colors.expense,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: StatisticsKpiCard(
                  label: appLocalizations.statisticsNetResult,
                  value: netResultLabel,
                  valueColor: netResultColor,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: StatisticsKpiCard(
                  label: appLocalizations.statisticsSavingsRate,
                  value: savingsRateLabel,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatAmount(
    double amount,
    Currency? currency,
    CurrencySymbolPosition currencyPosition,
  ) {
    return amount.toStringAsFixedRoundedWithCurrency(
      2,
      currency,
      currencyPosition,
    );
  }
}
