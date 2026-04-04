import 'package:expense_tracker/features/accounts/domain/models/account.dart';
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
  Future<List<Transaction>> getTransactions({
    DateTime? startDate,
    DateTime? endDate,
    Account? forAccount,
    int? categoryId,
    bool? includeIncomes,
    bool? includeExpenses,
    int? limit,
    String? recurringId,
  }) async {
    return dbHelper.getTransactions(
      startDate,
      endDate,
      forAccount,
      categoryId,
      includeIncomes,
      includeExpenses,
      limit,
      recurringId,
    );
  }

  @override
  Future<int> generateRecurringTransactionsUntil(DateTime targetDate) async {
    return dbHelper.generateRecurringTransactionsUntil(targetDate);
  }
}
