import 'package:expense_tracker/models/account.dart';
import 'package:expense_tracker/models/category.dart';
import 'package:expense_tracker/notifiers/account_provider.dart';
import 'package:expense_tracker/notifiers/category_provider.dart';
import 'package:expense_tracker/notifiers/transaction_provider.dart';
import 'package:flutter/material.dart';

class CentralProvider with ChangeNotifier {
  TransactionProvider? transactionProvider;
  AccountProvider? accountProvider;
  CategoryProvider? categoryProvider;

  CentralProvider({
    this.transactionProvider,
    this.accountProvider,
    this.categoryProvider,
  });

  /// Deletes the account affecting the transactions viewed in the current session
  Future<bool> deleteAccount(Account account) async {
    if (accountProvider != null &&
        await accountProvider!.deleteAccount(account)) {
      transactionProvider?.transactionList.forEach(
        (transaction) {
          if (transaction.accountId == account.id) {
            transaction.accountId = null;
          }
        },
      );

      notifyListeners();

      return true;
    }

    return false;
  }

  /// Deletes the category affecting the transactions viewed in the current session
  Future<bool> deleteCategory(Category category) async {
    if (categoryProvider != null &&
        await categoryProvider!.deleteCategory(category)) {
      transactionProvider?.transactionList.forEach(
        (transaction) {
          if (transaction.categoryId == category.id) {
            transaction.categoryId = null;
          }
        },
      );

      notifyListeners();

      return true;
    }

    return false;
  }
}
