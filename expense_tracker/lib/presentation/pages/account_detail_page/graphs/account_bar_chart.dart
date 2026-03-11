import 'dart:math';

import 'package:expense_tracker/Helper/date_time_helper.dart';
import 'package:expense_tracker/Helper/double_helper.dart';
import 'package:expense_tracker/domain/models/transaction.dart';
import 'package:expense_tracker/application/common/notifiers/currency_provider.dart';
import 'package:expense_tracker/presentation/pages/account_detail_page/account_detail_page.dart';
import 'package:expense_tracker/style.dart';
import 'package:expense_tracker/style/app_theme.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

enum AccountBarChartModeTime { month, year, all }

enum AccountBarChartModeTransactionType { income, expense, all }

class AccountBarChart extends ConsumerStatefulWidget {
  final List<Transaction> transactionList;
  final AccountBarChartModeTransactionType? transactionType;
  final TransactionTimePeriod? transactionTimePeriod;
  final DateTime? startDate;
  final DateTime? endDate;

  const AccountBarChart({
    super.key,
    required this.transactionList,
    this.transactionType,
    this.transactionTimePeriod,
    this.startDate,
    this.endDate,
  });

  @override
  ConsumerState<AccountBarChart> createState() => AccountBarChartState();
}

class AccountBarChartState extends ConsumerState<AccountBarChart> {
  final double barWidth = 10;
  final double barsSpace = 1; // Space between bars of the same group

  /// CALCULATIONS

  /// Calculates the transaction values for the current view based on [widget.transactionTimePeriod]
  /// and [widget.transactionType]. Returns a record containing the [valueMap], [minValue], and [maxValue].
  ///
  /// [valueMap] maps the time index (e.g., day of week, week number, or month) to a list
  /// of exactly two doubles: `[incomeAmount, expenseAmount]`.
  (Map<int, List<double>> valueMap, double minValue, double maxValue)
      _calculateValues() {
    Map<int, List<double>> valueMap;
    switch (widget.transactionTimePeriod) {
      case TransactionTimePeriod.day:
        valueMap = {};
        break;
      case TransactionTimePeriod.week:
        valueMap = getDailyBalanceForWeek();
        break;
      case TransactionTimePeriod.month:
        valueMap = getWeekBalanceForMonth();
        break;
      case TransactionTimePeriod.year:
        valueMap = getMonthlyBalanceForYear();
        break;
      default:
        valueMap = {};
        break;
    }

    double minValue = 0.0;
    double maxValue = 0.0;

    valueMap.forEach((key, value) {
      switch (widget.transactionType) {
        case AccountBarChartModeTransactionType.income:
          if (value[0] < minValue) minValue = value[0];
          if (value[0] > maxValue) maxValue = value[0];
          break;
        case AccountBarChartModeTransactionType.expense:
          if (value[1] < minValue) minValue = value[1];
          if (value[1] > maxValue) maxValue = value[1];
          break;
        case AccountBarChartModeTransactionType.all:
          if (value[0] < minValue) minValue = value[0];
          if (value[0] > maxValue) maxValue = value[0];
          if (value[1] < minValue) minValue = value[1];
          if (value[1] > maxValue) maxValue = value[1];
          break;
        default:
          break;
      }
    });

    return (valueMap, minValue, maxValue);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final bottomTitlesStrings = _getBottomTitlesString();
    final (valueMap, rawMinValue, maxValue) = _calculateValues();

    final minValue = rawMinValue * -1;
    const minY = 0.0;
    final maxY = widget.transactionType ==
            AccountBarChartModeTransactionType.income
        ? maxValue
        : widget.transactionType == AccountBarChartModeTransactionType.expense
            ? minValue
            : max(minValue, maxValue);

    final leftMaxValue = widget.transactionType ==
            AccountBarChartModeTransactionType.income
        ? maxValue
        : widget.transactionType == AccountBarChartModeTransactionType.expense
            ? minValue
            : max(minValue, maxValue);

    final showingBarGroups = _buildGroupData(
      valueMap: valueMap,
      bottomTitlesStrings: bottomTitlesStrings,
      incomeBarColor: colors.income,
      expenseBarColor: colors.expense,
    );

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: BarChart(
        BarChartData(
          minY: minY,
          maxY: maxY,
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              getTooltipColor: (BarChartGroupData group) =>
                  colors.surface.withValues(alpha: 0.9),
              fitInsideVertically: true,
              fitInsideHorizontally: true,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                return BarTooltipItem(
                  rod.toY.toStringAsFixed(2),
                  TextStyle(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) =>
                    _buildBottomTitleWidget(value, meta, bottomTitlesStrings),
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 35,
                getTitlesWidget: (value, meta) =>
                    _leftTitles(value, meta, leftMaxValue),
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          barGroups: showingBarGroups,
          gridData: const FlGridData(show: false),
        ),
      ),
    );
  }

  /// LEFT TITLE MANAGEMENT

