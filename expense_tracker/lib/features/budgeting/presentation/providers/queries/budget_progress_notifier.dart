import 'package:expense_tracker/features/budgeting/domain/logic/budget_calculator.dart';
import 'package:expense_tracker/features/budgeting/domain/models/budget.dart';
import 'package:expense_tracker/features/budgeting/domain/models/budget_progress.dart';
import 'package:expense_tracker/features/budgeting/presentation/providers/budget_period_spent_query_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BudgetProgressNotifier extends AsyncNotifier<BudgetProgress> {
  final Budget budget;

  BudgetProgressNotifier(this.budget);

  @override
  Future<BudgetProgress> build() async {
    final now = DateTime.now();
    final spentQuery = ref.read(budgetPeriodSpentQueryProvider);
    final period = BudgetCalculator.getPeriodBoundaries(budget, now);
    final spent = await spentQuery(
      categoryIds: budget.categoryIds,
      start: period.start,
      end: period.end,
      allCategories: budget.allCategories,
    );

    return BudgetCalculator.calculateProgress(
      budget: budget,
      spent: spent,
      now: now,
    );
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}

final budgetProgressProvider = AsyncNotifierProvider.family<
    BudgetProgressNotifier, BudgetProgress, Budget>(
  BudgetProgressNotifier.new,
);

/// Shown while [budgetProgressProvider] is loading.
BudgetProgress budgetProgressPlaceholder(Budget budget) {
  final now = DateTime.now();
  final period = BudgetCalculator.getPeriodBoundaries(budget, now);
  return BudgetProgress(
    limit: budget.amount,
    spent: 0,
    carriedOver: budget.rolloverAmount,
    startDate: period.start,
    endDate: period.end,
  );
}
