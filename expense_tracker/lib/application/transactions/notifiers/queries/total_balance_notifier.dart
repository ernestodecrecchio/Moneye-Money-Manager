import 'package:equatable/equatable.dart';
import 'package:expense_tracker/domain/models/account.dart';
import 'package:expense_tracker/application/transactions/notifiers/transactions_repository_provider.dart';
import 'package:expense_tracker/domain/repositories/transactions_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TotalBalanceNotifier extends AsyncNotifier<double> {
  TransactionsRepository get _repo => ref.read(transactionsRepositoryProvider);

  final TotalBalanceParams params;

  TotalBalanceNotifier(this.params);

  @override
  Future<double> build() async {
    return _repo.getTotalBalance(
      startDate: params.startDate,
      endDate: params.endDate,
      forAccount: params.account,
    );
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}

final totalBalanceProvider = AsyncNotifierProvider.family<TotalBalanceNotifier,
    double, TotalBalanceParams>(TotalBalanceNotifier.new);

class TotalBalanceParams extends Equatable {
  final DateTime? startDate;
  final DateTime? endDate;
  final Account? account;

  const TotalBalanceParams({this.startDate, this.endDate, this.account});

  @override
  List<Object?> get props => [startDate, endDate, account];
}
