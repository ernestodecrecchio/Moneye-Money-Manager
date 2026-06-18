import 'dart:math';

import 'package:expense_tracker/core/presentation/providers/app_localizations_provider.dart';
import 'package:expense_tracker/core/presentation/providers/currency_provider.dart';
import 'package:expense_tracker/core/style/app_theme.dart';
import 'package:expense_tracker/core/utils/double_helper.dart';
import 'package:expense_tracker/features/statistics/domain/models/net_worth_trend_series.dart';
import 'package:expense_tracker/features/statistics/domain/models/statistics_period_granularity.dart';
import 'package:expense_tracker/features/statistics/presentation/providers/queries/net_worth_trend_notifier.dart';
import 'package:expense_tracker/features/statistics/presentation/providers/statistics_period_provider.dart';
import 'package:expense_tracker/features/statistics/presentation/widgets/statistics_chart_axis.dart';
import 'package:expense_tracker/features/statistics/presentation/widgets/statistics_empty_states.dart';
import 'package:expense_tracker/features/statistics/presentation/widgets/statistics_layout.dart';
import 'package:expense_tracker/features/statistics/presentation/widgets/statistics_section_card.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class OverviewNetWorthTrendSection extends ConsumerWidget {
  const OverviewNetWorthTrendSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocalizations = ref.watch(appLocalizationsProvider);
    final trendAsync = ref.watch(netWorthTrendProvider);

    return trendAsync.when(
      data: (series) {
        if (series.hasInsufficientData) {
          return StatisticsSectionCard(
            title: appLocalizations.statisticsNetWorthTrend,
            child: StatisticsChartEmptyMessage(
              message: appLocalizations.statisticsNetWorthTrendInsufficientData,
            ),
          );
        }

        return StatisticsSectionCard(
          title: appLocalizations.statisticsNetWorthTrend,
          child: NetWorthTrendLineChart(series: series),
        );
      },
      loading: () => StatisticsSectionCard(
        title: appLocalizations.statisticsNetWorthTrend,
        child: const StatisticsChartLoading(),
      ),
      error: (_, __) => StatisticsSectionCard(
        title: appLocalizations.statisticsNetWorthTrend,
        child: StatisticsChartEmptyMessage(
          message: appLocalizations.statisticsNetWorthTrendError,
        ),
      ),
    );
  }
}

class NetWorthTrendLineChart extends ConsumerWidget {
  const NetWorthTrendLineChart({super.key, required this.series});

  final NetWorthTrendSeries series;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final appLocalizations = ref.watch(appLocalizationsProvider);
    final period = ref.watch(statisticsPeriodProvider);
    final currency = ref.watch(currentCurrencyProvider);
    final currencyPosition = ref.watch(currentCurrencySymbolPositionProvider);

    final minValue = series.minNetWorth;
    final maxValue = series.maxNetWorth;
    final range = max(maxValue - minValue, 1.0);
    final chartPadding = range * 0.08;
    final minY = minValue - chartPadding;
    final maxY = maxValue + chartPadding;
    final labelInterval = max(1, (series.points.length / 5).floor()).toDouble();
    final showDots = series.points.length <= 12;

    final spots = [
      for (var i = 0; i < series.points.length; i++)
        FlSpot(i.toDouble(), series.points[i].netWorth),
    ];

    final labelStyle = StatisticsLayout.chartAxisLabelStyle(context);
    final leftReservedSize = StatisticsChartAxis.computeLeftReservedSize(
      style: labelStyle,
      minY: minY,
      maxY: maxY,
      currency: currency,
      currencyPosition: currencyPosition,
    );

    return SizedBox(
      height: StatisticsLayout.chartHeight,
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: max(series.points.length - 1, 1).toDouble(),
          minY: minY,
          maxY: maxY,
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: range <= 0 ? 1 : range / 2,
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
                reservedSize: 28,
                interval: labelInterval,
                getTitlesWidget: (value, meta) => _buildBottomTitle(
                  meta: meta,
                  value: value,
                  series: series,
                  granularity: period.granularity,
                  locale: appLocalizations.localeName,
                  style: labelStyle,
                ),
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: leftReservedSize,
                interval: range <= 0 ? 1 : range / 2,
                getTitlesWidget: (value, meta) =>
                    StatisticsChartAxis.buildLeftTitle(
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
                  final dateLabel = _formatTooltipDate(
                    point.date,
                    period.granularity,
                    appLocalizations.localeName,
                  );
                  final amountLabel =
                      point.netWorth.toStringAsFixedRoundedWithCurrency(
                    2,
                    currency,
                    currencyPosition,
                  );

                  return LineTooltipItem(
                    '$dateLabel\n$amountLabel',
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
              isCurved: series.points.length > 2,
              color: colors.primary,
              barWidth: 2.5,
              dotData: FlDotData(show: showDots),
              belowBarData: BarAreaData(
                show: true,
                color: colors.primary.withValues(alpha: 0.12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomTitle({
    required TitleMeta meta,
    required double value,
    required NetWorthTrendSeries series,
    required StatisticsPeriodGranularity granularity,
    required String locale,
    required TextStyle style,
  }) {
    final index = value.round();
    if (index < 0 || index >= series.points.length) {
      return const SizedBox.shrink();
    }

    return SideTitleWidget(
      meta: meta,
      space: 6,
      child: Text(
        _formatAxisLabel(
          series.points[index].date,
          granularity,
          locale,
        ),
        style: style,
        textAlign: TextAlign.center,
      ),
    );
  }

  String _formatAxisLabel(
    DateTime date,
    StatisticsPeriodGranularity granularity,
    String locale,
  ) {
    return switch (granularity) {
      StatisticsPeriodGranularity.month => DateFormat.d(locale).format(date),
      StatisticsPeriodGranularity.quarter =>
        DateFormat.MMMd(locale).format(date),
      StatisticsPeriodGranularity.year => DateFormat.MMM(locale).format(date),
    };
  }

  String _formatTooltipDate(
    DateTime date,
    StatisticsPeriodGranularity granularity,
    String locale,
  ) {
    return switch (granularity) {
      StatisticsPeriodGranularity.month ||
      StatisticsPeriodGranularity.quarter =>
        DateFormat.yMMMd(locale).format(date),
      StatisticsPeriodGranularity.year => DateFormat.yMMM(locale).format(date),
    };
  }
}
