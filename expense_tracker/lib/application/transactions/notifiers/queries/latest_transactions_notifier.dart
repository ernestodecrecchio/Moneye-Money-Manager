import 'package:expense_tracker/domain/models/transaction.dart';
import 'package:expense_tracker/application/transactions/notifiers/transactions_repository_provider.dart';
import 'package:expense_tracker/domain/repositories/transactions_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LatestTransactionsNotifier extends AsyncNotifier<List<Transaction>> {
  TransactionsRepository get _repo => ref.read(transactionsRepositoryProvider);

  @override
  Future<List<Transaction>> build() => _repo.getLatestTransactions();

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_repo.getLatestTransactions);
  }
}

final latestTransactionsProvider =
    AsyncNotifierProvider<LatestTransactionsNotifier, List<Transaction>>(
  LatestTransactionsNotifier.new,
);
