import 'package:expense_tracker/core/style/app_theme.dart';
import 'package:expense_tracker/features/statistics/presentation/widgets/statistics_surface_card.dart';
import 'package:flutter/material.dart';

class InsightsEmptyState extends StatelessWidget {
  const InsightsEmptyState({
    super.key,
    required this.title,
    required this.message,
  });

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return StatisticsSurfaceCard(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Column(
        spacing: 12,
        children: [
          Icon(
            Icons.lightbulb_outline_rounded,
            size: 48,
            color: colors.textSecondary.withValues(alpha: 0.45),
          ),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
