import 'package:expense_tracker/core/configuration/constants.dart';
import 'package:expense_tracker/core/style/app_theme.dart';
import 'package:flutter/material.dart';

/// A unified, centralized theme and layout metrics extension for the custom floating bottom bar.
///
/// This combines what was previously separate [AppChrome] (layout metrics) and
/// [TabBarColors] (color extensions) into a single cohesive configuration class.
class FloatingTabBarTheme extends ThemeExtension<FloatingTabBarTheme> {
  const FloatingTabBarTheme({
    // Layout Metrics
    required this.tabBarHeight,
    required this.tabBarBottomMargin,
    required this.tabBarHorizontalMargin,
    required this.tabBarOuterRadius,
    required this.tabBarItemRadius,
    required this.fabSize,
    required this.fabAboveTabBarGap,
    required this.fabMargin,
    required this.scrollBottomSpacing,
    required this.fadeExtensionAboveBar,
    // Styling & Animations
    required this.barBackdropBlurSigma,
    required this.selectionAnimationDuration,
    required this.selectionAnimationCurve,
    // Colors
    required this.barBackground,
    required this.border,
    required this.selectedPill,
    required this.selectedForeground,
    required this.unselectedForeground,
    required this.barFill,
    required this.selectedPillFill,
  });

  // ==========================================
  // Layout Metrics
  // ==========================================

  /// Height of the floating tab bar pill itself, excluding margins and device insets.
  final double tabBarHeight;

  /// Space between the bottom of the tab bar and the device safe area inset.
  final double tabBarBottomMargin;

  /// Horizontal margin of the tab bar from the screen edges.
  final double tabBarHorizontalMargin;

  /// Corner radius of the outer tab bar container.
  final double tabBarOuterRadius;

  /// Corner radius of the selected-tab indicator pill.
  final double tabBarItemRadius;

  /// Width and height of the floating action button (FAB).
  final double fabSize;

  /// Vertical gap between the top of the tab bar and the bottom of the FAB.
  final double fabAboveTabBarGap;

  /// Margin from the FAB to the edges of the screen on the shell page.
  final double fabMargin;

  /// Extra padding added below the last scrollable item to clear the tab bar.
  final double scrollBottomSpacing;

  /// Additional height of the bottom fade gradient above the tab bar chrome.
  final double fadeExtensionAboveBar;

  // ==========================================
  // Styling & Animations
  // ==========================================

  /// Backdrop blur sigma for the transparent background effect.
  final double barBackdropBlurSigma;

  /// Duration of the transition animation when switching tabs.
  final Duration selectionAnimationDuration;

  /// Curve of the transition animation when switching tabs.
  final Curve selectionAnimationCurve;

  // ==========================================
  // Colors & Fills
  // ==========================================

  /// Base background color of the tab bar.
  final Color barBackground;

  /// Border color of the tab bar container.
  final Color border;

  /// Selected tab pill background color.
  final Color selectedPill;

  /// Foreground (icon & label) color of the selected tab.
  final Color selectedForeground;

  /// Foreground (icon & label) color of unselected tabs.
  final Color unselectedForeground;

  /// Tab bar background with theme-appropriate fill opacity applied.
  final Color barFill;

  /// Selected-tab pill with theme-appropriate opacity applied.
  final Color selectedPillFill;

  // ==========================================
  // Standard Default Metrics Configuration
  // ==========================================

  static final standard = FloatingTabBarTheme(
    tabBarHeight: 68,
    tabBarBottomMargin: 2,
    tabBarHorizontalMargin: Constants.horizontalPadding,
    tabBarOuterRadius: 36,
    tabBarItemRadius: 28,
    fabSize: 56,
    fabAboveTabBarGap: 0,
    fabMargin: 16,
    scrollBottomSpacing: 0,
    fadeExtensionAboveBar: 0,
    barBackdropBlurSigma: 12.0,
    selectionAnimationDuration: const Duration(milliseconds: 280),
    selectionAnimationCurve: Curves.easeOutCubic,
    barBackground: Colors.transparent,
    border: Colors.transparent,
    selectedPill: Colors.transparent,
    selectedForeground: Colors.transparent,
    unselectedForeground: Colors.transparent,
    barFill: Colors.transparent,
    selectedPillFill: Colors.transparent,
  );

  BoxConstraints get fabSizeConstraints =>
      BoxConstraints.tightFor(width: fabSize, height: fabSize);

  // ==========================================
  // Calculations based on screen insets
  // ==========================================

  /// Total height occupied by the tab bar chrome from the bottom of the screen.
  double chromeHeight(double deviceBottomInset) =>
      tabBarHeight + tabBarBottomMargin + deviceBottomInset;

