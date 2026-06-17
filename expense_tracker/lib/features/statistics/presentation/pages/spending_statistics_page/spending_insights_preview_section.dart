import 'package:expense_tracker/core/presentation/providers/app_localizations_provider.dart';
import 'package:expense_tracker/features/statistics/presentation/pages/insights_statistics_page/insights_empty_state.dart';
import 'package:expense_tracker/features/statistics/presentation/providers/queries/statistics_insights_notifier.dart';
import 'package:expense_tracker/features/statistics/presentation/widgets/insight_card.dart';
import 'package:expense_tracker/features/statistics/presentation/widgets/statistics_empty_states.dart';
import 'package:expense_tracker/features/statistics/presentation/widgets/statistics_layout.dart';
import 'package:expense_tracker/features/statistics/presentation/widgets/statistics_section_card.dart';
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
          return StatisticsSectionCard(
            title: appLocalizations.statisticsSpendingInsightsPreview,
            subtitle: appLocalizations.statisticsSpendingInsightsPreviewSubtitle,
            child: StatisticsInlineEmptyMessage(
              message: appLocalizations.statisticsInsightsEmptyMessage,
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: StatisticsLayout.sectionSpacing,
          children: [
            _SpendingInsightsPreviewHeader(
              appLocalizations: appLocalizations,
            ),
            Column(
              spacing: 12,
              children: [
                for (final insight in insights.take(_previewCount))
                  InsightCard(insight: insight),
              ],
            ),
          ],
        );
      },
      loading: () => StatisticsSectionCard(
        title: appLocalizations.statisticsSpendingInsightsPreview,
        subtitle: appLocalizations.statisticsSpendingInsightsPreviewSubtitle,
        child: const StatisticsChartLoading(height: 120),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 4,
      children: [
        Text(
          appLocalizations.statisticsSpendingInsightsPreview,
          style: StatisticsLayout.cardTitleStyle(context),
        ),
        Text(
          appLocalizations.statisticsSpendingInsightsPreviewSubtitle,
          style: StatisticsLayout.cardSubtitleStyle(context),
        ),
      ],
    );
  }
}
