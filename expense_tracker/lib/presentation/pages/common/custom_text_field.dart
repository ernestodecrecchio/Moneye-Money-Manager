import 'package:expense_tracker/style/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? label;
  final String? hintText;
  final IconData? icon;
  final Function()? onTap;
  final Function(String newText)? onTextChanged;
  final List<TextInputFormatter>? textInputFormatters;
  final TextInputType? keyboardType;
  final bool readOnly;
  final String? Function(String?)? validator;
  final int? maxLines;
  final FocusNode? focusNode;

  final borderRadius = 40.0;

  const CustomTextField({
    super.key,
    this.controller,
    this.label,
    this.hintText,
    this.icon,
    this.onTap,
    this.onTextChanged,
    this.textInputFormatters,
    this.keyboardType,
    this.readOnly = false,
    this.validator,
    this.maxLines = 1,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label != null)
            Text(
              label!,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          const SizedBox(
            height: 5,
          ),
          TextFormField(
            textCapitalization: TextCapitalization.sentences,
            focusNode: focusNode,
            onEditingComplete: () => FocusScope.of(context).nextFocus(),
            readOnly: readOnly,
            controller: controller,
            validator: validator,
            onTap: onTap,
            maxLines: maxLines,
            inputFormatters: [...?textInputFormatters],
            keyboardType: keyboardType,
            style: textTheme.bodyLarge,
            onChanged: onTextChanged != null
                ? (newText) => onTextChanged!(newText)
                : null,
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
              suffixIcon: icon != null
                  ? Icon(
                      icon,
                      color: colors.primary,
                    )
                  : null,
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
      ),
    );
  }
}
