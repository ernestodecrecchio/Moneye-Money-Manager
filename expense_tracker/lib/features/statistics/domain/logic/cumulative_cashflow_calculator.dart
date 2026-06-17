import 'package:expense_tracker/core/utils/double_helper.dart';
import 'package:expense_tracker/features/statistics/domain/models/cumulative_cashflow_point.dart';
import 'package:expense_tracker/features/statistics/domain/models/cumulative_cashflow_series.dart';
import 'package:expense_tracker/features/statistics/domain/models/monthly_cashflow_series.dart';
import 'package:expense_tracker/features/statistics/domain/models/statistics_period.dart';
import 'package:intl/intl.dart';

class CumulativeCashflowCalculator {
  const CumulativeCashflowCalculator._();

  static CumulativeCashflowSeries build({
    required StatisticsPeriod period,
    required MonthlyCashflowSeries monthlySeries,
    required String locale,
  }) {
    if (monthlySeries.points.isEmpty) {
      return const CumulativeCashflowSeries(points: [], isEmpty: true);
    }

    final periodStartLabel = DateFormat.yMMMd(locale).format(period.startDate);
    final points = <CumulativeCashflowPoint>[
      CumulativeCashflowPoint(
        monthStart: period.startDate,
        label: periodStartLabel,
        cumulativeNetCashflow: 0,
      ),
    ];

    var cumulative = 0.0;
    for (final month in monthlySeries.points) {
      cumulative = (cumulative + month.netCashflow).withPrecision(2);
      points.add(
        CumulativeCashflowPoint(
          monthStart: month.monthStart,
          label: month.label,
          cumulativeNetCashflow: cumulative,
        ),
      );
    }

    return CumulativeCashflowSeries(
      points: points,
      isEmpty: monthlySeries.isEmpty,
    );
  }
}
