import 'package:expense_tracker/core/configuration/constants.dart';
import 'package:expense_tracker/core/presentation/common/widgets/safe_vector_graphic.dart';
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
    final effectiveWidth = size ?? Constants.defaultIconItemWidth;
    final effectiveHeight = size ?? Constants.defaultIconItemHeight;
    // Calculate padding as 20% of the smaller dimension (which is proportional to 7 padding for a 35 size)
    final paddingValue = (effectiveWidth < effectiveHeight ? effectiveWidth : effectiveHeight) * 0.2;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        height: effectiveHeight,
        width: effectiveWidth,
        padding: EdgeInsets.all(paddingValue),
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
