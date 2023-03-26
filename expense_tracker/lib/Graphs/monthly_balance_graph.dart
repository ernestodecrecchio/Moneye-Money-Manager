import 'package:expense_tracker/notifiers/transaction_provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MonthlyBalanceGraph extends StatelessWidget {
  const MonthlyBalanceGraph({super.key});

  @override
  Widget build(BuildContext context) {
    final result = Provider.of<TransactionProvider>(context, listen: true)
        .getMonthlyBalanceForYear(DateTime.now().year);

    List<FlSpot> spotList = [];
    var minValue = 0.0;
    var maxValue = 0.0;

    result.forEach((key, value) {
      if (value < minValue) minValue = value;
      if (value > maxValue) maxValue = value;

      spotList.add(FlSpot(key.toDouble(), value));
    });

    return Container(
      height: 200,
      padding: const EdgeInsets.only(
        top: 20,
        right: 20,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: LineChart(
        LineChartData(
          minX: 1,
          maxX: 12,
          minY: minValue - 200,
          maxY: maxValue + 200,
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
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
              ),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
                spots: spotList, isCurved: true, color: Colors.white)
          ],
        ),
      ),
    );
  }
}
