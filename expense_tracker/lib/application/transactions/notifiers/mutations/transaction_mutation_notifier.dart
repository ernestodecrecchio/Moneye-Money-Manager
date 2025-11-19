import 'package:expense_tracker/domain/models/transaction.dart';
import 'package:expense_tracker/application/transactions/notifiers/queries/latest_transactions_notifier.dart';
import 'package:expense_tracker/application/transactions/notifiers/queries/total_balance_notifier.dart';
import 'package:expense_tracker/application/transactions/notifiers/transactions_repository_provider.dart';
import 'package:expense_tracker/domain/repositories/transactions_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransactionMutationNotifier extends Notifier<void> {
  TransactionsRepository get _repo => ref.read(transactionsRepositoryProvider);

  @override
  void build() {
    return;
  }

  Future<Transaction> add(Transaction transaction) async {
    final inserted = await _repo.insertTransaction(transaction: transaction);

    ref.invalidate(totalBalanceProvider(const TotalBalanceParams()));
    ref.invalidate(latestTransactionsProvider);

    return inserted;
  }

  Future<void> update(Transaction original, Transaction modified) async {
    await _repo.updateTransaction(
        transactionToEdit: original, editedTransaction: modified);

    ref.invalidate(totalBalanceProvider(const TotalBalanceParams()));
    ref.invalidate(latestTransactionsProvider);
  }

  Future<void> delete(Transaction transaction) async {
    final removedTransactionCount =
        await _repo.deleteTransaction(transaction: transaction);

    if (removedTransactionCount > 0) {
      ref.invalidate(totalBalanceProvider(const TotalBalanceParams()));
      ref.invalidate(latestTransactionsProvider);
    }
  }
}

final transactionMutationProvider =
    NotifierProvider<TransactionMutationNotifier, void>(
  TransactionMutationNotifier.new,
);
