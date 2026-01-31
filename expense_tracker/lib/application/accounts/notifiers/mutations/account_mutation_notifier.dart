import 'package:expense_tracker/application/accounts/notifiers/accounts_repository_provider.dart';
import 'package:expense_tracker/application/accounts/notifiers/queries/accounts_list_notifier.dart';
import 'package:expense_tracker/application/accounts/notifiers/queries/accounts_with_balance_notifier.dart';
import 'package:expense_tracker/application/transactions/notifiers/queries/total_balance_notifier.dart';
import 'package:expense_tracker/application/transactions/notifiers/queries/transactions_list_notifier.dart';
import 'package:expense_tracker/domain/models/account.dart';
import 'package:expense_tracker/domain/repositories/accounts_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountMutationNotifier extends AsyncNotifier<void> {
  AccountsRepository get _repo => ref.read(accountsRepositoryProvider);

  @override
  Future<void> build() async {}

  Future<Account> addAccount(Account account) async {
    late final Account inserted;

    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      inserted = await _repo.insertAccount(account: account);

      ref.invalidate(accountsListProvider);
      ref.invalidate(accountsWithBalanceProvider);
    });

    return inserted;
  }

  Future<void> updateAccount(Account original, Account modified) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      await _repo.updateAccount(
        accountToEdit: original,
        editedAccount: modified,
      );

      ref.invalidate(accountsListProvider);
      ref.invalidate(accountsWithBalanceProvider);
    });
  }

  Future<void> deleteAccount(Account account) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      await _repo.deleteAccount(account: account);
      ref.invalidate(accountsListProvider);
      ref.invalidate(accountsWithBalanceProvider);
      ref.invalidate(transactionsListProvider);
      ref.invalidate(totalBalanceProvider);
    });
  }
}

final accountMutationProvider =
    AsyncNotifierProvider<AccountMutationNotifier, void>(
  AccountMutationNotifier.new,
);
