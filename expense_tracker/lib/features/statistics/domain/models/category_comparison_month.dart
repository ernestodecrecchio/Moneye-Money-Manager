class CategoryComparisonMonth {
  const CategoryComparisonMonth({
    required this.monthStart,
    required this.label,
    required this.amountsByCategory,
  });

  final DateTime monthStart;
  final String label;
  final List<double> amountsByCategory;
}
