import 'package:collection/collection.dart';
import 'package:expense_tracker/Helper/Database/database_account_helper.dart';
import 'package:expense_tracker/models/account.dart';
import 'package:expense_tracker/models/transaction.dart';
import 'package:flutter/material.dart';

class AccountProvider with ChangeNotifier {
  List<Account> accountList = [];

  AccountProvider() {
    // getAllAccounts();
  }

  Future getAllAccounts() async {
    accountList = await DatabaseAccountHelper.instance.getAllAccounts();

    notifyListeners();
  }

  Account? getAccountFromId(int id) {
    return accountList.firstWhereOrNull((element) => element.id == id);
  }

  Account? getAccountForTransaction(Transaction transaction) {
    return accountList
        .firstWhereOrNull((element) => element.id == transaction.accountId);
  }

  Future addNewAccount({
    required String name,
    required int colorValue,
    required IconData iconData,
  }) async {
    final newAccount = Account(
      name: name,
      colorValue: colorValue,
      iconData: iconData,
    );

    accountList.add(await DatabaseAccountHelper.instance
        .insertAccount(account: newAccount));

    notifyListeners();
  }

  Future updateAccount({
    required Account accountToEdit,
    required String name,
    required int colorValue,
    required IconData iconData,
  }) async {
    final modifiedAccount = Account(
      id: accountToEdit.id,
      name: name,
      colorValue: colorValue,
      iconData: iconData,
    );

    if (await DatabaseAccountHelper.instance.updateAccount(
        accountToEdit: accountToEdit, modifiedAccount: modifiedAccount)) {
      final accountIndexToModify =
          accountList.indexWhere((element) => element.id == accountToEdit.id);

      if (accountIndexToModify != -1) {
        accountList[accountIndexToModify] = modifiedAccount;
        print('edited');
      }

      notifyListeners();
    }
  }

  /// Deletes the account without affecting the transactions viewed in the current session
  Future<bool> deleteAccount(Account account) async {
    final removedAccountCount =
        await DatabaseAccountHelper.instance.deleteAccount(account: account);

    if (removedAccountCount > 0) {
      accountList.removeWhere((element) => element.id == account.id);

      notifyListeners();

      return true;
    }

    return false;
  }
}
