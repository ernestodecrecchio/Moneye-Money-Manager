import 'package:equatable/equatable.dart';
import 'package:expense_tracker/application/transactions/models/account.dart';
import 'package:expense_tracker/application/transactions/notifiers/transactions_repository_provider.dart';
import 'package:expense_tracker/data/repositories/transactions_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TotalBalanceNotifier extends AsyncNotifier<double> {
  TransactionsRepository get _repo => ref.read(transactionsRepositoryProvider);

  late final TotalBalanceParams params;

  final DateTime? startDate;
  final DateTime? endDate;
  final Account? account;

  TotalBalanceNotifier({this.startDate, this.endDate, this.account});

  @override
  Future<double> build() async {
    return _repo.getTotalBalance(
      startDate: startDate,
      endDate: endDate,
      forAccount: account,
    );
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}

final totalBalanceProvider = AsyncNotifierProvider.family<TotalBalanceNotifier,
    double, TotalBalanceParams>(
  (params) => TotalBalanceNotifier(
    startDate: params.startDate,
    endDate: params.endDate,
    account: params.account,
  ),
);

class TotalBalanceParams extends Equatable {
  final DateTime? startDate;
  final DateTime? endDate;
  final Account? account;

  const TotalBalanceParams({this.startDate, this.endDate, this.account});

  @override
  List<Object?> get props => [startDate, endDate, account];
}
