import 'package:expense_tracker/style/app_theme.dart';
import 'package:flutter/material.dart';

class CustomDropdownButtonFormField<T> extends StatelessWidget {
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final void Function(T?)? onChanged;
  final String? label;
  final String? hintText;
  final String? Function(T?)? validator;

  final borderRadius = 40.0;

  const CustomDropdownButtonFormField({
    super.key,
    required this.items,
    this.value,
    this.onChanged,
    this.label,
    this.hintText,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 5,
      children: [
        if (label != null)
          Text(
            label!,
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        DropdownButtonFormField<T>(
          initialValue: value,
          items: items,
          onChanged: onChanged,
          validator: validator,
          style: textTheme.bodyLarge,
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: colors.primary,
          ),
          decoration: InputDecoration(
            isDense: true,
            hintText: hintText,
            hintStyle: textTheme.bodyMedium?.copyWith(
              color: colors.textSecondary.withAlpha(150),
            ),
            filled: true,
            fillColor: colors.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: colors.primary, width: 2),
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: colors.primary, width: 2),
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: colors.expense, width: 2),
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),
        ),
      ],
    );
  }
}
