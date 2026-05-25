import 'dart:async';

import 'package:expense_tracker/core/presentation/common/amount_keyboard/amount_keyboard_input.dart';
import 'package:expense_tracker/core/presentation/common/amount_keyboard/amount_keyboard_scope.dart';
import 'package:expense_tracker/core/presentation/common/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
  static const _scrollAlignment = 0.2;
  static const _scrollMargin = 16.0;

  final GlobalKey _visibilityKey = GlobalKey();
  late FocusNode _focusNode;
  bool _ownsFocusNode = false;
  AmountKeyboardScopeState? _attachedScope;
  Timer? _scrollRetryTimer;

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
      _cancelScrollRetry();
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

  void _handlePointerDown(PointerDownEvent event) {
    if (!_focusNode.hasFocus) return;
    _scheduleScrollIntoView();
  }

  EdgeInsets _scrollPadding(BuildContext context) {
    final scope = AmountKeyboardScope.maybeOf(context);
    if (scope == null) {
      return const EdgeInsets.all(20);
    }
    final keyboardHeight = AmountKeyboardMetrics.fullHeight(context);
    return EdgeInsets.fromLTRB(20, 20, 20, keyboardHeight + _scrollMargin);
  }

  void _cancelScrollRetry() {
    _scrollRetryTimer?.cancel();
    _scrollRetryTimer = null;
  }

  void _scheduleScrollIntoView() {
    _cancelScrollRetry();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _performScrollIntoView(animate: true);
    });
    _scrollRetryTimer = Timer(const Duration(milliseconds: 280), () {
      _performScrollIntoView(animate: false);
    });
  }

  void _performScrollIntoView({required bool animate}) {
    if (!mounted || !_focusNode.hasFocus) return;

    final targetContext = _visibilityKey.currentContext;
    if (targetContext == null) return;

    final renderObject = targetContext.findRenderObject();
    if (renderObject is! RenderBox || !renderObject.hasSize) {
      _scrollWithEnsureVisible(targetContext, animate: animate);
      return;
    }

    final scrollable = Scrollable.maybeOf(targetContext);
    final position = scrollable?.position;
    if (position == null) {
      _scrollWithEnsureVisible(targetContext, animate: animate);
      return;
    }

    final viewport = RenderAbstractViewport.of(renderObject);
    final reveal = viewport.getOffsetToReveal(renderObject, _scrollAlignment);
    final targetOffset = reveal.offset.clamp(
      position.minScrollExtent,
      position.maxScrollExtent,
    );

    if (animate) {
      position.animateTo(
        targetOffset,
        duration: const Duration(milliseconds: 250),
        curve: Curves.fastOutSlowIn,
      );
    } else if ((position.pixels - targetOffset).abs() > 0.5) {
      position.jumpTo(targetOffset);
    }
  }

  void _scrollWithEnsureVisible(BuildContext targetContext,
      {required bool animate}) {
    Scrollable.ensureVisible(
      targetContext,
      duration: animate
          ? const Duration(milliseconds: 250)
          : Duration.zero,
      curve: Curves.fastOutSlowIn,
      alignment: _scrollAlignment,
      alignmentPolicy: ScrollPositionAlignmentPolicy.explicit,
    );
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
      onPresented: _scheduleScrollIntoView,
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
    _cancelScrollRetry();
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
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: _handlePointerDown,
      child: KeyedSubtree(
        key: _visibilityKey,
        child: CustomTextField(
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
          scrollPadding: _scrollPadding(context),
        ),
      ),
    );
  }
}
