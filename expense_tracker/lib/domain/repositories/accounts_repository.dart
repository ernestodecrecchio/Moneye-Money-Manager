import 'package:expense_tracker/application/accounts/models/account_with_balance.dart';
import 'package:expense_tracker/domain/models/account.dart';

abstract class AccountsRepository {
  Future<Account> insertAccount({required Account account});
  Future<bool> updateAccount(
      {required Account accountToEdit, required Account editedAccount});
  Future<int> deleteAccount({required Account account});
  Future<List<AccountWithBalance>> getAccountsListWithBalance();
}
