import 'dart:math';

import 'package:expense_tracker/core/models/currency.dart';
import 'package:expense_tracker/core/presentation/common/category_ui_extension.dart';
import 'package:expense_tracker/core/presentation/common/widgets/icon_item.dart';
import 'package:expense_tracker/core/presentation/providers/app_localizations_provider.dart';
import 'package:expense_tracker/core/presentation/providers/currency_provider.dart';
import 'package:expense_tracker/core/style/app_theme.dart';
import 'package:expense_tracker/core/utils/double_helper.dart';
import 'package:expense_tracker/features/statistics/domain/models/category_expense_entry.dart';
import 'package:expense_tracker/features/statistics/domain/models/expenses_by_category_series.dart';
import 'package:expense_tracker/features/statistics/presentation/providers/queries/expenses_by_category_notifier.dart';
import 'package:expense_tracker/features/statistics/presentation/widgets/statistics_empty_states.dart';
import 'package:expense_tracker/features/statistics/presentation/widgets/statistics_surface_card.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SpendingExpensesByCategorySection extends ConsumerWidget {
  const SpendingExpensesByCategorySection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocalizations = ref.watch(appLocalizationsProvider);
    final seriesAsync = ref.watch(expensesByCategoryProvider);

    return seriesAsync.when(
      data: (series) {
        if (series.isEmpty) {
          return _ExpensesByCategoryCard(
            title: appLocalizations.statisticsSpendingExpensesByCategory,
            child: StatisticsChartEmptyMessage(
              message: appLocalizations.statisticsNoExpensesInPeriod,
            ),
          );
        }

        return _ExpensesByCategoryCard(
          title: appLocalizations.statisticsSpendingExpensesByCategory,
          child: ExpensesByCategoryBarChart(series: series),
        );
      },
      loading: () => _ExpensesByCategoryCard(
        title: appLocalizations.statisticsSpendingExpensesByCategory,
        child: const StatisticsChartLoading(),
      ),
      error: (_, __) => _ExpensesByCategoryCard(
        title: appLocalizations.statisticsSpendingExpensesByCategory,
        child: StatisticsChartEmptyMessage(
          message: appLocalizations.statisticsSpendingExpensesByCategoryError,
        ),
      ),
    );
  }
}

class ExpensesByCategoryBarChart extends ConsumerWidget {
  const ExpensesByCategoryBarChart({super.key, required this.series});

  final ExpensesByCategorySeries series;

  static const double _barHeight = 10;
  static const double _rowSpacing = 14;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final textTheme = Theme.of(context).textTheme;
    final currency = ref.watch(currentCurrencyProvider);
    final currencyPosition = ref.watch(currentCurrencySymbolPositionProvider);
    final maxAmount = max(series.maxAmount, 1.0);

    final labelStyle = textTheme.labelSmall?.copyWith(
          color: colors.textSecondary,
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ) ??
        TextStyle(
          color: colors.textSecondary,
          fontWeight: FontWeight.w500,
          fontSize: 12,
        );

    final amountStyle = textTheme.labelMedium?.copyWith(
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ) ??
        const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 13,
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: _rowSpacing,
      children: [
        for (final entry in series.entries)
          _CategoryExpenseRow(
            entry: entry,
            maxAmount: maxAmount,
            barHeight: _barHeight,
            labelStyle: labelStyle,
            amountStyle: amountStyle,
            currency: currency,
            currencyPosition: currencyPosition,
            trackColor: colors.divider.withValues(alpha: 0.15),
          ),
      ],
    );
  }
}

class _CategoryExpenseRow extends StatelessWidget {
  const _CategoryExpenseRow({
    required this.entry,
    required this.maxAmount,
    required this.barHeight,
    required this.labelStyle,
    required this.amountStyle,
    required this.currency,
    required this.currencyPosition,
    required this.trackColor,
  });

  final CategoryExpenseEntry entry;
  final double maxAmount;
  final double barHeight;
  final TextStyle labelStyle;
  final TextStyle amountStyle;
  final Currency? currency;
  final CurrencySymbolPosition currencyPosition;
  final Color trackColor;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final categoryColor = entry.category.color;
    final amountLabel = entry.amount.toStringAsFixedRoundedWithCurrency(
      2,
      currency,
      currencyPosition,
    );
    final percentageLabel = '${entry.percentage.toStringAsFixedRounded(1)}%';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        Row(
          spacing: 10,
          children: [
            IconItem(
              backgroundColor: categoryColor,
              iconPath: entry.category.iconPath,
              shape: BoxShape.circle,
              size: 28,
            ),
            Expanded(
              child: Text(
                entry.category.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: labelStyle.copyWith(color: colors.textPrimary),
              ),
            ),
            Text(
              amountLabel,
              style: amountStyle.copyWith(color: colors.textPrimary),
            ),
            SizedBox(
              width: 44,
              child: Text(
                percentageLabel,
                textAlign: TextAlign.end,
                style: labelStyle,
              ),
            ),
          ],
        ),
        SizedBox(
          height: barHeight,
          width: double.infinity,
          child: BarChart(
            BarChartData(
              rotationQuarterTurns: 1,
              minY: 0,
              maxY: maxAmount,
              alignment: BarChartAlignment.spaceAround,
              barTouchData: const BarTouchData(enabled: false),
              gridData: const FlGridData(show: false),
              borderData: FlBorderData(show: false),
              titlesData: const FlTitlesData(show: false),
              barGroups: [
                BarChartGroupData(
                  x: 0,
                  barRods: [
                    BarChartRodData(
                      toY: entry.amount,
                      color: categoryColor,
                      width: barHeight,
                      borderRadius:
                          BorderRadius.all(Radius.circular(barHeight / 2)),
                      backDrawRodData: BackgroundBarChartRodData(
                        show: true,
                        toY: maxAmount,
                        color: trackColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ExpensesByCategoryCard extends StatelessWidget {
  const _ExpensesByCategoryCard({
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return StatisticsSurfaceCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16,
        children: [
          Text(
            title,
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
