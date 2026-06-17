import 'package:expense_tracker/features/statistics/presentation/widgets/statistics_layout.dart';
import 'package:expense_tracker/features/statistics/presentation/widgets/statistics_surface_card.dart';
import 'package:flutter/material.dart';

class StatisticsSectionCard extends StatelessWidget {
  const StatisticsSectionCard({
    super.key,
    required this.title,
    required this.child,
    this.subtitle,
    this.padding,
  });

  final String title;
  final String? subtitle;
  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return StatisticsSurfaceCard(
      padding: padding ?? StatisticsLayout.cardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: StatisticsLayout.cardHeaderSpacing,
        children: [
          if (subtitle != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 4,
              children: [
                Text(title, style: StatisticsLayout.cardTitleStyle(context)),
                Text(
                  subtitle!,
                  style: StatisticsLayout.cardSubtitleStyle(context),
                ),
              ],
            )
          else
            Text(title, style: StatisticsLayout.cardTitleStyle(context)),
          child,
        ],
      ),
    );
  }
}
