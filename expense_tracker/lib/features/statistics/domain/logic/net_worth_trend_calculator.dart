import 'package:expense_tracker/features/statistics/domain/models/net_worth_trend_series.dart';
import 'package:expense_tracker/features/statistics/domain/models/statistics_period.dart';
import 'package:expense_tracker/features/statistics/domain/models/statistics_period_granularity.dart';

class NetWorthTrendCalculator {
  const NetWorthTrendCalculator._();

  static NetWorthTrendSeries build({
    required StatisticsPeriod period,
    required double openingNetWorth,
    required Map<DateTime, double> dailyChanges,
  }) {
    final bucketEnds = _bucketEndDates(period);
    if (bucketEnds.isEmpty) {
      return const NetWorthTrendSeries(points: []);
    }

    final points = <NetWorthTrendPoint>[];
    var runningNetWorth = openingNetWorth;
    var previousExclusiveEnd = _dateOnly(period.startDate)
        .subtract(const Duration(days: 1));

    for (final bucketEnd in bucketEnds) {
      for (final entry in dailyChanges.entries) {
        final day = entry.key;
        if (day.isAfter(previousExclusiveEnd) && !day.isAfter(bucketEnd)) {
          runningNetWorth += entry.value;
        }
      }

      points.add(
        NetWorthTrendPoint(
          date: bucketEnd,
          netWorth: runningNetWorth,
        ),
      );
      previousExclusiveEnd = bucketEnd;
    }

    return NetWorthTrendSeries(points: points);
  }

  static List<DateTime> _bucketEndDates(StatisticsPeriod period) {
    final start = _dateOnly(period.startDate);
    final end = _dateOnly(period.endDate);

    return switch (period.granularity) {
      StatisticsPeriodGranularity.month => _dailyBucketEnds(start, end),
      StatisticsPeriodGranularity.quarter => _weeklyBucketEnds(start, end),
      StatisticsPeriodGranularity.year => _monthlyBucketEnds(start, end),
    };
  }

  static List<DateTime> _dailyBucketEnds(DateTime start, DateTime end) {
    final dates = <DateTime>[];
    var current = start;

    while (!current.isAfter(end)) {
      dates.add(current);
      current = current.add(const Duration(days: 1));
    }

    return dates;
  }

  static List<DateTime> _weeklyBucketEnds(DateTime start, DateTime end) {
    final dates = <DateTime>[];
    var current = start;

    while (!current.isAfter(end)) {
      dates.add(current);
      current = current.add(const Duration(days: 7));
    }

    if (dates.isEmpty || dates.last != end) {
      dates.add(end);
    }

    return dates;
  }

  static List<DateTime> _monthlyBucketEnds(DateTime start, DateTime end) {
    final dates = <DateTime>[];
    var year = start.year;
    var month = start.month;

    while (true) {
      final monthEnd = DateTime(year, month + 1, 0);
      final bucketEnd = monthEnd.isAfter(end) ? end : monthEnd;

      if (!bucketEnd.isBefore(start)) {
        if (dates.isEmpty || dates.last != bucketEnd) {
          dates.add(bucketEnd);
        }
      }

      if (bucketEnd == end) {
        break;
      }

      month++;
      if (month > 12) {
        year++;
        month = 1;
      }

      if (DateTime(year, month, 1).isAfter(end)) {
        if (dates.isEmpty || dates.last != end) {
          dates.add(end);
        }
        break;
      }
    }

    return dates;
  }

  static DateTime _dateOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }
}
