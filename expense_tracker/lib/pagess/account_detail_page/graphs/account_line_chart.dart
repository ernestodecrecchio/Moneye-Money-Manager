/*import 'package:expense_tracker/models/transaction.dart';
import 'package:expense_tracker/style.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum TimeMode {
  day,
  week,
  month,
  year,
}

class AccountLineChart extends StatelessWidget {
  final TimeMode mode;
  final DateTime? startDate;
  final DateTime? endDate;
  final List<Transaction> transactionList;

  const AccountLineChart(
      {super.key,
      required this.transactionList,
      required this.mode,
      this.startDate,
      this.endDate});

  @override
  Widget build(BuildContext context) {
    //  print(transactionList);

    final Map<int, double> result = mode == TimeMode.day
        ? getDailyBalanceForWeeks()
        : getMonthlyBalanceForYear();

    var minValue = 0.0;
    var maxValue = 0.0;

    List<FlSpot> spotList = [];

    result.forEach((key, value) {
      if (value < minValue) minValue = value;
      if (value > maxValue) maxValue = value;

      spotList.add(FlSpot(key.toDouble(), value));
    });

    final double minX = mode == TimeMode.day ? 0 : 0;
    final double maxX = mode == TimeMode.day ? 6 : 11;

    return AspectRatio(
      aspectRatio: 2.5,
      child: Padding(
        padding: const EdgeInsets.only(
          bottom: 10,
          top: 20,
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return LineChart(
              LineChartData(
                minX: minX,
                maxX: maxX,
                minY: minValue,
                maxY: maxValue,
                lineTouchData: LineTouchData(
                  enabled: true,
                  getTouchedSpotIndicator: (barData, spotIndexes) {
                    return spotIndexes.map((spotIndex) {
                      return TouchedSpotIndicatorData(
                        FlLine(
                            color: CustomColors.blue,
                            strokeWidth: 2,
                            dashArray: [4, 7]),
                        FlDotData(
                          getDotPainter: (spot, percent, barData, index) {
                            return FlDotCirclePainter(
                              radius: 8,
                              color: CustomColors.blue,
                            );
                          },
                        ),
                      );
                    }).toList();
                  },
                  touchTooltipData: LineTouchTooltipData(
                    tooltipBgColor: Colors.grey[200],
                    getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                      return touchedBarSpots.map((barSpot) {
                        return LineTooltipItem(
                          result[barSpot.x.toInt()].toString(),
                          const TextStyle(
                            color: CustomColors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }).toList();
                    },
                  ),
                ),
                borderData: FlBorderData(
                  show: false,
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: CustomColors.grey,
                      strokeWidth: 1,
                      dashArray: [4, 7],
                    );
                  },
                  getDrawingVerticalLine: (value) {
                    return FlLine(
                      color: CustomColors.grey,
                      strokeWidth: 1,
                      dashArray: [4, 7],
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: false,
                    ),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: false,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 50,
                      interval: 1,
                      getTitlesWidget: (value, meta) =>
                          leftTitleWidgets(value, meta, minValue, maxValue),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 18,
                      interval: 1,
                      getTitlesWidget: bottomTitleWidgets,
                    ),
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: spotList,
                    isCurved: true,
                    color: CustomColors.blue,
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget leftTitleWidgets(
      double value, TitleMeta meta, double minValue, double maxValue) {
    const style = TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 10,
        color: CustomColors.clearGreyText);

    final int avgValue = (minValue + maxValue) ~/ 2;

    if (value.toInt() == avgValue) {
      return Text('${avgValue.toInt()}',
          style: style, textAlign: TextAlign.left);
    } else if (value.toInt() == minValue.toInt()) {
      return Text('${minValue.toInt()}',
          style: style, textAlign: TextAlign.left);
    } else if (value.toInt() == maxValue.toInt()) {
      return Text('${maxValue.toInt()}',
          style: style, textAlign: TextAlign.left);
    }

    return Container();
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    String text;

    if (mode == TimeMode.day) {
      switch (value.toInt()) {
        case 0:
          text = DateFormat("dd MMM").format(startDate!);
          break;
        case 1:
          text = DateFormat("dd MMM").format(
              DateTime(startDate!.year, startDate!.month, startDate!.day + 1));
          break;
        case 2:
          text = DateFormat("dd MMM").format(
              DateTime(startDate!.year, startDate!.month, startDate!.day + 2));
          break;
        case 3:
          text = DateFormat("dd MMM").format(
              DateTime(startDate!.year, startDate!.month, startDate!.day + 3));
          break;
        case 4:
          text = DateFormat("dd MMM").format(
              DateTime(startDate!.year, startDate!.month, startDate!.day + 4));
          break;
        case 5:
          text = DateFormat("dd MMM").format(
              DateTime(startDate!.year, startDate!.month, startDate!.day + 5));
          break;
        case 6:
          text = DateFormat("dd MMM").format(endDate!);
          break;
        default:
          return Container();
      }
    } else {
      switch (value.toInt()) {
        case 0:
          text = 'Jan';
          break;
        case 1:
          text = 'Feb';
          break;
        case 2:
          text = 'Mar';
          break;
        case 3:
          text = 'Apr';
          break;
        case 4:
          text = 'May';
          break;
        case 5:
          text = 'Jun';
          break;
        case 6:
          text = 'Jul';
          break;
        case 7:
          text = 'Aug';
          break;
        case 8:
          text = 'Sep';
          break;
        case 9:
          text = 'Oct';
          break;
        case 10:
          text = 'Nov';
          break;
        case 11:
          text = 'Dec';
          break;
        default:
          return Container();
      }
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 10,
          color: CustomColors.clearGreyText,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Map<int, double> getDailyBalanceForWeeks() {
    final Map<int, double> balanceMap = {};

    for (var transaction in transactionList) {
      balanceMap[transaction.date.weekday - 1] =
          (balanceMap[transaction.date.weekday - 1] ?? 0) + transaction.value;
    }

    return balanceMap;
  }

  Map<int, double> getWeeklyBalanceForMonth() {
    final Map<int, double> balanceMap = {};

    for (var transaction in transactionList) {
      balanceMap[transaction.date.weekday - 1] =
          (balanceMap[transaction.date.weekday - 1] ?? 0) + transaction.value;
    }

    return balanceMap;
  }

  Map<int, double> getMonthlyBalanceForYear() {
    final Map<int, double> balanceMap = {};

    for (var transaction in transactionList) {
      balanceMap[transaction.date.month] =
          (balanceMap[transaction.date.month] ?? 0) + transaction.value;
    }

    return balanceMap;
  }
}
*/