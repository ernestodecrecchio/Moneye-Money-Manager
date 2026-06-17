import 'package:expense_tracker/core/presentation/providers/app_localizations_provider.dart';
import 'package:expense_tracker/features/statistics/domain/logic/cumulative_cashflow_calculator.dart';
import 'package:expense_tracker/features/statistics/domain/models/cumulative_cashflow_series.dart';
import 'package:expense_tracker/features/statistics/presentation/providers/queries/monthly_cashflow_notifier.dart';
import 'package:expense_tracker/features/statistics/presentation/providers/statistics_period_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CumulativeCashflowNotifier extends AsyncNotifier<CumulativeCashflowSeries> {
  @override
  Future<CumulativeCashflowSeries> build() async {
    final period = ref.watch(statisticsPeriodProvider);
    final appLocalizations = ref.watch(appLocalizationsProvider);
    final monthlySeries = await ref.watch(monthlyCashflowProvider.future);

    return CumulativeCashflowCalculator.build(
      period: period,
      monthlySeries: monthlySeries,
      locale: appLocalizations.localeName,
    );
  }
}

final cumulativeCashflowProvider =
    AsyncNotifierProvider<CumulativeCashflowNotifier, CumulativeCashflowSeries>(
  CumulativeCashflowNotifier.new,
);
