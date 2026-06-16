class AverageMonthlyAmount {
  const AverageMonthlyAmount({
    required this.averageAmount,
    required this.monthsConsidered,
    required this.totalAmount,
  });

  final double averageAmount;
  final int monthsConsidered;
  final double totalAmount;

  bool get isEmpty => totalAmount == 0 || monthsConsidered == 0;
}
