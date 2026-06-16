import 'package:expense_tracker/features/accounts/domain/models/account.dart';
import 'package:expense_tracker/features/categories/domain/models/category.dart';
import 'package:expense_tracker/features/transactions/data/database/database_transaction_helper.dart';
import 'package:expense_tracker/features/transactions/domain/models/transaction.dart';
import 'package:expense_tracker/features/transactions/domain/repositories/transactions_repository.dart';

class TransactionsRepositoryImpl implements TransactionsRepository {
  final dbHelper = DatabaseTransactionHelper.instance;

  @override
  Future<Transaction> insertTransaction(
      {required Transaction transaction}) async {
    return dbHelper.insertTransaction(transaction: transaction);
  }

  @override
  Future<bool> updateTransaction(
      {required Transaction transactionToEdit,
      required Transaction editedTransaction}) async {
    return dbHelper.updateTransaction(
      transactionToEdit: transactionToEdit,
      modifiedTransaction: editedTransaction,
    );
  }

  @override
  Future<int> deleteTransaction({required Transaction transaction}) async {
    return dbHelper.deleteTransaction(transaction: transaction);
  }

  @override
  Future<int> getTransactionsCount(
      {Category? forCategory, Account? forAccount}) async {
    return dbHelper.getTransactionsCount(forCategory, forAccount);
  }

  @override
  Future<double> getTotalBalance({
    DateTime? startDate,
    DateTime? endDate,
    Account? forAccount,
  }) async {
    return dbHelper.getTotalBalance(startDate, endDate, forAccount);
  }

  @override
  Future<List<Transaction>> getLatestTransactions({int limit = 5}) async {
    return dbHelper.getLatestTransactions(limit);
  }

  @override
  Future<double> sumExpensesForBudgetPeriod({
    required List<int> categoryIds,
    required DateTime start,
    required DateTime end,
    bool allCategories = false,
  }) async {
    return dbHelper.sumExpensesForBudgetPeriod(
      categoryIds: categoryIds,
      start: start,
      end: end,
      allCategories: allCategories,
    );
  }

  @override
  Future<({double income, double expenses})> sumIncomeAndExpensesForPeriod({
    required DateTime start,
    required DateTime end,
  }) async {
    return dbHelper.sumIncomeAndExpensesForPeriod(
      start: start,
      end: end,
    );
  }

  @override
  Future<double> getGlobalNetWorthBeforePeriod(DateTime periodStart) async {
    return dbHelper.getGlobalNetWorthBeforePeriod(periodStart);
  }

  @override
  Future<Map<DateTime, double>> getDailyTransactionChangesInPeriod({
    required DateTime start,
    required DateTime end,
  }) async {
    return dbHelper.getDailyTransactionChangesInPeriod(
      start: start,
      end: end,
    );
  }

  @override
  Future<List<({DateTime date, double income, double expenses})>>
      getDailyIncomeAndExpensesInPeriod({
    required DateTime start,
    required DateTime end,
  }) async {
    return dbHelper.getDailyIncomeAndExpensesInPeriod(
      start: start,
      end: end,
    );
  }

  @override
  Future<List<({int? categoryId, double amount})>> getExpensesByCategoryInPeriod({
    required DateTime start,
    required DateTime end,
  }) async {
    return dbHelper.getExpensesByCategoryInPeriod(
      start: start,
      end: end,
    );
  }

  @override
  Future<List<({int? categoryId, double amount})>> getIncomeByCategoryInPeriod({
    required DateTime start,
    required DateTime end,
  }) async {
    return dbHelper.getIncomeByCategoryInPeriod(
      start: start,
      end: end,
    );
  }

  @override
  Future<List<({int? categoryId, DateTime monthStart, double amount})>>
      getExpensesByCategoryAndMonthInPeriod({
    required DateTime start,
    required DateTime end,
  }) async {
    return dbHelper.getExpensesByCategoryAndMonthInPeriod(
      start: start,
      end: end,
    );
  }

  @override
  Future<List<Transaction>> getTransactions({
    DateTime? startDate,
    DateTime? endDate,
    Account? forAccount,
    Category? forCategory,
    bool? includeIncomes,
    bool? includeExpenses,
    int? limit,
    String? recurringId,
  }) async {
    return dbHelper.getTransactions(
      startDate,
      endDate,
      forAccount,
      forCategory,
      includeIncomes,
      includeExpenses,
      limit,
      recurringId,
    );
  }

  @override
  Future<int> deleteTransactionsByCategory({required Category category}) async {
    return dbHelper.deleteTransactionsByCategory(category);
  }

  @override
  Future<int> transferTransactions(
      {required Category from, required Category to}) async {
    return dbHelper.transferTransactions(from, to);
  }

  @override
  Future<int> generateRecurringTransactionsUntil(DateTime targetDate) async {
    return dbHelper.generateRecurringTransactionsUntil(targetDate);
  }
}
