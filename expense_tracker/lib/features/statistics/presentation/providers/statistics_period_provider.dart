import 'package:expense_tracker/features/statistics/domain/models/statistics_period.dart';
import 'package:expense_tracker/features/statistics/domain/models/statistics_period_granularity.dart';
import 'package:expense_tracker/features/statistics/domain/models/statistics_period_selection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StatisticsPeriodNotifier extends Notifier<StatisticsPeriodSelection> {
  @override
  StatisticsPeriodSelection build() {
    return StatisticsPeriodSelection.initial();
  }

  void updateGranularity(StatisticsPeriodGranularity granularity) {
    state = StatisticsPeriodSelection(
      granularity: granularity,
      anchorDate: StatisticsPeriodSelection.anchorFor(
        granularity,
        DateTime.now(),
      ),
    );
  }

  void goToPreviousPeriod() {
    state = state.shifted(-1);
  }

  void goToNextPeriod() {
    if (!state.canGoForward) {
      return;
    }
    state = state.shifted(1);
  }
}

final statisticsPeriodSelectionProvider =
    NotifierProvider<StatisticsPeriodNotifier, StatisticsPeriodSelection>(
  StatisticsPeriodNotifier.new,
);

final statisticsPeriodProvider = Provider<StatisticsPeriod>((ref) {
  final selection = ref.watch(statisticsPeriodSelectionProvider);
  return StatisticsPeriod.fromSelection(selection);
});
