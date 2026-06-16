class MonthlyExpensePoint {
  const MonthlyExpensePoint({
    required this.monthStart,
    required this.label,
    required this.expenses,
  });

  final DateTime monthStart;
  final String label;
  final double expenses;
}
