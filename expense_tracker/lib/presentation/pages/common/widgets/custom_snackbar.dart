import 'package:expense_tracker/style/app_theme.dart';
import 'package:flutter/material.dart';

enum SnackBarType { success, error, info }

class CustomSnackBar {
  static void show(
    BuildContext context, {
    required String message,
    SnackBarType type = SnackBarType.info,
    String? actionLabel,
    VoidCallback? onActionPressed,
    Duration duration = const Duration(seconds: 4),
  }) {
    final colors = context.appColors;

    Color backgroundColor;
    IconData icon;

    switch (type) {
      case SnackBarType.success:
        backgroundColor = colors.income;
        icon = Icons.check_circle_rounded;
        break;
      case SnackBarType.error:
        backgroundColor = colors.expense;
        icon = Icons.error_rounded;
        break;
      case SnackBarType.info:
        backgroundColor = colors.primary;
        icon = Icons.info_rounded;
        break;
    }

    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          spacing: 12,
          children: [
            Icon(
              icon,
              color: colors.onPrimary,
              size: 24,
            ),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  color: colors.onPrimary,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        persist: false,
        duration: duration,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        elevation: 4,
        action: actionLabel != null && onActionPressed != null
            ? SnackBarAction(
                label: actionLabel,
                textColor: colors.onPrimary,
                onPressed: onActionPressed,
              )
            : null,
      ),
    );
  }
}
