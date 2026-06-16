import 'package:expense_tracker/core/utils/double_helper.dart';
import 'package:expense_tracker/features/categories/domain/models/category.dart';
import 'package:expense_tracker/features/statistics/domain/models/category_expense_entry.dart';
import 'package:expense_tracker/features/statistics/domain/models/expenses_by_category_series.dart';

class ExpensesByCategoryCalculator {
  const ExpensesByCategoryCalculator._();

  static ExpensesByCategorySeries build({
    required List<({int? categoryId, double amount})> records,
    required List<Category> categories,
    required Category uncategorizedCategory,
  }) {
    final categoryById = {
      for (final category in categories)
        if (category.id != null) category.id!: category,
    };

    final totalsByCategory = <Category, double>{};

    for (final record in records) {
      if (record.amount <= 0) {
        continue;
      }

      final category = _resolveCategory(
        categoryId: record.categoryId,
        categoryById: categoryById,
        uncategorizedCategory: uncategorizedCategory,
      );

      totalsByCategory[category] =
          ((totalsByCategory[category] ?? 0) + record.amount).withPrecision(2);
    }

    final totalExpenses = totalsByCategory.values
        .fold<double>(0, (sum, amount) => sum + amount)
        .withPrecision(2);

    final entries = totalsByCategory.entries
        .map(
          (entry) => CategoryExpenseEntry(
            category: entry.key,
            amount: entry.value,
            percentage: totalExpenses > 0
                ? (entry.value / totalExpenses * 100).withPrecision(1)
                : 0,
          ),
        )
        .toList()
      ..sort((left, right) => right.amount.compareTo(left.amount));

    return ExpensesByCategorySeries(
      entries: entries,
      totalExpenses: totalExpenses,
    );
  }

  static Category _resolveCategory({
    required int? categoryId,
    required Map<int, Category> categoryById,
    required Category uncategorizedCategory,
  }) {
    if (categoryId == null) {
      return uncategorizedCategory;
    }

    return categoryById[categoryId] ??
        Category(
          id: categoryId,
          name: uncategorizedCategory.name,
          colorValue: uncategorizedCategory.colorValue,
          iconPath: uncategorizedCategory.iconPath,
          isOtherCategory: true,
        );
  }
}
