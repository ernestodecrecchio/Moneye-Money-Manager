import 'package:expense_tracker/core/presentation/common/amount_keyboard/amount_keyboard_controller.dart';
import 'package:flutter/material.dart';

/// Bottom chrome (e.g. save button) that hides while the amount keyboard is open,
/// matching system-keyboard behaviour.
class AmountKeyboardChrome extends StatelessWidget {
  final Widget child;

  const AmountKeyboardChrome({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final keyboard = AmountKeyboardController.maybeInstance;
    if (keyboard == null) {
      return child;
    }

    return ListenableBuilder(
      listenable: keyboard,
      builder: (context, _) {
        if (keyboard.isKeyboardVisible) {
          return const SizedBox.shrink();
        }
        return child;
      },
    );
  }
}
