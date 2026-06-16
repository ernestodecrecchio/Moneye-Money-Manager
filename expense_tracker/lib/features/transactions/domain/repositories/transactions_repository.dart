import 'package:expense_tracker/features/accounts/domain/models/account.dart';
import 'package:expense_tracker/features/categories/domain/models/category.dart';
import 'package:expense_tracker/features/transactions/domain/models/transaction.dart';

abstract class TransactionsRepository {
  Future<Transaction> insertTransaction({required Transaction transaction});
  Future<bool> updateTransaction({
    required Transaction transactionToEdit,
    required Transaction editedTransaction,
  });
  Future<int> deleteTransaction({required Transaction transaction});

  Future<int> getTransactionsCount({Category? forCategory, Account? forAccount});

  Future<double> getTotalBalance({
    DateTime? startDate,
    DateTime? endDate,
    Account? forAccount,
  });
  Future<List<Transaction>> getLatestTransactions({int limit = 5});
  Future<List<Transaction>> getTransactions({
    DateTime? startDate,
    DateTime? endDate,
    Account? forAccount,
    Category? forCategory,
    bool? includeIncomes,
    bool? includeExpenses,
    int? limit,
    String? recurringId,
  });

  /// Sum of expense amounts (absolute value) for budget tracking in a period.
  Future<double> sumExpensesForBudgetPeriod({
    required List<int> categoryIds,
    required DateTime start,
    required DateTime end,
    bool allCategories = false,
  });

  /// Sums reportable income and expenses for a date range (all accounts).
  Future<({double income, double expenses})> sumIncomeAndExpensesForPeriod({
    required DateTime start,
    required DateTime end,
  });

  Future<int> deleteTransactionsByCategory({required Category category});
  Future<int> transferTransactions({required Category from, required Category to});

  Future<int> generateRecurringTransactionsUntil(DateTime targetDate);
}
