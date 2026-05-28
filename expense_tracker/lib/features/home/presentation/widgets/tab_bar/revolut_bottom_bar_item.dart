import 'package:flutter/material.dart';

/// One destination/item in the custom floating bottom bar.
///
/// Supports both:
/// 1. Simple, static icons (using [icon] with [IconData] or a custom [Widget]).
/// 2. Dynamic, responsive icons (using [iconBuilder] to get access to selected state and color).
class RevolutBottomBarItem {
  const RevolutBottomBarItem({
    required this.label,
    this.icon,
    this.iconBuilder,
  }) : assert(
          icon != null || iconBuilder != null,
          'Either icon or iconBuilder must be provided to RevolutBottomBarItem.',
        );

  /// The localized label displayed underneath the icon.
  final String label;

  /// A static icon to show. Can be [IconData] or a custom [Widget].
  ///
  /// If [iconBuilder] is provided, this static [icon] is ignored.
  final dynamic icon;

  /// A custom builder closure giving full access to selection state and theme colors.
  final Widget Function(bool selected, Color color)? iconBuilder;

  /// Resolves and builds the appropriate icon widget based on the selection state and color.
  Widget buildIcon({required bool selected, required Color color}) {
    if (iconBuilder != null) {
      return iconBuilder!(selected, color);
    }

    final localIcon = icon;
    if (localIcon is IconData) {
      return Icon(localIcon, color: color, size: 22);
    } else if (localIcon is Widget) {
      return localIcon;
    }

    throw ArgumentError(
      'Invalid icon type provided to RevolutBottomBarItem. '
      'Must be an IconData, a Widget, or use an iconBuilder.',
    );
  }
}
