import 'package:expense_tracker/application/transactions/models/account.dart';
import 'package:expense_tracker/data/database/database_transaction_helper.dart';
import 'package:expense_tracker/application/transactions/models/transaction.dart';

abstract class TransactionsRepository {
  Future<Transaction> insertTransaction({required Transaction transaction});
  Future<bool> updateTransaction({
    required Transaction transactionToEdit,
    required Transaction editedTransaction,
  });
  Future<int> deleteTransaction({required Transaction transaction});

  Future<double> getTotalBalance({
    DateTime? startDate,
    DateTime? endDate,
    Account? forAccount,
  });
  Future<List<Transaction>> getLatestTransactions({int limit = 5});
}

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
}
