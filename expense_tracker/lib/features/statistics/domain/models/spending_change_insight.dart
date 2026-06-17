class SpendingChangeInsight {
  const SpendingChangeInsight({
    required this.currentExpenses,
    required this.previousExpenses,
    required this.absoluteChange,
    required this.percentChange,
  });

  final double currentExpenses;
  final double previousExpenses;
  final double absoluteChange;
  final double percentChange;

  bool get isIncrease => absoluteChange > 0;
}