  /// Total height of the bottom fade overlay.
  double fadeOverlayHeight(double deviceBottomInset) =>
      chromeHeight(deviceBottomInset) + fadeExtensionAboveBar;

  /// Vertical offset of the FAB above the tab bar.
  double fabBottomOffset(double deviceBottomInset) =>
      chromeHeight(deviceBottomInset) + fabAboveTabBarGap;

  /// Bottom inset/padding required for scrollable list content to clear the bar (and FAB if needed).
  double scrollBottomInset(
    double deviceBottomInset, {
    bool includeFab = false,
  }) {
    final chrome = chromeHeight(deviceBottomInset);
    if (includeFab) {
      return chrome + fabAboveTabBarGap + fabSize + scrollBottomSpacing;
    }
    return chrome + scrollBottomSpacing;
  }

  // ==========================================
  // Factory for Theme Construction
  // ==========================================

  /// Generates the theming colors based on the app's global [AppColors] and current [Brightness].
  factory FloatingTabBarTheme.fromAppColors({
    required AppColors colors,
    double? tabBarHeight,
    double? tabBarBottomMargin,
    double? tabBarHorizontalMargin,
    double? tabBarOuterRadius,
    double? tabBarItemRadius,
    double? fabSize,
    double? fabAboveTabBarGap,
    double? fabMargin,
    double? scrollBottomSpacing,
    double? fadeExtensionAboveBar,
  }) {
    return FloatingTabBarTheme(
      tabBarHeight: tabBarHeight ?? standard.tabBarHeight,
      tabBarBottomMargin: tabBarBottomMargin ?? standard.tabBarBottomMargin,
      tabBarHorizontalMargin:
          tabBarHorizontalMargin ?? standard.tabBarHorizontalMargin,
      tabBarOuterRadius: tabBarOuterRadius ?? standard.tabBarOuterRadius,
      tabBarItemRadius: tabBarItemRadius ?? standard.tabBarItemRadius,
      fabSize: fabSize ?? standard.fabSize,
      fabAboveTabBarGap: fabAboveTabBarGap ?? standard.fabAboveTabBarGap,
      fabMargin: fabMargin ?? standard.fabMargin,
      scrollBottomSpacing: scrollBottomSpacing ?? standard.scrollBottomSpacing,
      fadeExtensionAboveBar:
          fadeExtensionAboveBar ?? standard.fadeExtensionAboveBar,
      barBackdropBlurSigma: standard.barBackdropBlurSigma,
      selectionAnimationDuration: standard.selectionAnimationDuration,
      selectionAnimationCurve: standard.selectionAnimationCurve,
      barBackground: colors.navBarBackground,
      border: colors.navBarBorder ?? Colors.transparent,
      selectedPill: colors.navBarPill,
      selectedForeground: colors.navBarSelectedContent,
      unselectedForeground: colors.navBarUnselectedContent,
      barFill: colors.navBarBackground,
      selectedPillFill: colors.navBarPill,
    );
  }

  // ==========================================
  // ThemeExtension Implementation Methods
  // ==========================================

  @override
  FloatingTabBarTheme copyWith({
    double? tabBarHeight,
    double? tabBarBottomMargin,
    double? tabBarHorizontalMargin,
    double? tabBarOuterRadius,
    double? tabBarItemRadius,
    double? fabSize,
    double? fabAboveTabBarGap,
    double? fabMargin,
    double? scrollBottomSpacing,
    double? fadeExtensionAboveBar,
    double? barBackdropBlurSigma,
    Duration? selectionAnimationDuration,
    Curve? selectionAnimationCurve,
    Color? barBackground,
    Color? border,
    Color? selectedPill,
    Color? selectedForeground,
    Color? unselectedForeground,
    Color? barFill,
    Color? selectedPillFill,
  }) {
    return FloatingTabBarTheme(
      tabBarHeight: tabBarHeight ?? this.tabBarHeight,
      tabBarBottomMargin: tabBarBottomMargin ?? this.tabBarBottomMargin,
      tabBarHorizontalMargin:
          tabBarHorizontalMargin ?? this.tabBarHorizontalMargin,
      tabBarOuterRadius: tabBarOuterRadius ?? this.tabBarOuterRadius,
      tabBarItemRadius: tabBarItemRadius ?? this.tabBarItemRadius,
      fabSize: fabSize ?? this.fabSize,
      fabAboveTabBarGap: fabAboveTabBarGap ?? this.fabAboveTabBarGap,
      fabMargin: fabMargin ?? this.fabMargin,
      scrollBottomSpacing: scrollBottomSpacing ?? this.scrollBottomSpacing,
      fadeExtensionAboveBar:
          fadeExtensionAboveBar ?? this.fadeExtensionAboveBar,
      barBackdropBlurSigma: barBackdropBlurSigma ?? this.barBackdropBlurSigma,
      selectionAnimationDuration:
          selectionAnimationDuration ?? this.selectionAnimationDuration,
      selectionAnimationCurve:
          selectionAnimationCurve ?? this.selectionAnimationCurve,
      barBackground: barBackground ?? this.barBackground,
      border: border ?? this.border,
      selectedPill: selectedPill ?? this.selectedPill,
      selectedForeground: selectedForeground ?? this.selectedForeground,
      unselectedForeground: unselectedForeground ?? this.unselectedForeground,
      barFill: barFill ?? this.barFill,
      selectedPillFill: selectedPillFill ?? this.selectedPillFill,
    );
  }

