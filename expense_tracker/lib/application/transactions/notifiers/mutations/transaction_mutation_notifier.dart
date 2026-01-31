import 'package:expense_tracker/application/accounts/notifiers/queries/accounts_with_balance_notifier.dart';
import 'package:expense_tracker/application/transactions/notifiers/queries/transactions_list_notifier.dart';
import 'package:expense_tracker/domain/models/transaction.dart';
import 'package:expense_tracker/application/transactions/notifiers/queries/total_balance_notifier.dart';
import 'package:expense_tracker/application/transactions/notifiers/transactions_repository_provider.dart';
import 'package:expense_tracker/domain/repositories/transactions_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransactionMutationNotifier extends AsyncNotifier<void> {
  TransactionsRepository get _repo => ref.read(transactionsRepositoryProvider);

  @override
  Future<void> build() async {}

  Future<Transaction> addTransaction(Transaction transaction) async {
    late final Transaction inserted;

    state = AsyncLoading();

    state = await AsyncValue.guard(() async {
      inserted = await _repo.insertTransaction(transaction: transaction);

      ref.invalidate(totalBalanceProvider(const TotalBalanceParams()));
      ref.invalidate(transactionsListProvider);
      ref.invalidate(accountsWithBalanceProvider);
    });

    return inserted;
  }

  Future<void> updateTransaction(
      Transaction original, Transaction modified) async {
    state = AsyncLoading();

    state = await AsyncValue.guard(() async {
      await _repo.updateTransaction(
          transactionToEdit: original, editedTransaction: modified);

      ref.invalidate(totalBalanceProvider(const TotalBalanceParams()));
      ref.invalidate(transactionsListProvider);
      ref.invalidate(accountsWithBalanceProvider);
    });
  }

  Future<void> deleteTransaction(Transaction transaction) async {
    state = AsyncLoading();

    state = await AsyncValue.guard(() async {
      final removedTransactionCount =
          await _repo.deleteTransaction(transaction: transaction);

      if (removedTransactionCount > 0) {
        ref.invalidate(totalBalanceProvider(const TotalBalanceParams()));
        ref.invalidate(transactionsListProvider);
        ref.invalidate(accountsWithBalanceProvider);
      }
    });
  }
}

final transactionMutationProvider =
    AsyncNotifierProvider<TransactionMutationNotifier, void>(
  TransactionMutationNotifier.new,
);
