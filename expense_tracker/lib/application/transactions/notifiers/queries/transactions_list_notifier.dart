import 'package:equatable/equatable.dart';
import 'package:expense_tracker/application/transactions/notifiers/transactions_repository_provider.dart';
import 'package:expense_tracker/domain/models/account.dart';
import 'package:expense_tracker/domain/models/transaction.dart';
import 'package:expense_tracker/domain/repositories/transactions_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransactionsListNotifier extends AsyncNotifier<List<Transaction>> {
  TransactionsRepository get _repo => ref.read(transactionsRepositoryProvider);

  final TransactionsListParams params;

  TransactionsListNotifier(this.params);

  @override
  Future<List<Transaction>> build() async {
    return _repo.getTransactions(
      startDate: params.startDate,
      endDate: params.endDate,
      forAccount: params.account,
      includeIncomes: params.includeIncomes,
      includeExpenses: params.includeExpenses,
      limit: params.limit,
    );
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}

final transactionsListProvider = AsyncNotifierProvider.family<
    TransactionsListNotifier, List<Transaction>, TransactionsListParams>(
  TransactionsListNotifier.new,
);

class TransactionsListParams extends Equatable {
  final DateTime? startDate;
  final DateTime? endDate;
  final Account? account;
  final bool? includeIncomes;
  final bool? includeExpenses;
  final int? limit;

  const TransactionsListParams({
    this.startDate,
    this.endDate,
    this.account,
    this.includeIncomes,
    this.includeExpenses,
    this.limit,
  });

  @override
  List<Object?> get props => [
        startDate,
        endDate,
        account,
        includeIncomes,
        includeExpenses,
        limit,
      ];
}
