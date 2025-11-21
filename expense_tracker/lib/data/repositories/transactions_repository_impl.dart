import 'package:expense_tracker/domain/models/account.dart';
import 'package:expense_tracker/data/database/database_transaction_helper.dart';
import 'package:expense_tracker/domain/models/transaction.dart';
import 'package:expense_tracker/domain/repositories/transactions_repository.dart';

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
    bool? includeIncomes,
    bool? includeExpenses,
    int? limit,
  }) async {
    return dbHelper.getTransactions(
      startDate,
      endDate,
      forAccount,
      includeIncomes,
      includeExpenses,
      limit,
    );
  }

  /// Returns a Map where for each month of the year, there is a sum of all the transactions amount
  /* @override
  Future<Map<int, double>> getMonthlyBalanceForYear({required int year}) async {
    return dbHelper.getMonthlyBalanceForYear(year);
  }*/
}
