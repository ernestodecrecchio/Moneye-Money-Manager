import 'package:expense_tracker/core/utils/double_helper.dart';
import 'package:expense_tracker/features/statistics/domain/models/daily_income_expense.dart';
import 'package:expense_tracker/features/statistics/domain/models/monthly_cashflow_point.dart';
import 'package:expense_tracker/features/statistics/domain/models/monthly_cashflow_series.dart';
import 'package:expense_tracker/features/statistics/domain/models/statistics_period.dart';
import 'package:intl/intl.dart';

class MonthlyCashflowCalculator {
  const MonthlyCashflowCalculator._();

  static MonthlyCashflowSeries build({
    required StatisticsPeriod period,
    required List<DailyIncomeExpense> dailyRecords,
    required String locale,
  }) {
    final monthStarts = _monthStartsInPeriod(period);
    final incomeTotals = {
      for (final monthStart in monthStarts) _monthKey(monthStart): 0.0,
    };
    final expenseTotals = {
      for (final monthStart in monthStarts) _monthKey(monthStart): 0.0,
    };

    for (final record in dailyRecords) {
      final key = _monthKey(DateTime(record.date.year, record.date.month, 1));
      final incomeBucket = incomeTotals[key];
      final expenseBucket = expenseTotals[key];
      if (incomeBucket == null || expenseBucket == null) {
        continue;
      }

      incomeTotals[key] = (incomeBucket + record.income).withPrecision(2);
      expenseTotals[key] = (expenseBucket + record.expenses).withPrecision(2);
    }

    final spansMultipleYears = _spansMultipleYears(monthStarts);
    final labelFormat = spansMultipleYears
        ? DateFormat.yMMM(locale)
        : DateFormat.MMM(locale);

    final points = monthStarts
        .map(
          (monthStart) => MonthlyCashflowPoint(
            monthStart: monthStart,
            label: labelFormat.format(monthStart),
            income: incomeTotals[_monthKey(monthStart)]!,
            expenses: expenseTotals[_monthKey(monthStart)]!,
          ),
        )
        .toList();

    return MonthlyCashflowSeries(points: points);
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

  static bool _spansMultipleYears(List<DateTime> monthStarts) {
    if (monthStarts.isEmpty) {
      return false;
    }

    final firstYear = monthStarts.first.year;
    return monthStarts.any((monthStart) => monthStart.year != firstYear);
  }

  static String _monthKey(DateTime monthStart) {
    return '${monthStart.year}-${monthStart.month}';
  }
}
