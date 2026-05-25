import 'dart:async';
import 'package:expense_tracker/core/presentation/common/amount_keyboard/amount_keyboard_input.dart';
import 'package:expense_tracker/core/style/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Revolut-style numeric keyboard for monetary amount entry.
class AmountKeyboard extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback? onDone;
  final String? doneLabel;

  const AmountKeyboard({
    super.key,
    required this.controller,
    this.onDone,
    this.doneLabel,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textTheme = Theme.of(context).textTheme;

    return Material(
      color: colors.scaffoldBackground,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _KeyRow(
                children: [
                  _DigitKey(label: '1', controller: controller),
                  _DigitKey(label: '2', controller: controller),
                  _DigitKey(label: '3', controller: controller),
                ],
              ),
              const SizedBox(height: 8),
              _KeyRow(
                children: [
                  _DigitKey(label: '4', controller: controller),
                  _DigitKey(label: '5', controller: controller),
                  _DigitKey(label: '6', controller: controller),
                ],
              ),
              const SizedBox(height: 8),
              _KeyRow(
                children: [
                  _DigitKey(label: '7', controller: controller),
                  _DigitKey(label: '8', controller: controller),
                  _DigitKey(label: '9', controller: controller),
                ],
              ),
              const SizedBox(height: 8),
              _KeyRow(
                children: [
                  _DecimalKey(controller: controller),
                  _DigitKey(label: '0', controller: controller),
                  _BackspaceKey(controller: controller),
                ],
              ),
              if (onDone != null) ...[
                const SizedBox(height: 8),
                _DoneKey(
                  label: doneLabel ?? 'Done',
                  onPressed: onDone!,
                  textStyle: textTheme.titleMedium,
                  colors: colors,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _KeyRow extends StatelessWidget {
  final List<Widget> children;

  const _KeyRow({required this.children});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < children.length; i++) ...[
          if (i > 0) const SizedBox(width: 8),
          Expanded(child: children[i]),
        ],
      ],
    );
  }
}

class _AmountKey extends StatefulWidget {
  final Widget child;
  final VoidCallback onPressed;
  final bool repeatWhileHeld;

  const _AmountKey({
    required this.child,
    required this.onPressed,
    this.repeatWhileHeld = false,
  });

  @override
  State<_AmountKey> createState() => _AmountKeyState();
}

class _AmountKeyState extends State<_AmountKey> {
  static const _pressInDuration = Duration(milliseconds: 35);
  static const _pressOutDuration = Duration(milliseconds: 25);
  static const _minPressDuration = Duration(milliseconds: 45);
  static const _repeatInitialDelay = Duration(milliseconds: 400);
  static const _repeatInterval = Duration(milliseconds: 60);

  bool _pressed = false;
  int _activePointers = 0;
  DateTime? _pressStartTime;
  Timer? _releaseTimer;
  Timer? _repeatTimer;

  void _setPressed(bool value) {
    if (_pressed == value) return;
    setState(() => _pressed = value);
  }

  void _firePressed({bool haptic = true}) {
    widget.onPressed();
    if (haptic) HapticFeedback.lightImpact();
  }

  void _startRepeat() {
    _stopRepeat();
    _firePressed();
    _repeatTimer = Timer(_repeatInitialDelay, () {
      if (!mounted) return;
      _repeatTimer = Timer.periodic(_repeatInterval, (_) {
        if (!mounted) return;
        _firePressed(haptic: false);
      });
    });
  }

  void _stopRepeat() {
    _repeatTimer?.cancel();
    _repeatTimer = null;
  }

  void _handlePointerDown(PointerDownEvent event) {
    if (_activePointers > 0) return;
    _activePointers = 1;
    _releaseTimer?.cancel();
    _pressStartTime = DateTime.now();
    _setPressed(true);
    if (widget.repeatWhileHeld) {
      _startRepeat();
    } else {
      _firePressed();
    }
  }

  void _handlePointerUp(PointerUpEvent event) {
    if (_activePointers == 0) return;
    _activePointers = 0;
    _stopRepeat();
    _releaseVisualPress();
  }

  void _handlePointerCancel(PointerCancelEvent event) {
    if (_activePointers == 0) return;
    _activePointers = 0;
    _stopRepeat();
    _releaseVisualPress();
  }

  void _releaseVisualPress() {
    final pressStart = _pressStartTime;
    _pressStartTime = null;
    if (pressStart == null) {
      _setPressed(false);
      return;
    }

    final elapsed = DateTime.now().difference(pressStart);
    if (elapsed < _minPressDuration) {
      final delay = _minPressDuration - elapsed;
      _releaseTimer = Timer(delay, () {
        if (mounted) _setPressed(false);
      });
    } else {
      _setPressed(false);
    }
  }

  @override
  void dispose() {
    _releaseTimer?.cancel();
    _stopRepeat();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Listener(
      behavior: HitTestBehavior.opaque,
      onPointerDown: _handlePointerDown,
      onPointerUp: _handlePointerUp,
      onPointerCancel: _handlePointerCancel,
      child: AnimatedScale(
        scale: _pressed ? 0.94 : 1.0,
        duration: _pressed ? _pressInDuration : _pressOutDuration,
        curve: _pressed ? Curves.easeOut : Curves.easeIn,
        child: Container(
          height: 52, // Explicitly lock the container's height to 52px so borders paint inside without expanding the key size!
          decoration: BoxDecoration(
            color: _pressed
                ? colors.fieldBackground.withAlpha(200)
                : colors.fieldBackground,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: _pressed
                  ? colors.primary.withAlpha(40)
                  : Colors.transparent,
              width: 1.5,
            ),
          ),
          child: Center(child: widget.child),
        ),
      ),
    );
  }
}

class _DigitKey extends StatelessWidget {
  final String label;
  final TextEditingController controller;

  const _DigitKey({
    required this.label,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return _AmountKey(
      onPressed: () => AmountKeyboardInput.insertCharacter(
        controller: controller,
        character: label,
      ),
      child: Text(
        label,
        style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w500),
      ),
    );
  }
}

class _DecimalKey extends StatelessWidget {
  final TextEditingController controller;

  const _DecimalKey({required this.controller});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final separator = AmountKeyboardInput.decimalSeparator;

    return _AmountKey(
      onPressed: () {
        if (controller.text.contains(separator)) return;
        AmountKeyboardInput.insertCharacter(
          controller: controller,
          character: separator,
        );
      },
      child: Text(
        separator,
        style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w500),
      ),
    );
  }
}

class _BackspaceKey extends StatelessWidget {
  final TextEditingController controller;

  const _BackspaceKey({required this.controller});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return _AmountKey(
      repeatWhileHeld: true,
      onPressed: () => AmountKeyboardInput.backspace(controller),
      child: Icon(
        Icons.backspace_outlined,
        size: 24,
        color: colors.textPrimary,
      ),
    );
  }
}

class _DoneKey extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final TextStyle? textStyle;
  final AppColors colors;

  const _DoneKey({
    required this.label,
    required this.onPressed,
    required this.textStyle,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return _AmountKey(
      onPressed: onPressed,
      child: Text(
        label,
        style: textStyle?.copyWith(
          color: colors.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
