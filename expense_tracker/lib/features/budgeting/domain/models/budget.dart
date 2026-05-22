import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

enum PeriodType { monthly, weekly, custom }

enum RolloverMode { none, carryRemaining, carryOverspending }

@immutable
class Budget extends Equatable {
  final int? id;
  final String name;
  final double amount;
  final PeriodType periodType;
  
  // Discrete properties for period configuration
  final int? startDay; // For monthly budgets (1-31)
  final int? startWeekday; // For weekly budgets (1=Monday, 7=Sunday)
  final DateTime? customStartDate;
  final DateTime? customEndDate;
  
  final RolloverMode rolloverMode;

  /// Amount carried into the current period (positive = extra budget, negative = overspend debt).
  final double rolloverAmount;

  /// Start of the active budget period; used to detect period transitions.
  final DateTime? periodStart;

  final DateTime createdAt;
  final DateTime updatedAt;

  final List<int> categoryIds; // IDs of associated categories

  const Budget({
    this.id,
    required this.name,
    required this.amount,
    required this.periodType,
    this.startDay,
    this.startWeekday,
    this.customStartDate,
    this.customEndDate,
    this.rolloverMode = RolloverMode.none,
    this.rolloverAmount = 0,
    this.periodStart,
    required this.createdAt,
    required this.updatedAt,
    required this.categoryIds,
  });

  Budget copy({
    int? id,
    String? name,
    double? amount,
    PeriodType? periodType,
    int? startDay,
    int? startWeekday,
    DateTime? customStartDate,
    DateTime? customEndDate,
    RolloverMode? rolloverMode,
    double? rolloverAmount,
    DateTime? periodStart,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<int>? categoryIds,
  }) {
    return Budget(
      id: id ?? this.id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      periodType: periodType ?? this.periodType,
      startDay: startDay ?? this.startDay,
      startWeekday: startWeekday ?? this.startWeekday,
      customStartDate: customStartDate ?? this.customStartDate,
      customEndDate: customEndDate ?? this.customEndDate,
      rolloverMode: rolloverMode ?? this.rolloverMode,
      rolloverAmount: rolloverAmount ?? this.rolloverAmount,
      periodStart: periodStart ?? this.periodStart,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      categoryIds: categoryIds ?? this.categoryIds,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        amount,
        periodType,
        startDay,
        startWeekday,
        customStartDate,
        customEndDate,
        rolloverMode,
        rolloverAmount,
        periodStart,
        createdAt,
        updatedAt,
        categoryIds,
      ];
}
