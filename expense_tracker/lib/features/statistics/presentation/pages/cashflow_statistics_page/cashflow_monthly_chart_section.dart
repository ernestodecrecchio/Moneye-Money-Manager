import 'dart:math';

import 'package:expense_tracker/core/presentation/providers/app_localizations_provider.dart';
import 'package:expense_tracker/core/presentation/providers/currency_provider.dart';
import 'package:expense_tracker/core/style/app_theme.dart';
import 'package:expense_tracker/core/utils/double_helper.dart';
import 'package:expense_tracker/features/statistics/domain/models/monthly_cashflow_series.dart';
import 'package:expense_tracker/features/statistics/presentation/providers/queries/monthly_cashflow_notifier.dart';
import 'package:expense_tracker/features/statistics/presentation/providers/statistics_period_provider.dart';
import 'package:expense_tracker/features/statistics/presentation/widgets/statistics_chart_axis.dart';
import 'package:expense_tracker/features/statistics/presentation/widgets/statistics_empty_states.dart';
import 'package:expense_tracker/features/statistics/presentation/widgets/statistics_layout.dart';
import 'package:expense_tracker/features/statistics/presentation/widgets/statistics_period_chart_support.dart';
import 'package:expense_tracker/features/statistics/presentation/widgets/statistics_section_card.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CashflowMonthlyChartSection extends ConsumerWidget {
  const CashflowMonthlyChartSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final period = ref.watch(statisticsPeriodProvider);
    if (!statisticsPeriodSupportsMultipleMonths(period)) {
      return const SizedBox.shrink();
    }

    final appLocalizations = ref.watch(appLocalizationsProvider);
    final seriesAsync = ref.watch(monthlyCashflowProvider);

    return seriesAsync.when(
      data: (series) {
        if (series.isEmpty) {
          return StatisticsSectionCard(
            title: appLocalizations.statisticsCashflowMonthlyChart,
            child: StatisticsChartEmptyMessage(
              message: appLocalizations.statisticsNoTransactionsInPeriod,
            ),
          );
        }

        if (series.hasInsufficientData) {
          return StatisticsSectionCard(
            title: appLocalizations.statisticsCashflowMonthlyChart,
            child: StatisticsChartEmptyMessage(
              message:
                  appLocalizations.statisticsCashflowMonthlyChartInsufficientData,
            ),
          );
        }

        return StatisticsSectionCard(
          title: appLocalizations.statisticsCashflowMonthlyChart,
          fullscreenChartBuilder: ({required bool expanded}) =>
              MonthlyCashflowChart(series: series, expanded: expanded),
          child: MonthlyCashflowChart(series: series),
        );
      },
      loading: () => StatisticsSectionCard(
        title: appLocalizations.statisticsCashflowMonthlyChart,
        child: const StatisticsChartLoading(),
      ),
      error: (_, __) => StatisticsSectionCard(
        title: appLocalizations.statisticsCashflowMonthlyChart,
        child: StatisticsChartEmptyMessage(
          message: appLocalizations.statisticsCashflowMonthlyChartError,
        ),
      ),
    );
  }
}

class MonthlyCashflowChart extends ConsumerWidget {
  const MonthlyCashflowChart({
    super.key,
    required this.series,
    this.expanded = false,
  });

  final MonthlyCashflowSeries series;
  final bool expanded;

  static const double _barWidth = 7;
  static const double _barsSpace = 3;
  static const double _bottomTitleReservedSize = 28;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final appLocalizations = ref.watch(appLocalizationsProvider);
    final currency = ref.watch(currentCurrencyProvider);
    final currencyPosition = ref.watch(currentCurrencySymbolPositionProvider);

    final minY = series.chartMinY;
    final maxY = series.chartMaxY;
    final labelInterval = max(1, (series.points.length / 5).floor()).toDouble();

    final labelStyle = StatisticsLayout.chartAxisLabelStyle(context);
    final leftReservedSize = StatisticsChartAxis.computeLeftReservedSize(
      style: labelStyle,
      minY: minY,
      maxY: maxY,
      currency: currency,
      currencyPosition: currencyPosition,
      showZeroWhenCrossing: true,
    );

