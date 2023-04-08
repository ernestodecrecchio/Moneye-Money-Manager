import 'package:expense_tracker/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? label;
  final String hintText;
  final IconData? icon;
  final Function()? onTap;
  final Function(String newText)? onTextChanged;
  final List<TextInputFormatter>? textInputFormatters;
  final TextInputType? keyboardType;
  final bool readOnly;
  final String? Function(String?)? validator;
  final int? maxLines;

  final borderRadius = 40.0;

  const CustomTextField({
    super.key,
    required this.controller,
    this.label,
    required this.hintText,
    this.icon,
    this.onTap,
    this.onTextChanged,
    this.textInputFormatters,
    this.keyboardType,
    this.readOnly = false,
    this.validator,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label != null)
            Text(
              label!,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: CustomColors.lightBlack,
              ),
            ),
          const SizedBox(
            height: 5,
          ),
          TextFormField(
            onEditingComplete: () => FocusScope.of(context).nextFocus(),
            readOnly: readOnly,
            controller: controller,
            validator: validator,
            onTap: onTap,
            maxLines: maxLines,
            inputFormatters: [...?textInputFormatters],
            keyboardType: keyboardType,
            onChanged: onTextChanged != null
                ? (newText) => onTextChanged!(newText)
                : null,
            decoration: InputDecoration(
              isDense: true,
              hintText: hintText,
              hintStyle: TextStyle(fontSize: 16, color: Colors.grey.shade400),
              filled: true,
              fillColor: CustomColors.lightBlue,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: const BorderSide(
                  width: 0,
                  style: BorderStyle.none,
                ),
              ),
              suffixIcon: icon != null
                  ? Icon(
                      icon,
                      color: CustomColors.blue,
                    )
                  : null,
              focusedBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(color: CustomColors.blue, width: 2),
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(color: CustomColors.blue, width: 2),
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.red, width: 2),
                borderRadius: BorderRadius.circular(borderRadius),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
