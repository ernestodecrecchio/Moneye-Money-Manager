import 'dart:math';

import 'package:expense_tracker/core/models/currency.dart';
import 'package:expense_tracker/core/presentation/providers/app_localizations_provider.dart';
import 'package:expense_tracker/core/presentation/providers/currency_provider.dart';
import 'package:expense_tracker/core/style/app_theme.dart';
import 'package:expense_tracker/core/style/style.dart';
import 'package:expense_tracker/core/utils/double_helper.dart';
import 'package:expense_tracker/features/statistics/domain/models/cumulative_cashflow_series.dart';
import 'package:expense_tracker/features/statistics/presentation/providers/queries/cumulative_cashflow_notifier.dart';
import 'package:expense_tracker/features/statistics/presentation/providers/statistics_period_provider.dart';
import 'package:expense_tracker/features/statistics/presentation/widgets/statistics_empty_states.dart';
import 'package:expense_tracker/features/statistics/presentation/widgets/statistics_period_chart_support.dart';
import 'package:expense_tracker/features/statistics/presentation/widgets/statistics_surface_card.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

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
          return _CumulativeCashflowChartCard(
            title: appLocalizations.statisticsCashflowCumulativeChart,
            subtitle: appLocalizations.statisticsCashflowCumulativeChartSubtitle,
            child: StatisticsChartEmptyMessage(
              height: 220,
              message: appLocalizations.statisticsNoTransactionsInPeriod,
            ),
          );
        }

        if (series.hasInsufficientData) {
          return _CumulativeCashflowChartCard(
            title: appLocalizations.statisticsCashflowCumulativeChart,
            subtitle: appLocalizations.statisticsCashflowCumulativeChartSubtitle,
            child: StatisticsChartEmptyMessage(
              height: 220,
              message: appLocalizations
                  .statisticsCashflowCumulativeChartInsufficientData,
            ),
          );
        }

        return _CumulativeCashflowChartCard(
          title: appLocalizations.statisticsCashflowCumulativeChart,
          subtitle: appLocalizations.statisticsCashflowCumulativeChartSubtitle,
          child: CumulativeCashflowLineChart(series: series),
        );
      },
      loading: () => _CumulativeCashflowChartCard(
        title: appLocalizations.statisticsCashflowCumulativeChart,
        subtitle: appLocalizations.statisticsCashflowCumulativeChartSubtitle,
        child: const StatisticsChartLoading(height: 220),
      ),
      error: (_, __) => _CumulativeCashflowChartCard(
        title: appLocalizations.statisticsCashflowCumulativeChart,
        subtitle: appLocalizations.statisticsCashflowCumulativeChartSubtitle,
        child: StatisticsChartEmptyMessage(
          height: 220,
          message: appLocalizations.statisticsCashflowCumulativeChartError,
        ),
      ),
    );
  }
}

class CumulativeCashflowLineChart extends ConsumerWidget {
  const CumulativeCashflowLineChart({super.key, required this.series});

  final CumulativeCashflowSeries series;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final textTheme = Theme.of(context).textTheme;
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

    return SizedBox(
      height: 220,
      child: LineChart(
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
                reservedSize: 48,
                interval: range / 2,
                getTitlesWidget: (value, meta) => _buildLeftTitle(
                  meta: meta,
                  value: value,
                  minY: minY,
                  maxY: maxY,
                  currency: currency,
                  currencyPosition: currencyPosition,
                  style: labelStyle,
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
      ),
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

  Widget _buildLeftTitle({
    required TitleMeta meta,
    required double value,
    required double minY,
    required double maxY,
    required Currency? currency,
    required CurrencySymbolPosition currencyPosition,
    required TextStyle style,
  }) {
    final midY = minY + (maxY - minY) / 2;
    final shouldShow = value == minY ||
        value == maxY ||
        (value - midY).abs() < 0.01 ||
        (minY < 0 && value == 0) ||
        (maxY > 0 && minY < 0 && value == 0);
    if (!shouldShow) {
      return const SizedBox.shrink();
    }

    return SideTitleWidget(
      meta: meta,
      space: 6,
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

    return value.toStringAsFixedRoundedWithCurrency(
      0,
      currency,
      currencyPosition,
    );
  }
}

class _CumulativeCashflowChartCard extends StatelessWidget {
  const _CumulativeCashflowChartCard({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return StatisticsSurfaceCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 4,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 13,
                  height: 1.4,
                  color: colors.textSecondary,
                ),
              ),
            ],
          ),
          child,
        ],
      ),
    );
  }
}
