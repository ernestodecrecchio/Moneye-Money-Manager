import 'package:expense_tracker/core/presentation/common/amount_keyboard/amount_keyboard.dart';
import 'package:flutter/material.dart';

/// Host that shows [AmountKeyboard] when an [AmountTextField] is focused.
///
/// The keyboard is drawn in the root [Overlay] (on top of page chrome) and
/// injects [MediaQuery.viewInsets] so layouts behave like the system keyboard.
class AmountKeyboardScope extends StatefulWidget {
  final Widget child;
  final String? doneLabel;

  const AmountKeyboardScope({
    super.key,
    required this.child,
    this.doneLabel,
  });

  static AmountKeyboardScopeState? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_AmountKeyboardScopeInherited>()
        ?.scope;
  }

  @override
  State<AmountKeyboardScope> createState() => AmountKeyboardScopeState();
}

class _AmountKeyboardScopeInherited extends InheritedWidget {
  final AmountKeyboardScopeState scope;

  const _AmountKeyboardScopeInherited({
    required this.scope,
    required super.child,
  });

  @override
  bool updateShouldNotify(_AmountKeyboardScopeInherited oldWidget) {
    return scope != oldWidget.scope;
  }
}

class AmountKeyboardScopeState extends State<AmountKeyboardScope> {
  final ValueNotifier<int> keyboardRevision = ValueNotifier(0);
  final OverlayPortalController _portalController = OverlayPortalController();

  double _keyboardHeight = 0;
  bool _portalUpdateScheduled = false;

  TextEditingController? _activeController;
  FocusNode? _activeFocusNode;
  VoidCallback? _onDone;

  bool get isKeyboardVisible =>
      _activeController != null && (_activeFocusNode?.hasFocus ?? false);

  /// Bottom inset applied while the keyboard is open (for [MediaQuery]).
  double get keyboardInset => isKeyboardVisible ? _keyboardHeight : 0;

  void _schedulePortalUpdate() {
    keyboardRevision.value++;
    if (_portalUpdateScheduled) return;
    _portalUpdateScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _portalUpdateScheduled = false;
      if (mounted) _syncPortal();
    });
  }

  void _setKeyboardHeight(double height) {
    if (_keyboardHeight == height) return;
    setState(() => _keyboardHeight = height);
    keyboardRevision.value++;
  }

  void attach({
    required TextEditingController controller,
    required FocusNode focusNode,
    VoidCallback? onDone,
  }) {
    if (_activeFocusNode != null && _activeFocusNode != focusNode) {
      _activeFocusNode!.removeListener(_handleFocusChange);
    }

    _activeController = controller;
    _activeFocusNode = focusNode;
    _onDone = onDone;

    focusNode.removeListener(_handleFocusChange);
    focusNode.addListener(_handleFocusChange);

    _schedulePortalUpdate();
  }

  void detach({
    required TextEditingController controller,
    required FocusNode focusNode,
  }) {
    if (_activeController != controller || _activeFocusNode != focusNode) {
      return;
    }
    focusNode.removeListener(_handleFocusChange);
    _activeController = null;
    _activeFocusNode = null;
    _onDone = null;
    _schedulePortalUpdate();
  }

  void _handleFocusChange() {
    if (_activeFocusNode?.hasFocus != true) {
      final controller = _activeController;
      final focusNode = _activeFocusNode;
      if (controller != null && focusNode != null) {
        detach(controller: controller, focusNode: focusNode);
      }
    } else {
      _schedulePortalUpdate();
    }
  }

  void _dismissKeyboard() {
    _activeFocusNode?.unfocus();
  }

  void _syncPortal() {
    final shouldShow = isKeyboardVisible && _activeController != null;
    if (shouldShow) {
      if (!_portalController.isShowing) {
        _portalController.show();
      }
    } else {
      if (_portalController.isShowing) {
        _portalController.hide();
      }
      if (_keyboardHeight != 0) {
        setState(() => _keyboardHeight = 0);
      }
    }
  }

  Widget _buildOverlay(BuildContext context) {
    final scopeContext = this.context;
    final theme = Theme.of(scopeContext);

    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: _MeasureChildSize(
        onSizeChanged: _setKeyboardHeight,
        child: Theme(
          data: theme,
          child: Material(
            elevation: 8,
            color: theme.scaffoldBackgroundColor,
            child: AmountKeyboard(
              controller: _activeController!,
              doneLabel: widget.doneLabel,
              onDone: () {
                _onDone?.call();
                _dismissKeyboard();
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _activeFocusNode?.removeListener(_handleFocusChange);
    if (_portalController.isShowing) {
      _portalController.hide();
    }
    keyboardRevision.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final inset = keyboardInset;

    final child = inset > 0
        ? MediaQuery(
            data: mediaQuery.copyWith(
              viewInsets: mediaQuery.viewInsets.copyWith(
                bottom: mediaQuery.viewInsets.bottom + inset,
              ),
            ),
            child: widget.child,
          )
        : widget.child;

    return _AmountKeyboardScopeInherited(
      scope: this,
      child: _RootOverlayPortal(
        controller: _portalController,
        overlayChildBuilder: _buildOverlay,
        child: child,
      ),
    );
  }
}

/// Root overlay when supported; falls back to the nearest [Overlay] on older SDKs.
class _RootOverlayPortal extends StatelessWidget {
  final OverlayPortalController controller;
  final WidgetBuilder overlayChildBuilder;
  final Widget child;

  const _RootOverlayPortal({
    required this.controller,
    required this.overlayChildBuilder,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return OverlayPortal(
      overlayLocation: OverlayChildLocation.rootOverlay,
      controller: controller,
      overlayChildBuilder: overlayChildBuilder,
      child: child,
    );
  }
}

/// Reports the laid-out size of [child] after each frame.
class _MeasureChildSize extends StatefulWidget {
  final Widget child;
  final ValueChanged<double> onSizeChanged;

  const _MeasureChildSize({
    required this.child,
    required this.onSizeChanged,
  });

  @override
  State<_MeasureChildSize> createState() => _MeasureChildSizeState();
}

class _MeasureChildSizeState extends State<_MeasureChildSize> {
  double? _lastHeight;

  void _reportSize() {
    final height = context.size?.height;
    if (height == null || height == _lastHeight) return;
    _lastHeight = height;
    widget.onSizeChanged(height);
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _reportSize();
    });
    return widget.child;
  }
}
