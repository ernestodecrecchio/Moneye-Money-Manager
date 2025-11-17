import 'package:expense_tracker/data/database/database_transaction_helper.dart';
import 'package:expense_tracker/application/transactions/models/transaction.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransactionNotifier extends Notifier<List<Transaction>> {
  @override
  List<Transaction> build() {
    return [];
  }

  Future getTransactionsFromDb() async {
    state = await DatabaseTransactionHelper.instance.getAllTransactions();
  }

  /// Returns a Map where for each month of the year, there is a sum of all the transactions amount
  Map<int, double> getMonthlyBalanceForYear(int year) {
    final Map<int, double> balanceMap = {};

    final currentYearTransactions =
        state.where((element) => element.date.year == year);

    for (var transaction in currentYearTransactions) {
      balanceMap[transaction.date.month] =
          (balanceMap[transaction.date.month] ?? 0) + transaction.amount;
    }

    return balanceMap;
  }
}

final transactionProvider =
    NotifierProvider<TransactionNotifier, List<Transaction>>(() {
  return TransactionNotifier();
});
