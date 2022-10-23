import 'dart:convert';

import 'package:expense_tracker/notifiers/transaction_provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MonthlyBalanceGraph extends StatelessWidget {
  const MonthlyBalanceGraph({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getChartData(context),
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
                          double.parse(monthlyBalance['month'] as String),
                          monthlyBalance['balance']);
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

  Future<List<Map<String, dynamic>>> _getChartData(BuildContext context) async {
    return await Provider.of<TransactionProvider>(context, listen: false)
        .getMonthlyBalanceForYear(2022);
  }
}
