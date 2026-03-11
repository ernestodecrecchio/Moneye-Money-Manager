import 'package:expense_tracker/style/app_theme.dart';
import 'package:flutter/material.dart';

enum CustomElevatedButtonMode { light, dark }

class CustomElevatedButton extends StatelessWidget {
  final String text;
  final Future<void> Function()? onPressed;
  final bool isLoading;
  final CustomElevatedButtonMode mode;

  const CustomElevatedButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.isLoading,
    this.mode = CustomElevatedButtonMode.dark,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textTheme = Theme.of(context).textTheme;

    final backgroundColor = mode == CustomElevatedButtonMode.dark
        ? colors.secondary
        : colors.scaffoldBackground;
    final foregroundColor = mode == CustomElevatedButtonMode.dark
        ? colors.onSecondary
        : colors.secondary;

    return SizedBox(
      height: 50,
      width: double.infinity,
      child: FilledButton(
        onPressed: isLoading ? null : onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          disabledBackgroundColor: backgroundColor.withValues(alpha: 0.5),
          disabledForegroundColor: colors.textSecondary,
        ),
        child: isLoading
            ? const CircularProgressIndicator()
            : Text(
                text,
                style: textTheme.titleMedium?.copyWith(
                  color: foregroundColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
      ),
    );
  }
}
