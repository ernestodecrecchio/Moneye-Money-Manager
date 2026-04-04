import 'package:equatable/equatable.dart';
import 'package:expense_tracker/features/transactions/presentation/providers/transactions_repository_provider.dart';
import 'package:expense_tracker/features/categories/domain/models/category.dart';
import 'package:expense_tracker/features/accounts/domain/models/account.dart';
import 'package:expense_tracker/features/transactions/domain/models/transaction.dart';
import 'package:expense_tracker/features/transactions/domain/repositories/transactions_repository.dart';
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
      categoryId: params.category?.id,
      includeIncomes: params.includeIncomes,
      includeExpenses: params.includeExpenses,
      limit: params.limit,
      recurringId: params.recurringId,
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
  final Category? category;
  final bool? includeIncomes;
  final bool? includeExpenses;
  final int? limit;
  final String? recurringId;

  const TransactionsListParams({
    this.startDate,
    this.endDate,
    this.account,
    this.category,
    this.includeIncomes,
    this.includeExpenses,
    this.limit,
    this.recurringId,
  });

  TransactionsListParams copyWith({
    DateTime? startDate,
    DateTime? endDate,
    Account? account,
    Category? category,
    bool? includeIncomes,
    bool? includeExpenses,
    int? limit,
    String? recurringId,
  }) {
    return TransactionsListParams(
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      account: account ?? this.account,
      category: category ?? this.category,
      includeIncomes: includeIncomes ?? this.includeIncomes,
      includeExpenses: includeExpenses ?? this.includeExpenses,
      limit: limit ?? this.limit,
      recurringId: recurringId ?? this.recurringId,
    );
  }

  @override
  List<Object?> get props => [
        startDate,
        endDate,
        account,
        category,
        includeIncomes,
        includeExpenses,
        limit,
        recurringId,
      ];
}
