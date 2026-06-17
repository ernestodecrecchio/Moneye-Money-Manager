import 'package:expense_tracker/core/models/currency.dart';
import 'package:expense_tracker/core/presentation/providers/app_localizations_provider.dart';
import 'package:expense_tracker/core/presentation/providers/currency_provider.dart';
import 'package:expense_tracker/core/style/app_theme.dart';
import 'package:expense_tracker/core/utils/double_helper.dart';
import 'package:expense_tracker/features/statistics/domain/models/monthly_cashflow_point.dart';
import 'package:expense_tracker/features/statistics/domain/models/monthly_cashflow_series.dart';
import 'package:expense_tracker/features/statistics/presentation/providers/queries/monthly_cashflow_notifier.dart';
import 'package:expense_tracker/features/statistics/presentation/widgets/statistics_empty_states.dart';
import 'package:expense_tracker/features/statistics/presentation/widgets/statistics_surface_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CashflowMonthlyListSection extends ConsumerWidget {
  const CashflowMonthlyListSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocalizations = ref.watch(appLocalizationsProvider);
    final seriesAsync = ref.watch(monthlyCashflowProvider);

    return seriesAsync.when(
      data: (series) {
        if (series.isEmpty) {
          return _CashflowMonthlyListCard(
            child: StatisticsInlineEmptyMessage(
              message: appLocalizations.statisticsNoTransactionsInPeriod,
            ),
          );
        }

        return _CashflowMonthlyListCard(
          child: _CashflowMonthlyListContent(series: series),
        );
      },
      loading: () => const _CashflowMonthlyListCard(
        child: StatisticsChartLoading(height: 120),
      ),
      error: (_, __) => _CashflowMonthlyListCard(
        child: StatisticsInlineEmptyMessage(
          message: appLocalizations.statisticsCashflowMonthlyListError,
        ),
      ),
    );
  }
}

class _CashflowMonthlyListCard extends ConsumerWidget {
  const _CashflowMonthlyListCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocalizations = ref.watch(appLocalizationsProvider);

    return StatisticsSurfaceCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12,
        children: [
          Text(
            appLocalizations.statisticsCashflowMonthlyList,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
          child,
        ],
      ),
    );
  }
}

class _CashflowMonthlyListContent extends ConsumerWidget {
  const _CashflowMonthlyListContent({required this.series});

  final MonthlyCashflowSeries series;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocalizations = ref.watch(appLocalizationsProvider);
    final colors = context.appColors;

    final headerStyle = TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w600,
      color: colors.textSecondary,
      letterSpacing: 0.2,
    );

    return Column(
      spacing: 8,
      children: [
        Row(
          children: [
            Expanded(
              flex: 3,
              child: Text(
                appLocalizations.month,
                style: headerStyle,
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                appLocalizations.income,
                textAlign: TextAlign.end,
                style: headerStyle,
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                appLocalizations.statisticsExpenses,
                textAlign: TextAlign.end,
                style: headerStyle,
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                appLocalizations.statisticsNetResult,
                textAlign: TextAlign.end,
                style: headerStyle,
              ),
            ),
          ],
        ),
        Divider(
          height: 1,
          color: colors.divider.withValues(alpha: 0.35),
        ),
        for (var i = 0; i < series.points.length; i++)
          _CashflowMonthlyListRow(
            point: series.points[i],
            showDivider: i < series.points.length - 1,
          ),
      ],
    );
  }
}

class _CashflowMonthlyListRow extends ConsumerWidget {
  const _CashflowMonthlyListRow({
    required this.point,
    required this.showDivider,
  });

  final MonthlyCashflowPoint point;
  final bool showDivider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final currency = ref.watch(currentCurrencyProvider);
    final currencyPosition = ref.watch(currentCurrencySymbolPositionProvider);

    final incomeLabel = _formatAmount(point.income, currency, currencyPosition);
    final expensesLabel =
        _formatAmount(point.expenses, currency, currencyPosition);
    final netLabel =
        _formatAmount(point.netCashflow, currency, currencyPosition);
    final netColor = point.netCashflow > 0
        ? colors.income
        : point.netCashflow < 0
            ? colors.expense
            : colors.textPrimary;

    final amountStyle = TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w600,
    );

    return Column(
      spacing: 8,
      children: [
        Row(
          children: [
            Expanded(
              flex: 3,
              child: Text(
                point.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: colors.textPrimary,
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                incomeLabel,
                textAlign: TextAlign.end,
                style: amountStyle.copyWith(color: colors.income),
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                expensesLabel,
                textAlign: TextAlign.end,
                style: amountStyle.copyWith(color: colors.expense),
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                netLabel,
                textAlign: TextAlign.end,
                style: amountStyle.copyWith(color: netColor),
              ),
            ),
          ],
        ),
        if (showDivider)
          Divider(
            height: 1,
            color: colors.divider.withValues(alpha: 0.25),
          ),
      ],
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
