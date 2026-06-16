class OverviewPeriodKpis {
  const OverviewPeriodKpis({
    required this.totalIncome,
    required this.totalExpenses,
  });

  final double totalIncome;
  final double totalExpenses;

  double get netResult => totalIncome - totalExpenses;

  double? get savingsRate {
    if (totalIncome == 0) {
      return null;
    }
    return netResult / totalIncome;
  }

  bool get isEmpty => totalIncome == 0 && totalExpenses == 0;
}
