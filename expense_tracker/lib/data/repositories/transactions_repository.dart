import 'package:expense_tracker/data/database/database_transaction_helper.dart';
import 'package:expense_tracker/application/transactions/models/transaction.dart';

abstract class TransactionsRepository {
  Future<List<Transaction>> getLatestTransactions({int limit = 5});
}

class TransactionsRepositoryImpl implements TransactionsRepository {
  final dbHelper = DatabaseTransactionHelper.instance;

  @override
  Future<List<Transaction>> getLatestTransactions({int limit = 5}) async {
    return dbHelper.getLatestTransactions(limit);
  }
}
