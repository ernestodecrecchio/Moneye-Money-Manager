import 'package:expense_tracker/features/accounts/presentation/providers/queries/accounts_with_balance_notifier.dart';
import 'package:expense_tracker/features/budgeting/presentation/providers/queries/budget_progress_notifier.dart';
import 'package:expense_tracker/features/statistics/presentation/providers/queries/net_worth_trend_notifier.dart';
import 'package:expense_tracker/features/statistics/presentation/providers/queries/overview_kpis_notifier.dart';
import 'package:expense_tracker/core/configuration/analytics_manager.dart';
import 'package:expense_tracker/features/transactions/presentation/providers/queries/transactions_list_notifier.dart';
import 'package:expense_tracker/features/transactions/domain/models/transaction.dart';
import 'package:expense_tracker/features/transactions/presentation/providers/queries/total_balance_notifier.dart';
import 'package:expense_tracker/features/transactions/presentation/providers/transactions_repository_provider.dart';
import 'package:expense_tracker/features/transactions/domain/repositories/transactions_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransactionMutationNotifier extends AsyncNotifier<void> {
  TransactionsRepository get _repo => ref.read(transactionsRepositoryProvider);

  @override
  Future<void> build() async {}

  Future<Transaction?> addTransaction(Transaction transaction) async {
    Transaction? inserted;

    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      inserted = await _repo.insertTransaction(transaction: transaction);

      ref.invalidate(totalBalanceProvider);
      ref.invalidate(transactionsListProvider);
      ref.invalidate(accountsWithBalanceProvider);
      ref.invalidate(budgetProgressProvider);
      ref.invalidate(overviewKpisProvider);
      ref.invalidate(netWorthTrendProvider);
    });

    await AnalyticsManager.logTransactionAdded();

    return inserted;
  }

  Future<void> updateTransaction(
      Transaction original, Transaction modified) async {
    state = AsyncLoading();

    state = await AsyncValue.guard(() async {
      await _repo.updateTransaction(
          transactionToEdit: original, editedTransaction: modified);

      ref.invalidate(totalBalanceProvider);
      ref.invalidate(transactionsListProvider);
      ref.invalidate(accountsWithBalanceProvider);
      ref.invalidate(budgetProgressProvider);
      ref.invalidate(overviewKpisProvider);
      ref.invalidate(netWorthTrendProvider);
    });

    await AnalyticsManager.logTransactionUpdated();
  }

  Future<void> deleteTransaction(Transaction transaction) async {
    state = AsyncLoading();

    state = await AsyncValue.guard(() async {
      final removedTransactionCount =
          await _repo.deleteTransaction(transaction: transaction);

      if (removedTransactionCount > 0) {
        ref.invalidate(totalBalanceProvider);
        ref.invalidate(transactionsListProvider);
        ref.invalidate(accountsWithBalanceProvider);
        ref.invalidate(budgetProgressProvider);
        ref.invalidate(overviewKpisProvider);
        ref.invalidate(netWorthTrendProvider);
      }
    });

    await AnalyticsManager.logTransactionDeleted();
  }
}

final transactionMutationProvider =
    AsyncNotifierProvider<TransactionMutationNotifier, void>(
  TransactionMutationNotifier.new,
);
