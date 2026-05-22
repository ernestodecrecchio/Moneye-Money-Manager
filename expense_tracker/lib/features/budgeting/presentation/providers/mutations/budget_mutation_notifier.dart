import 'package:expense_tracker/features/budgeting/domain/models/budget.dart';
import 'package:expense_tracker/features/budgeting/domain/repositories/budgets_repository.dart';
import 'package:expense_tracker/features/budgeting/presentation/providers/budgets_repository_provider.dart';
import 'package:expense_tracker/features/budgeting/presentation/providers/queries/budgets_list_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BudgetMutationNotifier extends AsyncNotifier<void> {
  BudgetsRepository get _repo => ref.read(budgetsRepositoryProvider);

  @override
  Future<void> build() async {}

  Future<Budget?> addBudget(Budget budget) async {
    state = const AsyncLoading();
    Budget? inserted;

    state = await AsyncValue.guard(() async {
      inserted = await _repo.insertBudget(budget: budget);
      ref.invalidate(budgetsListProvider);
    });

    return inserted;
  }

  Future<void> updateBudget(Budget original, Budget modified) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final success = await _repo.updateBudget(
        budgetToEdit: original,
        editedBudget: modified,
      );
      if (success) {
        ref.invalidate(budgetsListProvider);
      }
    });
  }

  Future<void> deleteBudget(Budget budget) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final deletedCount = await _repo.deleteBudget(budget: budget);
      if (deletedCount > 0) {
        ref.invalidate(budgetsListProvider);
      }
    });
  }
}

final budgetMutationProvider =
    AsyncNotifierProvider<BudgetMutationNotifier, void>(
  BudgetMutationNotifier.new,
);
