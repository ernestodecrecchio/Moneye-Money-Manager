import 'package:equatable/equatable.dart';
import 'package:expense_tracker/domain/models/account.dart';
import 'package:expense_tracker/application/transactions/notifiers/transactions_repository_provider.dart';
import 'package:expense_tracker/domain/repositories/transactions_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TotalBalanceNotifier
    extends FamilyAsyncNotifier<double, TotalBalanceParams> {
  TransactionsRepository get _repo => ref.read(transactionsRepositoryProvider);

  @override
  Future<double> build(TotalBalanceParams arg) async {
    return _repo.getTotalBalance(
      startDate: arg.startDate,
      endDate: arg.endDate,
      forAccount: arg.account,
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
