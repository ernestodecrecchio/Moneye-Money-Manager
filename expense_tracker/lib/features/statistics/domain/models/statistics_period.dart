import 'package:expense_tracker/features/statistics/domain/models/statistics_period_granularity.dart';
import 'package:expense_tracker/features/statistics/domain/models/statistics_period_selection.dart';

class StatisticsPeriod {
  const StatisticsPeriod({
    required this.granularity,
    required this.anchorDate,
    required this.startDate,
    required this.endDate,
  });

  final StatisticsPeriodGranularity granularity;
  final DateTime anchorDate;
  final DateTime startDate;
  final DateTime endDate;

  factory StatisticsPeriod.fromSelection(StatisticsPeriodSelection selection) {
    final anchor = selection.anchorDate;

    return switch (selection.granularity) {
      StatisticsPeriodGranularity.month => StatisticsPeriod(
          granularity: selection.granularity,
          anchorDate: anchor,
          startDate: anchor,
          endDate: _endOfDay(_lastDayOfMonth(anchor.year, anchor.month)),
        ),
      StatisticsPeriodGranularity.quarter => StatisticsPeriod(
          granularity: selection.granularity,
          anchorDate: anchor,
          startDate: anchor,
          endDate: _endOfDay(
            _lastDayOfMonth(anchor.year, anchor.month + 2),
          ),
        ),
      StatisticsPeriodGranularity.year => StatisticsPeriod(
          granularity: selection.granularity,
          anchorDate: anchor,
          startDate: DateTime(anchor.year, 1, 1),
          endDate: _endOfDay(DateTime(anchor.year, 12, 31)),
        ),
    };
  }

  int get quarter => ((anchorDate.month - 1) ~/ 3) + 1;

  StatisticsPeriod get previous {
    final selection = StatisticsPeriodSelection(
      granularity: granularity,
      anchorDate: anchorDate,
    ).shifted(-1);
    return StatisticsPeriod.fromSelection(selection);
  }

  static DateTime _endOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59, 999);
  }

  static DateTime _lastDayOfMonth(int year, int month) {
    return DateTime(year, month + 1, 0);
  }
}
