import 'package:expense_tracker/core/presentation/providers/app_localizations_provider.dart';
import 'package:expense_tracker/features/statistics/presentation/pages/insights_statistics_page/insights_empty_state.dart';
import 'package:expense_tracker/features/statistics/presentation/providers/queries/statistics_insights_notifier.dart';
import 'package:expense_tracker/features/statistics/presentation/widgets/insight_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InsightsListSection extends ConsumerWidget {
  const InsightsListSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocalizations = ref.watch(appLocalizationsProvider);
    final insightsAsync = ref.watch(statisticsInsightsProvider);

    return insightsAsync.when(
      data: (insights) {
        if (insights.isEmpty) {
          return InsightsEmptyState(
            title: appLocalizations.statisticsInsightsEmptyTitle,
            message: appLocalizations.statisticsInsightsEmptyMessage,
          );
        }

        return Column(
          spacing: 12,
          children: [
            for (final insight in insights) InsightCard(insight: insight),
          ],
        );
      },
      loading: () => const SizedBox(
        height: 200,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (_, __) => InsightsEmptyState(
        title: appLocalizations.statisticsInsightsErrorTitle,
        message: appLocalizations.statisticsInsightsError,
      ),
    );
  }
}
