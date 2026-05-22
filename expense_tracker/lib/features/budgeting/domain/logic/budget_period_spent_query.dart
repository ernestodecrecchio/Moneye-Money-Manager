/// Loads total budget-eligible expenses for a date range (typically from SQL).
typedef BudgetPeriodSpentQuery = Future<double> Function({
  required List<int> categoryIds,
  required DateTime start,
  required DateTime end,
});
