import 'package:expense_tracker/features/statistics/domain/models/category_statistics_entry.dart';

class CategoriesStatisticsSeries {
  const CategoriesStatisticsSeries({required this.entries});

  final List<CategoryStatisticsEntry> entries;

  bool get isEmpty => entries.isEmpty;
}
