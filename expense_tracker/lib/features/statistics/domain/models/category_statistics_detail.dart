import 'package:expense_tracker/features/statistics/domain/models/category_statistics_entry.dart';
import 'package:expense_tracker/features/statistics/domain/models/monthly_spending_trend_series.dart';
import 'package:expense_tracker/features/transactions/domain/models/transaction.dart';

class CategoryStatisticsDetail {
  const CategoryStatisticsDetail({
    required this.summary,
    required this.monthlyTrend,
    required this.transactions,
  });

  final CategoryStatisticsEntry summary;
  final MonthlySpendingTrendSeries monthlyTrend;
  final List<Transaction> transactions;
}
