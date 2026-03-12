import 'package:flutter/material.dart';
import 'package:vector_graphics/vector_graphics.dart';

class IconItem extends StatelessWidget {
  final Color backgroundColor;
  final String? iconPath;
  final bool isSelected;
  final VoidCallback? onTap;

  const IconItem({
    super.key,
    required this.backgroundColor,
    this.iconPath,
    this.isSelected = true,
    this.onTap,
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
          loader: AssetBytesLoader(iconPath ?? 'assets/icons/box.svg'),
          colorFilter: const ColorFilter.mode(
            Colors.white,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
}
