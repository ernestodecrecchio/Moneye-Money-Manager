import 'package:expense_tracker/core/presentation/providers/app_localizations_provider.dart';
import 'package:expense_tracker/features/statistics/presentation/widgets/statistics_fullscreen_chart.dart';
import 'package:expense_tracker/features/statistics/presentation/widgets/statistics_layout.dart';
import 'package:expense_tracker/features/statistics/presentation/widgets/statistics_surface_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StatisticsSectionCard extends ConsumerWidget {
  const StatisticsSectionCard({
    super.key,
    required this.title,
    required this.child,
    this.subtitle,
    this.padding,
    this.fullscreenChartBuilder,
  });

  final String title;
  final String? subtitle;
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final StatisticsFullscreenChartBuilder? fullscreenChartBuilder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocalizations = ref.watch(appLocalizationsProvider);

    return StatisticsSurfaceCard(
      padding: padding ?? StatisticsLayout.cardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: StatisticsLayout.cardHeaderSpacing,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 4,
            children: [
              Expanded(child: _buildHeader(context)),
              if (fullscreenChartBuilder != null)
                IconButton(
                  onPressed: () => openStatisticsFullscreenChart(
                    context: context,
                    title: title,
                    chartBuilder: fullscreenChartBuilder!,
                  ),
                  tooltip: appLocalizations.statisticsChartFullscreen,
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 36,
                    minHeight: 36,
                  ),
                  icon: const Icon(Icons.fullscreen, size: 22),
                ),
            ],
          ),
          child,
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    if (subtitle != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 4,
        children: [
          Text(title, style: StatisticsLayout.cardTitleStyle(context)),
          Text(
            subtitle!,
            style: StatisticsLayout.cardSubtitleStyle(context),
          ),
        ],
      );
    }

    return Text(title, style: StatisticsLayout.cardTitleStyle(context));
  }
}
