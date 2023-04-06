import 'package:expense_tracker/Helper/Database/database_transaction_helper.dart';
import 'package:expense_tracker/models/account.dart';
import 'package:expense_tracker/models/category.dart';
import 'package:expense_tracker/models/transaction.dart';
import 'package:expense_tracker/notifiers/account_provider.dart';
import 'package:flutter/material.dart';

class TransactionProvider with ChangeNotifier {
  AccountProvider? accountProvider;

  List<Transaction> transactionList = [];
  List<Transaction> get currentMonthTransactionList {
    final todayDate = DateTime.now();

    return transactionList
        .where((element) =>
            element.date.month == todayDate.month &&
            element.date.year == todayDate.year)
        .toList();
  }

  double get totalBalance {
    return transactionList.fold(
        0, (previousValue, element) => previousValue + element.value);
  }

  double getTotalBanalceUntilDate(DateTime date) {
    double totalBalance = 0;
    transactionList.forEach(
      (transaction) {
        print('analizzo ${transaction.date} vs $date');
        if (transaction.date.isBefore(date)) {
          print('è prima');
          totalBalance += transaction.value;
        }
      },
    );

    return totalBalance;
  }

  TransactionProvider({this.accountProvider}) {
    //getAllTransactions();
  }

  List<Transaction> getTransactionListForAccount(Account account) {
    return transactionList
        .where((element) => element.accountId == account.id)
        .toList();
  }

  Future getAllTransactions() async {
    transactionList =
        await DatabaseTransactionHelper.instance.getAllTransactions();

    notifyListeners();
  }

  Future<Transaction?> addNewTransaction({
    required String title,
    required double value,
    required DateTime date,
    Category? category,
    Account? account,
  }) async {
    Transaction newTransaction = Transaction(
      title: title,
      value: value,
      date: date,
      categoryId: category?.id,
      accountId: account?.id,
    );

    transactionList.add(await DatabaseTransactionHelper.instance
        .insertTransaction(transaction: newTransaction));

    notifyListeners();

    return transactionList.last;
  }

  Future<bool> deleteTransaction(Transaction transaction) async {
    final removedTransactionCount = await DatabaseTransactionHelper.instance
        .deleteTransaction(transaction: transaction);

    if (removedTransactionCount > 0) {
      transactionList.removeWhere((element) => element.id == transaction.id);

      notifyListeners();

      return true;
    }

    return false;
  }

  /// Returns a Map where for each month of the year, there is a sum of all the transactions value
  Map<int, double> getMonthlyBalanceForYear(int year) {
    final Map<int, double> balanceMap = {};

    final currentYearTransactions =
        transactionList.where((element) => element.date.year == year);

    for (var transaction in currentYearTransactions) {
      balanceMap[transaction.date.month] =
          (balanceMap[transaction.date.month] ?? 0) + transaction.value;
    }

    return balanceMap;
  }
}
