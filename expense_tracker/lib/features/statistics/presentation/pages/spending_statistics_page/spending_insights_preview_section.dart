import 'package:expense_tracker/core/presentation/providers/app_localizations_provider.dart';
import 'package:expense_tracker/core/style/app_theme.dart';
import 'package:expense_tracker/features/statistics/presentation/pages/insights_statistics_page/insights_empty_state.dart';
import 'package:expense_tracker/features/statistics/presentation/providers/queries/statistics_insights_notifier.dart';
import 'package:expense_tracker/features/statistics/presentation/widgets/insight_card.dart';
import 'package:expense_tracker/features/statistics/presentation/widgets/statistics_empty_states.dart';
import 'package:expense_tracker/features/statistics/presentation/widgets/statistics_surface_card.dart';
import 'package:expense_tracker/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SpendingInsightsPreviewSection extends ConsumerWidget {
  const SpendingInsightsPreviewSection({super.key});

  static const _previewCount = 2;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocalizations = ref.watch(appLocalizationsProvider);
    final insightsAsync = ref.watch(statisticsInsightsProvider);

    return insightsAsync.when(
      data: (insights) {
        if (insights.isEmpty) {
          return StatisticsSurfaceCard(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 16,
              children: [
                _SpendingInsightsPreviewHeader(
                  appLocalizations: appLocalizations,
                ),
                StatisticsInlineEmptyMessage(
                  message: appLocalizations.statisticsInsightsEmptyMessage,
                ),
              ],
            ),
          );
        }

        final previewInsights = insights.take(_previewCount).toList();

        return StatisticsSurfaceCard(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 16,
            children: [
              _SpendingInsightsPreviewHeader(
                appLocalizations: appLocalizations,
              ),
              Column(
                spacing: 12,
                children: [
                  for (final insight in previewInsights)
                    InsightCard(insight: insight),
                ],
              ),
            ],
          ),
        );
      },
      loading: () => StatisticsSurfaceCard(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16,
          children: [
            _SpendingInsightsPreviewHeader(
              appLocalizations: appLocalizations,
            ),
            const StatisticsChartLoading(height: 120),
          ],
        ),
      ),
      error: (_, __) => InsightsEmptyState(
        title: appLocalizations.statisticsInsightsErrorTitle,
        message: appLocalizations.statisticsInsightsError,
      ),
    );
  }
}

class _SpendingInsightsPreviewHeader extends StatelessWidget {
  const _SpendingInsightsPreviewHeader({required this.appLocalizations});

  final AppLocalizations appLocalizations;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 4,
      children: [
        Text(
          appLocalizations.statisticsSpendingInsightsPreview,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
        ),
        Text(
          appLocalizations.statisticsSpendingInsightsPreviewSubtitle,
          style: TextStyle(
            fontSize: 13,
            color: colors.textSecondary,
          ),
        ),
      ],
    );
  }
}
