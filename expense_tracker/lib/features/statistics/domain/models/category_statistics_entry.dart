import 'package:expense_tracker/features/categories/domain/models/category.dart';

enum CategoryStatisticsAmountType { expense, income }

class CategoryStatisticsEntry {
  const CategoryStatisticsEntry({
    required this.category,
    required this.amount,
    required this.percentage,
    required this.amountType,
  });

  final Category category;
  final double amount;
  final double percentage;
  final CategoryStatisticsAmountType amountType;

  bool get isExpense => amountType == CategoryStatisticsAmountType.expense;
}
