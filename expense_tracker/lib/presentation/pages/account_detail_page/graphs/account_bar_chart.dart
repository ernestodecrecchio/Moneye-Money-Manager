import 'dart:math';

import 'package:expense_tracker/Helper/date_time_helper.dart';
import 'package:expense_tracker/Helper/double_helper.dart';
import 'package:expense_tracker/domain/models/transaction.dart';
import 'package:expense_tracker/notifiers/currency_provider.dart';
import 'package:expense_tracker/presentation/pages/account_detail_page/account_detail_page.dart';
import 'package:expense_tracker/style.dart';
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
  final Color incomeBarColor = CustomColors.income;
  final Color expenseBarColor = CustomColors.expense;
  final Color avgColor = CustomColors.blue;

  final double barWidth = 10;
  final double barsSpace = 1; // Space between bars of the same group

  late Map<int, List<double>> valueMap;

  late List<BarChartGroupData> showingBarGroups;

  late List<String> bottomTitlesStrings;

  int touchedGroupIndex = -1;

  var minValue = 0.0;
  var maxValue = 0.0;

  double? minY;
  double? maxY;
  double leftMinValue = 0;
  double leftMaxValue = 0;
  double leftAvgValue = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _loadData();
  }

  @override
  void didUpdateWidget(covariant AccountBarChart oldWidget) {
    super.didUpdateWidget(oldWidget);

    _loadData();
  }

  void _loadData() {
    bottomTitlesStrings = _getBottomTitlesString();

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

    minValue *= -1;

    minY = 0;

    maxY = widget.transactionType == AccountBarChartModeTransactionType.income
        ? maxValue
        : widget.transactionType == AccountBarChartModeTransactionType.expense
            ? minValue
            : max(minValue, maxValue);

    showingBarGroups = _buildGroupData();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 8.0,
      ),
      child: BarChart(
        BarChartData(
          minY: minY,
          maxY: maxY,
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              getTooltipColor: (BarChartGroupData group) =>
                  Colors.grey.shade200,
              fitInsideVertically: true,
              fitInsideHorizontally: true,
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
                getTitlesWidget: _buildBottomTitleWidget,
                // reservedSize: 0,
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 35,
                  //  interval: getInterval(),
                  getTitlesWidget: leftTitles),
            ),
          ),
          borderData: FlBorderData(
            show: false,
          ),
          barGroups: showingBarGroups,
          //   groupsSpace: ,
          gridData: const FlGridData(
            show: false,
          ),
        ),
      ),
    );
  }

  /// LEFT TITLE MANAGEMENT

  Widget leftTitles(double value, TitleMeta meta) {
    final currentCurrency = ref.watch(currentCurrencyProvider);
    final currentCurrencyPosition =
        ref.watch(currentCurrencySymbolPositionProvider);

    const style = TextStyle(
      color: Color(0xff7589a2),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );

    String text;

    if (widget.transactionType == AccountBarChartModeTransactionType.income) {
      leftMaxValue = maxValue;
    } else if (widget.transactionType ==
        AccountBarChartModeTransactionType.expense) {
      leftMaxValue = minValue;
    } else if (widget.transactionType ==
        AccountBarChartModeTransactionType.all) {
      leftMaxValue = max(minValue, maxValue);
    }
    leftAvgValue = (leftMaxValue / 2).roundToDouble();

    if (value == leftMinValue) {
      text = leftMinValue.toStringAsFixedRoundedWithCurrency(
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

  List<String> _getWeekdayBottomTitlesString() {
    return [
      DateFormat("dd/MM").format(widget.startDate!),
      DateFormat("dd/MM").format(DateTime(widget.startDate!.year,
          widget.startDate!.month, widget.startDate!.day + 1)),
      DateFormat("dd/MM").format(DateTime(widget.startDate!.year,
          widget.startDate!.month, widget.startDate!.day + 2)),
      DateFormat("dd/MM").format(DateTime(widget.startDate!.year,
          widget.startDate!.month, widget.startDate!.day + 3)),
      DateFormat("dd/MM").format(DateTime(widget.startDate!.year,
          widget.startDate!.month, widget.startDate!.day + 4)),
      DateFormat("dd/MM").format(DateTime(widget.startDate!.year,
          widget.startDate!.month, widget.startDate!.day + 5)),
      DateFormat("dd/MM").format(DateTime(widget.startDate!.year,
          widget.startDate!.month, widget.startDate!.day + 6)),
    ];
  }

  List<String> _getWeekIntervalBottomTitlesString() {
    final ddDateFormat = DateFormat("dd");

    final List<String> weekDatesList = [];

    final DateTime currentMonthFirstDayDate =
        currentMonthFirstDay(widget.startDate!);
    final DateTime currentMonthLastDayDate =
        currentMonthLastDay(widget.startDate!);

    final DateTime nextMonthFirstDayDate = nextMonthFirstDay(widget.startDate!);

    DateTime currentWeekFirstDayDate =
        currentWeekFirstDay(currentMonthFirstDayDate);
    DateTime currentWeekLastDayDate =
        currentWeekLastDay(currentMonthFirstDayDate);

    if (currentMonthFirstDayDate.day != currentWeekLastDayDate.day) {
      weekDatesList.add(
          '${ddDateFormat.format(currentMonthFirstDayDate)} - ${ddDateFormat.format(currentWeekLastDayDate)}');
    } else {
      weekDatesList.add(ddDateFormat.format(currentMonthFirstDayDate));
    }
    currentWeekFirstDayDate = nextWeekFirstDay(currentWeekFirstDayDate);
    currentWeekLastDayDate = nextWeekLastDay(currentWeekLastDayDate);

    while (currentWeekLastDayDate.isBefore(nextMonthFirstDayDate)) {
      weekDatesList.add(
          '${ddDateFormat.format(currentWeekFirstDayDate)} - ${ddDateFormat.format(currentWeekLastDayDate)}');

      currentWeekFirstDayDate = nextWeekFirstDay(currentWeekFirstDayDate);
      currentWeekLastDayDate = nextWeekLastDay(currentWeekLastDayDate);
    }

    if (currentWeekFirstDayDate.month == currentMonthFirstDayDate.month) {
      if (currentWeekFirstDayDate.day != currentMonthLastDayDate.day) {
        weekDatesList.add(
            '${ddDateFormat.format(currentWeekFirstDayDate)} - ${ddDateFormat.format(currentMonthLastDayDate)}');
      } else {
        weekDatesList.add(ddDateFormat.format(currentWeekFirstDayDate));
      }
    }

    return weekDatesList;
  }

  List<String> _getMonthBottomTitlesString() {
    return [
      DateFormat("MMM").format(widget.startDate!),
      DateFormat("MMM").format(
          DateTime(widget.startDate!.year, widget.startDate!.month + 1)),
      DateFormat("MMM").format(
          DateTime(widget.startDate!.year, widget.startDate!.month + 2)),
      DateFormat("MMM").format(
          DateTime(widget.startDate!.year, widget.startDate!.month + 3)),
      DateFormat("MMM").format(
          DateTime(widget.startDate!.year, widget.startDate!.month + 4)),
      DateFormat("MMM").format(
          DateTime(widget.startDate!.year, widget.startDate!.month + 5)),
      DateFormat("MMM").format(
          DateTime(widget.startDate!.year, widget.startDate!.month + 6)),
      DateFormat("MMM").format(
          DateTime(widget.startDate!.year, widget.startDate!.month + 7)),
      DateFormat("MMM").format(
          DateTime(widget.startDate!.year, widget.startDate!.month + 8)),
      DateFormat("MMM").format(
          DateTime(widget.startDate!.year, widget.startDate!.month + 9)),
      DateFormat("MMM").format(
          DateTime(widget.startDate!.year, widget.startDate!.month + 10)),
      DateFormat("MMM").format(
          DateTime(widget.startDate!.year, widget.startDate!.month + 11)),
    ];
  }

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

  Widget _weekdayBottomTitleWidget(double value, TitleMeta meta) {
    final Widget text = Text(
      bottomTitlesStrings[value.toInt()],
      style: const TextStyle(
        color: Color(0xff7589a2),
        fontWeight: FontWeight.bold,
        fontSize: 12,
      ),
    );

    return SideTitleWidget(
      meta: meta,
      space: 5, //margin top
      child: text,
    );
  }

  Widget _weekIntervalBottomTitleWidget(double value, TitleMeta meta) {
    final Widget text = Text(
      bottomTitlesStrings[value.toInt()],
      style: const TextStyle(
        color: Color(0xff7589a2),
        fontWeight: FontWeight.bold,
        fontSize: 12,
      ),
    );

    return SideTitleWidget(
      meta: meta,
      space: 5, //margin top
      child: text,
    );
  }

  Widget _monthBottomTitleWidget(double value, TitleMeta meta) {
    final Widget text = Text(
      bottomTitlesStrings[value.toInt()],
      style: const TextStyle(
        color: Color(0xff7589a2),
        fontWeight: FontWeight.bold,
        fontSize: 12,
      ),
    );

    return SideTitleWidget(
      meta: meta,
      // axisSide: meta.axisSide,
      space: 5, //margin top
      child: text,
    );
  }

  Widget _buildBottomTitleWidget(double value, TitleMeta meta) {
    switch (widget.transactionTimePeriod) {
      case TransactionTimePeriod.day:
        break;
      case TransactionTimePeriod.week:
        return _weekdayBottomTitleWidget(value, meta);
      case TransactionTimePeriod.month:
        return _weekIntervalBottomTitleWidget(value, meta);
      case TransactionTimePeriod.year:
        return _monthBottomTitleWidget(value, meta);
      default:
        break;
    }

    return Container();
  }

  /// BALANCE MANAGEMENT

  Map<int, List<double>> getDailyBalanceForWeek() {
    final Map<int, List<double>> balanceMap2 = {};

    for (var transaction in widget.transactionList) {
      if (balanceMap2[transaction.date.weekday - 1] == null) {
        if (transaction.amount >= 0) {
          balanceMap2[transaction.date.weekday - 1] = [transaction.amount, 0];
        } else {
          balanceMap2[transaction.date.weekday - 1] = [0, transaction.amount];
        }
      } else {
        final List<double> currValueArray =
            balanceMap2[transaction.date.weekday - 1]!;

        if (transaction.amount >= 0) {
          balanceMap2[transaction.date.weekday - 1] = [
            (currValueArray[0] + transaction.amount).withPrecision(2),
            currValueArray[1]
          ];
        } else {
          balanceMap2[transaction.date.weekday - 1] = [
            currValueArray[0],
            (currValueArray[1] + transaction.amount).withPrecision(2),
          ];
        }
      }
    }

    return balanceMap2;
  }

  Map<int, List<double>> getWeekBalanceForMonth() {
    final Map<int, List<double>> balanceMap = {};
    final firstWeeknumberOfMonth = weekNumber(widget.startDate!);

    for (var transaction in widget.transactionList) {
      final transactionWeeknumber = weekNumber(transaction.date);

      if (balanceMap[transactionWeeknumber - firstWeeknumberOfMonth] == null) {
        if (transaction.amount >= 0) {
          balanceMap[transactionWeeknumber - firstWeeknumberOfMonth] = [
            transaction.amount,
            0
          ];
        } else {
          balanceMap[transactionWeeknumber - firstWeeknumberOfMonth] = [
            0,
            transaction.amount
          ];
        }
      } else {
        final List<double> currValueArray =
            balanceMap[transactionWeeknumber - firstWeeknumberOfMonth]!;

        if (transaction.amount >= 0) {
          balanceMap[transactionWeeknumber - firstWeeknumberOfMonth] = [
            (currValueArray[0] + transaction.amount).withPrecision(2),
            currValueArray[1]
          ];
        } else {
          balanceMap[transactionWeeknumber - firstWeeknumberOfMonth] = [
            currValueArray[0],
            (currValueArray[1] + transaction.amount).withPrecision(2),
          ];
        }
      }
    }

    return balanceMap;
  }

  Map<int, List<double>> getMonthlyBalanceForYear() {
    final Map<int, List<double>> balanceMap = {};

    for (var transaction in widget.transactionList) {
      if (balanceMap[transaction.date.month - 1] == null) {
        if (transaction.amount >= 0) {
          balanceMap[transaction.date.month - 1] = [transaction.amount, 0];
        } else {
          balanceMap[transaction.date.month - 1] = [0, transaction.amount];
        }
      } else {
        final List<double> currValueArray =
            balanceMap[transaction.date.month - 1]!;

        if (transaction.amount >= 0) {
          balanceMap[transaction.date.month - 1] = [
            (currValueArray[0] + transaction.amount).withPrecision(2),
            currValueArray[1]
          ];
        } else {
          balanceMap[transaction.date.month - 1] = [
            currValueArray[0],
            (currValueArray[1] + transaction.amount).withPrecision(2),
          ];
        }
      }
    }

    return balanceMap;
  }

  List<BarChartGroupData> _buildGroupData() {
    final List<BarChartGroupData> barChartGroupDataList = [];

    for (int i = 0; i < bottomTitlesStrings.length; i++) {
      List<double> barValue = valueMap[i] ?? [0, 0];

      if (widget.transactionType ==
              AccountBarChartModeTransactionType.expense ||
          widget.transactionType == AccountBarChartModeTransactionType.all) {
        barValue[1] *= -1;
      }

      barChartGroupDataList
          .add(makeGroupData(x: i, y1: barValue[0], y2: barValue[1]));
    }

    return barChartGroupDataList;
  }

  BarChartGroupData makeGroupData(
      {required int x, required double? y1, double? y2}) {
    return BarChartGroupData(
      barsSpace: barsSpace,
      x: x,
      barRods: [
        if (y1 != null &&
            (widget.transactionType ==
                    AccountBarChartModeTransactionType.income ||
                widget.transactionType ==
                    AccountBarChartModeTransactionType.all))
          BarChartRodData(
            toY: y1,
            color: incomeBarColor,
            width: barWidth,
          ),
        if (y2 != null &&
            (widget.transactionType ==
                    AccountBarChartModeTransactionType.expense ||
                widget.transactionType ==
                    AccountBarChartModeTransactionType.all))
          BarChartRodData(
            toY: y2,
            color: expenseBarColor,
            width: barWidth,
          ),
      ],
    );
  }
}
