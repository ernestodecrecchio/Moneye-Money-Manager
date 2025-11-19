/*import 'package:equatable/equatable.dart';
import 'package:expense_tracker/application/transactions/notifiers/transactions_repository_provider.dart';
import 'package:expense_tracker/data/repositories/transactions_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MonthlyBalanceNotifier extends AsyncNotifier<Map<int, double>> {
  TransactionsRepository get _repo => ref.read(transactionsRepositoryProvider);

  late final MonthlyBalanceParams params;

  MonthlyBalanceNotifier({required this.params});

  @override
  Future<Map<int, double>> build() async {
    return _getMonthlyBalanceForYear(params.year);
  }

  Future<Map<int, double>> _getMonthlyBalanceForYear(int year) async {
    return await _repo.getMonthlyBalanceForYear(year: year);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => _getMonthlyBalanceForYear(params.year),
    );
  }
}

final monthlyBalanceProvider = AsyncNotifierProvider.family<
    MonthlyBalanceNotifier,
    Map<int, double>,
    MonthlyBalanceParams>((params) => MonthlyBalanceNotifier(params: params));

class MonthlyBalanceParams extends Equatable {
  final int year;

  const MonthlyBalanceParams({required this.year});

  @override
  List<Object?> get props => [year];
}
*/