  @override
  FloatingTabBarTheme lerp(
      ThemeExtension<FloatingTabBarTheme>? other, double t) {
    if (other is! FloatingTabBarTheme) return this;
    return FloatingTabBarTheme(
      tabBarHeight: _lerpDouble(tabBarHeight, other.tabBarHeight, t),
      tabBarBottomMargin:
          _lerpDouble(tabBarBottomMargin, other.tabBarBottomMargin, t),
      tabBarHorizontalMargin:
          _lerpDouble(tabBarHorizontalMargin, other.tabBarHorizontalMargin, t),
      tabBarOuterRadius:
          _lerpDouble(tabBarOuterRadius, other.tabBarOuterRadius, t),
      tabBarItemRadius:
          _lerpDouble(tabBarItemRadius, other.tabBarItemRadius, t),
      fabSize: _lerpDouble(fabSize, other.fabSize, t),
      fabAboveTabBarGap:
          _lerpDouble(fabAboveTabBarGap, other.fabAboveTabBarGap, t),
      fabMargin: _lerpDouble(fabMargin, other.fabMargin, t),
      scrollBottomSpacing:
          _lerpDouble(scrollBottomSpacing, other.scrollBottomSpacing, t),
      fadeExtensionAboveBar:
          _lerpDouble(fadeExtensionAboveBar, other.fadeExtensionAboveBar, t),
      barBackdropBlurSigma:
          _lerpDouble(barBackdropBlurSigma, other.barBackdropBlurSigma, t),
      selectionAnimationDuration: t < 0.5
          ? selectionAnimationDuration
          : other.selectionAnimationDuration,
      selectionAnimationCurve:
          t < 0.5 ? selectionAnimationCurve : other.selectionAnimationCurve,
      barBackground: Color.lerp(barBackground, other.barBackground, t)!,
      border: Color.lerp(border, other.border, t)!,
      selectedPill: Color.lerp(selectedPill, other.selectedPill, t)!,
      selectedForeground:
          Color.lerp(selectedForeground, other.selectedForeground, t)!,
      unselectedForeground:
          Color.lerp(unselectedForeground, other.unselectedForeground, t)!,
      barFill: Color.lerp(barFill, other.barFill, t)!,
      selectedPillFill:
          Color.lerp(selectedPillFill, other.selectedPillFill, t)!,
    );
  }

  static double _lerpDouble(double a, double b, double t) => a + (b - a) * t;
}

// ==========================================
// BuildContext Extension for simple access
// ==========================================

extension TabBarThemeExtension on BuildContext {
  /// Convenient accessor for the unified [FloatingTabBarTheme] from the [Theme].
  FloatingTabBarTheme get floatingTabBarTheme =>
      Theme.of(this).extension<FloatingTabBarTheme>()!;

  /// Safe device bottom inset (home indicator height).
  double get deviceBottomInset {
    final media = MediaQuery.of(this);
    return media.viewPadding.bottom > media.padding.bottom
        ? media.viewPadding.bottom
        : media.padding.bottom;
  }

  /// Calculations based on current bottom inset and theme metrics.
  double get tabBarChromeHeight =>
      floatingTabBarTheme.chromeHeight(deviceBottomInset);

  double get tabBarFadeOverlayHeight =>
      floatingTabBarTheme.fadeOverlayHeight(deviceBottomInset);

  double get tabBarFabBottomOffset =>
      floatingTabBarTheme.fabBottomOffset(deviceBottomInset);

  double tabBarScrollBottomInset({bool includeFab = false}) =>
      floatingTabBarTheme.scrollBottomInset(
        deviceBottomInset,
        includeFab: includeFab,
      );
}
