import 'package:collection/collection.dart';
import 'package:expense_tracker/Database/database_account_helper.dart';
import 'package:expense_tracker/Database/database_transaction_helper.dart';
import 'package:expense_tracker/models/account.dart';
import 'package:expense_tracker/models/transaction.dart';
import 'package:expense_tracker/notifiers/transaction_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountNotifier extends Notifier<List<Account>> {
  @override
  List<Account> build() {
    return [];
  }

  Future getAccountsFromDb() async {
    state = await DatabaseAccountHelper.instance.getAllAccounts();
  }

  Account? getAccountFromId(int id) {
    return state.firstWhereOrNull((element) => element.id == id);
  }

  Account? getAccountForTransaction(Transaction transaction) {
    return state
        .firstWhereOrNull((element) => element.id == transaction.accountId);
  }

  Future addNewAccountByParameters({
    required String name,
    String? description,
    required int? colorValue,
    required String? iconPath,
    double? initialAmount,
  }) async {
    final newAccount = Account(
      name: name,
      description: description,
      colorValue: colorValue,
      iconPath: iconPath,
    );
    final addedAccount =
        await DatabaseAccountHelper.instance.insertAccount(account: newAccount);

    if (initialAmount != null) {
      final newTransaction = Transaction(
        accountId: addedAccount.id,
        title: "Initial amount",
        value: initialAmount,
        date: DateTime.now(),
      );

      ref
          .read(transactionProvider.notifier)
          .addTransaction(transaction: newTransaction);
    }

    state = [...state, addedAccount];
  }

  Future addNewAccount({required Account account}) async {
    final addedAccount =
        await DatabaseAccountHelper.instance.insertAccount(account: account);

    state = [...state, addedAccount];
  }

  Future updateAccount({
    required Account accountToEdit,
    required String name,
    String? description,
    required int? colorValue,
    required String? iconPath,
  }) async {
    final modifiedAccount = Account(
      id: accountToEdit.id,
      name: name,
      description: description,
      colorValue: colorValue,
      iconPath: iconPath,
    );

    if (await DatabaseAccountHelper.instance.updateAccount(
        accountToEdit: accountToEdit, modifiedAccount: modifiedAccount)) {
      final accountIndexToModify =
          state.indexWhere((element) => element.id == accountToEdit.id);

      if (accountIndexToModify != -1) {
        final tempList = List<Account>.of(state);
        tempList[accountIndexToModify] = modifiedAccount;

        state = tempList;
      }
    }
  }

  /// Deletes the account without affecting the transactions viewed in the current session
  Future<bool> deleteAccount(Account account) async {
    final removedAccountCount =
        await DatabaseAccountHelper.instance.deleteAccount(account: account);

    if (removedAccountCount > 0) {
      final tempList = List<Account>.of(state);
      tempList.removeWhere((element) => element.id == account.id);

      state = tempList;

      return true;
    }

    return false;
  }

  /// Deletes the account affecting the transactions viewed in the current session
  Future<bool> deleteAccountCentral(Account account) async {
    final isAccountDeleted = await deleteAccount(account);

    if (isAccountDeleted) {
      final transactionList = ref.read(transactionProvider);

      for (var transaction in transactionList) {
        if (transaction.accountId == account.id) {
          transaction.accountId = null;
        }
      }

      return true;
    }

    return false;
  }
}

final accountProvider = NotifierProvider<AccountNotifier, List<Account>>(() {
  return AccountNotifier();
});
