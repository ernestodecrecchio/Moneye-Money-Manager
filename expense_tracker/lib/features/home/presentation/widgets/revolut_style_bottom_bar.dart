import 'dart:ui';

import 'package:expense_tracker/core/style/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A floating, pill-shaped bottom bar inspired by Revolut's mobile navigation.
///
/// Layout metrics ([AppChrome]) and FAB size come from the app theme.
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

  static const _animationDuration = Duration(milliseconds: 280);
  static const _barBackdropBlurSigma = 12.0;
  static const _barFillOpacityLight = 0.0;
  static const _barFillOpacityDark = 0.3;
  static const _selectedPillOpacityLight = 0.5;
  static const _selectedPillOpacityDark = 0.5;

  /// Distance from the physical bottom of the screen to the top of the tab bar.
  static double chromeHeight(BuildContext context) =>
      context.appChrome.chromeHeight(context.deviceBottomInset);

  /// Height of the fade overlay (bar chrome + short fade zone above the bar).
  static double fadeOverlayHeight(BuildContext context) =>
      context.appChrome.fadeOverlayHeight(context.deviceBottomInset);

  /// Bottom inset for a [FloatingActionButton] on the tab shell [Scaffold].
  static double fabBottomOffset(BuildContext context) =>
      context.appChrome.fabBottomOffset(context.deviceBottomInset);

  /// Scroll padding: [chromeHeight] + optional FAB stack + spacing from [AppChrome].
  static double scrollBottomInset(
    BuildContext context, {
    bool includeFab = false,
  }) =>
      context.appChrome.scrollBottomInset(
        context.deviceBottomInset,
        includeFab: includeFab,
      );

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final chrome = context.appChrome;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bottomInset = context.deviceBottomInset;
    final tabBar = _TabBarColors.resolve(colors, isDark);
    final barFillOpacity = isDark ? _barFillOpacityDark : _barFillOpacityLight;
    final barFill = tabBar.barBackground.withValues(alpha: barFillOpacity);
    final selectedPillOpacity =
        isDark ? _selectedPillOpacityDark : _selectedPillOpacityLight;
    final selectedPillFill =
        tabBar.selectedPill.withValues(alpha: selectedPillOpacity);
    final barRadius = BorderRadius.circular(chrome.tabBarOuterRadius);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        chrome.tabBarHorizontalMargin,
        0,
        chrome.tabBarHorizontalMargin,
        chrome.tabBarBottomMargin + bottomInset,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: barRadius,
          boxShadow: [
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
              sigmaX: _barBackdropBlurSigma,
              sigmaY: _barBackdropBlurSigma,
            ),
            child: Material(
              color: barFill,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: barRadius,
                side: BorderSide(color: tabBar.border),
              ),
              child: SizedBox(
                height: chrome.tabBarHeight,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
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
                                color: selectedPillFill,
                                borderRadius: BorderRadius.circular(
                                  chrome.tabBarItemRadius,
                                ),
                              ),
                            ),
                          ),
                          Row(
                            children: List.generate(items.length, (i) {
                              final selected = i == currentIndex;
                              final item = items[i];
                              final foreground = selected
                                  ? tabBar.selectedForeground
                                  : tabBar.unselectedForeground;

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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
        ),
      ),
    );
  }
}

/// Tab bar colors derived from [AppColors] with correct contrast per theme.
class _TabBarColors {
  const _TabBarColors({
    required this.barBackground,
    required this.border,
    required this.selectedPill,
    required this.selectedForeground,
    required this.unselectedForeground,
  });

  final Color barBackground;
  final Color border;
  final Color selectedPill;
  final Color selectedForeground;
  final Color unselectedForeground;

  /// Slightly lifted surface so the bar reads above the scaffold in dark mode.
  static const _darkBarBackground = Color(0xFF2A2A2E);

  static _TabBarColors resolve(AppColors colors, bool isDark) {
    if (!isDark) {
      return _TabBarColors(
        barBackground: colors.surface,
        border: colors.divider.withValues(alpha: 0.35),
        selectedPill: colors.primary,
        selectedForeground: colors.onPrimary,
        unselectedForeground: colors.textSecondary,
      );
    }

    final primaryIsNeutral = colors.primary.computeLuminance() > 0.85;
    if (primaryIsNeutral) {
      return _TabBarColors(
        barBackground: _darkBarBackground,
        border: colors.divider.withValues(alpha: 0.55),
        selectedPill: Colors.white,
        selectedForeground: Colors.white,
        unselectedForeground: colors.textSecondary,
      );
    }

    return _TabBarColors(
      barBackground: _darkBarBackground,
      border: colors.divider.withValues(alpha: 0.55),
      selectedPill: colors.primary,
      selectedForeground: Colors.white,
      unselectedForeground: colors.textSecondary,
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
    const chrome = AppChrome.standard;
    final fabSize = scaffoldGeometry.floatingActionButtonSize;
    final scaffoldSize = scaffoldGeometry.scaffoldSize;
    final bottomInset = scaffoldGeometry.minInsets.bottom;
    final tabBarTopFromBottom = chrome.chromeHeight(bottomInset);

    return Offset(
      scaffoldSize.width - fabSize.width - chrome.fabMargin,
      scaffoldSize.height -
          fabSize.height -
          chrome.fabMargin -
          tabBarTopFromBottom,
    );
  }
}

/// Scroll bottom padding for the active tab, computed on [TabBarPage].
class TabBarScrollScope extends InheritedWidget {
  const TabBarScrollScope({
    super.key,
    required this.bottomScrollPadding,
    required super.child,
  });

  final double bottomScrollPadding;

  static double of(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<TabBarScrollScope>();
    assert(
      scope != null,
      'TabBarScrollScope not found. Wrap tab content in TabBarPage.',
    );
    return scope!.bottomScrollPadding;
  }

  @override
  bool updateShouldNotify(TabBarScrollScope oldWidget) =>
      bottomScrollPadding != oldWidget.bottomScrollPadding;
}

class TabBarScrollBottomSliver extends StatelessWidget {
  const TabBarScrollBottomSliver({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: SizedBox(height: TabBarScrollScope.of(context)),
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
