import 'package:expense_tracker/Helper/database_transaction_helper.dart';
import 'package:expense_tracker/models/account.dart';
import 'package:expense_tracker/models/category.dart';
import 'package:expense_tracker/models/transaction.dart';
import 'package:flutter/material.dart';

class TransactionProvider with ChangeNotifier {
  List<Transaction> transactionList = [];

  Future getAllTransactions() async {
    transactionList =
        await DatabaseTransactionHelper.instance.readAllTransactions();

    notifyListeners();
  }

  Future getTransactionsForDate(DateTime date) async {
    transactionList = await DatabaseTransactionHelper.instance
        .getTransactionsForDate(date: date);

    notifyListeners();
  }

  Future addNewTransaction({
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
        accountId: account?.id);

    transactionList.add(await DatabaseTransactionHelper.instance
        .insertTransaction(transaction: newTransaction));

    notifyListeners();
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
}
