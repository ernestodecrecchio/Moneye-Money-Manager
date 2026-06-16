import 'package:expense_tracker/features/categories/domain/models/category.dart';

class CategoryExpenseEntry {
  const CategoryExpenseEntry({
    required this.category,
    required this.amount,
    required this.percentage,
  });

  final Category category;
  final double amount;
  final double percentage;
}
