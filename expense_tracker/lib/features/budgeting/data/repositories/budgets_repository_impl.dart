import 'package:expense_tracker/features/budgeting/data/database/database_budget_helper.dart';
import 'package:expense_tracker/features/budgeting/domain/models/budget.dart';
import 'package:expense_tracker/features/budgeting/domain/repositories/budgets_repository.dart';

class BudgetsRepositoryImpl implements BudgetsRepository {
  final dbHelper = DatabaseBudgetHelper.instance;

  @override
  Future<Budget> insertBudget({required Budget budget}) async {
    return dbHelper.insertBudget(budget: budget);
  }

  @override
  Future<bool> updateBudget(
      {required Budget budgetToEdit, required Budget editedBudget}) async {
    return dbHelper.updateBudget(
      budgetToEdit: budgetToEdit,
      modifiedBudget: editedBudget,
    );
  }

  @override
  Future<int> deleteBudget({required Budget budget}) async {
    return dbHelper.deleteBudget(budget: budget);
  }

  @override
  Future<List<Budget>> getAllBudgets() async {
    return dbHelper.getAllBudgets();
  }

  @override
  Future<Budget?> getBudgetById(int id) async {
    return dbHelper.getBudgetById(id);
  }
}
