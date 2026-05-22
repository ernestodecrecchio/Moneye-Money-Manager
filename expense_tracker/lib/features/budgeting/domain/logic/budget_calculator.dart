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

  static BudgetPeriod getPeriodBoundaries(Budget budget, DateTime date) {
    switch (budget.periodType) {
      case PeriodType.monthly:
        final startDay = budget.startDay ?? 1;
        DateTime start = DateTime(date.year, date.month, startDay);
        if (date.isBefore(start)) {
          start = DateTime(date.year, date.month - 1, startDay);
        }
        final nextStart = DateTime(start.year, start.month + 1, startDay);
        final end = nextStart.subtract(const Duration(milliseconds: 1));
        return BudgetPeriod(start, end);

      case PeriodType.weekly:
        final startWeekday = budget.startWeekday ?? 1;
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
}
