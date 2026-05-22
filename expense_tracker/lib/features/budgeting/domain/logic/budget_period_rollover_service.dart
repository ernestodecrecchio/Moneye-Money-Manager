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
      if (budget.periodStart != null &&
          _sameInstant(budget.periodStart!, period.start)) {
        return budget;
      }
      return budget.copy(
        periodStart: period.start,
        rolloverAmount: 0,
        updatedAt: now,
      );
    }

    final currentPeriod = BudgetCalculator.getPeriodBoundaries(budget, now);
    var working = budget;
    var periodAnchor = budget.periodStart ?? budget.createdAt;

    if (budget.periodStart == null) {
      return working.copy(
        periodStart: currentPeriod.start,
        updatedAt: now,
      );
    }

    var closures = 0;
    while (!_sameInstant(periodAnchor, currentPeriod.start)) {
      if (closures++ >= _maxPeriodClosures) break;

      final closingPeriod =
          BudgetCalculator.getPeriodBoundaries(working, periodAnchor);
      final spent = await spentQuery(
        categoryIds: working.categoryIds,
        start: closingPeriod.start,
        end: closingPeriod.end,
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

      periodAnchor = closingPeriod.end.add(const Duration(seconds: 1));
      working = working.copy(
        rolloverAmount: newRollover,
        periodStart: periodAnchor,
        updatedAt: now,
      );
    }

    return working;
  }

  static bool _sameInstant(DateTime a, DateTime b) =>
      a.toUtc().millisecondsSinceEpoch == b.toUtc().millisecondsSinceEpoch;
}
