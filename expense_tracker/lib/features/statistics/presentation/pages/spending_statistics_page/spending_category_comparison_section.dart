import 'dart:math';

import 'package:expense_tracker/core/models/currency.dart';
import 'package:expense_tracker/core/presentation/common/category_ui_extension.dart';
import 'package:expense_tracker/core/presentation/providers/app_localizations_provider.dart';
import 'package:expense_tracker/core/presentation/providers/currency_provider.dart';
import 'package:expense_tracker/core/style/app_theme.dart';
import 'package:expense_tracker/core/utils/double_helper.dart';
import 'package:expense_tracker/features/statistics/domain/models/category_comparison_series.dart';
import 'package:expense_tracker/features/statistics/presentation/providers/queries/category_comparison_notifier.dart';
import 'package:expense_tracker/features/statistics/presentation/providers/statistics_period_provider.dart';
import 'package:expense_tracker/features/statistics/presentation/widgets/statistics_empty_states.dart';
import 'package:expense_tracker/features/statistics/presentation/widgets/statistics_layout.dart';
import 'package:expense_tracker/features/statistics/presentation/widgets/statistics_period_chart_support.dart';
import 'package:expense_tracker/features/statistics/presentation/widgets/statistics_section_card.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class SpendingCategoryComparisonSection extends ConsumerWidget {
  const SpendingCategoryComparisonSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final period = ref.watch(statisticsPeriodProvider);
    if (!statisticsPeriodSupportsMultipleMonths(period)) {
      return const SizedBox.shrink();
    }

    final appLocalizations = ref.watch(appLocalizationsProvider);
    final seriesAsync = ref.watch(categoryComparisonProvider);

    return seriesAsync.when(
      data: (series) {
        if (series.isEmpty) {
          return StatisticsSectionCard(
            title: appLocalizations.statisticsSpendingCategoryComparison,
            subtitle:
                appLocalizations.statisticsSpendingCategoryComparisonSubtitle,
            child: StatisticsChartEmptyMessage(
              message: appLocalizations.statisticsNoExpensesInPeriod,
            ),
          );
        }

        if (series.hasInsufficientData) {
          return StatisticsSectionCard(
            title: appLocalizations.statisticsSpendingCategoryComparison,
            subtitle:
                appLocalizations.statisticsSpendingCategoryComparisonSubtitle,
            child: StatisticsChartEmptyMessage(
              message: appLocalizations
                  .statisticsSpendingCategoryComparisonInsufficientData,
            ),
          );
        }

        return StatisticsSectionCard(
          title: appLocalizations.statisticsSpendingCategoryComparison,
          subtitle:
              appLocalizations.statisticsSpendingCategoryComparisonSubtitle,
          child: CategoryComparisonBarChart(series: series),
        );
      },
      loading: () => StatisticsSectionCard(
        title: appLocalizations.statisticsSpendingCategoryComparison,
        subtitle: appLocalizations.statisticsSpendingCategoryComparisonSubtitle,
        child: const StatisticsChartLoading(),
      ),
      error: (_, __) => StatisticsSectionCard(
        title: appLocalizations.statisticsSpendingCategoryComparison,
        subtitle: appLocalizations.statisticsSpendingCategoryComparisonSubtitle,
        child: StatisticsChartEmptyMessage(
          message: appLocalizations.statisticsSpendingCategoryComparisonError,
        ),
      ),
    );
  }
}

class CategoryComparisonBarChart extends ConsumerWidget {
  const CategoryComparisonBarChart({super.key, required this.series});

  final CategoryComparisonSeries series;

  static const double _barWidth = 6;
  static const double _barsSpace = 0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final currency = ref.watch(currentCurrencyProvider);
    final currencyPosition = ref.watch(currentCurrencySymbolPositionProvider);

    final maxValue = max(series.maxAmount, 1.0);
    final labelInterval = max(1, (series.months.length / 5).floor()).toDouble();

    final labelStyle = StatisticsLayout.chartAxisLabelStyle(context);

    final barGroups = [
      for (var monthIndex = 0; monthIndex < series.months.length; monthIndex++)
        BarChartGroupData(
          x: monthIndex,
          barsSpace: _barsSpace,
          barRods: [
            for (var categoryIndex = 0;
                categoryIndex < series.categories.length;
                categoryIndex++)
              BarChartRodData(
                toY: series.months[monthIndex].amountsByCategory[categoryIndex],
                color: series.categories[categoryIndex].color,
                width: _barWidth,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(3),
                ),
              ),
          ],
        ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12,
      children: [
        Wrap(
          spacing: 12,
          runSpacing: 8,
          children: [
            for (final category in series.categories)
              _LegendItem(
                color: category.color,
                label: category.name,
              ),
          ],
        ),
        SizedBox(
          height: StatisticsLayout.chartHeight,
          child: BarChart(
            BarChartData(
              minY: 0,
              maxY: maxValue * 1.12,
              barTouchData: BarTouchData(
                touchTooltipData: BarTouchTooltipData(
                  getTooltipColor: (_) =>
                      colors.surface.withValues(alpha: 0.95),
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    if (groupIndex < 0 || groupIndex >= series.months.length) {
                      return null;
                    }
                    if (rodIndex < 0 || rodIndex >= series.categories.length) {
                      return null;
                    }

                    final month = series.months[groupIndex];
                    final category = series.categories[rodIndex];
                    final amount = rod.toY.toStringAsFixedRoundedWithCurrency(
                      2,
                      currency,
                      currencyPosition,
                    );

                    return BarTooltipItem(
                      '${month.label}\n${category.name}\n$amount',
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
                    reservedSize: 28,
                    interval: labelInterval,
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      if (index < 0 || index >= series.months.length) {
                        return const SizedBox.shrink();
                      }

                      return SideTitleWidget(
                        meta: meta,
                        space: 6,
                        child: Text(
                          series.months[index].label,
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
                    reservedSize: 48,
                    interval: maxValue / 2,
                    getTitlesWidget: (value, meta) {
                      final midY = maxValue * 1.12 / 2;
                      final shouldShow = value == 0 ||
                          (value - maxValue * 1.12).abs() < 0.01 ||
                          (value - midY).abs() < 0.01;
                      if (!shouldShow) {
                        return const SizedBox.shrink();
                      }

                      return SideTitleWidget(
                        meta: meta,
                        space: 6,
                        child: Text(
                          _formatLeftAxisValue(
                            value,
                            currency,
                            currencyPosition,
                          ),
                          style: labelStyle,
                          textAlign: TextAlign.right,
                        ),
                      );
                    },
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
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 120),
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              color: context.appColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