    final barGroups = [
      for (var monthIndex = 0; monthIndex < series.points.length; monthIndex++)
        BarChartGroupData(
          x: monthIndex,
          barsSpace: _barsSpace,
          barRods: [
            BarChartRodData(
              fromY: 0,
              toY: series.points[monthIndex].income,
              color: colors.income,
              width: _barWidth,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(3)),
            ),
            BarChartRodData(
              fromY: 0,
              toY: series.points[monthIndex].expenses,
              color: colors.expense,
              width: _barWidth,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(3)),
            ),
          ],
        ),
    ];

    final netLineSpots = [
      for (var i = 0; i < series.points.length; i++)
        FlSpot(i.toDouble(), series.points[i].netCashflow),
    ];

    final chartStack = Stack(
      children: [
        BarChart(
          BarChartData(
            minY: minY,
            maxY: maxY,
            barTouchData: BarTouchData(
              touchTooltipData: BarTouchTooltipData(
                getTooltipColor: (_) => colors.surface.withValues(alpha: 0.95),
                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                  if (rodIndex != 0) {
                    return null;
                  }
                  if (groupIndex < 0 || groupIndex >= series.points.length) {
                    return null;
                  }

                  final point = series.points[groupIndex];
                  final incomeLabel =
                      point.income.toStringAsFixedRoundedWithCurrency(
                    2,
                    currency,
                    currencyPosition,
                  );
                  final expensesLabel =
                      point.expenses.toStringAsFixedRoundedWithCurrency(
                    2,
                    currency,
                    currencyPosition,
                  );
                  final netLabel =
                      point.netCashflow.toStringAsFixedRoundedWithCurrency(
                    2,
                    currency,
                    currencyPosition,
                  );

                  return BarTooltipItem(
                    '${point.label}\n'
                    '${appLocalizations.income}: $incomeLabel\n'
                    '${appLocalizations.statisticsExpenses}: $expensesLabel\n'
                    '${appLocalizations.statisticsNetCashflow}: $netLabel',
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
              horizontalInterval: (maxY - minY) / 2,
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
                  reservedSize: _bottomTitleReservedSize,
                  interval: labelInterval,
                  getTitlesWidget: (value, meta) {
                    final index = value.toInt();
                    if (index < 0 || index >= series.points.length) {
                      return const SizedBox.shrink();
                    }

                    return SideTitleWidget(
                      meta: meta,
                      space: 6,
                      child: Text(
                        series.points[index].label,
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
                  reservedSize: leftReservedSize,
                  interval: (maxY - minY) / 2,
                  getTitlesWidget: (value, meta) =>
                      StatisticsChartAxis.buildLeftTitle(
                    meta: meta,
                    value: value,
                    minY: minY,
                    maxY: maxY,
                    currency: currency,
                    currencyPosition: currencyPosition,
                    style: labelStyle,
                    showZeroWhenCrossing: true,
                  ),
                ),
              ),
            ),
            barGroups: barGroups,
          ),
        ),
        if (series.showNetLine)
          LineChart(
            LineChartData(
              minX: 0,
              maxX: max(series.points.length - 1, 1).toDouble(),
              minY: minY,
              maxY: maxY,
              clipData: const FlClipData.all(),
              gridData: const FlGridData(show: false),
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: false,
                    reservedSize: leftReservedSize,
                  ),
                ),
                bottomTitles: const AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: false,
                    reservedSize: _bottomTitleReservedSize,
                  ),
                ),
              ),
              lineTouchData: const LineTouchData(enabled: false),
              lineBarsData: [
                LineChartBarData(
                  spots: netLineSpots,
                  isCurved: false,
                  color: colors.primary,
                  barWidth: 2,
                  dotData: FlDotData(
                    show: series.points.length <= 12,
                    getDotPainter: (spot, percent, barData, index) {
                      return FlDotCirclePainter(
                        radius: 3,
                        color: colors.primary,
                        strokeWidth: 0,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
      ],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12,
      children: [
        Wrap(
          spacing: 12,
          runSpacing: 8,
          children: [
            _LegendSwatch(
              color: colors.income,
              label: appLocalizations.income,
            ),
            _LegendSwatch(
              color: colors.expense,
              label: appLocalizations.statisticsExpenses,
            ),
            if (series.showNetLine)
              _LegendLine(
                color: colors.primary,
                label: appLocalizations.statisticsNetCashflow,
              ),
          ],
        ),
        if (expanded)
          Expanded(child: chartStack)
        else
          SizedBox(
            height: StatisticsLayout.chartHeight,
            child: chartStack,
          ),
      ],
    );
  }
}

class _LegendSwatch extends StatelessWidget {
  const _LegendSwatch({required this.color, required this.label});

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

class _LegendLine extends StatelessWidget {
  const _LegendLine({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 6,
      children: [
        Container(
          width: 14,
          height: 2,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(1),
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
