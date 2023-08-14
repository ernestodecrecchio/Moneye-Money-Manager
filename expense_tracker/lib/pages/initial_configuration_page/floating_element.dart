import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FloatingElement extends ConsumerStatefulWidget {
  final Widget widget;
  final double coordinateX;
  final double coordinateY;

  const FloatingElement({
    Key? key,
    required this.widget,
    required this.coordinateX,
    required this.coordinateY,
  }) : super(key: key);

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
      duration: const Duration(seconds: 5), // Adjust the duration as needed
    )..addStatusListener(
        (status) {
          if (status == AnimationStatus.completed) {
            _animationController.reverse();
          } else if (status == AnimationStatus.dismissed) {
            _animationController.forward();
          }
        },
      );

    // Start the animation
    _animationController.forward();
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
          final translateX = (40) * _animationController.value;
          return Transform.translate(
            offset: Offset(translateX, 0),
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
