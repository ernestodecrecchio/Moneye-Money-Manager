import 'package:expense_tracker/core/style/app_theme.dart';
import 'package:expense_tracker/features/home/presentation/widgets/tab_bar/tab_bar_chrome.dart';
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
///
/// Uses [AppChrome.standard] because [FloatingActionButtonLocation.getOffset]
/// has no [BuildContext] to read the theme extension.
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

/// Bottom spacer for [CustomScrollView] tab content.
class TabBarScrollBottomSliver extends StatelessWidget {
  const TabBarScrollBottomSliver({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: SizedBox(height: TabBarScrollScope.of(context)),
    );
  }
}

/// Applies [TabBarScrollScope] padding to scrollable or list content.
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
