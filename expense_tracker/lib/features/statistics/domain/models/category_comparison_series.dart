import 'package:expense_tracker/features/categories/domain/models/category.dart';
import 'package:expense_tracker/features/statistics/domain/models/category_comparison_month.dart';

class CategoryComparisonSeries {
  const CategoryComparisonSeries({
    required this.categories,
    required this.months,
  });

  static const int topCategoryLimit = 3;

  final List<Category> categories;
  final List<CategoryComparisonMonth> months;

  bool get hasInsufficientData => months.length < 2;

  bool get isEmpty {
    if (categories.isEmpty || months.isEmpty) {
      return true;
    }

    return months.every(
      (month) => month.amountsByCategory.every((amount) => amount == 0),
    );
  }

  double get maxAmount {
    var maxValue = 0.0;

    for (final month in months) {
      for (final amount in month.amountsByCategory) {
        if (amount > maxValue) {
          maxValue = amount;
        }
      }
    }

    return maxValue;
  }
}
