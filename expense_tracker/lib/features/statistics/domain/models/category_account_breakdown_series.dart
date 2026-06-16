import 'dart:math';

import 'package:expense_tracker/features/statistics/domain/models/account_breakdown_entry.dart';

class CategoryAccountBreakdownSeries {
  const CategoryAccountBreakdownSeries({required this.entries});

  final List<AccountBreakdownEntry> entries;

  bool get isEmpty {
    return entries.isEmpty || entries.every((entry) => entry.amount == 0);
  }

  double get maxAmount {
    if (entries.isEmpty) {
      return 0;
    }

    return entries.map((entry) => entry.amount).reduce(max);
  }
}
