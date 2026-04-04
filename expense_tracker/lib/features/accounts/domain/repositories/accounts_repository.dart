import 'package:expense_tracker/features/accounts/domain/models/account_with_balance.dart';
import 'package:expense_tracker/features/accounts/domain/models/account.dart';

abstract class AccountsRepository {
  Future<Account> insertAccount({required Account account});
  Future<bool> updateAccount({
    required Account accountToEdit,
    required Account editedAccount,
  });
  Future<int> deleteAccount({required Account account});

  Future<List<Account>> getAccounts();
  Future<List<AccountWithBalance>> getAccountsListWithBalance(
      {String? otherAccountName});
}
