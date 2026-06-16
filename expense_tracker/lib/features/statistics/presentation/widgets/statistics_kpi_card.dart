import 'package:expense_tracker/core/style/app_theme.dart';
import 'package:flutter/material.dart';

class StatisticsKpiCard extends StatelessWidget {
  const StatisticsKpiCard({
    super.key,
    required this.label,
    required this.value,
    this.valueColor,
  });

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 4,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: colors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: valueColor ?? colors.textPrimary,
            letterSpacing: -0.5,
          ),
        ),
      ],
    );
  }
}
