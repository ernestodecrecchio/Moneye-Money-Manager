import 'package:expense_tracker/domain/models/account.dart';
import 'package:expense_tracker/domain/models/transaction.dart';

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
  Future<List<Transaction>> getTransactions({
    DateTime? startDate,
    DateTime? endDate,
    Account? forAccount,
    bool? includeIncomes,
    bool? includeExpenses,
    int? limit,
  });
}
