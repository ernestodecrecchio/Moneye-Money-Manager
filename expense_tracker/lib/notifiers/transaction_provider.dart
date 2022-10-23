import 'package:expense_tracker/Helper/Database/database_transaction_helper.dart';
import 'package:expense_tracker/models/account.dart';
import 'package:expense_tracker/models/category.dart';
import 'package:expense_tracker/models/transaction.dart';
import 'package:flutter/material.dart';

class TransactionProvider with ChangeNotifier {
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
        accountId: account?.id);

    return await DatabaseTransactionHelper.instance
        .insertTransaction(transaction: newTransaction);
  }

  Future<bool> deleteTransaction(Transaction transaction) async {
    final removedTransactionCount = await DatabaseTransactionHelper.instance
        .deleteTransaction(transaction: transaction);

    if (removedTransactionCount > 0) {
      return true;
    }

    return false;
  }

  Future<List<Transaction>> getMonthlyBalance() async {
    final todayDate = DateTime.now();

    final firstDayOfMonth = DateTime(todayDate.year, todayDate.month, 1);
    final lastDayOfMonth = (todayDate.month < 12)
        ? DateTime(todayDate.year, todayDate.month + 1, 0)
        : DateTime(todayDate.year + 1, 1, 0);

    return await DatabaseTransactionHelper.instance.getTransactionsBetweenDates(
        startDate: firstDayOfMonth, endDate: lastDayOfMonth);
  }

  Future<List<Transaction>> getLastTransactions(int limit) async {
    return await DatabaseTransactionHelper.instance.getLastTransactions(limit);
  }
}
