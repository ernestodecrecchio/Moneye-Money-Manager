import 'package:expense_tracker/core/services/asset_registry.dart';
import 'package:flutter/material.dart';
import 'package:vector_graphics/vector_graphics.dart';

class SafeVectorGraphic extends StatelessWidget {
  final String? iconPath;
  final double? height;
  final double? width;
  final bool colorFilterEnabled;
  final Color? color;
  final BoxFit? fit;
  final String fallback;

  const SafeVectorGraphic({
    super.key,
    required this.iconPath,
    this.height,
    this.width,
    this.colorFilterEnabled = true,
    this.color,
    this.fit,
    this.fallback = 'assets/icons/box.svg',
  });

  @override
  Widget build(BuildContext context) {
    final path = (iconPath != null && AssetRegistry.instance.exists(iconPath!))
        ? iconPath!
        : fallback;

    return VectorGraphic(
      loader: AssetBytesLoader(path),
      height: height,
      width: width,
      colorFilter: colorFilterEnabled
          ? ColorFilter.mode(
              color ?? Colors.white,
              BlendMode.srcIn,
            )
          : null,
      fit: fit ?? BoxFit.contain,
    );
  }
}
