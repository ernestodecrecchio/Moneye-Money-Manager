import 'package:expense_tracker/Helper/database_transaction_helper.dart';
import 'package:expense_tracker/models/transaction.dart';
import 'package:flutter/material.dart';

class TransactionProvider with ChangeNotifier {
  List<Transaction> transactionList = [];

  Future getAllTransactions() async {
    transactionList =
        await DatabaseTransactionHelper.instance.readAllTransactions();

    notifyListeners();
  }

  Future addNewTransaction(Transaction newTransaction) async {
    transactionList.add(await DatabaseTransactionHelper.instance
        .insertTransaction(transaction: newTransaction));

    notifyListeners();
  }
}
