import 'package:expense_tracker/core/style/app_theme.dart';
import 'package:flutter/material.dart';

enum InsightSeverity {
  info,
  positive,
  warning,
  negative,
}

extension InsightSeverityColors on InsightSeverity {
  Color accentColor(AppColors colors) {
    return switch (this) {
      InsightSeverity.info => colors.primary,
      InsightSeverity.positive => colors.income,
      InsightSeverity.warning => colors.warning,
      InsightSeverity.negative => colors.expense,
    };
  }
}
