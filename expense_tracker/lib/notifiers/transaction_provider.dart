import 'dart:collection';

import 'package:expense_tracker/Helper/database_transaction_helper.dart';
import 'package:expense_tracker/models/account.dart';
import 'package:expense_tracker/models/category.dart';
import 'package:expense_tracker/models/transaction.dart';
import 'package:flutter/material.dart';

class TransactionProvider with ChangeNotifier {
  List<Transaction> _transactions = [];

  UnmodifiableListView<Transaction> get allTransaction =>
      UnmodifiableListView(_transactions);

  UnmodifiableListView<Transaction> transactionsBetweenDates(
          DateTime startDate, DateTime endDate) =>
      UnmodifiableListView(_transactions.where((element) =>
          element.date.isAfter(startDate) && element.date.isBefore(endDate)));

  TransactionProvider() {
    getAllTransactions();
  }

  addNewTransaction({
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

    _transactions.add(await DatabaseTransactionHelper.instance
        .insertTransaction(transaction: newTransaction));

    notifyListeners();
  }

  Future<bool> deleteTransaction(Transaction transaction) async {
    final removedTransactionCount = await DatabaseTransactionHelper.instance
        .deleteTransaction(transaction: transaction);

    if (removedTransactionCount > 0) {
      _transactions.remove(transaction);

      notifyListeners();

      return true;
    }

    return false;
  }

  getAllTransactions() async {
    _transactions =
        await DatabaseTransactionHelper.instance.getAllTransactions();

    notifyListeners();
  }
}
