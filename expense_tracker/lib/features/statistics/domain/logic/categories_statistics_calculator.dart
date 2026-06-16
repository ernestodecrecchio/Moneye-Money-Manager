import 'package:expense_tracker/core/utils/double_helper.dart';
import 'package:expense_tracker/features/categories/domain/models/category.dart';
import 'package:expense_tracker/features/statistics/domain/logic/expenses_by_category_calculator.dart';
import 'package:expense_tracker/features/statistics/domain/models/categories_statistics_series.dart';
import 'package:expense_tracker/features/statistics/domain/models/category_statistics_entry.dart';

class CategoriesStatisticsCalculator {
  const CategoriesStatisticsCalculator._();

  static CategoriesStatisticsSeries build({
    required List<({int? categoryId, double amount})> expenseRecords,
    required List<({int? categoryId, double amount})> incomeRecords,
    required List<Category> categories,
    required Category uncategorizedCategory,
  }) {
    final categoryById = {
      for (final category in categories)
        if (category.id != null) category.id!: category,
    };

    final expenseTotals = _totalsByCategoryId(expenseRecords);
    final incomeTotals = _totalsByCategoryId(incomeRecords);

    final totalExpenses = expenseTotals.values
        .fold<double>(0, (sum, amount) => sum + amount)
        .withPrecision(2);
    final totalIncome = incomeTotals.values
        .fold<double>(0, (sum, amount) => sum + amount)
        .withPrecision(2);

    final categoryIds = {
      ...expenseTotals.keys,
      ...incomeTotals.keys,
    };

    final entries = <CategoryStatisticsEntry>[];

    for (final categoryId in categoryIds) {
      final expenseAmount = expenseTotals[categoryId] ?? 0;
      final incomeAmount = incomeTotals[categoryId] ?? 0;
      final category = ExpensesByCategoryCalculator.resolveCategory(
        categoryId: categoryId,
        categoryById: categoryById,
        uncategorizedCategory: uncategorizedCategory,
      );

      if (expenseAmount > 0) {
        entries.add(
          CategoryStatisticsEntry(
            category: category,
            amount: expenseAmount,
            percentage: totalExpenses > 0
                ? (expenseAmount / totalExpenses * 100).withPrecision(1)
                : 0,
            amountType: CategoryStatisticsAmountType.expense,
          ),
        );
        continue;
      }

      if (incomeAmount > 0) {
        entries.add(
          CategoryStatisticsEntry(
            category: category,
            amount: incomeAmount,
            percentage: totalIncome > 0
                ? (incomeAmount / totalIncome * 100).withPrecision(1)
                : 0,
            amountType: CategoryStatisticsAmountType.income,
          ),
        );
      }
    }

    entries.sort((left, right) => right.amount.compareTo(left.amount));

    return CategoriesStatisticsSeries(entries: entries);
  }

  static Map<int?, double> _totalsByCategoryId(
    List<({int? categoryId, double amount})> records,
  ) {
    final totals = <int?, double>{};

    for (final record in records) {
      if (record.amount <= 0) {
        continue;
      }

      totals[record.categoryId] =
          ((totals[record.categoryId] ?? 0) + record.amount).withPrecision(2);
    }

    return totals;
  }
}
