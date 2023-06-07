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
  final TransactionTimePeriod? timeMode;
  final DateTime? startDate;
  final DateTime? endDate;

  const AccountBarChart({
    super.key,
    required this.transactionList,
    this.transactionType,
    this.timeMode,
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

  late List<BarChartGroupData> rawBarGroups;
  late List<BarChartGroupData> showingBarGroups;

  int touchedGroupIndex = -1;

  var minValue = 0.0;

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

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        maxY: minValue,
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
              getTitlesWidget: _buildBottomTitles,
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

  Widget leftTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff7589a2),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );

    String text;
    if (value == 0) {
      text = (0.0).toStringAsFixedRoundedWithCurrency(context, 2);
    } else if (value == minValue) {
      text = minValue.toStringAsFixedRoundedWithCurrency(context, 2);
    } else if (value == minValue / 2) {
      text = (minValue / 2).toStringAsFixedRoundedWithCurrency(context, 2);
    } else {
      return Container();
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 0,
      child: Text(text, style: style),
    );
  }

  Widget _buildBottomTitles(double value, TitleMeta meta) {
    switch (widget.timeMode) {
      case TransactionTimePeriod.day:
        return _dailyBottomTitles(value, meta);
      case TransactionTimePeriod.week:
        break;
      case TransactionTimePeriod.month:
        return _monthlyBottomTitles(value, meta);
      case TransactionTimePeriod.year:
        break;
      default:
        break;
    }

    return Container();
  }

  Widget _dailyBottomTitles(double value, TitleMeta meta) {
    final titles = <String>[
      DateFormat("dd MMM").format(widget.startDate!),
      DateFormat("dd MMM").format(DateTime(widget.startDate!.year,
          widget.startDate!.month, widget.startDate!.day + 1)),
      DateFormat("dd MMM").format(DateTime(widget.startDate!.year,
          widget.startDate!.month, widget.startDate!.day + 2)),
      DateFormat("dd MMM").format(DateTime(widget.startDate!.year,
          widget.startDate!.month, widget.startDate!.day + 3)),
      DateFormat("dd MMM").format(DateTime(widget.startDate!.year,
          widget.startDate!.month, widget.startDate!.day + 4)),
      DateFormat("dd MMM").format(DateTime(widget.startDate!.year,
          widget.startDate!.month, widget.startDate!.day + 5)),
      DateFormat("dd MMM").format(DateTime(widget.startDate!.year,
          widget.startDate!.month, widget.startDate!.day + 6)),
    ];

    final Widget text = Text(
      titles[value.toInt()],
      style: const TextStyle(
        color: Color(0xff7589a2),
        fontWeight: FontWeight.bold,
        fontSize: 12,
      ),
    );

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: value % 2 == 0 ? 10 : 25, //margin top
      child: text,
    );
  }

  Widget _monthlyBottomTitles(double value, TitleMeta meta) {
    final titles = <String>[
      'Gen',
      'Feb',
      'Mar',
      'Apr',
      'Mag',
      'Giu',
      'Lug',
      'Ago',
      'Set',
      'Ott',
      'Nov',
      'Dic'
    ];

    final Widget text = Text(
      titles[value.toInt()],
      style: const TextStyle(
        color: Color(0xff7589a2),
        fontWeight: FontWeight.bold,
        fontSize: 12,
      ),
    );

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: value % 2 == 0 ? 10 : 25, //margin top
      child: text,
    );
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

  Map<int, double> getDailyBalanceForWeek() {
    final Map<int, double> balanceMap = {};

    for (var transaction in widget.transactionList) {
      balanceMap[transaction.date.weekday - 1] =
          (balanceMap[transaction.date.weekday - 1] ?? 0) + transaction.value;
    }

    return balanceMap;
  }

  List<BarChartGroupData> _buildGroupData() {
    final List<BarChartGroupData> barChartGroupDataList = [];

    final valueMap = getDailyBalanceForWeek();

    for (int i = 0; i < 7; i++) {
      barChartGroupDataList.add(makeGroupData(i, (valueMap[i] ?? 0) * -1));
    }

    return barChartGroupDataList;
  }

  _loadData() {
    rawBarGroups = _buildGroupData();

    showingBarGroups = rawBarGroups;

    final Map<int, double> result = getDailyBalanceForWeek();
    result.forEach((key, value) {
      if (value < minValue) minValue = value;
    });

    minValue *= -1;
  }
}
