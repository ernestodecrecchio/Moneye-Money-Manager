import 'package:expense_tracker/core/style/app_theme.dart';
import 'package:flutter/material.dart';

/// Layout metrics for the floating tab bar, derived from [AppChrome] and device insets.
extension TabBarChrome on BuildContext {
  double get tabBarChromeHeight =>
      appChrome.chromeHeight(deviceBottomInset);

  double get tabBarFadeOverlayHeight =>
      appChrome.fadeOverlayHeight(deviceBottomInset);

  double get tabBarFabBottomOffset =>
      appChrome.fabBottomOffset(deviceBottomInset);

  double tabBarScrollBottomInset({bool includeFab = false}) =>
      appChrome.scrollBottomInset(
        deviceBottomInset,
        includeFab: includeFab,
      );
}
