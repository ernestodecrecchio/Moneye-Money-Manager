class MonthlyCashflowPoint {
  const MonthlyCashflowPoint({
    required this.monthStart,
    required this.label,
    required this.income,
    required this.expenses,
  });

  final DateTime monthStart;
  final String label;
  final double income;
  final double expenses;

  double get netCashflow => income - expenses;
}
