class MonthlyNetResultSummary {
  const MonthlyNetResultSummary({
    required this.monthStart,
    required this.label,
    required this.netResult,
  });

  final DateTime monthStart;
  final String label;
  final double netResult;
}

class BestWorstMonthInsight {
  const BestWorstMonthInsight({
    required this.best,
    required this.worst,
  });

  final MonthlyNetResultSummary best;
  final MonthlyNetResultSummary worst;
}
