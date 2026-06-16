import 'package:expense_tracker/core/utils/double_helper.dart';
import 'package:expense_tracker/features/accounts/domain/models/account.dart';
import 'package:expense_tracker/features/statistics/domain/models/account_breakdown_entry.dart';
import 'package:expense_tracker/features/statistics/domain/models/category_account_breakdown_series.dart';

class CategoryAccountBreakdownCalculator {
  const CategoryAccountBreakdownCalculator._();

  static CategoryAccountBreakdownSeries build({
    required List<({int? accountId, double amount})> records,
    required List<Account> accounts,
    required Account uncategorizedAccount,
  }) {
    final accountById = {
      for (final account in accounts)
        if (account.id != null) account.id!: account,
    };

    final totalsByAccount = <Account, double>{};

    for (final record in records) {
      if (record.amount <= 0) {
        continue;
      }

      final account = _resolveAccount(
        accountId: record.accountId,
        accountById: accountById,
        uncategorizedAccount: uncategorizedAccount,
      );

      totalsByAccount[account] =
          ((totalsByAccount[account] ?? 0) + record.amount).withPrecision(2);
    }

    final totalAmount = totalsByAccount.values
        .fold<double>(0, (sum, amount) => sum + amount)
        .withPrecision(2);

    final entries = totalsByAccount.entries
        .map(
          (entry) => AccountBreakdownEntry(
            account: entry.key,
            amount: entry.value,
            percentage: totalAmount > 0
                ? (entry.value / totalAmount * 100).withPrecision(1)
                : 0,
          ),
        )
        .toList()
      ..sort((left, right) => right.amount.compareTo(left.amount));

    return CategoryAccountBreakdownSeries(entries: entries);
  }

  static Account _resolveAccount({
    required int? accountId,
    required Map<int, Account> accountById,
    required Account uncategorizedAccount,
  }) {
    if (accountId == null) {
      return uncategorizedAccount;
    }

    return accountById[accountId] ??
        Account(
          id: accountId,
          name: uncategorizedAccount.name,
          colorValue: uncategorizedAccount.colorValue,
          iconPath: uncategorizedAccount.iconPath,
          isOtherAccount: true,
        );
  }
}
