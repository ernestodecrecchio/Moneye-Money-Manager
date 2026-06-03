import 'package:expense_tracker/core/style/app_theme.dart';
import 'package:expense_tracker/features/budgeting/domain/logic/budget_calculator.dart';
import 'package:expense_tracker/features/budgeting/domain/models/budget.dart';
import 'package:expense_tracker/features/budgeting/domain/models/budget_progress.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension BudgetPeriodLabelExtension on Budget {
  String formatPeriodRange(BudgetProgress progress, String localeName) {
    final period = BudgetCalculator.currentPeriod(this, DateTime.now());
    final formatter = DateFormat.yMMMd(localeName);
    final start = BudgetCalculator.periodDisplayStartDate(period.start);
    final end = BudgetCalculator.periodInclusiveEndDate(this, period);
    return '${formatter.format(start)} - ${formatter.format(end)}';
  }
}

extension BudgetProgressUIExtension on BudgetProgress {
  /// Computes the state color using theme-defined budget progress rules.
  Color getStateColor(BuildContext context) {
    return context.budgetProgressColor(
      percentage: percentage,
      isOverBudget: isOverBudget,
    );
  }
}
