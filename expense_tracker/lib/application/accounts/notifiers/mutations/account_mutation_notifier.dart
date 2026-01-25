import 'package:expense_tracker/application/accounts/notifiers/accounts_repository_provider.dart';
import 'package:expense_tracker/application/accounts/notifiers/queries/accounts_list_notifier.dart';
import 'package:expense_tracker/application/accounts/notifiers/queries/accounts_with_balance_notifier.dart';
import 'package:expense_tracker/application/transactions/notifiers/queries/total_balance_notifier.dart';
import 'package:expense_tracker/application/transactions/notifiers/queries/transactions_list_notifier.dart';
import 'package:expense_tracker/domain/models/account.dart';
import 'package:expense_tracker/domain/repositories/accounts_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountMutationNotifier extends Notifier<void> {
  AccountsRepository get _repo => ref.read(accountsRepositoryProvider);

  @override
  void build() {
    return;
  }

  Future<Account> add(Account account) async {
    final inserted = await _repo.insertAccount(account: account);
    ref.invalidate(accountsListProvider);
    ref.invalidate(accountsWithBalanceProvider);
    return inserted;
  }

  Future<void> update(Account original, Account modified) async {
    await _repo.updateAccount(accountToEdit: original, editedAccount: modified);
    ref.invalidate(accountsListProvider);
    ref.invalidate(accountsWithBalanceProvider);
  }

  Future<void> delete(Account account) async {
    await _repo.deleteAccount(account: account);
    ref.invalidate(accountsListProvider);
    ref.invalidate(accountsWithBalanceProvider);
    ref.invalidate(transactionsListProvider);
    ref.invalidate(totalBalanceProvider);
  }
}

final accountMutationProvider = NotifierProvider<AccountMutationNotifier, void>(
  AccountMutationNotifier.new,
);
