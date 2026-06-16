import 'package:expense_tracker/features/statistics/domain/models/statistics_period_granularity.dart';

class StatisticsPeriodSelection {
  const StatisticsPeriodSelection({
    required this.granularity,
    required this.anchorDate,
  });

  final StatisticsPeriodGranularity granularity;
  final DateTime anchorDate;

  factory StatisticsPeriodSelection.initial({DateTime? referenceDate}) {
    final date = referenceDate ?? DateTime.now();
    return StatisticsPeriodSelection(
      granularity: StatisticsPeriodGranularity.month,
      anchorDate: anchorFor(StatisticsPeriodGranularity.month, date),
    );
  }

  static DateTime anchorFor(
    StatisticsPeriodGranularity granularity,
    DateTime date,
  ) {
    return switch (granularity) {
      StatisticsPeriodGranularity.month =>
        DateTime(date.year, date.month, 1),
      StatisticsPeriodGranularity.quarter => DateTime(
          date.year,
          ((date.month - 1) ~/ 3) * 3 + 1,
          1,
        ),
      StatisticsPeriodGranularity.year => DateTime(date.year, 1, 1),
    };
  }

  int get quarter => ((anchorDate.month - 1) ~/ 3) + 1;

  bool get canGoForward {
    final currentAnchor = anchorFor(granularity, DateTime.now());
    return anchorDate.isBefore(currentAnchor);
  }

  StatisticsPeriodSelection shifted(int delta) {
    return copyWith(anchorDate: _shiftAnchor(anchorDate, granularity, delta));
  }

  StatisticsPeriodSelection copyWith({
    StatisticsPeriodGranularity? granularity,
    DateTime? anchorDate,
  }) {
    return StatisticsPeriodSelection(
      granularity: granularity ?? this.granularity,
      anchorDate: anchorDate ?? this.anchorDate,
    );
  }

  static DateTime _shiftAnchor(
    DateTime anchor,
    StatisticsPeriodGranularity granularity,
    int delta,
  ) {
    return switch (granularity) {
      StatisticsPeriodGranularity.month =>
        DateTime(anchor.year, anchor.month + delta, 1),
      StatisticsPeriodGranularity.quarter =>
        DateTime(anchor.year, anchor.month + delta * 3, 1),
      StatisticsPeriodGranularity.year =>
        DateTime(anchor.year + delta, 1, 1),
    };
  }
}
