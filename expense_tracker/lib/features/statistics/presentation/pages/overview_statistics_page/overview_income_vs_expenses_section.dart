import 'dart:math';

import 'package:expense_tracker/core/models/currency.dart';
import 'package:expense_tracker/core/presentation/providers/app_localizations_provider.dart';
import 'package:expense_tracker/core/presentation/providers/currency_provider.dart';
import 'package:expense_tracker/core/style/app_theme.dart';
import 'package:expense_tracker/core/style/style.dart';
import 'package:expense_tracker/core/utils/double_helper.dart';
import 'package:expense_tracker/features/statistics/domain/models/income_vs_expenses_series.dart';
import 'package:expense_tracker/features/statistics/presentation/providers/queries/income_vs_expenses_notifier.dart';
import 'package:expense_tracker/features/statistics/presentation/widgets/statistics_empty_states.dart';
import 'package:expense_tracker/features/statistics/presentation/widgets/statistics_surface_card.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class OverviewIncomeVsExpensesSection extends ConsumerWidget {
  const OverviewIncomeVsExpensesSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocalizations = ref.watch(appLocalizationsProvider);
    final seriesAsync = ref.watch(incomeVsExpensesProvider);

    return seriesAsync.when(
      data: (series) {
        if (series.isEmpty) {
          return _IncomeVsExpensesCard(
            title: appLocalizations.statisticsIncomeVsExpenses,
            child: StatisticsChartEmptyMessage(
              height: 220,
              message: appLocalizations.statisticsNoTransactionsInPeriod,
            ),
          );
        }

        return _IncomeVsExpensesCard(
          title: appLocalizations.statisticsIncomeVsExpenses,
          child: IncomeVsExpensesBarChart(series: series),
        );
      },
      loading: () => _IncomeVsExpensesCard(
        title: appLocalizations.statisticsIncomeVsExpenses,
        child: const StatisticsChartLoading(height: 220),
      ),
      error: (_, __) => _IncomeVsExpensesCard(
        title: appLocalizations.statisticsIncomeVsExpenses,
        child: StatisticsChartEmptyMessage(
          height: 220,
          message: appLocalizations.statisticsIncomeVsExpensesError,
        ),
      ),
    );
  }
}

class IncomeVsExpensesBarChart extends ConsumerWidget {
  const IncomeVsExpensesBarChart({super.key, required this.series});

  final IncomeVsExpensesSeries series;

  static const double _barWidth = 8;
  static const double _barsSpace = 4;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final textTheme = Theme.of(context).textTheme;
    final appLocalizations = ref.watch(appLocalizationsProvider);
    final currency = ref.watch(currentCurrencyProvider);
    final currencyPosition = ref.watch(currentCurrencySymbolPositionProvider);

    final maxValue = max(series.maxValue, 1.0);
    final labelStyle = textTheme.labelSmall?.copyWith(
          color: colors.textSecondary,
          fontWeight: FontWeight.bold,
          fontSize: 11,
        ) ??
        const TextStyle(
          color: CustomColors.chartLabelsGray,
          fontWeight: FontWeight.bold,
          fontSize: 11,
        );

    final barGroups = [
      for (var i = 0; i < series.buckets.length; i++)
        BarChartGroupData(
          x: i,
          barsSpace: _barsSpace,
          barRods: [
            BarChartRodData(
              toY: series.buckets[i].income,
              color: colors.income,
              width: _barWidth,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
            ),
            BarChartRodData(
              toY: series.buckets[i].expenses,
              color: colors.expense,
              width: _barWidth,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
            ),
          ],
        ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12,
      children: [
        Row(
          spacing: 16,
          children: [
            _LegendItem(
              color: colors.income,
              label: appLocalizations.income,
            ),
            _LegendItem(
              color: colors.expense,
              label: appLocalizations.statisticsExpenses,
            ),
          ],
        ),
        SizedBox(
          height: 220,
          child: BarChart(
            BarChartData(
              minY: 0,
              maxY: maxValue * 1.12,
              barTouchData: BarTouchData(
                touchTooltipData: BarTouchTooltipData(
                  getTooltipColor: (_) => colors.surface.withValues(alpha: 0.95),
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    final isIncome = rodIndex == 0;
                    final label = isIncome
                        ? appLocalizations.income
                        : appLocalizations.statisticsExpenses;
                    final amount = rod.toY.toStringAsFixedRoundedWithCurrency(
                      2,
                      currency,
                      currencyPosition,
                    );

                    return BarTooltipItem(
                      '$label\n$amount',
                      TextStyle(
                        color: colors.textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    );
                  },
                ),
              ),
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: maxValue / 2,
                getDrawingHorizontalLine: (value) => FlLine(
                  color: colors.divider.withValues(alpha: 0.35),
                  strokeWidth: 1,
                ),
              ),
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 30,
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      if (index < 0 || index >= series.buckets.length) {
                        return const SizedBox.shrink();
                      }

                      return SideTitleWidget(
                        meta: meta,
                        space: 6,
                        child: Text(
                          series.buckets[index].label,
                          style: labelStyle,
                          textAlign: TextAlign.center,
                        ),
                      );
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 32,
                    interval: maxValue / 2,
                    getTitlesWidget: (value, meta) => _buildLeftTitle(
                      meta: meta,
                      value: value,
                      maxY: maxValue * 1.12,
                      currency: currency,
                      currencyPosition: currencyPosition,
                      style: labelStyle,
                    ),
                  ),
                ),
              ),
              barGroups: barGroups,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLeftTitle({
    required TitleMeta meta,
    required double value,
    required double maxY,
    required Currency? currency,
    required CurrencySymbolPosition currencyPosition,
    required TextStyle style,
  }) {
    final midY = maxY / 2;
    final shouldShow =
        value == 0 || value == maxY || (value - midY).abs() < 0.01;
    if (!shouldShow) {
      return const SizedBox.shrink();
    }

    return SideTitleWidget(
      meta: meta,
      space: 2,
      child: Text(
        _formatAxisValue(value, currency, currencyPosition),
        style: style,
        textAlign: TextAlign.right,
      ),
    );
  }

  String _formatAxisValue(
    double value,
    Currency? currency,
    CurrencySymbolPosition currencyPosition,
  ) {
    if (value.abs() >= 1000) {
      final symbol = currency?.symbolNative ?? '';
      final formatted = NumberFormat.compact().format(value);
      return currencyPosition == CurrencySymbolPosition.leading
          ? '$symbol$formatted'
          : '$formatted$symbol';
    }

    return value.toStringAsFixedRoundedWithCurrency(0, currency, currencyPosition);
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 6,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: context.appColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _IncomeVsExpensesCard extends StatelessWidget {
  const _IncomeVsExpensesCard({
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
