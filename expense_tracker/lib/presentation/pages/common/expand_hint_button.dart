import 'package:flutter/material.dart';

class ExpandHintButton extends StatelessWidget {
  final VoidCallback onTap;
  final Color backgroundColor;
  final double? width;
  final IconData icon;
  final Color? iconColor;

  const ExpandHintButton({
    super.key,
    required this.onTap,
    required this.backgroundColor,
    this.width,
    this.icon = Icons.chevron_right_rounded,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      right: 0,
      left: null,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Container(
          width: width,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                backgroundColor.withAlpha(0),
                backgroundColor,
              ],
            ),
          ),
          child: Icon(
            icon,
            color: iconColor ?? Theme.of(context).iconTheme.color,
          ),
        ),
      ),
    );
  }
}
