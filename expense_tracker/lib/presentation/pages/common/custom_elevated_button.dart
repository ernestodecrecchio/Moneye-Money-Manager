import 'package:expense_tracker/style.dart';
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
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: FilledButton(
        onPressed: isLoading ? null : onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: mode == CustomElevatedButtonMode.dark
              ? CustomColors.darkBlue
              : Colors.white,
          foregroundColor: mode == CustomElevatedButtonMode.dark
              ? Colors.white
              : CustomColors.darkBlue,
          disabledBackgroundColor: mode == CustomElevatedButtonMode.dark
              ? CustomColors.darkBlue
              : Colors.white,
          disabledForegroundColor: Colors.grey,
        ),
        child: isLoading
            ? const CircularProgressIndicator()
            : Text(
                text,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }
}
