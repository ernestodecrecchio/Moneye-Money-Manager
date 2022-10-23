import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MonthlyBalanceGraph extends StatelessWidget {
  const MonthlyBalanceGraph({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getChartData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else {
          final result = snapshot.data as List<Map<String, dynamic>>;

          var minValue = 0.0;
          var maxValue = 0.0;

          for (var monthlyBalance in result) {
            if (monthlyBalance['balance'] < minValue) {
              minValue = monthlyBalance['balance'];
            }

            if (monthlyBalance['balance'] > maxValue) {
              maxValue = monthlyBalance['balance'];
            }
          }

          return Container(
            height: 200,
            padding: const EdgeInsets.only(
              top: 20,
              right: 20,
            ),
            color: Colors.grey,
            child: LineChart(
              LineChartData(
                minX: 0,
                maxX: 11,
                minY: minValue,
                maxY: maxValue,
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
                  LineChartBarData(spots: [
                    ...result.map((monthlyBalance) {
                      return FlSpot(
                          monthlyBalance['month'], monthlyBalance['balance']);
                    }),
                  ], isCurved: true)
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Future _getChartData() async {
    return [
      {
        'month': 0.0,
        'balance': 1984.0,
      },
      {
        'month': 1.0,
        'balance': 123.0,
      },
      {
        'month': 2.0,
        'balance': -1453.0,
      },
      {
        'month': 3.0,
        'balance': 2760.0,
      },
      {
        'month': 4.0,
        'balance': 2654.0,
      },
      {
        'month': 5.0,
        'balance': 2500.0,
      },
      {
        'month': 6.0,
        'balance': 1800.0,
      },
      {
        'month': 7.0,
        'balance': 2000.0,
      },
      {
        'month': 8.0,
        'balance': 2145.0,
      },
      {
        'month': 9.0,
        'balance': 2200.0,
      },
      {
        'month': 10.0,
        'balance': 4500.0,
      },
      {
        'month': 11.0,
        'balance': 3000.0,
      },
    ];
  }
}
