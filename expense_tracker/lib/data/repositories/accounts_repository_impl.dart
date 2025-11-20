import 'package:expense_tracker/application/accounts/models/account_with_balance.dart';
import 'package:expense_tracker/domain/models/account.dart';
import 'package:expense_tracker/data/database/database_account_helper.dart';
import 'package:expense_tracker/domain/repositories/accounts_repository.dart';

class AccountsRepositoryImpl implements AccountsRepository {
  final dbHelper = DatabaseAccountHelper.instance;

  @override
  Future<Account> insertAccount({required Account account}) async {
    return dbHelper.insertAccount(account: account);
  }

  @override
  Future<bool> updateAccount(
      {required Account accountToEdit, required Account editedAccount}) async {
    return dbHelper.updateAccount(
      accountToEdit: accountToEdit,
      modifiedAccount: editedAccount,
    );
  }

  @override
  Future<int> deleteAccount({required Account account}) async {
    return dbHelper.deleteAccount(account: account);
  }

  @override
  Future<List<AccountWithBalance>> getAccountsListWithBalance() async {
    return getAccountsListWithBalance();
  }
}
