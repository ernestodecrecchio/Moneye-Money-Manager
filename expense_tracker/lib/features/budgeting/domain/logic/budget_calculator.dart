import 'package:expense_tracker/features/budgeting/domain/models/budget.dart';
import 'package:expense_tracker/features/budgeting/domain/models/budget_period.dart';
import 'package:expense_tracker/features/budgeting/domain/models/budget_progress.dart';

/// Pure logic for budget period boundaries and current-period progress.
///
/// [Budget.rolloverAmount] is persisted and updated only when a period ends
/// (see [BudgetPeriodRolloverService]). [spent] is supplied from a SQL aggregate.
class BudgetCalculator {
  static BudgetProgress calculateProgress({
    required Budget budget,
    required double spent,
    required DateTime now,
  }) {
    final currentPeriod = getPeriodBoundaries(budget, now);

    final carriedOver =
        budget.periodType == PeriodType.custom ? 0.0 : budget.rolloverAmount;

    return BudgetProgress(
      limit: budget.amount,
      spent: spent,
      carriedOver: carriedOver,
      startDate: currentPeriod.start,
      endDate: currentPeriod.end,
    );
  }

  /// Monthly anchor day; falls back to the creation day when not stored.
  static int effectiveStartDay(Budget budget) =>
      budget.startDay ?? budget.createdAt.day;

  /// ISO weekday the week starts on (1 = Monday … 7 = Sunday). Defaults to Monday.
  static int effectiveStartWeekday(Budget budget) => budget.startWeekday ?? 1;

  static DateTime toDateOnly(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  /// Last calendar day included in [period] (for labels).
  static DateTime periodInclusiveEndDate(Budget budget, BudgetPeriod period) {
    switch (budget.periodType) {
      case PeriodType.custom:
        final end = budget.customEndDate ?? period.end;
        return toDateOnly(end);
      case PeriodType.weekly:
        return toDateOnly(period.end);
      case PeriodType.monthly:
        final next = nextPeriodStart(budget, period);
        return toDateOnly(next).subtract(const Duration(days: 1));
    }
  }

  /// Whether [periodStart] is the start of a period under the current [periodType].
  static bool isPeriodStartAligned(Budget budget) {
    if (budget.periodStart == null) return false;
    final stored = normalizePeriodStart(budget.periodStart!);
    final canonical = normalizePeriodStart(
      periodStartFor(budget, budget.periodStart!),
    );
    return sameCalendarDay(stored, canonical);
  }

  /// The active budget interval containing [now] (spent totals and labels).
  static BudgetPeriod currentPeriod(Budget budget, DateTime now) =>
      getPeriodBoundaries(budget, now);

  static DateTime periodDisplayStartDate(DateTime start) => toDateOnly(start);

  static BudgetPeriod getPeriodBoundaries(Budget budget, DateTime date) {
    switch (budget.periodType) {
      case PeriodType.monthly:
        final startDay = effectiveStartDay(budget);
        final onDay = toDateOnly(date);
        DateTime start = DateTime(date.year, date.month, startDay);
        if (onDay.isBefore(toDateOnly(start))) {
          start = DateTime(date.year, date.month - 1, startDay);
        }
        final nextStart = DateTime(start.year, start.month + 1, startDay);
        final end = nextStart.subtract(const Duration(milliseconds: 1));
        return BudgetPeriod(start, end);

      case PeriodType.weekly:
        final startWeekday = effectiveStartWeekday(budget);
        var daysSinceStart = date.weekday - startWeekday;
        if (daysSinceStart < 0) daysSinceStart += 7;
        final start = DateTime(date.year, date.month, date.day)
            .subtract(Duration(days: daysSinceStart));
        final end = start
            .add(const Duration(days: 7))
            .subtract(const Duration(milliseconds: 1));
        return BudgetPeriod(start, end);

      case PeriodType.custom:
        return BudgetPeriod(
          budget.customStartDate ?? date,
          budget.customEndDate ?? date,
        );
    }
  }

  /// Start of the period that contains [date] (used for rollover bookkeeping).
  static DateTime periodStartFor(Budget budget, DateTime date) =>
      getPeriodBoundaries(budget, date).start;

  /// Start of the budget period immediately after [closed].
  static DateTime nextPeriodStart(Budget budget, BudgetPeriod closed) {
    switch (budget.periodType) {
      case PeriodType.monthly:
        final startDay = effectiveStartDay(budget);
        return DateTime(closed.start.year, closed.start.month + 1, startDay);
      case PeriodType.weekly:
        return closed.start.add(const Duration(days: 7));
      case PeriodType.custom:
        return closed.end.add(const Duration(days: 1));
    }
  }

  static bool sameCalendarDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  /// Midnight on the calendar day of [periodStart] for persistence.
  static DateTime normalizePeriodStart(DateTime periodStart) =>
      toDateOnly(periodStart);
}
