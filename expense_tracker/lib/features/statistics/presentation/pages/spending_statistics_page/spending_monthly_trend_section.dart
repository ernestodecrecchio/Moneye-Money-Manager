import 'dart:math';

import 'package:expense_tracker/core/models/currency.dart';
import 'package:expense_tracker/core/presentation/providers/app_localizations_provider.dart';
import 'package:expense_tracker/core/presentation/providers/currency_provider.dart';
import 'package:expense_tracker/core/style/app_theme.dart';
import 'package:expense_tracker/core/style/style.dart';
import 'package:expense_tracker/core/utils/double_helper.dart';
import 'package:expense_tracker/features/statistics/domain/models/monthly_spending_trend_series.dart';
import 'package:expense_tracker/features/statistics/presentation/providers/queries/monthly_spending_trend_notifier.dart';
import 'package:expense_tracker/features/statistics/presentation/providers/statistics_period_provider.dart';
import 'package:expense_tracker/features/statistics/presentation/widgets/statistics_empty_states.dart';
import 'package:expense_tracker/features/statistics/presentation/widgets/statistics_period_chart_support.dart';
import 'package:expense_tracker/features/statistics/presentation/widgets/statistics_surface_card.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class SpendingMonthlyTrendSection extends ConsumerWidget {
  const SpendingMonthlyTrendSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final period = ref.watch(statisticsPeriodProvider);
    if (!statisticsPeriodSupportsMultipleMonths(period)) {
      return const SizedBox.shrink();
    }

    final appLocalizations = ref.watch(appLocalizationsProvider);
    final seriesAsync = ref.watch(monthlySpendingTrendProvider);

    return seriesAsync.when(
      data: (series) {
        if (series.isEmpty) {
          return _MonthlyTrendCard(
            title: appLocalizations.statisticsSpendingMonthlyTrend,
            child: StatisticsChartEmptyMessage(
              height: 200,
              message: appLocalizations.statisticsNoExpensesInPeriod,
            ),
          );
        }

        if (series.hasInsufficientData) {
          return _MonthlyTrendCard(
            title: appLocalizations.statisticsSpendingMonthlyTrend,
            child: StatisticsChartEmptyMessage(
              height: 200,
              message:
                  appLocalizations.statisticsSpendingMonthlyTrendInsufficientData,
            ),
          );
        }

        return _MonthlyTrendCard(
          title: appLocalizations.statisticsSpendingMonthlyTrend,
          child: MonthlySpendingTrendLineChart(series: series),
        );
      },
      loading: () => _MonthlyTrendCard(
        title: appLocalizations.statisticsSpendingMonthlyTrend,
        child: const StatisticsChartLoading(height: 200),
      ),
      error: (_, __) => _MonthlyTrendCard(
        title: appLocalizations.statisticsSpendingMonthlyTrend,
        child: StatisticsChartEmptyMessage(
          height: 200,
          message: appLocalizations.statisticsSpendingMonthlyTrendError,
        ),
      ),
    );
  }
}

class MonthlySpendingTrendLineChart extends ConsumerWidget {
  const MonthlySpendingTrendLineChart({
    super.key,
    required this.series,
    this.lineColor,
  });

  final MonthlySpendingTrendSeries series;
  final Color? lineColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final textTheme = Theme.of(context).textTheme;
    final appLocalizations = ref.watch(appLocalizationsProvider);
    final currency = ref.watch(currentCurrencyProvider);
    final currencyPosition = ref.watch(currentCurrencySymbolPositionProvider);

    final maxValue = max(series.maxExpenses, 1.0);
    final chartPadding = maxValue * 0.12;
    final maxY = maxValue + chartPadding;
    final labelInterval = max(1, (series.points.length / 5).floor()).toDouble();
    final showDots = series.points.length <= 12;
    final chartColor = lineColor ?? colors.expense;

    final spots = [
      for (var i = 0; i < series.points.length; i++)
        FlSpot(i.toDouble(), series.points[i].expenses),
    ];

    final labelStyle = textTheme.labelSmall?.copyWith(
          color: colors.textSecondary,
          fontWeight: FontWeight.bold,
        ) ??
        const TextStyle(
          color: CustomColors.chartLabelsGray,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        );

    return SizedBox(
      height: 220,
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: max(series.points.length - 1, 1).toDouble(),
          minY: 0,
          maxY: maxY,
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
                reservedSize: 28,
                interval: labelInterval,
                getTitlesWidget: (value, meta) => _buildBottomTitle(
                  meta: meta,
                  value: value,
                  series: series,
                  style: labelStyle,
                ),
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 48,
                interval: maxValue / 2,
                getTitlesWidget: (value, meta) => _buildLeftTitle(
                  meta: meta,
                  value: value,
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
                  final monthLabel = DateFormat.yMMM(
                    appLocalizations.localeName,
                  ).format(point.monthStart);
                  final amountLabel =
                      point.expenses.toStringAsFixedRoundedWithCurrency(
                    2,
                    currency,
                    currencyPosition,
                  );

                  return LineTooltipItem(
                    '$monthLabel\n$amountLabel',
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
              color: chartColor,
              barWidth: 2.5,
              dotData: FlDotData(show: showDots),
              belowBarData: BarAreaData(
                show: true,
                color: chartColor.withValues(alpha: 0.12),
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
    required MonthlySpendingTrendSeries series,
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
        series.points[index].label,
        style: style,
        textAlign: TextAlign.center,
      ),
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
      space: 6,
      child: Text(
        _formatLeftAxisValue(value, currency, currencyPosition),
        style: style,
        textAlign: TextAlign.right,
      ),
    );
  }

  String _formatLeftAxisValue(
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

class _MonthlyTrendCard extends StatelessWidget {
  const _MonthlyTrendCard({
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
