import 'dart:ui';
import 'package:expense_tracker/features/home/presentation/widgets/tab_bar/revolut_bottom_bar_item.dart';
import 'package:expense_tracker/features/home/presentation/widgets/tab_bar/tab_bar_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A floating, pill-shaped bottom bar inspired by modern capsule navigation shells.
///
/// Retrieves all layout metrics, paddings, borders, backdrop filters, animation curves,
/// and colors from the unified [FloatingTabBarTheme] registered in the [ThemeData] extensions.
class RevolutStyleBottomBar extends StatelessWidget {
  const RevolutStyleBottomBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });

  /// Index of the currently active tab.
  final int currentIndex;

  /// Callback fired when a tab is pressed.
  final ValueChanged<int> onTap;

  /// The list of items/destinations to build in this tab bar.
  final List<RevolutBottomBarItem> items;

  @override
  Widget build(BuildContext context) {
    // Read the unified bottom bar theme and current device insets
    final theme = context.floatingTabBarTheme;
    final barRadius = BorderRadius.circular(theme.tabBarOuterRadius);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        theme.tabBarHorizontalMargin,
        0,
        theme.tabBarHorizontalMargin,
        theme.tabBarBottomMargin + context.deviceBottomInset,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: barRadius,
          boxShadow: [
            // Shadow around the bottom bar, to "pop" it out from the screen especially when the background is white
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.45 : 0.12),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: barRadius,
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: theme.barBackdropBlurSigma,
              sigmaY: theme.barBackdropBlurSigma,
            ),
            child: Material(
              color: theme.barFill,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: barRadius,
                side: BorderSide(color: theme.border),
              ),
              child: SizedBox(
                height: theme.tabBarHeight,
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      // Dynamically split total width by the number of tab items
                      final tabWidth = constraints.maxWidth / items.length;

                      return _TabBarTrack(
                        tabWidth: tabWidth,
                        currentIndex: currentIndex,
                        items: items,
                        theme: theme,
                        onTap: onTap,
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Renders the animation background track and arranges the active/inactive tabs.
class _TabBarTrack extends StatelessWidget {
  const _TabBarTrack({
    required this.tabWidth,
    required this.currentIndex,
    required this.items,
    required this.theme,
    required this.onTap,
  });

  final double tabWidth;
  final int currentIndex;
  final List<RevolutBottomBarItem> items;
  final FloatingTabBarTheme theme;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Sliding active pill background indicator
        AnimatedPositioned(
          duration: theme.selectionAnimationDuration,
          curve: theme.selectionAnimationCurve,
          left: tabWidth * currentIndex,
          width: tabWidth,
          top: 0,
          bottom: 0,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: theme.selectedPillFill,
              borderRadius: BorderRadius.circular(theme.tabBarItemRadius),
            ),
          ),
        ),

        // Row of tap targets
        Row(
          children: List.generate(items.length, (index) {
            final isSelected = index == currentIndex;

            return Expanded(
              child: _TabBarTab(
                item: items[index],
                selected: isSelected,
                theme: theme,
                onTap: () {
                  if (isSelected) return;
                  // Standard haptic feedback on tab change
                  HapticFeedback.lightImpact();
                  onTap(index);
                },
              ),
            );
          }),
        ),
      ],
    );
  }
}

/// Renders an individual tab with its label and icon.
class _TabBarTab extends StatelessWidget {
  const _TabBarTab({
    required this.item,
    required this.selected,
    required this.theme,
    required this.onTap,
  });

  final RevolutBottomBarItem item;
  final bool selected;
  final FloatingTabBarTheme theme;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // Pick correct foreground color depending on state
    final foregroundColor =
        selected ? theme.selectedForeground : theme.unselectedForeground;

    return Semantics(
      button: true,
      selected: selected,
      label: item.label,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Responsive icon
            item.buildIcon(selected: selected, color: foregroundColor),
            const SizedBox(height: 2),

            // Smoothly transitioning label text style
            AnimatedDefaultTextStyle(
              duration: theme.selectionAnimationDuration,
              curve: theme.selectionAnimationCurve,
              style: TextStyle(
                fontFamily: 'Ubuntu',
                fontSize: selected ? 11 : 10,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                color: foregroundColor,
                height: 1.1,
              ),
              child: Text(
                item.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
