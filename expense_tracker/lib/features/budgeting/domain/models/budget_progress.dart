import 'package:equatable/equatable.dart';

/// Represents the state of a [Budget] for a specific period.
/// 
/// This model encapsulates spending limits, actual expenditure, 
/// and historical carry-over values, along with the temporal 
/// boundaries of the period being analyzed.
class BudgetProgress extends Equatable {
  /// The base spending limit defined for the budget.
  final double limit;

  /// The total amount spent within the period boundaries.
  final double spent;

  /// The amount carried forward from previous periods (positive for savings, negative for overspending).
  final double carriedOver;

  /// The inclusive start date of the current budget period.
  final DateTime startDate;

  /// The inclusive end date of the current budget period.
  final DateTime endDate;

  const BudgetProgress({
    required this.limit,
    required this.spent,
    this.carriedOver = 0,
    required this.startDate,
    required this.endDate,
  });

  /// The total spending capacity for the period, adjusting the [limit] by [carriedOver].
  double get totalAllowed => limit + carriedOver;

  /// The amount of funds remaining before the [totalAllowed] limit is reached.
  double get remaining => totalAllowed - spent;

  /// The ratio of [spent] to [totalAllowed], represented as a value between 0.0 and 1.0.
  double get percentage => totalAllowed > 0 ? (spent / totalAllowed) : 0.0;

  /// Indicates whether the [spent] amount exceeds the [totalAllowed] limit.
  bool get isOverBudget => spent > totalAllowed;

  @override
  List<Object?> get props => [limit, spent, carriedOver, startDate, endDate];
}
