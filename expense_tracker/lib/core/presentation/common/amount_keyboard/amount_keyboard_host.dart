import 'package:expense_tracker/core/presentation/common/amount_keyboard/amount_keyboard_controller.dart';
import 'package:flutter/material.dart';

/// Installs the global [AmountKeyboardController] and root navigator overlay.
///
/// Pair with [MaterialApp.builder] using [AmountKeyboardController.viewInset]
/// so bottom sheets receive the same [MediaQuery.viewInsets] updates as with
/// the system keyboard.
class AmountKeyboardHost extends StatefulWidget {
  final Widget child;
  final GlobalKey<NavigatorState> navigatorKey;

  const AmountKeyboardHost({
    super.key,
    required this.child,
    required this.navigatorKey,
  });

  @override
  State<AmountKeyboardHost> createState() => _AmountKeyboardHostState();
}

class _AmountKeyboardHostState extends State<AmountKeyboardHost>
    with SingleTickerProviderStateMixin {
  late final AmountKeyboardController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AmountKeyboardController(vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _controller.installOverlay(widget.navigatorKey);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

/// Merges the custom keyboard inset into [MediaQuery], like the platform does
/// for the system keyboard. Use as [MaterialApp.builder].
Widget amountKeyboardMediaQueryBuilder(BuildContext context, Widget? child) {
  final controller = AmountKeyboardController.maybeInstance;
  if (controller == null || child == null) {
    return child ?? const SizedBox.shrink();
  }

  return ListenableBuilder(
    listenable: controller,
    builder: (context, child) {
      final mediaQuery = MediaQuery.of(context);
      final inset = controller.viewInset;
      return MediaQuery(
        data: mediaQuery.copyWith(
          viewInsets: mediaQuery.viewInsets.copyWith(
            bottom: mediaQuery.viewInsets.bottom + inset,
          ),
        ),
        child: child!,
      );
    },
    child: child,
  );
}

/// Effective bottom inset for modal routes (platform + custom keyboard).
///
/// Modal bottom sheets are laid out from the full screen height and do not
/// shift automatically for [MediaQuery.viewInsets]; wrap sheet content with
/// [AmountKeyboardModalInset].
double amountKeyboardBottomInset(BuildContext context) {
  final mediaQueryBottom = MediaQuery.viewInsetsOf(context).bottom;
  final customInset = AmountKeyboardController.maybeInstance?.viewInset ?? 0;
  return mediaQueryBottom > customInset ? mediaQueryBottom : customInset;
}

/// Shows a centered dialog that stays fixed when the custom amount keyboard
/// opens. Unlike [showDialog], the route does not apply [MediaQuery.viewInsets]
/// padding, so the keyboard draws over the dialog instead of pushing it up.
Future<T?> showAmountKeyboardOverlayDialog<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool barrierDismissible = true,
  Color? barrierColor,
  Duration transitionDuration = const Duration(milliseconds: 200),
}) {
  return showGeneralDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: barrierColor ?? Colors.black54,
    transitionDuration: transitionDuration,
    pageBuilder: (dialogContext, animation, secondaryAnimation) {
      return Align(
        alignment: Alignment.center,
        child: builder(dialogContext),
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: CurvedAnimation(
          parent: animation,
          curve: Curves.easeOut,
        ),
        child: child,
      );
    },
  );
}

/// Lifts [child] when the amount keyboard (or system keyboard) is visible.
class AmountKeyboardModalInset extends StatelessWidget {
  final Widget child;

  const AmountKeyboardModalInset({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final controller = AmountKeyboardController.maybeInstance;
    if (controller == null) {
      return AnimatedPadding(
        padding: MediaQuery.viewInsetsOf(context),
        duration: const Duration(milliseconds: 250),
        curve: Curves.fastOutSlowIn,
        child: child,
      );
    }

    return ListenableBuilder(
      listenable: controller,
      builder: (context, child) {
        return AnimatedPadding(
          padding: EdgeInsets.only(bottom: amountKeyboardBottomInset(context)),
          duration: const Duration(milliseconds: 250),
          curve: Curves.fastOutSlowIn,
          child: child,
        );
      },
      child: child,
    );
  }
}
