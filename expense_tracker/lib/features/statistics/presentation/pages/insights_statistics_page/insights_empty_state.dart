import 'package:expense_tracker/core/style/app_theme.dart';
import 'package:expense_tracker/features/statistics/presentation/widgets/statistics_layout.dart';
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
    final textTheme = Theme.of(context).textTheme;

    return StatisticsSurfaceCard(
      padding: StatisticsLayout.cardPadding,
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
            style: textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: colors.textPrimary,
            ),
          ),
          Text(
            message,
            textAlign: TextAlign.center,
            style: StatisticsLayout.emptyMessageStyle(context),
          ),
        ],
      ),
    );
  }
}
