import 'package:expense_tracker/core/style/app_theme.dart';
import 'package:expense_tracker/features/budgeting/domain/models/budget_progress.dart';
import 'package:flutter/material.dart';

extension BudgetProgressUIExtension on BudgetProgress {
  /// Computes the state color based on the current budget status:
  /// - Exceeded (> 100%): Red (expense)
  /// - Near limit (>= 80%): Yellow/Orange (warning)
  /// - Healthy (< 80%): Green (income)
  Color getStateColor(BuildContext context) {
    return isOverBudget
        ? context.appColors.expense
        : (percentage >= 0.8
            ? context.appColors.warning
            : context.appColors.income);
  }
}
