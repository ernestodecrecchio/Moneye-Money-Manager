import 'package:expense_tracker/features/budgeting/domain/logic/budget_period_spent_query.dart';
import 'package:expense_tracker/features/transactions/presentation/providers/transactions_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final budgetPeriodSpentQueryProvider = Provider<BudgetPeriodSpentQuery>((ref) {
  final repository = ref.watch(transactionsRepositoryProvider);
  return ({
    required List<int> categoryIds,
    required DateTime start,
    required DateTime end,
    required bool allCategories,
  }) {
    return repository.sumExpensesForBudgetPeriod(
      categoryIds: categoryIds,
      start: start,
      end: end,
      allCategories: allCategories,
    );
  };
});
