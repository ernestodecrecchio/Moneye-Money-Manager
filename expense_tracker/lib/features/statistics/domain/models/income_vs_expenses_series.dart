class IncomeExpenseBucket {
  const IncomeExpenseBucket({
    required this.label,
    required this.income,
    required this.expenses,
  });

  final String label;
  final double income;
  final double expenses;
}

class IncomeVsExpensesSeries {
  const IncomeVsExpensesSeries({required this.buckets});

  final List<IncomeExpenseBucket> buckets;

  bool get isEmpty {
    return buckets.every((bucket) => bucket.income == 0 && bucket.expenses == 0);
  }

  double get maxValue {
    if (buckets.isEmpty) {
      return 0;
    }

    return buckets
        .map((bucket) => bucket.income > bucket.expenses ? bucket.income : bucket.expenses)
        .reduce((left, right) => left > right ? left : right);
  }
}
