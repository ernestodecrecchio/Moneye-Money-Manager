import 'package:expense_tracker/configuration/constants.dart';
import 'package:expense_tracker/presentation/pages/common/widgets/safe_vector_graphic.dart';
import 'package:flutter/material.dart';

class IconItem extends StatelessWidget {
  final Color backgroundColor;
  final BoxShape shape;
  final String? iconPath;
  final bool isSelected;
  final double? size;
  final VoidCallback? onTap;

  const IconItem({
    super.key,
    required this.backgroundColor,
    required this.shape,
    this.iconPath,
    this.isSelected = true,
    this.size,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        height: size ?? defaultIconItemHeight,
        width: size ?? defaultIconItemWidth,
        padding: const EdgeInsets.all(7),
        decoration: BoxDecoration(
          color: isSelected
              ? backgroundColor
              : backgroundColor.withValues(alpha: 0.30),
          shape: shape,
          borderRadius:
              shape == BoxShape.rectangle ? BorderRadius.circular(8) : null,
        ),
        child: SafeVectorGraphic(iconPath: iconPath),
      ),
    );
  }
}
