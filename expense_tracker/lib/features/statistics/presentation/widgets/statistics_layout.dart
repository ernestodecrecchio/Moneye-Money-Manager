import 'package:expense_tracker/core/style/app_theme.dart';
import 'package:flutter/material.dart';

/// Shared spacing and typography tokens for the Statistics section.
abstract final class StatisticsLayout {
  static const double chartHeight = 220;
  static const double sectionSpacing = 16;
  static const double periodSectionSpacing = 20;
  static const EdgeInsets cardPadding = EdgeInsets.all(20);
  static const double cardHeaderSpacing = 16;
  static const double periodCardPaddingH = 16;
  static const double periodCardPaddingV = 12;

  static TextStyle cardTitleStyle(BuildContext context) {
    return Theme.of(context).textTheme.titleMedium!.copyWith(
          fontWeight: FontWeight.bold,
          letterSpacing: -0.5,
        );
  }

  static TextStyle cardSubtitleStyle(BuildContext context) {
    return Theme.of(context).textTheme.bodySmall!.copyWith(
          fontSize: 13,
          height: 1.4,
          color: context.appColors.textSecondary,
        );
  }

  static TextStyle sectionHeaderStyle(BuildContext context) {
    return TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.bold,
      color: context.appColors.primary,
      letterSpacing: 1.1,
    );
  }

  static TextStyle chartAxisLabelStyle(BuildContext context) {
    return Theme.of(context).textTheme.labelSmall!.copyWith(
          color: context.appColors.textSecondary,
          fontWeight: FontWeight.bold,
          fontSize: 11,
        );
  }

  static TextStyle emptyMessageStyle(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
          fontSize: 14,
          height: 1.45,
          color: context.appColors.textSecondary,
        );
  }
}
