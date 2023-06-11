import 'package:expense_tracker/Helper/date_time_helper.dart';
import 'package:expense_tracker/Helper/double_helper.dart';
import 'package:expense_tracker/models/transaction.dart';
import 'package:expense_tracker/pages/account_detail_page/account_detail_page.dart';
import 'package:expense_tracker/style.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum AccountBarChartModeTime { month, year, all }

enum AccountBarChartModeTransactionType { income, expense, all }

class AccountBarChart extends StatefulWidget {
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
  State<StatefulWidget> createState() => AccountBarChartState();
}

class AccountBarChartState extends State<AccountBarChart> {
  late final Color barColor;
  final Color avgColor = CustomColors.blue;

  final double barWidth = 10;

  late Map<int, double> valueMap;
  late List<BarChartGroupData> rawBarGroups;
  late List<BarChartGroupData> showingBarGroups;

  late List<String> bottomTitlesStrings;

  int touchedGroupIndex = -1;

  var minValue = 0.0;
  var maxValue = 0.0;

  @override
  void initState() {
    super.initState();

    switch (widget.transactionType) {
      case AccountBarChartModeTransactionType.income:
        barColor = CustomColors.income;
        break;
      case AccountBarChartModeTransactionType.expense:
        barColor = CustomColors.expense;
        break;
      default:
        barColor = CustomColors.blue;
        break;
    }
  }

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

  _loadData() {
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
      if (value < minValue) minValue = value;
      if (value > maxValue) maxValue = value;
    });

    minValue *= -1;

    rawBarGroups = _buildGroupData();

    showingBarGroups = rawBarGroups;
  }

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        minY:
            widget.transactionType == AccountBarChartModeTransactionType.income
                ? 0
                : null,
        maxY:
            widget.transactionType == AccountBarChartModeTransactionType.income
                ? maxValue
                : minValue,
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.grey[200],
            fitInsideVertically: true,
            fitInsideHorizontally: true,
          ),
          touchCallback: (FlTouchEvent event, response) {
            if (response == null || response.spot == null) {
              setState(() {
                touchedGroupIndex = -1;
                showingBarGroups = List.of(rawBarGroups);
              });
              return;
            }

            touchedGroupIndex = response.spot!.touchedBarGroupIndex;

            setState(() {
              if (!event.isInterestedForInteractions) {
                touchedGroupIndex = -1;
                showingBarGroups = List.of(rawBarGroups);
                return;
              }
              showingBarGroups = List.of(rawBarGroups);
              if (touchedGroupIndex != -1) {
                var sum = 0.0;
                for (final rod in showingBarGroups[touchedGroupIndex].barRods) {
                  sum += rod.toY;
                }
                final avg =
                    sum / showingBarGroups[touchedGroupIndex].barRods.length;

                showingBarGroups[touchedGroupIndex] =
                    showingBarGroups[touchedGroupIndex].copyWith(
                  barRods:
                      showingBarGroups[touchedGroupIndex].barRods.map((rod) {
                    return rod.copyWith(toY: avg, color: avgColor);
                  }).toList(),
                );
              }
            });
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: _buildBottomTitleWidget,
              reservedSize: 42,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 35,
              interval: 1,
              getTitlesWidget: leftTitles,
            ),
          ),
        ),
        borderData: FlBorderData(
          show: false,
        ),
        barGroups: showingBarGroups,
        gridData: FlGridData(
          show: false,
        ),
      ),
    );
  }

  /// LEFT TITLE MANAGEMENT

  Widget leftTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff7589a2),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );

    String text;
    if (value == 0) {
      text = (0.0).toStringAsFixedRoundedWithCurrency(context, 2);
    } else if (widget.transactionType ==
            AccountBarChartModeTransactionType.expense &&
        value == minValue) {
      text = minValue.toStringAsFixedRoundedWithCurrency(context, 2);
    } else if (widget.transactionType ==
            AccountBarChartModeTransactionType.income &&
        value == maxValue) {
      text = maxValue.toStringAsFixedRoundedWithCurrency(context, 2);
    } else if (value == (minValue + maxValue) / 2) {
      text = ((minValue + maxValue) / 2)
          .toStringAsFixedRoundedWithCurrency(context, 2);
    } else {
      return const SizedBox.shrink();
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 0,
      child: Text(text, style: style),
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
      axisSide: meta.axisSide,
      space: 10, //margin top
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
      axisSide: meta.axisSide,
      space: 10, //margin top
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
      axisSide: meta.axisSide,
      space: 10, //margin top
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

  Map<int, double> getDailyBalanceForWeek() {
    final Map<int, double> balanceMap = {};

    for (var transaction in widget.transactionList) {
      balanceMap[transaction.date.weekday - 1] =
          (balanceMap[transaction.date.weekday - 1] ?? 0) + transaction.value;
    }

    return balanceMap;
  }

  Map<int, double> getWeekBalanceForMonth() {
    final Map<int, double> balanceMap = {};

    final firstWeeknumberOfMonth = weekNumber(widget.startDate!);

    for (var transaction in widget.transactionList) {
      final transactionWeeknumber = weekNumber(transaction.date);

      balanceMap[transactionWeeknumber - firstWeeknumberOfMonth] =
          (balanceMap[transactionWeeknumber - firstWeeknumberOfMonth] ?? 0) +
              transaction.value;
    }

    return balanceMap;
  }

  Map<int, double> getMonthlyBalanceForYear() {
    final Map<int, double> balanceMap = {};

    for (var transaction in widget.transactionList) {
      balanceMap[transaction.date.month - 1] =
          (balanceMap[transaction.date.month - 1] ?? 0) + transaction.value;
    }

    return balanceMap;
  }

  List<BarChartGroupData> _buildGroupData() {
    final List<BarChartGroupData> barChartGroupDataList = [];

    for (int i = 0; i < bottomTitlesStrings.length; i++) {
      double valueToAdd = valueMap[i] ?? 0;

      if (widget.transactionType ==
          AccountBarChartModeTransactionType.expense) {
        valueToAdd *= -1;
      }

      barChartGroupDataList.add(makeGroupData(i, valueToAdd));
    }

    return barChartGroupDataList;
  }

  BarChartGroupData makeGroupData(int x, double value) {
    return BarChartGroupData(
      barsSpace: 4,
      x: x,
      barRods: [
        BarChartRodData(
          toY: value,
          color: barColor,
          width: barWidth,
        ),
      ],
    );
  }
}
