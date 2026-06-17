import 'package:expense_tracker/features/statistics/domain/models/statistics_period.dart';
import 'package:expense_tracker/features/statistics/domain/models/statistics_period_granularity.dart';

/// Charts that compare values across multiple months need at least a quarter
/// or year granularity. Month view has a single bucket and is not supported.
bool statisticsPeriodSupportsMultipleMonths(StatisticsPeriod period) {
  return period.granularity != StatisticsPeriodGranularity.month;
}
