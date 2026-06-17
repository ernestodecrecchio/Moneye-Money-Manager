import 'package:expense_tracker/features/statistics/domain/models/statistics_insight.dart';
import 'package:expense_tracker/features/statistics/presentation/providers/statistics_period_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Placeholder provider for statistics insights.
///
/// Returns an empty list until insight generation is implemented.
final statisticsInsightsProvider = Provider<List<StatisticsInsight>>((ref) {
  ref.watch(statisticsPeriodProvider);
  return const [];
});
