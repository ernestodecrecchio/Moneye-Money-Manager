import 'package:expense_tracker/features/statistics/domain/logic/net_worth_trend_calculator.dart';
import 'package:expense_tracker/features/statistics/domain/models/net_worth_trend_series.dart';
import 'package:expense_tracker/features/statistics/presentation/providers/statistics_period_provider.dart';
import 'package:expense_tracker/features/transactions/presentation/providers/transactions_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NetWorthTrendNotifier extends AsyncNotifier<NetWorthTrendSeries> {
  @override
  Future<NetWorthTrendSeries> build() async {
    final period = ref.watch(statisticsPeriodProvider);
    final repository = ref.read(transactionsRepositoryProvider);

    final openingNetWorth =
        await repository.getGlobalNetWorthBeforePeriod(period.startDate);
    final dailyChanges = await repository.getDailyTransactionChangesInPeriod(
      start: period.startDate,
      end: period.endDate,
    );

    return NetWorthTrendCalculator.build(
      period: period,
      openingNetWorth: openingNetWorth,
      dailyChanges: dailyChanges,
    );
  }
}

final netWorthTrendProvider =
    AsyncNotifierProvider<NetWorthTrendNotifier, NetWorthTrendSeries>(
  NetWorthTrendNotifier.new,
);
