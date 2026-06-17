import 'package:expense_tracker/core/style/app_theme.dart';
import 'package:expense_tracker/features/statistics/domain/models/insight_severity.dart';
import 'package:expense_tracker/features/statistics/domain/models/statistics_insight.dart';
import 'package:expense_tracker/features/statistics/presentation/widgets/statistics_surface_card.dart';
import 'package:flutter/material.dart';

class InsightCard extends StatelessWidget {
  const InsightCard({
    super.key,
    required this.insight,
  });

  final StatisticsInsight insight;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final accentColor = insight.severity?.accentColor(colors) ?? colors.primary;
    final icon = insight.icon ?? Icons.lightbulb_outline_rounded;

    return StatisticsSurfaceCard(
      padding: EdgeInsets.zero,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 4,
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.85),
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(20),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 12,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: accentColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        icon,
                        size: 20,
                        color: accentColor,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 6,
                        children: [
                          Text(
                            insight.title,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              height: 1.3,
                            ),
                          ),
                          Text(
                            insight.description,
                            style: TextStyle(
                              fontSize: 13,
                              height: 1.45,
                              color: colors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
