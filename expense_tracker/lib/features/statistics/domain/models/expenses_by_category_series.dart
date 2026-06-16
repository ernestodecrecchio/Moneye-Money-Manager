import 'dart:math';

import 'package:expense_tracker/features/statistics/domain/models/category_expense_entry.dart';

class ExpensesByCategorySeries {
  const ExpensesByCategorySeries({
    required this.entries,
    required this.totalExpenses,
  });

  final List<CategoryExpenseEntry> entries;
  final double totalExpenses;

  bool get isEmpty => totalExpenses == 0 || entries.isEmpty;

  double get maxAmount {
    if (entries.isEmpty) {
      return 0;
    }

    return entries.map((entry) => entry.amount).reduce(max);
  }
}
