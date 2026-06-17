import 'dart:math';

import 'package:expense_tracker/core/models/currency.dart';
import 'package:expense_tracker/core/presentation/providers/app_localizations_provider.dart';
import 'package:expense_tracker/core/presentation/providers/currency_provider.dart';
import 'package:expense_tracker/core/style/app_theme.dart';
import 'package:expense_tracker/core/style/style.dart';
import 'package:expense_tracker/core/utils/double_helper.dart';
import 'package:expense_tracker/features/statistics/domain/models/monthly_cashflow_series.dart';
import 'package:expense_tracker/features/statistics/presentation/providers/queries/monthly_cashflow_notifier.dart';
import 'package:expense_tracker/features/statistics/presentation/widgets/statistics_surface_card.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class CashflowMonthlyChartSection extends ConsumerWidget {
  const CashflowMonthlyChartSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocalizations = ref.watch(appLocalizationsProvider);
    final seriesAsync = ref.watch(monthlyCashflowProvider);

    return seriesAsync.when(
      data: (series) {
        if (series.hasInsufficientData) {
          return _CashflowMonthlyChartCard(
            title: appLocalizations.statisticsCashflowMonthlyChart,
            child: _EmptyChartMessage(
              message:
                  appLocalizations.statisticsCashflowMonthlyChartInsufficientData,
            ),
          );
        }

        if (series.isEmpty) {
          return _CashflowMonthlyChartCard(
            title: appLocalizations.statisticsCashflowMonthlyChart,
            child: _EmptyChartMessage(
              message: appLocalizations.statisticsNoTransactionsInPeriod,
            ),
          );
        }

        return _CashflowMonthlyChartCard(
          title: appLocalizations.statisticsCashflowMonthlyChart,
          child: MonthlyCashflowChart(series: series),
        );
      },
      loading: () => _CashflowMonthlyChartCard(
        title: appLocalizations.statisticsCashflowMonthlyChart,
        child: const SizedBox(
          height: 220,
          child: Center(child: CircularProgressIndicator()),
        ),
      ),
      error: (_, __) => _CashflowMonthlyChartCard(
        title: appLocalizations.statisticsCashflowMonthlyChart,
        child: _EmptyChartMessage(
          message: appLocalizations.statisticsCashflowMonthlyChartError,
        ),
      ),
    );
  }
}

class MonthlyCashflowChart extends ConsumerWidget {
  const MonthlyCashflowChart({super.key, required this.series});

  final MonthlyCashflowSeries series;

  static const double _barWidth = 7;
  static const double _barsSpace = 3;
  static const double _leftTitleReservedSize = 48;
  static const double _bottomTitleReservedSize = 28;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final textTheme = Theme.of(context).textTheme;
    final appLocalizations = ref.watch(appLocalizationsProvider);
    final currency = ref.watch(currentCurrencyProvider);
    final currencyPosition = ref.watch(currentCurrencySymbolPositionProvider);

    final minY = series.chartMinY;
    final maxY = series.chartMaxY;
    final labelInterval = max(1, (series.points.length / 5).floor()).toDouble();

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
        SizedBox(
          height: 220,
          child: Stack(
            children: [
              BarChart(
                BarChartData(
                  minY: minY,
                  maxY: maxY,
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipColor: (_) =>
                          colors.surface.withValues(alpha: 0.95),
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        if (rodIndex != 0) {
                          return null;
                        }
                        if (groupIndex < 0 ||
                            groupIndex >= series.points.length) {
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
                        reservedSize: _leftTitleReservedSize,
                        interval: (maxY - minY) / 2,
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
                      leftTitles: const AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: false,
                          reservedSize: _leftTitleReservedSize,
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
          ),
        ),
      ],
    );
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
        (minY < 0 && value == 0);
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

class _CashflowMonthlyChartCard extends StatelessWidget {
  const _CashflowMonthlyChartCard({
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

class _EmptyChartMessage extends StatelessWidget {
  const _EmptyChartMessage({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      height: 220,
      width: double.infinity,
      decoration: BoxDecoration(
        color: colors.divider.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 14,
          color: colors.textSecondary,
        ),
      ),
    );
  }
}
