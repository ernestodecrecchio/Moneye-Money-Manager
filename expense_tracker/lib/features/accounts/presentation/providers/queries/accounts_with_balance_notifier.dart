import 'package:expense_tracker/features/accounts/domain/models/account_with_balance.dart';
import 'package:expense_tracker/features/accounts/presentation/providers/accounts_repository_provider.dart';
import 'package:expense_tracker/core/presentation/providers/app_localizations_provider.dart';
import 'package:expense_tracker/features/accounts/domain/repositories/accounts_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountsWithBalanceNotifier
    extends AsyncNotifier<List<AccountWithBalance>> {
  AccountsRepository get _repo => ref.read(accountsRepositoryProvider);

  @override
  Future<List<AccountWithBalance>> build() {
    final appLocalizations = ref.watch(appLocalizationsProvider);

    return _repo.getAccountsListWithBalance(
      otherAccountName: appLocalizations.other,
    );
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}

final accountsWithBalanceProvider = AsyncNotifierProvider<
    AccountsWithBalanceNotifier, List<AccountWithBalance>>(
  AccountsWithBalanceNotifier.new,
);
