import 'package:flutter/material.dart';

/// One destination in [RevolutStyleBottomBar].
class RevolutBottomBarItem {
  const RevolutBottomBarItem({
    required this.label,
    required this.iconBuilder,
  });

  final String label;

  /// Builds the tab icon; [selected] and [color] reflect active/inactive state.
  final Widget Function(bool selected, Color color) iconBuilder;
}
