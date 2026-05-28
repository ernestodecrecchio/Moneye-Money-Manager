import 'package:expense_tracker/core/style/app_theme.dart';
import 'package:expense_tracker/features/budgeting/domain/models/budget_progress.dart';
import 'package:flutter/material.dart';

extension BudgetProgressUIExtension on BudgetProgress {
  /// Computes the state color using theme-defined budget progress rules.
  Color getStateColor(BuildContext context) {
    return context.budgetProgressColor(
      percentage: percentage,
      isOverBudget: isOverBudget,
    );
  }
}
