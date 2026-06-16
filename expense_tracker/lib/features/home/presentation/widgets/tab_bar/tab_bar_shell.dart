import 'package:expense_tracker/core/style/app_theme.dart';
import 'package:expense_tracker/features/home/presentation/widgets/tab_bar/tab_bar_theme.dart';
import 'package:flutter/material.dart';

/// Fades scrollable content behind the floating tab bar, anchored to the screen bottom.
class BottomBarBodyFade extends StatelessWidget {
  const BottomBarBodyFade({super.key});

  @override
  Widget build(BuildContext context) {
    final background = context.appColors.scaffoldBackground;

    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      height: context.tabBarFadeOverlayHeight,
      child: IgnorePointer(
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                background,
                background.withValues(alpha: 0.74),
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
///
/// Uses [FloatingTabBarTheme.standard] because [FloatingActionButtonLocation.getOffset]
/// has no [BuildContext] to read the theme extension at evaluation time.
class FabAboveTabBarLocation extends FloatingActionButtonLocation {
  const FabAboveTabBarLocation();

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    final theme = FloatingTabBarTheme.standard;
    final fabSize = scaffoldGeometry.floatingActionButtonSize;
    final scaffoldSize = scaffoldGeometry.scaffoldSize;
    // Keep the FAB vertically aligned with the custom bottom bar and its
    // "home-indicator" safe area logic.
    //
    // We use the larger between MediaQuery.padding and MediaQuery.viewPadding
    // (same logic as [TabBarThemeExtension.deviceBottomInset]).
    final paddingInset = scaffoldGeometry.minInsets.bottom;
    final viewPaddingInset = scaffoldGeometry.minViewPadding.bottom;
    final deviceBottomInset =
        viewPaddingInset > paddingInset ? viewPaddingInset : paddingInset;
    final fabBottomOffset = theme.fabBottomOffset(deviceBottomInset);

    return Offset(
      scaffoldSize.width - fabSize.width - theme.fabMargin,
      (scaffoldSize.height - fabSize.height - fabBottomOffset).clamp(
        0.0,
        scaffoldSize.height - fabSize.height,
      ),
    );
  }
}

/// Inherited widget holding the scroll bottom padding for the active tab.
///
/// This padding is dynamically computed on [TabBarPage] and provided to child pages.
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

/// A sliver bottom spacer that uses the [TabBarScrollScope] spacing.
///
/// Insert this at the bottom of a [CustomScrollView] to ensure its slivers
/// can clear the floating bottom bar and FAB.
class TabBarScrollBottomSliver extends StatelessWidget {
  const TabBarScrollBottomSliver({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: SizedBox(height: TabBarScrollScope.of(context)),
    );
  }
}

/// Applies bottom spacing to standard scrollable list content using [TabBarScrollScope].
class TabBarScrollPadding extends StatelessWidget {
  const TabBarScrollPadding({
    super.key,
    required this.child,
    this.additional = EdgeInsets.zero,
  });

  final Widget child;
  final EdgeInsets additional;

  /// Combined [additional] insets plus tab-bar scroll clearance at the bottom.
  static EdgeInsets contentInsets(
    BuildContext context, {
    EdgeInsets additional = EdgeInsets.zero,
  }) {
    return additional.copyWith(
      bottom: additional.bottom + TabBarScrollScope.of(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: contentInsets(context, additional: additional),
      child: child,
    );
  }
}

/// Allows tab content to extend fully under the floating bar and home indicator insets.
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
