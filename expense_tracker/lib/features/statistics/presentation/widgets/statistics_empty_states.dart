import 'package:expense_tracker/core/style/app_theme.dart';
import 'package:flutter/material.dart';

class StatisticsChartEmptyMessage extends StatelessWidget {
  const StatisticsChartEmptyMessage({
    super.key,
    required this.message,
    this.height = 180,
  });

  final String message;
  final double height;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: colors.divider.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 14,
          height: 1.45,
          color: colors.textSecondary,
        ),
      ),
    );
  }
}

class StatisticsChartLoading extends StatelessWidget {
  const StatisticsChartLoading({super.key, this.height = 180});

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
    final colors = context.appColors;

    return Text(
      message,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 14,
        height: 1.5,
        color: colors.textSecondary,
      ),
    );
  }
}
