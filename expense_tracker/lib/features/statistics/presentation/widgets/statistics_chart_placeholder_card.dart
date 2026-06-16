import 'package:expense_tracker/core/style/app_theme.dart';
import 'package:expense_tracker/features/statistics/presentation/widgets/statistics_surface_card.dart';
import 'package:flutter/material.dart';

class StatisticsChartPlaceholderCard extends StatelessWidget {
  const StatisticsChartPlaceholderCard({
    super.key,
    required this.title,
    this.placeholderText,
    this.height = 180,
  });

  final String title;
  final String? placeholderText;
  final double height;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return StatisticsSurfaceCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
          Container(
            height: height,
            width: double.infinity,
            decoration: BoxDecoration(
              color: colors.divider.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Text(
              placeholderText ?? '',
              style: TextStyle(
                fontSize: 14,
                color: colors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
