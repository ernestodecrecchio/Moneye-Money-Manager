import 'package:equatable/equatable.dart';
import 'package:expense_tracker/application/transactions/notifiers/transactions_repository_provider.dart';
import 'package:expense_tracker/domain/models/account.dart';
import 'package:expense_tracker/domain/models/transaction.dart';
import 'package:expense_tracker/domain/repositories/transactions_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransactionsListNotifier
    extends FamilyAsyncNotifier<List<Transaction>, TransactionsListParams> {
  TransactionsRepository get _repo => ref.read(transactionsRepositoryProvider);

  @override
  Future<List<Transaction>> build(TransactionsListParams arg) async {
    return _repo.getTransactions(
      startDate: arg.startDate,
      endDate: arg.endDate,
      forAccount: arg.account,
      includeIncomes: arg.includeIncomes,
      includeExpenses: arg.includeExpenses,
      limit: arg.limit,
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