  /// Builds the left-side axis titles for the bar chart.
  /// Displays the minimum, maximum, and average values formatted with currency.
  Widget _leftTitles(double value, TitleMeta meta, double leftMaxValue) {
    final currentCurrency = ref.watch(currentCurrencyProvider);
    final currentCurrencyPosition =
        ref.watch(currentCurrencySymbolPositionProvider);
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;

    final style = textTheme.labelSmall?.copyWith(
          color: colors.textSecondary,
          fontWeight: FontWeight.bold,
        ) ??
        const TextStyle(
          color: CustomColors.chartLabelsGray,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        );

    final leftAvgValue = (leftMaxValue / 2).roundToDouble();

    String text;
    if (value == 0) {
      text = 0.0.toStringAsFixedRoundedWithCurrency(
          2, currentCurrency, currentCurrencyPosition);
    } else if (value == leftMaxValue) {
      text = leftMaxValue.toStringAsFixedRoundedWithCurrency(
          2, currentCurrency, currentCurrencyPosition);
    } else if (value == leftAvgValue) {
      text = leftAvgValue.toStringAsFixedRoundedWithCurrency(
          2, currentCurrency, currentCurrencyPosition);
    } else {
      return const SizedBox.shrink();
    }

    return SideTitleWidget(
      meta: meta,
      space: 0,
      child: FittedBox(child: Text(text, style: style)),
    );
  }

  /// BOTTOM TITLE MANAGEMENT

  /// Generates the weekday labels for a week-long period (e.g., "dd/MM").
  List<String> _getWeekdayBottomTitlesString() {
    return [
      DateFormat("dd/MM").format(widget.startDate!),
      DateFormat("dd/MM")
          .format(widget.startDate!.add(const Duration(days: 1))),
      DateFormat("dd/MM")
          .format(widget.startDate!.add(const Duration(days: 2))),
      DateFormat("dd/MM")
          .format(widget.startDate!.add(const Duration(days: 3))),
      DateFormat("dd/MM")
          .format(widget.startDate!.add(const Duration(days: 4))),
      DateFormat("dd/MM")
          .format(widget.startDate!.add(const Duration(days: 5))),
      DateFormat("dd/MM")
          .format(widget.startDate!.add(const Duration(days: 6))),
    ];
  }

  /// Generates the week-interval labels for a month-long period (e.g., "01 - 07").
  List<String> _getWeekIntervalBottomTitlesString() {
    final ddDateFormat = DateFormat("dd");
    final List<String> weekDatesList = [];

    final DateTime start = currentMonthFirstDay(widget.startDate!);
    final DateTime end = nextMonthFirstDay(widget.startDate!);

    DateTime currentWeekFirst = currentWeekFirstDay(start);
    DateTime currentWeekLast = currentWeekLastDay(start);

    if (start.day != currentWeekLast.day) {
      weekDatesList.add(
          '${ddDateFormat.format(start)} - ${ddDateFormat.format(currentWeekLast)}');
    } else {
      weekDatesList.add(ddDateFormat.format(start));
    }

    currentWeekFirst = nextWeekFirstDay(currentWeekFirst);
    currentWeekLast = nextWeekLastDay(currentWeekLast);

    while (currentWeekLast.isBefore(end)) {
      weekDatesList.add(
          '${ddDateFormat.format(currentWeekFirst)} - ${ddDateFormat.format(currentWeekLast)}');
      currentWeekFirst = nextWeekFirstDay(currentWeekFirst);
      currentWeekLast = nextWeekLastDay(currentWeekLast);
    }

    if (currentWeekFirst.month == start.month) {
      final lastDay = currentMonthLastDay(widget.startDate!);
      if (currentWeekFirst.day != lastDay.day) {
        weekDatesList.add(
            '${ddDateFormat.format(currentWeekFirst)} - ${ddDateFormat.format(lastDay)}');
      } else {
        weekDatesList.add(ddDateFormat.format(currentWeekFirst));
      }
    }

    return weekDatesList;
  }

  /// Generates month labels for a year-long period (e.g., "Jan", "Feb").
  List<String> _getMonthBottomTitlesString() {
    return List.generate(12, (i) {
      return DateFormat("MMM").format(
          DateTime(widget.startDate!.year, widget.startDate!.month + i));
    });
  }

  /// Returns the appropriate list of title strings based on [widget.transactionTimePeriod].
  List<String> _getBottomTitlesString() {
    switch (widget.transactionTimePeriod) {
      case TransactionTimePeriod.day:
        return [];
      case TransactionTimePeriod.week:
        return _getWeekdayBottomTitlesString();
      case TransactionTimePeriod.month:
        return _getWeekIntervalBottomTitlesString();
      case TransactionTimePeriod.year:
        return _getMonthBottomTitlesString();
      default:
        return [];
    }
  }

