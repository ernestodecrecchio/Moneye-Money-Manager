import 'package:expense_tracker/features/accounts/presentation/providers/accounts_repository_provider.dart';
import 'package:expense_tracker/features/accounts/domain/models/account.dart';
import 'package:expense_tracker/features/accounts/domain/repositories/accounts_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountsListNotifier extends AsyncNotifier<List<Account>> {
  AccountsRepository get _repo => ref.read(accountsRepositoryProvider);

  @override
  Future<List<Account>> build() async {
    return _repo.getAccounts();
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}

final accountsListProvider =
    AsyncNotifierProvider<AccountsListNotifier, List<Account>>(
  AccountsListNotifier.new,
);
