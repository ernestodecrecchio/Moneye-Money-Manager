import 'package:collection/collection.dart';
import 'package:expense_tracker/application/transactions/notifiers/mutations/transaction_mutation_notifier.dart';
import 'package:expense_tracker/data/database/database_account_helper.dart';
import 'package:expense_tracker/l10n/app_localizations.dart';
import 'package:expense_tracker/main.dart';
import 'package:expense_tracker/domain/models/account.dart';
import 'package:expense_tracker/domain/models/transaction.dart';
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
      final currentContext = navigatorKey.currentContext;
      String initialBalanceTitle = "Inital balance";

      if (currentContext != null && currentContext.mounted) {
        initialBalanceTitle =
            AppLocalizations.of(currentContext)!.initialBalance;
      }

      final newTransaction = Transaction(
        accountId: addedAccount.id,
        title: initialBalanceTitle,
        amount: initialAmount,
        date: DateTime.now(),
        includeInReports: false,
        isHidden: false,
      );

      ref.read(transactionMutationProvider.notifier).add(newTransaction);
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
}

final accountProvider = NotifierProvider<AccountNotifier, List<Account>>(() {
  return AccountNotifier();
});
