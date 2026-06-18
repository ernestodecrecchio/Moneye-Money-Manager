import 'dart:math';

import 'package:expense_tracker/core/presentation/providers/app_localizations_provider.dart';
import 'package:expense_tracker/core/presentation/providers/currency_provider.dart';
import 'package:expense_tracker/core/style/app_theme.dart';
import 'package:expense_tracker/core/utils/double_helper.dart';
import 'package:expense_tracker/features/statistics/domain/models/cumulative_cashflow_series.dart';
import 'package:expense_tracker/features/statistics/presentation/providers/queries/cumulative_cashflow_notifier.dart';
import 'package:expense_tracker/features/statistics/presentation/providers/statistics_period_provider.dart';
import 'package:expense_tracker/features/statistics/presentation/widgets/statistics_chart_axis.dart';
import 'package:expense_tracker/features/statistics/presentation/widgets/statistics_empty_states.dart';
import 'package:expense_tracker/features/statistics/presentation/widgets/statistics_layout.dart';
import 'package:expense_tracker/features/statistics/presentation/widgets/statistics_period_chart_support.dart';
import 'package:expense_tracker/features/statistics/presentation/widgets/statistics_section_card.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CashflowCumulativeChartSection extends ConsumerWidget {
  const CashflowCumulativeChartSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final period = ref.watch(statisticsPeriodProvider);
    if (!statisticsPeriodSupportsMultipleMonths(period)) {
      return const SizedBox.shrink();
    }

    final appLocalizations = ref.watch(appLocalizationsProvider);
    final seriesAsync = ref.watch(cumulativeCashflowProvider);

    return seriesAsync.when(
      data: (series) {
        if (series.isEmpty) {
          return StatisticsSectionCard(
            title: appLocalizations.statisticsCashflowCumulativeChart,
            subtitle: appLocalizations.statisticsCashflowCumulativeChartSubtitle,
            child: StatisticsChartEmptyMessage(
              message: appLocalizations.statisticsNoTransactionsInPeriod,
            ),
          );
        }

        if (series.hasInsufficientData) {
          return StatisticsSectionCard(
            title: appLocalizations.statisticsCashflowCumulativeChart,
            subtitle: appLocalizations.statisticsCashflowCumulativeChartSubtitle,
            child: StatisticsChartEmptyMessage(
              message: appLocalizations
                  .statisticsCashflowCumulativeChartInsufficientData,
            ),
          );
        }

        return StatisticsSectionCard(
          title: appLocalizations.statisticsCashflowCumulativeChart,
          subtitle: appLocalizations.statisticsCashflowCumulativeChartSubtitle,
          fullscreenChartBuilder: ({required bool expanded}) =>
              CumulativeCashflowLineChart(series: series, expanded: expanded),
          child: CumulativeCashflowLineChart(series: series),
        );
      },
      loading: () => StatisticsSectionCard(
        title: appLocalizations.statisticsCashflowCumulativeChart,
        subtitle: appLocalizations.statisticsCashflowCumulativeChartSubtitle,
        child: const StatisticsChartLoading(),
      ),
      error: (_, __) => StatisticsSectionCard(
        title: appLocalizations.statisticsCashflowCumulativeChart,
        subtitle: appLocalizations.statisticsCashflowCumulativeChartSubtitle,
        child: StatisticsChartEmptyMessage(
          message: appLocalizations.statisticsCashflowCumulativeChartError,
        ),
      ),
    );
  }
}

class CumulativeCashflowLineChart extends ConsumerWidget {
  const CumulativeCashflowLineChart({
    super.key,
    required this.series,
    this.expanded = false,
  });

  final CumulativeCashflowSeries series;
  final bool expanded;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final appLocalizations = ref.watch(appLocalizationsProvider);
    final currency = ref.watch(currentCurrencyProvider);
    final currencyPosition = ref.watch(currentCurrencySymbolPositionProvider);

    final minY = series.chartMinY;
    final maxY = series.chartMaxY;
    final range = max(maxY - minY, 1.0);
    final labelInterval = max(1, (series.points.length / 5).floor()).toDouble();
    final showDots = series.points.length <= 12;
    final lineColor = _lineColorForSeries(series, colors);

    final spots = [
      for (var i = 0; i < series.points.length; i++)
        FlSpot(i.toDouble(), series.points[i].cumulativeNetCashflow),
    ];

    final labelStyle = StatisticsLayout.chartAxisLabelStyle(context);
    final leftReservedSize = StatisticsChartAxis.computeLeftReservedSize(
      style: labelStyle,
      minY: minY,
      maxY: maxY,
      currency: currency,
      currencyPosition: currencyPosition,
      showZeroWhenCrossing: true,
    );

    final lineChart = LineChart(
      LineChartData(
          minX: 0,
          maxX: max(series.points.length - 1, 1).toDouble(),
          minY: minY,
          maxY: maxY,
          clipData: const FlClipData.all(),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: range / 2,
            getDrawingHorizontalLine: (value) {
              if (value == 0) {
                return FlLine(
                  color: colors.textSecondary.withValues(alpha: 0.35),
                  strokeWidth: 1,
                );
              }

              return FlLine(
                color: colors.divider.withValues(alpha: 0.35),
                strokeWidth: 1,
              );
            },
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
                reservedSize: 28,
                interval: labelInterval,
                getTitlesWidget: (value, meta) {
                  final index = value.round();
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
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: leftReservedSize,
                interval: range / 2,
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
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (_) => colors.surface.withValues(alpha: 0.95),
              getTooltipItems: (touchedSpots) {
                return touchedSpots.map((spot) {
                  final index = spot.x.round();
                  if (index < 0 || index >= series.points.length) {
                    return null;
                  }

                  final point = series.points[index];
                  final amountLabel =
                      point.cumulativeNetCashflow.toStringAsFixedRoundedWithCurrency(
                    2,
                    currency,
                    currencyPosition,
                  );

                  return LineTooltipItem(
                    '${point.label}\n'
                    '${appLocalizations.statisticsNetCashflow}: $amountLabel',
                    TextStyle(
                      color: colors.textPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  );
                }).toList();
              },
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: false,
              color: lineColor,
              barWidth: 2.5,
              dotData: FlDotData(show: showDots),
              belowBarData: BarAreaData(
                show: true,
                color: lineColor.withValues(alpha: 0.12),
              ),
            ),
          ],
        ),
    );

    if (expanded) {
      return SizedBox.expand(child: lineChart);
    }

    return SizedBox(
      height: StatisticsLayout.chartHeight,
      child: lineChart,
    );
  }

  Color _lineColorForSeries(CumulativeCashflowSeries series, AppColors colors) {
    if (series.points.isEmpty) {
      return colors.primary;
    }

    final finalValue = series.points.last.cumulativeNetCashflow;
    if (finalValue > 0) {
      return colors.income;
    }
    if (finalValue < 0) {
      return colors.expense;
    }

    return colors.primary;
  }
}
