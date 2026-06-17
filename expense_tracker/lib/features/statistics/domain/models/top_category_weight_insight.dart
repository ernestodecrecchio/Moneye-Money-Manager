import 'package:expense_tracker/features/categories/domain/models/category.dart';

class TopCategoryWeightInsight {
  const TopCategoryWeightInsight({
    required this.category,
    required this.amount,
    required this.sharePercent,
    required this.totalExpenses,
  });

  final Category category;
  final double amount;
  final double sharePercent;
  final double totalExpenses;
}
