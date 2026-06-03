import 'package:expense_tracker/features/budgeting/domain/logic/budget_sync_service.dart';
import 'package:expense_tracker/features/budgeting/domain/models/budget.dart';
import 'package:expense_tracker/features/budgeting/presentation/providers/budget_period_spent_query_provider.dart';
import 'package:expense_tracker/features/budgeting/presentation/providers/budgets_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BudgetsListNotifier extends AsyncNotifier<List<Budget>> {
  @override
  Future<List<Budget>> build() async {
    final budgetsRepository = ref.read(budgetsRepositoryProvider);
    final spentQuery = ref.read(budgetPeriodSpentQueryProvider);
    final budgets = await budgetsRepository.getAllBudgets();
    return BudgetSyncService(budgetsRepository, spentQuery).syncAllBudgets(
      budgets: budgets,
      now: DateTime.now(),
    );
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}

final budgetsListProvider = AsyncNotifierProvider<BudgetsListNotifier, List<Budget>>(
  BudgetsListNotifier.new,
);
