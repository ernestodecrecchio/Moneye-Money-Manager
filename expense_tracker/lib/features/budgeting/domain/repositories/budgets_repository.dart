import 'package:expense_tracker/features/budgeting/domain/models/budget.dart';

abstract class BudgetsRepository {
  Future<Budget> insertBudget({required Budget budget});
  Future<bool> updateBudget({
    required Budget budgetToEdit,
    required Budget editedBudget,
  });
  Future<int> deleteBudget({required Budget budget});
  Future<List<Budget>> getAllBudgets();
  Future<Budget?> getBudgetById(int id);
}
