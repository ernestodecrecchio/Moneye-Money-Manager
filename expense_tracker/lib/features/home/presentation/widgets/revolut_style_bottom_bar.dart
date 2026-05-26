import 'package:expense_tracker/core/style/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A floating, pill-shaped bottom bar inspired by Revolut's mobile navigation.
///
/// Selected tab: filled capsule behind icon + label, sliding between tabs.
/// Unselected tabs: muted icon and compact label.
class RevolutStyleBottomBar extends StatelessWidget {
  const RevolutStyleBottomBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<RevolutBottomBarItem> items;

  static const barHeight = 68.0;
  static const _outerRadius = 36.0;
  static const _itemRadius = 28.0;
  static const _animationDuration = Duration(milliseconds: 280);
  static const bottomMargin = 12.0;

  /// Distance from the physical bottom of the screen to the top of the bar.
  static double chromeHeight(BuildContext context) {
    return barHeight + bottomMargin + MediaQuery.paddingOf(context).bottom;
  }

  /// Height of the fade overlay (bar chrome + short fade zone above the bar).
  static double fadeOverlayHeight(BuildContext context) {
    return chromeHeight(context) + 28;
  }

  /// Bottom inset for a [FloatingActionButton] on the tab shell [Scaffold].
  static double fabBottomOffset(BuildContext context) {
    return chromeHeight(context) + 16;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    final selectedPillColor = isDark ? Colors.white : colors.textPrimary;
    final selectedForeground = isDark ? colors.textPrimary : colors.surface;
    final barColor = colors.surface;
    final borderColor = isDark
        ? colors.divider.withValues(alpha: 0.6)
        : colors.divider.withValues(alpha: 0.35);

    return Padding(
      padding: EdgeInsets.fromLTRB(20, 0, 20, bottomMargin + bottomInset),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(_outerRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.45 : 0.12),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Material(
          color: barColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_outerRadius),
            side: BorderSide(color: borderColor),
          ),
          child: SizedBox(
            height: barHeight,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final tabWidth = constraints.maxWidth / items.length;

                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      AnimatedPositioned(
                        duration: _animationDuration,
                        curve: Curves.easeOutCubic,
                        left: tabWidth * currentIndex,
                        width: tabWidth,
                        top: 0,
                        bottom: 0,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: selectedPillColor,
                            borderRadius:
                                BorderRadius.circular(_itemRadius),
                          ),
                        ),
                      ),
                      Row(
                        children: List.generate(items.length, (i) {
                          final selected = i == currentIndex;
                          final item = items[i];
                          final foreground = selected
                              ? selectedForeground
                              : colors.textSecondary;

                          return Expanded(
                            child: Semantics(
                              button: true,
                              selected: selected,
                              label: item.label,
                              child: GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () {
                                  if (i == currentIndex) return;
                                  HapticFeedback.lightImpact();
                                  onTap(i);
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    item.iconBuilder(selected, foreground),
                                    const SizedBox(height: 2),
                                    AnimatedDefaultTextStyle(
                                      duration: _animationDuration,
                                      curve: Curves.easeOutCubic,
                                      style: TextStyle(
                                        fontFamily: 'Ubuntu',
                                        fontSize: selected ? 11 : 10,
                                        fontWeight: selected
                                            ? FontWeight.w600
                                            : FontWeight.w500,
                                        color: foreground,
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
                            ),
                          );
                        }),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class RevolutBottomBarItem {
  const RevolutBottomBarItem({
    required this.label,
    required this.iconBuilder,
  });

  final String label;

  /// Builds the tab icon; [selected] and [color] reflect active/inactive state.
  final Widget Function(bool selected, Color color) iconBuilder;
}

/// Fades scrollable content behind the floating tab bar, anchored to the screen bottom.
class BottomBarBodyFade extends StatelessWidget {
  const BottomBarBodyFade({super.key});

  @override
  Widget build(BuildContext context) {
    final background = context.appColors.scaffoldBackground;
    final height = RevolutStyleBottomBar.fadeOverlayHeight(context);

    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      height: height,
      child: IgnorePointer(
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                background,
                background.withValues(alpha: 0.94),
                background.withValues(alpha: 0.0),
              ],
              stops: const [0.0, 0.22, 1.0],
            ),
          ),
        ),
      ),
    );
  }
}

/// Positions a [FloatingActionButton] on the tab shell above the bottom bar.
class FabAboveTabBarLocation extends FloatingActionButtonLocation {
  const FabAboveTabBarLocation();

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    final fabSize = scaffoldGeometry.floatingActionButtonSize;
    final scaffoldSize = scaffoldGeometry.scaffoldSize;
    final bottomInset = scaffoldGeometry.minInsets.bottom;
    final chrome = RevolutStyleBottomBar.barHeight +
        RevolutStyleBottomBar.bottomMargin +
        bottomInset;

    return Offset(
      scaffoldSize.width - fabSize.width - 16,
      scaffoldSize.height - fabSize.height - 16 - chrome,
    );
  }
}

/// Lets tab content extend under the floating bar and home-indicator inset.
class TabBarBody extends StatelessWidget {
  const TabBarBody({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MediaQuery.removeViewPadding(
      context: context,
      removeBottom: true,
      child: MediaQuery.removePadding(
        context: context,
        removeBottom: true,
        child: child,
      ),
    );
  }
}
