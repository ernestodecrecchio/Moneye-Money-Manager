import 'package:expense_tracker/core/utils/double_helper.dart';
import 'package:expense_tracker/features/categories/domain/models/category.dart';
import 'package:expense_tracker/features/statistics/domain/logic/expenses_by_category_calculator.dart';
import 'package:expense_tracker/features/statistics/domain/models/category_comparison_month.dart';
import 'package:expense_tracker/features/statistics/domain/models/category_comparison_series.dart';
import 'package:expense_tracker/features/statistics/domain/models/statistics_period.dart';
import 'package:intl/intl.dart';

class CategoryComparisonCalculator {
  const CategoryComparisonCalculator._();

  static CategoryComparisonSeries build({
    required StatisticsPeriod period,
    required List<({int? categoryId, DateTime monthStart, double amount})> records,
    required List<Category> categories,
    required Category uncategorizedCategory,
    required String locale,
  }) {
    final categoryById = {
      for (final category in categories)
        if (category.id != null) category.id!: category,
    };

    final totalsByCategoryId = <int?, double>{};
    final amountsByCategoryAndMonth = <String, double>{};

    for (final record in records) {
      if (record.amount <= 0) {
        continue;
      }

      totalsByCategoryId[record.categoryId] =
          ((totalsByCategoryId[record.categoryId] ?? 0) + record.amount)
              .withPrecision(2);

      final monthKey = _categoryMonthKey(record.categoryId, record.monthStart);
      amountsByCategoryAndMonth[monthKey] =
          ((amountsByCategoryAndMonth[monthKey] ?? 0) + record.amount)
              .withPrecision(2);
    }

    final topCategoryIds = totalsByCategoryId.entries.toList()
      ..sort((left, right) => right.value.compareTo(left.value));

    final selectedCategoryIds = topCategoryIds
        .take(CategoryComparisonSeries.topCategoryLimit)
        .map((entry) => entry.key)
        .toList();

    final selectedCategories = selectedCategoryIds
        .map(
          (categoryId) => ExpensesByCategoryCalculator.resolveCategory(
            categoryId: categoryId,
            categoryById: categoryById,
            uncategorizedCategory: uncategorizedCategory,
          ),
        )
        .toList();

    final monthStarts = _monthStartsInPeriod(period);
    final spansMultipleYears = _spansMultipleYears(monthStarts);
    final labelFormat = spansMultipleYears
        ? DateFormat.yMMM(locale)
        : DateFormat.MMM(locale);

    final months = monthStarts
        .map(
          (monthStart) => CategoryComparisonMonth(
            monthStart: monthStart,
            label: labelFormat.format(monthStart),
            amountsByCategory: [
              for (final categoryId in selectedCategoryIds)
                amountsByCategoryAndMonth[
                        _categoryMonthKey(categoryId, monthStart)] ??
                    0,
            ],
          ),
        )
        .toList();

    return CategoryComparisonSeries(
      categories: selectedCategories,
      months: months,
    );
  }

  static List<DateTime> _monthStartsInPeriod(StatisticsPeriod period) {
    final months = <DateTime>[];
    var year = period.startDate.year;
    var month = period.startDate.month;
    final endMonth = DateTime(period.endDate.year, period.endDate.month, 1);

    while (!DateTime(year, month, 1).isAfter(endMonth)) {
      months.add(DateTime(year, month, 1));
      month++;
      if (month > 12) {
        year++;
        month = 1;
      }
    }

    return months;
  }

  static bool _spansMultipleYears(List<DateTime> monthStarts) {
    if (monthStarts.isEmpty) {
      return false;
    }

    final firstYear = monthStarts.first.year;
    return monthStarts.any((monthStart) => monthStart.year != firstYear);
  }

  static String _categoryMonthKey(int? categoryId, DateTime monthStart) {
    final categoryKey = categoryId?.toString() ?? 'null';
    return '$categoryKey-${monthStart.year}-${monthStart.month}';
  }
}
