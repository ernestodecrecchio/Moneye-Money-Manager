import 'package:expense_tracker/features/budgeting/domain/logic/budget_calculator.dart';
import 'package:expense_tracker/features/budgeting/domain/logic/budget_sync_service.dart';
import 'package:expense_tracker/features/budgeting/domain/models/budget.dart';
import 'package:expense_tracker/features/budgeting/domain/models/budget_progress.dart';
import 'package:expense_tracker/features/budgeting/presentation/providers/budget_period_spent_query_provider.dart';
import 'package:expense_tracker/features/budgeting/presentation/providers/budgets_repository_provider.dart';
import 'package:expense_tracker/features/budgeting/presentation/providers/queries/budgets_list_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Progress for a [Budget]: syncs period rollover, then loads [spent] via SQL.
final budgetProgressProvider =
    FutureProvider.family<BudgetProgress, Budget>((ref, budget) async {
  final now = DateTime.now();
  final spentQuery = ref.read(budgetPeriodSpentQueryProvider);
  final syncService = BudgetSyncService(
    ref.read(budgetsRepositoryProvider),
    spentQuery,
  );

  final synced = await syncService.syncBudgetIfNeeded(budget: budget, now: now);
  if (synced != budget) {
    ref.invalidate(budgetsListProvider);
  }

  final period = BudgetCalculator.getPeriodBoundaries(synced, now);
  final spent = await spentQuery(
    categoryIds: synced.categoryIds,
    start: period.start,
    end: period.end,
  );

  return BudgetCalculator.calculateProgress(
    budget: synced,
    spent: spent,
    now: now,
  );
});

/// Shown while [budgetProgressProvider] is loading.
BudgetProgress budgetProgressPlaceholder(Budget budget) {
  final now = DateTime.now();
  return BudgetProgress(
    limit: budget.amount,
    spent: 0,
    carriedOver: budget.rolloverAmount,
    startDate: now,
    endDate: now,
  );
}
