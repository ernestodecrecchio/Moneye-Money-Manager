import 'package:expense_tracker/features/budgeting/domain/logic/budget_calculator.dart';
import 'package:expense_tracker/features/budgeting/domain/logic/budget_period_spent_query.dart';
import 'package:expense_tracker/features/budgeting/domain/models/budget.dart';

/// Closes past budget periods and updates persisted [Budget.rolloverAmount].
///
/// Rollover is applied only when a period ends, so editing or deleting old
/// transactions does not change the current period's carry-over.
class BudgetPeriodRolloverService {
  static const _maxPeriodClosures = 120;

  /// Returns an updated [Budget] when one or more periods have ended; otherwise
  /// returns the same instance.
  static Future<Budget> syncPeriodIfNeeded({
    required Budget budget,
    required BudgetPeriodSpentQuery spentQuery,
    required DateTime now,
  }) async {
    if (budget.periodType == PeriodType.custom) {
      final period = BudgetCalculator.getPeriodBoundaries(budget, now);
      final normalizedStart = BudgetCalculator.normalizePeriodStart(period.start);
      if (budget.periodStart != null &&
          BudgetCalculator.sameCalendarDay(budget.periodStart!, normalizedStart)) {
        return budget;
      }
      return budget.copy(
        periodStart: normalizedStart,
        rolloverAmount: 0,
        updatedAt: now,
      );
    }

    var working = budget;
    if (budget.periodType == PeriodType.monthly && budget.startDay == null) {
      working = budget.copy(startDay: BudgetCalculator.effectiveStartDay(budget));
    }
    final currentPeriod = BudgetCalculator.getPeriodBoundaries(working, now);
    final currentStart =
        BudgetCalculator.normalizePeriodStart(currentPeriod.start);

    if (working.periodStart == null) {
      return _withPeriodStart(working, budget, currentStart, now);
    }

    if (!BudgetCalculator.isPeriodStartAligned(working)) {
      return _withPeriodStart(
        working.copy(rolloverAmount: 0),
        budget,
        currentStart,
        now,
      );
    }

    var periodAnchor = BudgetCalculator.normalizePeriodStart(
      BudgetCalculator.periodStartFor(working, working.periodStart!),
    );

    if (BudgetCalculator.toDateOnly(periodAnchor)
        .isAfter(BudgetCalculator.toDateOnly(currentStart))) {
      return _withPeriodStart(working, budget, currentStart, now);
    }

    if (BudgetCalculator.sameCalendarDay(periodAnchor, currentStart)) {
      if (working == budget &&
          budget.periodStart != null &&
          BudgetCalculator.sameCalendarDay(budget.periodStart!, currentStart)) {
        return budget;
      }
      return _withPeriodStart(working, budget, currentStart, now);
    }

    var closures = 0;
    while (BudgetCalculator.toDateOnly(periodAnchor)
        .isBefore(BudgetCalculator.toDateOnly(currentStart))) {
      if (closures++ >= _maxPeriodClosures) break;

      final closingPeriod =
          BudgetCalculator.getPeriodBoundaries(working, periodAnchor);
      final spent = await spentQuery(
        categoryIds: working.categoryIds,
        start: closingPeriod.start,
        end: closingPeriod.end,
        allCategories: working.allCategories,
      );
      final balance = working.amount - spent;

      double newRollover = working.rolloverAmount;
      switch (working.rolloverMode) {
        case RolloverMode.none:
          newRollover = 0;
        case RolloverMode.carryRemaining:
          if (balance > 0) {
            newRollover += balance;
          }
        case RolloverMode.carryOverspending:
          if (balance < 0) {
            newRollover += balance;
          }
      }

      periodAnchor = BudgetCalculator.normalizePeriodStart(
        BudgetCalculator.nextPeriodStart(working, closingPeriod),
      );
      working = working.copy(
        rolloverAmount: newRollover,
        periodStart: periodAnchor,
        updatedAt: now,
      );
    }

    if (working.rolloverAmount == budget.rolloverAmount &&
        working.startDay == budget.startDay &&
        budget.periodStart != null &&
        BudgetCalculator.sameCalendarDay(budget.periodStart!, currentStart)) {
      return budget;
    }

    return _withPeriodStart(working, budget, currentStart, now);
  }

  static Budget _withPeriodStart(
    Budget working,
    Budget original,
    DateTime currentStart,
    DateTime now,
  ) {
    final updated = working.copy(
      periodStart: currentStart,
      updatedAt: now,
    );
    return updated == original ? original : updated;
  }
}
