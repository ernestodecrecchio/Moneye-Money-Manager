import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math' as math;

class FloatingElement extends ConsumerStatefulWidget {
  final Widget widget;
  final double coordinateX;
  final double coordinateY;

  const FloatingElement({
    super.key,
    required this.widget,
    required this.coordinateX,
    required this.coordinateY,
  });

  @override
  ConsumerState<FloatingElement> createState() => _FloatingElementState();
}

class _FloatingElementState extends ConsumerState<FloatingElement>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4), // Breathing rhythm
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.coordinateX,
      top: widget.coordinateY,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          // Organic bobbing motion using Sine waves
          final angle = _animationController.value * 2 * math.pi;
          final dy = math.sin(angle) * 15;
          final dx = math.cos(angle) * 10;
          
          return Transform.translate(
            offset: Offset(dx, dy),
            child: Container(
              alignment: Alignment.center,
              child: widget.widget,
            ),
          );
        },
      ),
    );
  }
}
