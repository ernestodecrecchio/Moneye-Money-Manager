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
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 4,
      children: [
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            value,
            style: textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: valueColor ?? colors.textPrimary,
              letterSpacing: -0.5,
            ),
          ),
        ),
      ],
    );
  }
}
