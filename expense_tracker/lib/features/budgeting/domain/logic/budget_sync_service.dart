import 'package:expense_tracker/features/budgeting/domain/logic/budget_period_rollover_service.dart';
import 'package:expense_tracker/features/budgeting/domain/logic/budget_period_spent_query.dart';
import 'package:expense_tracker/features/budgeting/domain/models/budget.dart';
import 'package:expense_tracker/features/budgeting/domain/repositories/budgets_repository.dart';

/// Syncs budget period state with the database after period transitions.
class BudgetSyncService {
  final BudgetsRepository _budgetsRepository;
  final BudgetPeriodSpentQuery _spentQuery;

  BudgetSyncService(this._budgetsRepository, this._spentQuery);

  Future<Budget> syncBudgetIfNeeded({
    required Budget budget,
    required DateTime now,
  }) async {
    final synced = await BudgetPeriodRolloverService.syncPeriodIfNeeded(
      budget: budget,
      spentQuery: _spentQuery,
      now: now,
    );

    if (synced == budget || synced.id == null) {
      return synced;
    }

    await _budgetsRepository.updateBudget(
      budgetToEdit: budget,
      editedBudget: synced,
    );
    return synced;
  }

  Future<List<Budget>> syncAllBudgets({
    required List<Budget> budgets,
    required DateTime now,
  }) async {
    final result = <Budget>[];
    for (final budget in budgets) {
      result.add(await syncBudgetIfNeeded(budget: budget, now: now));
    }
    return result;
  }
}
