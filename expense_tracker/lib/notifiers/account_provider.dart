import 'package:expense_tracker/Helper/Database/database_account_helper.dart';
import 'package:expense_tracker/models/account.dart';
import 'package:flutter/material.dart';

class AccountProvider with ChangeNotifier {
  Future<List<Account>> getAllAccounts() async {
    return await DatabaseAccountHelper.instance.getAllAccounts();
  }

  Future addNewAccount({required String name}) async {
    final newAccount = Account(name: name);

    return await DatabaseAccountHelper.instance
        .insertAccount(account: newAccount);
  }

  Future<bool> deleteAccount(Account account) async {
    final removedAccountCount =
        await DatabaseAccountHelper.instance.deleteAccount(account: account);

    if (removedAccountCount > 0) {
      return true;
    }

    return false;
  }

  Future<List<Map<String, dynamic>>> getAllAccountsWithBalance() async {
    return await DatabaseAccountHelper.instance.getAllAccountsWithBalance();
  }

  Future<Account?> getAccountFromId(int id) async {
    return await DatabaseAccountHelper.instance.getAccountFromId(id);
  }
}
