import 'dart:ui';

import 'package:expense_tracker/core/style/app_theme.dart';
import 'package:expense_tracker/features/home/presentation/widgets/tab_bar/revolut_bottom_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A floating, pill-shaped bottom bar inspired by Revolut's mobile navigation.
///
/// Layout metrics come from [AppChrome]; colors from [TabBarColors] on the theme.
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

  @override
  Widget build(BuildContext context) {
    final chrome = context.appChrome;
    final tabColors = context.tabBarColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final barRadius = BorderRadius.circular(chrome.tabBarOuterRadius);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        chrome.tabBarHorizontalMargin,
        0,
        chrome.tabBarHorizontalMargin,
        chrome.tabBarBottomMargin + context.deviceBottomInset,
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
              sigmaX: TabBarColors.barBackdropBlurSigma,
              sigmaY: TabBarColors.barBackdropBlurSigma,
            ),
            child: Material(
              color: tabColors.barFill,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: barRadius,
                side: BorderSide(color: tabColors.border),
              ),
              child: SizedBox(
                height: chrome.tabBarHeight,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return _RevolutTabBarTrack(
                        tabWidth: constraints.maxWidth / items.length,
                        currentIndex: currentIndex,
                        items: items,
                        tabColors: tabColors,
                        itemRadius: chrome.tabBarItemRadius,
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

class _RevolutTabBarTrack extends StatelessWidget {
  const _RevolutTabBarTrack({
    required this.tabWidth,
    required this.currentIndex,
    required this.items,
    required this.tabColors,
    required this.itemRadius,
    required this.onTap,
  });

  final double tabWidth;
  final int currentIndex;
  final List<RevolutBottomBarItem> items;
  final TabBarColors tabColors;
  final double itemRadius;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        AnimatedPositioned(
          duration: TabBarColors.selectionAnimationDuration,
          curve: Curves.easeOutCubic,
          left: tabWidth * currentIndex,
          width: tabWidth,
          top: 0,
          bottom: 0,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: tabColors.selectedPillFill,
              borderRadius: BorderRadius.circular(itemRadius),
            ),
          ),
        ),
        Row(
          children: List.generate(items.length, (index) {
            return Expanded(
              child: _RevolutTabBarTab(
                item: items[index],
                selected: index == currentIndex,
                tabColors: tabColors,
                onTap: () {
                  if (index == currentIndex) return;
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

class _RevolutTabBarTab extends StatelessWidget {
  const _RevolutTabBarTab({
    required this.item,
    required this.selected,
    required this.tabColors,
    required this.onTap,
  });

  final RevolutBottomBarItem item;
  final bool selected;
  final TabBarColors tabColors;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final foreground = selected
        ? tabColors.selectedForeground
        : tabColors.unselectedForeground;

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
            item.iconBuilder(selected, foreground),
            const SizedBox(height: 2),
            AnimatedDefaultTextStyle(
              duration: TabBarColors.selectionAnimationDuration,
              curve: Curves.easeOutCubic,
              style: TextStyle(
                fontFamily: 'Ubuntu',
                fontSize: selected ? 11 : 10,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
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
    );
  }
}
