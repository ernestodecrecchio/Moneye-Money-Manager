import 'package:flutter/material.dart';
import 'package:vector_graphics/vector_graphics.dart';

class IconItem extends StatelessWidget {
  final String iconPath;
  final bool isSelected;
  final Color backgroundColor;
  final VoidCallback onTap;

  const IconItem({
    super.key,
    required this.iconPath,
    required this.isSelected,
    required this.backgroundColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        height: 35,
        width: 35,
        padding: const EdgeInsets.all(7),
        decoration: BoxDecoration(
          color: isSelected
              ? backgroundColor
              : backgroundColor.withValues(alpha: 0.5),
          shape: BoxShape.circle,
        ),
        child: VectorGraphic(
          loader: AssetBytesLoader(iconPath),
          colorFilter: const ColorFilter.mode(
            Colors.white,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
}