  /// Builds the title widget for the bottom axis based on [value] and [bottomTitlesStrings].
  Widget _buildBottomTitleWidget(
      double value, TitleMeta meta, List<String> bottomTitlesStrings) {
    if (value.toInt() >= bottomTitlesStrings.length || value.toInt() < 0) {
      return const SizedBox.shrink();
    }

    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;

    return SideTitleWidget(
      meta: meta,
      space: 5,
      child: Text(
        bottomTitlesStrings[value.toInt()],
        style: textTheme.labelSmall?.copyWith(
              color: colors.textSecondary,
              fontWeight: FontWeight.bold,
            ) ??
            const TextStyle(
              color: CustomColors.chartLabelsGray,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
      ),
    );
  }

  /// BALANCE MANAGEMENT

  /// Aggregates transaction amounts by day of the week for a 7-day period.
  /// Result is a map of `dayIndex (0-6)` to `[totalIncome, totalExpense]`.
  Map<int, List<double>> getDailyBalanceForWeek() {
    final Map<int, List<double>> balanceMap = {};
    for (var transaction in widget.transactionList) {
      final dayIndex = transaction.date.weekday - 1;
      balanceMap.putIfAbsent(dayIndex, () => [0, 0]);
      if (transaction.amount >= 0) {
        balanceMap[dayIndex]![0] =
            (balanceMap[dayIndex]![0] + transaction.amount).withPrecision(2);
      } else {
        balanceMap[dayIndex]![1] =
            (balanceMap[dayIndex]![1] + transaction.amount).withPrecision(2);
      }
    }
    return balanceMap;
  }

  /// Aggregates transaction amounts by week index for a monthly view.
  /// Result is a map of `weekIndex` to `[totalIncome, totalExpense]`.
  Map<int, List<double>> getWeekBalanceForMonth() {
    final Map<int, List<double>> balanceMap = {};
    final firstWeek = weekNumber(widget.startDate!);
    for (var transaction in widget.transactionList) {
      final weekIndex = weekNumber(transaction.date) - firstWeek;
      balanceMap.putIfAbsent(weekIndex, () => [0, 0]);
      if (transaction.amount >= 0) {
        balanceMap[weekIndex]![0] =
            (balanceMap[weekIndex]![0] + transaction.amount).withPrecision(2);
      } else {
        balanceMap[weekIndex]![1] =
            (balanceMap[weekIndex]![1] + transaction.amount).withPrecision(2);
      }
    }
    return balanceMap;
  }

  /// Aggregates transaction amounts by month index for a yearly view.
  /// Result is a map of `monthIndex (0-11)` to `[totalIncome, totalExpense]`.
  Map<int, List<double>> getMonthlyBalanceForYear() {
    final Map<int, List<double>> balanceMap = {};
    for (var transaction in widget.transactionList) {
      final monthIndex = transaction.date.month - 1;
      balanceMap.putIfAbsent(monthIndex, () => [0, 0]);
      if (transaction.amount >= 0) {
        balanceMap[monthIndex]![0] =
            (balanceMap[monthIndex]![0] + transaction.amount).withPrecision(2);
      } else {
        balanceMap[monthIndex]![1] =
            (balanceMap[monthIndex]![1] + transaction.amount).withPrecision(2);
      }
    }
    return balanceMap;
  }

  /// Converts [valueMap] and [bottomTitlesStrings] into a list of [BarChartGroupData]
  /// using the provided [incomeBarColor] and [expenseBarColor].
  ///
  /// [valueMap] is index-based and contains `[income, expense]` totals per index.
  List<BarChartGroupData> _buildGroupData({
    required Map<int, List<double>> valueMap,
    required List<String> bottomTitlesStrings,
    required Color incomeBarColor,
    required Color expenseBarColor,
  }) {
    return List.generate(bottomTitlesStrings.length, (i) {
      final barValue = valueMap[i] ?? [0, 0];
      double y1 = barValue[0];
      double y2 = barValue[1];

      if (widget.transactionType ==
              AccountBarChartModeTransactionType.expense ||
          widget.transactionType == AccountBarChartModeTransactionType.all) {
        y2 *= -1;
      }

      return makeGroupData(
        x: i,
        y1: y1,
        y2: y2,
        incomeBarColor: incomeBarColor,
        expenseBarColor: expenseBarColor,
      );
    });
  }

  /// Factory method to create a [BarChartGroupData] entry with specific rod data
  /// based on enabled transaction types.
  BarChartGroupData makeGroupData({
    required int x,
    required double y1,
    required double y2,
    required Color incomeBarColor,
    required Color expenseBarColor,
  }) {
    final showIncome =
        widget.transactionType == AccountBarChartModeTransactionType.income ||
            widget.transactionType == AccountBarChartModeTransactionType.all;
    final showExpense =
        widget.transactionType == AccountBarChartModeTransactionType.expense ||
            widget.transactionType == AccountBarChartModeTransactionType.all;

    return BarChartGroupData(
      barsSpace: barsSpace,
      x: x,
      barRods: [
        if (showIncome)
          BarChartRodData(
            toY: y1,
            color: incomeBarColor,
            width: barWidth,
          ),
        if (showExpense)
          BarChartRodData(
            toY: y2,
            color: expenseBarColor,
            width: barWidth,
          ),
      ],
    );
  }
}
