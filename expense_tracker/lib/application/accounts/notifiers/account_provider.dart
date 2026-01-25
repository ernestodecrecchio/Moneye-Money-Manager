import 'package:collection/collection.dart';
import 'package:expense_tracker/application/transactions/notifiers/mutations/transaction_mutation_notifier.dart';
import 'package:expense_tracker/data/database/database_account_helper.dart';
import 'package:expense_tracker/l10n/app_localizations.dart';
import 'package:expense_tracker/main.dart';
import 'package:expense_tracker/domain/models/account.dart';
import 'package:expense_tracker/domain/models/transaction.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Legacy notifier responsible for managing the list of accounts.
///
/// [!] Note: This notifier combines both state management and data operations (mutations).
/// Modern features should use dedicated repository-based notifiers in subfolders.
class AccountNotifier extends Notifier<List<Account>> {
  @override
  List<Account> build() {
    return [];
  }

  /// Returns an [Account] by its ID from the current state.
  Account? getAccountFromId(int id) {
    return state.firstWhereOrNull((element) => element.id == id);
  }

  /// Returns the [Account] associated with a given [Transaction].
  Account? getAccountForTransaction(Transaction transaction) {
    return state
        .firstWhereOrNull((element) => element.id == transaction.accountId);
  }

  /// Adds a new account and optionally an initial balance transaction.
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

  /// Persists a new [Account] to the database and updates the state.
  Future addNewAccount({required Account account}) async {
    final addedAccount =
        await DatabaseAccountHelper.instance.insertAccount(account: account);

    state = [...state, addedAccount];
  }

  /// Updates an existing [Account] and refreshes the state.
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

  /// Deletes an [Account] from the database and state.
  /// Note: Transactions associated with the account stay in the session but lose their reference.
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

/// Provider for the [AccountNotifier], managing the list of user accounts.
final accountProvider = NotifierProvider<AccountNotifier, List<Account>>(() {
  return AccountNotifier();
});
