import 'package:expense_tracker/core/utils/date_time_helper.dart';
import 'package:expense_tracker/core/utils/double_helper.dart';
import 'package:expense_tracker/features/statistics/domain/models/daily_income_expense.dart';
import 'package:expense_tracker/features/statistics/domain/models/income_vs_expenses_series.dart';
import 'package:expense_tracker/features/statistics/domain/models/statistics_period.dart';
import 'package:expense_tracker/features/statistics/domain/models/statistics_period_granularity.dart';
import 'package:intl/intl.dart';

class IncomeVsExpensesCalculator {
  const IncomeVsExpensesCalculator._();

  static IncomeVsExpensesSeries build({
    required StatisticsPeriod period,
    required List<DailyIncomeExpense> dailyRecords,
    required String locale,
  }) {
    final buckets = period.granularity == StatisticsPeriodGranularity.month
        ? _buildWeeklyBuckets(
            periodStart: period.startDate,
            dailyRecords: dailyRecords,
            locale: locale,
          )
        : _buildMonthlyBuckets(
            period: period,
            dailyRecords: dailyRecords,
            locale: locale,
          );

    return IncomeVsExpensesSeries(buckets: buckets);
  }

  static List<IncomeExpenseBucket> _buildWeeklyBuckets({
    required DateTime periodStart,
    required List<DailyIncomeExpense> dailyRecords,
    required String locale,
  }) {
    final labels = _weekIntervalLabels(periodStart, locale);
    final totals = List.generate(labels.length, (_) => [0.0, 0.0]);
    final firstWeek = weekNumber(periodStart);

    for (final record in dailyRecords) {
      final weekIndex = weekNumber(record.date) - firstWeek;
      if (weekIndex < 0 || weekIndex >= totals.length) {
        continue;
      }

      totals[weekIndex][0] =
          (totals[weekIndex][0] + record.income).withPrecision(2);
      totals[weekIndex][1] =
          (totals[weekIndex][1] + record.expenses).withPrecision(2);
    }

    return [
      for (var i = 0; i < labels.length; i++)
        IncomeExpenseBucket(
          label: labels[i],
          income: totals[i][0],
          expenses: totals[i][1],
        ),
    ];
  }

  static List<IncomeExpenseBucket> _buildMonthlyBuckets({
    required StatisticsPeriod period,
    required List<DailyIncomeExpense> dailyRecords,
    required String locale,
  }) {
    final monthStarts = _monthStartsInPeriod(period);
    final totals = {
      for (final monthStart in monthStarts)
        _monthKey(monthStart): [0.0, 0.0],
    };

    for (final record in dailyRecords) {
      final key = _monthKey(DateTime(record.date.year, record.date.month, 1));
      final bucket = totals[key];
      if (bucket == null) {
        continue;
      }

      bucket[0] = (bucket[0] + record.income).withPrecision(2);
      bucket[1] = (bucket[1] + record.expenses).withPrecision(2);
    }

    return monthStarts
        .map(
          (monthStart) => IncomeExpenseBucket(
            label: DateFormat.MMM(locale).format(monthStart),
            income: totals[_monthKey(monthStart)]![0],
            expenses: totals[_monthKey(monthStart)]![1],
          ),
        )
        .toList();
  }

  static List<DateTime> _monthStartsInPeriod(StatisticsPeriod period) {
    final months = <DateTime>[];
    var year = period.startDate.year;
    var month = period.startDate.month;
    final endMonth = DateTime(period.endDate.year, period.endDate.month, 1);

    while (!DateTime(year, month, 1).isAfter(endMonth)) {
      months.add(DateTime(year, month, 1));
      month++;
      if (month > 12) {
        year++;
        month = 1;
      }
    }

    return months;
  }

  static String _monthKey(DateTime monthStart) {
    return '${monthStart.year}-${monthStart.month}';
  }

  static List<String> _weekIntervalLabels(DateTime monthDate, String locale) {
    final ddDateFormat = DateFormat('dd', locale);
    final labels = <String>[];

    final start = currentMonthFirstDay(monthDate);
    final end = nextMonthFirstDay(monthDate);

    var currentWeekFirst = currentWeekFirstDay(start);
    var currentWeekLast = currentWeekLastDay(start);

    if (start.day != currentWeekLast.day) {
      labels.add(
        '${ddDateFormat.format(start)} - ${ddDateFormat.format(currentWeekLast)}',
      );
    } else {
      labels.add(ddDateFormat.format(start));
    }

    currentWeekFirst = nextWeekFirstDay(currentWeekFirst);
    currentWeekLast = nextWeekLastDay(currentWeekLast);

    while (currentWeekLast.isBefore(end)) {
      labels.add(
        '${ddDateFormat.format(currentWeekFirst)} - ${ddDateFormat.format(currentWeekLast)}',
      );
      currentWeekFirst = nextWeekFirstDay(currentWeekFirst);
      currentWeekLast = nextWeekLastDay(currentWeekLast);
    }

    if (currentWeekFirst.month == start.month) {
      final lastDay = currentMonthLastDay(monthDate);
      if (currentWeekFirst.day != lastDay.day) {
        labels.add(
          '${ddDateFormat.format(currentWeekFirst)} - ${ddDateFormat.format(lastDay)}',
        );
      } else {
        labels.add(ddDateFormat.format(currentWeekFirst));
      }
    }

    return labels;
  }
}
