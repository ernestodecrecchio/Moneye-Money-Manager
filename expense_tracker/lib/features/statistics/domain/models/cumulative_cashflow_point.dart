class CumulativeCashflowPoint {
  const CumulativeCashflowPoint({
    required this.monthStart,
    required this.label,
    required this.cumulativeNetCashflow,
  });

  final DateTime monthStart;
  final String label;
  final double cumulativeNetCashflow;
}
