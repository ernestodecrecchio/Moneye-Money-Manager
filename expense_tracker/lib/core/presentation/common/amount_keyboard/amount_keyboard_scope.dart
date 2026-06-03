import 'package:flutter/material.dart';

/// Supplies an optional [doneLabel] for [AmountTextField] widgets below.
///
/// Keyboard presentation and [MediaQuery.viewInsets] are handled globally by
/// [AmountKeyboardHost] and [AmountKeyboardController].
class AmountKeyboardScope extends StatelessWidget {
  final Widget child;
  final String? doneLabel;

  const AmountKeyboardScope({
    super.key,
    required this.child,
    this.doneLabel,
  });

  static String? doneLabelOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_AmountKeyboardScopeInherited>()
        ?.doneLabel;
  }

  @override
  Widget build(BuildContext context) {
    return _AmountKeyboardScopeInherited(
      doneLabel: doneLabel,
      child: child,
    );
  }
}

class _AmountKeyboardScopeInherited extends InheritedWidget {
  final String? doneLabel;

  const _AmountKeyboardScopeInherited({
    required this.doneLabel,
    required super.child,
  });

  @override
  bool updateShouldNotify(_AmountKeyboardScopeInherited oldWidget) {
    return doneLabel != oldWidget.doneLabel;
  }
}
