import 'package:expense_tracker/style.dart';
import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final String text;
  final Future<void> Function()? onPressed;
  final bool isLoading;

  const CustomElevatedButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: double.infinity,
      margin: const EdgeInsets.only(top: 10),
      child: FilledButton(
        onPressed: isLoading ? null : onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: CustomColors.darkBlue,
          foregroundColor: Colors.white,
          disabledBackgroundColor: CustomColors.darkBlue,
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
