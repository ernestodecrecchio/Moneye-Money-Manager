import 'package:expense_tracker/core/presentation/common/amount_keyboard/amount_keyboard_input.dart';
import 'package:expense_tracker/core/presentation/common/amount_keyboard/amount_keyboard_scope.dart';
import 'package:expense_tracker/core/presentation/common/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Amount entry field that uses the custom [AmountKeyboard] instead of the
/// system keyboard. Must be placed under an [AmountKeyboardScope].
class AmountTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? label;
  final String? hintText;
  final String? infoText;
  final IconData? icon;
  final Function(String newText)? onTextChanged;
  final String? Function(String?)? validator;
  final Widget? prefix;
  final FocusNode? focusNode;
  final VoidCallback? onDone;

  const AmountTextField({
    super.key,
    this.controller,
    this.label,
    this.hintText,
    this.infoText,
    this.icon,
    this.onTextChanged,
    this.validator,
    this.prefix,
    this.focusNode,
    this.onDone,
  });

  @override
  State<AmountTextField> createState() => _AmountTextFieldState();
}

class _AmountTextFieldState extends State<AmountTextField> {
  late FocusNode _focusNode;
  bool _ownsFocusNode = false;
  AmountKeyboardScopeState? _attachedScope;

  static final _amountFormatters = <TextInputFormatter>[
    FilteringTextInputFormatter.allow(AmountKeyboardInput.allowedPattern),
  ];

  @override
  void initState() {
    super.initState();
    if (widget.focusNode != null) {
      _focusNode = widget.focusNode!;
    } else {
      _focusNode = FocusNode();
      _ownsFocusNode = true;
    }
    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void didUpdateWidget(AmountTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.focusNode != widget.focusNode) {
      oldWidget.focusNode?.removeListener(_onFocusChanged);
      _detachFromScope();
      if (_ownsFocusNode) {
        _focusNode.dispose();
      }
      if (widget.focusNode != null) {
        _focusNode = widget.focusNode!;
        _ownsFocusNode = false;
      } else {
        _focusNode = FocusNode();
        _ownsFocusNode = true;
      }
      _focusNode.addListener(_onFocusChanged);
    }
  }

  void _onFocusChanged() {
    if (!_focusNode.hasFocus) {
      _detachFromScope();
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _focusNode.hasFocus) {
        _attachToScope();
      }
    });
  }

  void _handleTap() {
    _focusNode.requestFocus();
    _attachToScope();
  }

  void _attachToScope() {
    if (!mounted) return;
    final scope = AmountKeyboardScope.maybeOf(context);
    final controller = widget.controller;
    if (scope == null || controller == null) return;
    _attachedScope = scope;
    scope.attach(
      controller: controller,
      focusNode: _focusNode,
      onDone: widget.onDone,
    );
  }

  void _detachFromScope() {
    final scope = _attachedScope ?? AmountKeyboardScope.maybeOf(context);
    final controller = widget.controller;
    if (scope == null || controller == null) return;
    scope.detach(controller: controller, focusNode: _focusNode);
    if (_attachedScope == scope) {
      _attachedScope = null;
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChanged);
    final scope = _attachedScope;
    final controller = widget.controller;
    if (scope != null && controller != null) {
      scope.detach(controller: controller, focusNode: _focusNode);
    }
    if (_ownsFocusNode) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: widget.controller,
      label: widget.label,
      hintText: widget.hintText,
      infoText: widget.infoText,
      icon: widget.icon,
      onTextChanged: widget.onTextChanged,
      validator: widget.validator,
      prefix: widget.prefix,
      focusNode: _focusNode,
      readOnly: true,
      enableInteractiveSelection: true,
      onTap: _handleTap,
      showCursor: true,
      keyboardType: TextInputType.none,
      textInputFormatters: _amountFormatters,
    );
  }
}
