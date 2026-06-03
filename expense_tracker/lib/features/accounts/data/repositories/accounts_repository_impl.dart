import 'package:expense_tracker/features/accounts/domain/models/account_with_balance.dart';
import 'package:expense_tracker/features/accounts/domain/models/account.dart';
import 'package:expense_tracker/features/accounts/data/database/database_account_helper.dart';
import 'package:expense_tracker/features/accounts/domain/repositories/accounts_repository.dart';
import 'package:expense_tracker/features/transactions/data/database/database_transaction_helper.dart';

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
  Future<List<Account>> getAccounts() async {
    return dbHelper.getAllAccounts();
  }

  @override
  Future<List<AccountWithBalance>> getAccountsListWithBalance(
      {String? otherAccountName}) async {
    return dbHelper.getAllAccountsWithBalance(
        otherAccountName: otherAccountName);
  }

  @override
  Future<bool> rebalanceAccount({
    required Account account,
    required double realBalance,
  }) async {
    if (account.id == null) return false;

    final transactionSum = await DatabaseTransactionHelper.instance
        .getTransactionSum(null, null, account);

    final displayedBalance = transactionSum + account.rebalanceOffset;
    final newOffset =
        account.rebalanceOffset + (realBalance - displayedBalance);

    return dbHelper.updateRebalanceOffset(
      accountId: account.id!,
      rebalanceOffset: newOffset,
    );
  }
}
