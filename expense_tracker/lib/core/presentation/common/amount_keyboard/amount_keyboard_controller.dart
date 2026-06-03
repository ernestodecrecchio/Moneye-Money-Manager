import 'package:expense_tracker/core/presentation/common/amount_keyboard/amount_keyboard.dart';
import 'package:expense_tracker/core/presentation/common/amount_keyboard/amount_keyboard_metrics.dart';
import 'package:flutter/material.dart';

/// Global amount keyboard state, mirroring how the engine exposes the system
/// keyboard via [MediaQuery.viewInsets] and paints above routes.
class AmountKeyboardController extends ChangeNotifier {
  AmountKeyboardController({required TickerProvider vsync}) {
    _instance = this;
    _animationController = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 250),
    );
    _curveAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.fastOutSlowIn,
      reverseCurve: Curves.fastOutSlowIn.flipped,
    );
    _animationController.addListener(_handleAnimationTick);
  }

  static AmountKeyboardController? _instance;

  static AmountKeyboardController get instance {
    final controller = _instance;
    assert(controller != null, 'AmountKeyboardHost is not mounted');
    return controller!;
  }

  static AmountKeyboardController? get maybeInstance => _instance;

  late final AnimationController _animationController;
  late final CurvedAnimation _curveAnimation;

  OverlayEntry? _overlayEntry;
  GlobalKey<NavigatorState>? _navigatorKey;

  TextEditingController? _activeController;
  FocusNode? _activeFocusNode;
  VoidCallback? _onDone;
  String? _doneLabel;

  /// Bumped on each attach/detach so stale animation callbacks are ignored.
  int _operationGeneration = 0;

  final ValueNotifier<int> keyboardRevision = ValueNotifier(0);

  bool get isKeyboardVisible =>
      _activeController != null && (_activeFocusNode?.hasFocus ?? false);

  /// Animated bottom inset merged into [MediaQuery.viewInsets] (like the OS).
  double get viewInset {
    final context = _navigatorKey?.currentContext;
    if (context == null || _activeController == null) return 0;
    return AmountKeyboardMetrics.fullHeight(context) * _curveAnimation.value;
  }

  void _handleAnimationTick() {
    notifyListeners();
    keyboardRevision.value++;
    _overlayEntry?.markNeedsBuild();
  }

  void installOverlay(GlobalKey<NavigatorState> navigatorKey) {
    _navigatorKey = navigatorKey;
  }

  /// Inserts (or re-inserts) the keyboard entry at the top of the root overlay,
  /// above modal routes and bottom sheets — same stacking as the system keyboard.
  void _ensureOverlayOnTop() {
    final overlay = _navigatorKey?.currentState?.overlay;
    if (overlay == null) return;

    final entry = _overlayEntry ??= OverlayEntry(builder: _buildOverlay);
    if (entry.mounted) {
      entry.remove();
    }
    overlay.insert(entry);
  }

  void _removeOverlayIfMounted() {
    final entry = _overlayEntry;
    if (entry != null && entry.mounted) {
      entry.remove();
    }
  }

  void attach({
    required TextEditingController controller,
    required FocusNode focusNode,
    String? doneLabel,
    VoidCallback? onDone,
    VoidCallback? onPresented,
  }) {
    if (_activeController == controller &&
        _activeFocusNode == focusNode &&
        _animationController.status != AnimationStatus.dismissed) {
      ++_operationGeneration;
      _ensureOverlayOnTop();
      if (_animationController.status != AnimationStatus.completed) {
        _animationController.forward();
      }
      return;
    }

    final generation = ++_operationGeneration;
    _activeController = controller;
    _activeFocusNode = focusNode;
    _doneLabel = doneLabel;
    _onDone = onDone;

    _ensureOverlayOnTop();
    _animationController.forward().then((_) {
      if (generation != _operationGeneration) return;
      if (_activeController == controller &&
          _activeFocusNode == focusNode &&
          focusNode.hasFocus) {
        onPresented?.call();
      }
    });
    notifyListeners();
  }

  void detach({
    required TextEditingController controller,
    required FocusNode focusNode,
  }) {
    if (_activeController != controller || _activeFocusNode != focusNode) {
      return;
    }

    final generation = ++_operationGeneration;
    _animationController.reverse().then((_) {
      if (generation != _operationGeneration) return;
      if (_activeController != controller || _activeFocusNode != focusNode) {
        return;
      }
      _activeController = null;
      _activeFocusNode = null;
      _onDone = null;
      _doneLabel = null;
      _removeOverlayIfMounted();
      notifyListeners();
      keyboardRevision.value++;
    });
  }

  void dismiss() {
    _activeFocusNode?.unfocus();
  }

  void _handleDonePressed() {
    _onDone?.call();
    dismiss();
  }

  Widget _buildOverlay(BuildContext context) {
    if (_activeController == null) {
      return const SizedBox.shrink();
    }

    final scopeContext = _navigatorKey!.currentContext!;
    final theme = Theme.of(scopeContext);
    final fullHeight = AmountKeyboardMetrics.fullHeight(scopeContext);

    return MediaQuery(
      data: MediaQuery.of(scopeContext),
      child: Theme(
        data: theme,
        child: ExcludeFocus(
          child: Stack(
            fit: StackFit.expand,
            children: [
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: AnimatedBuilder(
                  animation: _curveAnimation,
                  builder: (context, child) {
                    final translationY =
                        fullHeight * (1.0 - _curveAnimation.value);
                    return Transform.translate(
                      offset: Offset(0, translationY),
                      child: child,
                    );
                  },
                  child: GestureDetector(
                    onTap: () {},
                    behavior: HitTestBehavior.opaque,
                    child: SizedBox(
                      height: fullHeight,
                      child: Material(
                        elevation: 8,
                        color: theme.scaffoldBackgroundColor,
                        child: AmountKeyboard(
                          controller: _activeController!,
                          doneLabel: _doneLabel,
                          onDone: _handleDonePressed,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _removeOverlayIfMounted();
    _overlayEntry?.dispose();
    _overlayEntry = null;
    keyboardRevision.dispose();
    if (_instance == this) {
      _instance = null;
    }
    super.dispose();
  }
}
