import 'package:expense_tracker/core/presentation/common/amount_keyboard/amount_keyboard_scope.dart';
import 'package:flutter/material.dart';

/// Bottom chrome (e.g. save button) that hides while the amount keyboard is open,
/// matching system-keyboard behaviour.
class AmountKeyboardChrome extends StatelessWidget {
  final Widget child;

  const AmountKeyboardChrome({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final scope = AmountKeyboardScope.maybeOf(context);
    if (scope == null) {
      return child;
    }

    return ListenableBuilder(
      listenable: scope.keyboardRevision,
      builder: (context, _) {
        if (scope.isKeyboardVisible) {
          return const SizedBox.shrink();
        }
        return child;
      },
    );
  }
}
