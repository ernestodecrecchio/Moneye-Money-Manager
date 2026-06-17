import 'package:expense_tracker/features/statistics/presentation/widgets/statistics_layout.dart';
import 'package:flutter/material.dart';

class StatisticsChartEmptyMessage extends StatelessWidget {
  const StatisticsChartEmptyMessage({
    super.key,
    required this.message,
    this.height = StatisticsLayout.chartHeight,
  });

  final String message;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: StatisticsLayout.emptyMessageStyle(context),
      ),
    );
  }
}

class StatisticsChartLoading extends StatelessWidget {
  const StatisticsChartLoading({
    super.key,
    this.height = StatisticsLayout.chartHeight,
  });

  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: const Center(child: CircularProgressIndicator()),
    );
  }
}

class StatisticsInlineEmptyMessage extends StatelessWidget {
  const StatisticsInlineEmptyMessage({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Text(
      message,
      textAlign: TextAlign.center,
      style: StatisticsLayout.emptyMessageStyle(context),
    );
  }
}
