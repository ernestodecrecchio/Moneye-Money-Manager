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

class AmountKeyboardScopeState extends State<AmountKeyboardScope>
    with SingleTickerProviderStateMixin {
  final ValueNotifier<int> keyboardRevision = ValueNotifier(0);
  final OverlayPortalController _portalController = OverlayPortalController();

  late final AnimationController _animationController;
  late final Animation<double> _curveAnimation;

  TextEditingController? _activeController;
  FocusNode? _activeFocusNode;
  VoidCallback? _onDone;

  bool get isKeyboardVisible =>
      _activeController != null && (_activeFocusNode?.hasFocus ?? false);

  /// Bottom inset applied while the keyboard is open (for [MediaQuery]).
  /// Animates in sync with the slide-up transition.
  double get keyboardInset {
    if (_activeController == null) return 0;

    final bottomSafeArea = MediaQuery.of(context).padding.bottom;
    final hasDoneButton = _onDone != null;
    final numRows = hasDoneButton ? 5 : 4;
    const rowHeight = 52.0;
    const spacing = 8.0;
    const padding = 16.0; // 8 top + 8 bottom

    final fullHeight = (numRows * rowHeight) +
        ((numRows - 1) * spacing) +
        padding +
        bottomSafeArea;

    return fullHeight * _curveAnimation.value;
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250), // Matches system keyboard speed
    );
    _curveAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.fastOutSlowIn, // iOS/Android standard physical curve
      reverseCurve: Curves.fastOutSlowIn.flipped,
    );
    _animationController.addListener(_onAnimationTick);
  }

  void _onAnimationTick() {
    setState(() {});
    keyboardRevision.value++;
  }

  void attach({
    required TextEditingController controller,
    required FocusNode focusNode,
    VoidCallback? onDone,
  }) {
    setState(() {
      _activeController = controller;
      _activeFocusNode = focusNode;
      _onDone = onDone;
    });

    _portalController.show();
    _animationController.forward();
    keyboardRevision.value++;
  }

  void detach({
    required TextEditingController controller,
    required FocusNode focusNode,
  }) {
    if (_activeController != controller || _activeFocusNode != focusNode) {
      return;
    }

    // Smoothly slide down first
    _animationController.reverse().then((_) {
      if (!mounted) return;
      // After it slides down completely, clean up the state and hide the portal
      if (_activeController == controller && _activeFocusNode == focusNode) {
        setState(() {
          _activeController = null;
          _activeFocusNode = null;
          _onDone = null;
        });
        _portalController.hide();
        keyboardRevision.value++;
      }
    });
  }

  void _dismissKeyboard() {
    _activeFocusNode?.unfocus();
  }

  void _handleDonePressed() {
    _onDone?.call();
    _dismissKeyboard();
  }

  Widget _buildOverlay(BuildContext context) {
    if (_activeController == null) return const SizedBox.shrink();

    final scopeContext = this.context;
    final theme = Theme.of(scopeContext);

    final bottomSafeArea = MediaQuery.of(scopeContext).padding.bottom;
    final hasDoneButton = _onDone != null;
    final numRows = hasDoneButton ? 5 : 4;
    const rowHeight = 52.0;
    const spacing = 8.0;
    const padding = 16.0; // 8 top + 8 bottom

    final fullHeight = (numRows * rowHeight) +
        ((numRows - 1) * spacing) +
        padding +
        bottomSafeArea;

    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: AnimatedBuilder(
        animation: _curveAnimation,
        builder: (context, child) {
          final translationY = fullHeight * (1.0 - _curveAnimation.value);
          return Transform.translate(
            offset: Offset(0, translationY),
            child: child,
          );
        },
        child: GestureDetector(
          onTap: () {}, // Swallows taps on the keyboard background to prevent unfocus
          behavior: HitTestBehavior.opaque,
          child: SizedBox(
            height: fullHeight,
            child: Theme(
              data: theme,
              child: Material(
                elevation: 8,
                color: theme.scaffoldBackgroundColor,
                child: AmountKeyboard(
                  controller: _activeController!,
                  doneLabel: widget.doneLabel,
                  onDone: _onDone != null ? _handleDonePressed : null,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
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
