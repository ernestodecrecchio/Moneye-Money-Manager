import 'package:expense_tracker/core/style/app_theme.dart';
import 'package:expense_tracker/features/statistics/presentation/widgets/statistics_layout.dart';
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
      padding: StatisticsLayout.cardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: StatisticsLayout.cardHeaderSpacing,
        children: [
          Text(title, style: StatisticsLayout.cardTitleStyle(context)),
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
              style: StatisticsLayout.emptyMessageStyle(context),
            ),
          ),
        ],
      ),
    );
  }
}
