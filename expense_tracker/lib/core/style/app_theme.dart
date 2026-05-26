import 'package:expense_tracker/core/configuration/constants.dart';
import 'package:expense_tracker/core/style/style.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

enum AppThemeMode {
  system,
  light,
  dark,
  darkBlue;

  bool get isEnabled {
    switch (this) {
      case darkBlue:
        return kDebugMode;
      default:
        return true;
    }
  }
}

extension AppThemeModeExtension on AppThemeMode {
  /// Returns the [ThemeData] associated with this [AppThemeMode].
  ///
  /// This is used for the "light mode" configuration of the application.
  ThemeData get themeData {
    switch (this) {
      case AppThemeMode.system:
        return AppTheme.light;
      case AppThemeMode.light:
        return AppTheme.light;
      case AppThemeMode.dark:
        return AppTheme.dark;
      case AppThemeMode.darkBlue:
        return AppTheme.dark;
    }
  }

  /// Returns the corresponding [ThemeData] to be used when the app is in dark mode.
  ///
  /// For [AppThemeMode.system], this returns the standard dark theme.
  /// For fixed modes like [AppThemeMode.dark] or [AppThemeMode.green], it returns
  /// the specific theme regardless of the platform brightness.
  ThemeData get darkThemeData {
    switch (this) {
      case AppThemeMode.system:
        return AppTheme.dark;
      case AppThemeMode.light:
        return AppTheme.light;
      case AppThemeMode.dark:
        return AppTheme.dark;
      case AppThemeMode.darkBlue:
        return AppTheme.darkBlue;
    }
  }

  /// Maps the custom [AppThemeMode] to a standard Flutter [ThemeMode].
  ///
  /// This bridge function allows Flutter's [MaterialApp] to categorize custom
  /// themes (like Green) into either light or dark buckets for internal logic.
  ThemeMode get flutterThemeMode {
    switch (this) {
      case AppThemeMode.system:
        return ThemeMode.system;
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
      case AppThemeMode.darkBlue:
        return ThemeMode.dark;
    }
  }

  /// Returns a descriptive [IconData] representing the theme mode.
  IconData get icon {
    switch (this) {
      case AppThemeMode.system:
        return Icons.brightness_auto_rounded;
      case AppThemeMode.light:
        return Icons.light_mode_rounded;
      case AppThemeMode.dark:
        return Icons.dark_mode_rounded;
      case AppThemeMode.darkBlue:
        return Icons.dark_mode_rounded;
    }
  }

  /// Returns the localized display name for the theme mode.
  ///
  /// Requires [appLocalizations] to provide translated strings.
  String getName(dynamic appLocalizations) {
    switch (this) {
      case AppThemeMode.system:
        return appLocalizations.systemTheme;
      case AppThemeMode.light:
        return appLocalizations.lightTheme;
      case AppThemeMode.dark:
        return appLocalizations.darkTheme;
      case AppThemeMode.darkBlue:
        return "Dark Blue";
    }
  }
}

class AppColors extends ThemeExtension<AppColors> {
  final Color primary;
  final Color onPrimary;
  final Color secondary;
  final Color onSecondary;
  final Color accent;
  final Color scaffoldBackground;
  final Color surface;
  final Color fieldBackground;
  final Color onSurface;
  final Color onSurfaceAppBar;
  final Color onSurfaceTextAppBar;
  final Color textPrimary;
  final Color textSecondary;
  final Color divider;
  final Color income;
  final Color expense;
  final Color warning;

  const AppColors({
    required this.primary,
    required this.onPrimary,
    required this.secondary,
    required this.onSecondary,
    required this.accent,
    required this.scaffoldBackground,
    required this.surface,
    required this.fieldBackground,
    required this.onSurface,
    required this.onSurfaceAppBar,
    required this.onSurfaceTextAppBar,
    required this.textPrimary,
    required this.textSecondary,
    required this.divider,
    required this.income,
    required this.expense,
    required this.warning,
  });

  @override
  AppColors copyWith({
    Color? primary,
    Color? onPrimary,
    Color? secondary,
    Color? onSecondary,
    Color? accent,
    Color? scaffoldBackground,
    Color? surface,
    Color? fieldBackground,
    Color? onSurface,
    Color? onSurfaceAppBar,
    Color? onSurfaceTextAppBar,
    Color? textPrimary,
    Color? textSecondary,
    Color? divider,
    Color? income,
    Color? expense,
    Color? warning,
  }) {
    return AppColors(
      primary: primary ?? this.primary,
      onPrimary: onPrimary ?? this.onPrimary,
      secondary: secondary ?? this.secondary,
      onSecondary: onSecondary ?? this.onSecondary,
      accent: accent ?? this.accent,
      scaffoldBackground: scaffoldBackground ?? this.scaffoldBackground,
      surface: surface ?? this.surface,
      fieldBackground: fieldBackground ?? this.fieldBackground,
      onSurface: onSurface ?? this.onSurface,
      onSurfaceAppBar: onSurfaceAppBar ?? this.onSurfaceAppBar,
      onSurfaceTextAppBar: onSurfaceTextAppBar ?? this.onSurfaceTextAppBar,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      divider: divider ?? this.divider,
      income: income ?? this.income,
      expense: expense ?? this.expense,
      warning: warning ?? this.warning,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      primary: Color.lerp(primary, other.primary, t)!,
      onPrimary: Color.lerp(onPrimary, other.onPrimary, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      onSecondary: Color.lerp(onSecondary, other.onSecondary, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      scaffoldBackground:
          Color.lerp(scaffoldBackground, other.scaffoldBackground, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      fieldBackground: Color.lerp(fieldBackground, other.fieldBackground, t)!,
      onSurface: Color.lerp(onSurface, other.onSurface, t)!,
      onSurfaceAppBar: Color.lerp(onSurfaceAppBar, other.onSurfaceAppBar, t)!,
      onSurfaceTextAppBar:
          Color.lerp(onSurfaceTextAppBar, other.onSurfaceTextAppBar, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      income: Color.lerp(income, other.income, t)!,
      expense: Color.lerp(expense, other.expense, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
    );
  }

  static const light = AppColors(
    primary: CustomColors.blue,
    onPrimary: Colors.white,
    secondary: CustomColors.darkBlue,
    onSecondary: Colors.white,
    accent: CustomColors.darkBlue,
    scaffoldBackground: Colors.white,
    surface: Colors.white,
    fieldBackground: CustomColors.lightSurface,
    onSurface: CustomColors.lightBlack,
    onSurfaceAppBar: Colors.white,
    onSurfaceTextAppBar: Colors.white,
    textPrimary: CustomColors.lightBlack,
    textSecondary: CustomColors.clearGreyText,
    divider: CustomColors.clearGrey,
    income: CustomColors.income,
    expense: CustomColors.expense,
    warning: CustomColors.orange500,
  );

  static const dark = AppColors(
    primary: Colors.white,
    onPrimary: Colors.black,
    secondary: Colors.white,
    onSecondary: Colors.black,
    accent: Colors.white,
    scaffoldBackground: CustomColors.darkScaffoldBackground,
    surface: CustomColors.darkSurface,
    fieldBackground: CustomColors.darkSurface,
    onSurface: Colors.white,
    onSurfaceAppBar: Colors.white,
    onSurfaceTextAppBar: Colors.white,
    textPrimary: Colors.white,
    textSecondary: CustomColors.clearGreyText,
    divider: CustomColors.darkDivider,
    income: CustomColors.darkIncome,
    expense: CustomColors.darkExpense,
    warning: CustomColors.orange300,
  );

  static const darkBlue = AppColors(
    primary: Color.fromARGB(255, 100, 184, 252),
    onPrimary: Colors.white,
    secondary: Color.fromARGB(255, 100, 184, 252),
    onSecondary: Colors.white,
    accent: Color.fromARGB(255, 100, 184, 252),
    scaffoldBackground: CustomColors.darkScaffoldBackground,
    surface: CustomColors.darkSurface,
    fieldBackground: CustomColors.darkSurface,
    onSurface: Colors.white,
    onSurfaceAppBar: Colors.white,
    onSurfaceTextAppBar: Color.fromARGB(255, 100, 184, 252),
    textPrimary: Colors.white,
    textSecondary: CustomColors.clearGreyText,
    divider: CustomColors.darkDivider,
    income: CustomColors.darkIncome,
    expense: CustomColors.darkExpense,
    warning: CustomColors.orange300,
  );
}

/// Shared layout metrics for the tab bar, FAB, and related scroll insets.
class AppChrome extends ThemeExtension<AppChrome> {
  const AppChrome({
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
  });

  /// Height of the floating tab bar pill (icons and labels), excluding outer padding.
  final double tabBarHeight;

  /// Space between the bottom of the tab bar and the physical screen edge
  /// (sits above the system home-indicator inset).
  final double tabBarBottomMargin;

  /// Horizontal inset of the tab bar from the left and right screen edges.
  final double tabBarHorizontalMargin;

  /// Corner radius of the outer tab bar container (floating capsule).
  final double tabBarOuterRadius;

  /// Corner radius of the selected-tab indicator pill inside the bar.
  final double tabBarItemRadius;

  /// Width and height of the shell [FloatingActionButton] (see [fabSizeConstraints]).
  final double fabSize;

  /// Vertical gap between the top of the tab bar and the bottom of the FAB.
  final double fabAboveTabBarGap;

  /// Distance from the FAB to the bottom and right edges of the screen on the main tab shell.
  final double fabMargin;

  /// Extra padding added below the last scrollable item so content clears the tab bar
  /// (and FAB when present); used in `scrollBottomInset`.
  final double scrollBottomSpacing;

  /// Additional height of the bottom fade gradient above the tab bar chrome
  /// (see [fadeOverlayHeight]).
  final double fadeExtensionAboveBar;

  static const standard = AppChrome(
    tabBarHeight: 68,
    tabBarBottomMargin: 4,
    tabBarHorizontalMargin: Constants.horizontalPadding,
    tabBarOuterRadius: 36,
    tabBarItemRadius: 28,
    fabSize: 56,
    fabAboveTabBarGap: 0,
    fabMargin: 16,
    scrollBottomSpacing: 0,
    fadeExtensionAboveBar: 0,
  );

  BoxConstraints get fabSizeConstraints =>
      BoxConstraints.tightFor(width: fabSize, height: fabSize);

  /// Distance from the physical bottom of the screen to the top of the tab bar.
  double chromeHeight(double deviceBottomInset) =>
      tabBarHeight + tabBarBottomMargin + deviceBottomInset;

  double fadeOverlayHeight(double deviceBottomInset) =>
      chromeHeight(deviceBottomInset) + fadeExtensionAboveBar;

  double fabBottomOffset(double deviceBottomInset) =>
      chromeHeight(deviceBottomInset) + fabAboveTabBarGap;

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

  @override
  AppChrome copyWith({
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
    return AppChrome(
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
    );
  }

  @override
  AppChrome lerp(ThemeExtension<AppChrome>? other, double t) {
    if (other is! AppChrome) return this;
    return AppChrome(
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
    );
  }

  static double _lerpDouble(double a, double b, double t) => a + (b - a) * t;
}

class AppTheme {
  static const _chrome = AppChrome.standard;

  static FloatingActionButtonThemeData _floatingActionButtonTheme({
    required Color backgroundColor,
    required Color foregroundColor,
  }) {
    return FloatingActionButtonThemeData(
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      shape: const CircleBorder(),
      sizeConstraints: _chrome.fabSizeConstraints,
    );
  }

  static ThemeData get light {
    const fontFamily = 'Ubuntu';
    const colors = AppColors.light;

    return ThemeData(
      useMaterial3: true,
      fontFamily: fontFamily,
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        primary: colors.primary,
        onPrimary: colors.onPrimary,
        secondary: colors.secondary,
        onSecondary: colors.onSecondary,
        surface: colors.surface,
        onSurface: colors.onSurface,
        error: colors.expense,
      ),
      scaffoldBackgroundColor: colors.scaffoldBackground,
      appBarTheme: AppBarTheme(
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
        elevation: 0,
        titleTextStyle: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 20,
          fontFamily: fontFamily,
          color: Colors.white,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      listTileTheme: ListTileThemeData(
        iconColor: colors.accent,
      ),
      floatingActionButtonTheme: _floatingActionButtonTheme(
        backgroundColor: colors.secondary,
        foregroundColor: colors.onSecondary,
      ),
      dividerTheme: DividerThemeData(
        color: colors.divider,
        thickness: 1,
        space: 0,
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colors.primary,
          textStyle: const TextStyle(fontFamily: fontFamily),
        ),
      ),
      iconTheme: IconThemeData(color: colors.accent),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return colors.primary;
          return null;
        }),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.fieldBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(40),
          borderSide: BorderSide.none,
        ),
        hintStyle: TextStyle(color: colors.textSecondary.withAlpha(150)),
      ),
      textTheme: TextTheme(
        displayLarge:
            TextStyle(color: colors.textPrimary, fontWeight: FontWeight.bold),
        displayMedium:
            TextStyle(color: colors.textPrimary, fontWeight: FontWeight.bold),
        displaySmall:
            TextStyle(color: colors.textPrimary, fontWeight: FontWeight.bold),
        headlineLarge:
            TextStyle(color: colors.textPrimary, fontWeight: FontWeight.bold),
        headlineMedium:
            TextStyle(color: colors.textPrimary, fontWeight: FontWeight.bold),
        headlineSmall:
            TextStyle(color: colors.textPrimary, fontWeight: FontWeight.bold),
        titleLarge:
            TextStyle(color: colors.textPrimary, fontWeight: FontWeight.w600),
        titleMedium:
            TextStyle(color: colors.textPrimary, fontWeight: FontWeight.w600),
        titleSmall:
            TextStyle(color: colors.textPrimary, fontWeight: FontWeight.w600),
        bodyLarge: TextStyle(color: colors.textPrimary),
        bodyMedium: TextStyle(color: colors.textPrimary),
        bodySmall: TextStyle(color: colors.textSecondary),
        labelLarge: TextStyle(color: colors.textPrimary),
        labelMedium: TextStyle(color: colors.textSecondary),
        labelSmall: TextStyle(color: colors.textSecondary),
      ),
      tabBarTheme: TabBarThemeData(
        labelStyle: const TextStyle(
            fontFamily: fontFamily, fontWeight: FontWeight.bold),
        unselectedLabelStyle: const TextStyle(
            fontFamily: fontFamily, fontWeight: FontWeight.normal),
        labelColor: colors.primary,
        unselectedLabelColor: colors.textSecondary,
        indicatorColor: colors.primary,
        indicatorSize: TabBarIndicatorSize.tab,
      ),
      extensions: [colors, _chrome],
    );
  }

  static ThemeData get dark {
    const fontFamily = 'Ubuntu';
    const colors = AppColors.dark;

    return ThemeData(
      useMaterial3: true,
      fontFamily: fontFamily,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: colors.primary,
        onPrimary: colors.onPrimary,
        secondary: colors.secondary,
        onSecondary: colors.onSecondary,
        surface: colors.surface,
        onSurface: colors.onSurface,
        error: colors.expense,
      ),
      scaffoldBackgroundColor: colors.scaffoldBackground,
      appBarTheme: AppBarTheme(
        backgroundColor: colors.surface,
        foregroundColor: colors.accent,
        elevation: 0,
        titleTextStyle: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 20,
          fontFamily: fontFamily,
          color: colors.primary,
        ),
        iconTheme: IconThemeData(color: colors.primary),
      ),
      listTileTheme: ListTileThemeData(
        iconColor: colors.accent,
      ),
      floatingActionButtonTheme: _floatingActionButtonTheme(
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
      ),
      dividerTheme: DividerThemeData(
        color: colors.divider,
        thickness: 1,
        space: 0,
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colors.primary,
          textStyle: const TextStyle(fontFamily: fontFamily),
        ),
      ),
      iconTheme: IconThemeData(color: colors.accent),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return colors.primary;
          return null;
        }),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.fieldBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(40),
          borderSide: BorderSide.none,
        ),
        hintStyle: TextStyle(color: colors.textSecondary.withAlpha(150)),
      ),
      textTheme: TextTheme(
        displayLarge:
            TextStyle(color: colors.textPrimary, fontWeight: FontWeight.bold),
        displayMedium:
            TextStyle(color: colors.textPrimary, fontWeight: FontWeight.bold),
        displaySmall:
            TextStyle(color: colors.textPrimary, fontWeight: FontWeight.bold),
        headlineLarge:
            TextStyle(color: colors.textPrimary, fontWeight: FontWeight.bold),
        headlineMedium:
            TextStyle(color: colors.textPrimary, fontWeight: FontWeight.bold),
        headlineSmall:
            TextStyle(color: colors.textPrimary, fontWeight: FontWeight.bold),
        titleLarge:
            TextStyle(color: colors.textPrimary, fontWeight: FontWeight.w600),
        titleMedium:
            TextStyle(color: colors.textPrimary, fontWeight: FontWeight.w600),
        titleSmall:
            TextStyle(color: colors.textPrimary, fontWeight: FontWeight.w600),
        bodyLarge: TextStyle(color: colors.textPrimary),
        bodyMedium: TextStyle(color: colors.textPrimary),
        bodySmall: TextStyle(color: colors.textSecondary),
        labelLarge: TextStyle(color: colors.textPrimary),
        labelMedium: TextStyle(color: colors.textSecondary),
        labelSmall: TextStyle(color: colors.textSecondary),
      ),
      tabBarTheme: TabBarThemeData(
        labelStyle: const TextStyle(
            fontFamily: fontFamily, fontWeight: FontWeight.bold),
        unselectedLabelStyle: const TextStyle(
            fontFamily: fontFamily, fontWeight: FontWeight.normal),
        labelColor: colors.primary,
        unselectedLabelColor: colors.textSecondary,
        indicatorColor: colors.primary,
        indicatorSize: TabBarIndicatorSize.tab,
      ),
      extensions: [colors, _chrome],
    );
  }

  static ThemeData get darkBlue {
    const fontFamily = 'Ubuntu';
    const colors = AppColors.darkBlue;

    return ThemeData(
      useMaterial3: true,
      fontFamily: fontFamily,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: colors.primary,
        onPrimary: colors.onPrimary,
        secondary: colors.secondary,
        onSecondary: colors.onSecondary,
        surface: colors.surface,
        onSurface: colors.onSurface,
        error: colors.expense,
      ),
      scaffoldBackgroundColor: colors.scaffoldBackground,
      appBarTheme: AppBarTheme(
        backgroundColor: colors.surface,
        foregroundColor: colors.accent,
        elevation: 0,
        titleTextStyle: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 20,
          fontFamily: fontFamily,
          color: colors.primary,
        ),
        iconTheme: IconThemeData(color: colors.primary),
      ),
      listTileTheme: ListTileThemeData(
        iconColor: colors.accent,
      ),
      floatingActionButtonTheme: _floatingActionButtonTheme(
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
      ),
      dividerTheme: DividerThemeData(
        color: colors.divider,
        thickness: 1,
        space: 0,
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colors.primary,
          textStyle: const TextStyle(fontFamily: fontFamily),
        ),
      ),
      iconTheme: IconThemeData(color: colors.accent),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return colors.primary;
          return null;
        }),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.fieldBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(40),
          borderSide: BorderSide.none,
        ),
        hintStyle: TextStyle(color: colors.textSecondary.withAlpha(150)),
      ),
      textTheme: TextTheme(
        displayLarge:
            TextStyle(color: colors.textPrimary, fontWeight: FontWeight.bold),
        displayMedium:
            TextStyle(color: colors.textPrimary, fontWeight: FontWeight.bold),
        displaySmall:
            TextStyle(color: colors.textPrimary, fontWeight: FontWeight.bold),
        headlineLarge:
            TextStyle(color: colors.textPrimary, fontWeight: FontWeight.bold),
        headlineMedium:
            TextStyle(color: colors.textPrimary, fontWeight: FontWeight.bold),
        headlineSmall:
            TextStyle(color: colors.textPrimary, fontWeight: FontWeight.bold),
        titleLarge:
            TextStyle(color: colors.textPrimary, fontWeight: FontWeight.w600),
        titleMedium:
            TextStyle(color: colors.textPrimary, fontWeight: FontWeight.w600),
        titleSmall:
            TextStyle(color: colors.textPrimary, fontWeight: FontWeight.w600),
        bodyLarge: TextStyle(color: colors.textPrimary),
        bodyMedium: TextStyle(color: colors.textPrimary),
        bodySmall: TextStyle(color: colors.textSecondary),
        labelLarge: TextStyle(color: colors.textPrimary),
        labelMedium: TextStyle(color: colors.textSecondary),
        labelSmall: TextStyle(color: colors.textSecondary),
      ),
      tabBarTheme: TabBarThemeData(
        labelStyle: const TextStyle(
            fontFamily: fontFamily, fontWeight: FontWeight.bold),
        unselectedLabelStyle: const TextStyle(
            fontFamily: fontFamily, fontWeight: FontWeight.normal),
        labelColor: colors.primary,
        unselectedLabelColor: colors.textSecondary,
        indicatorColor: colors.primary,
        indicatorSize: TabBarIndicatorSize.tab,
      ),
      extensions: [colors, _chrome],
    );
  }
}

extension ThemeExt on BuildContext {
  AppColors get appColors => Theme.of(this).extension<AppColors>()!;

  AppChrome get appChrome => Theme.of(this).extension<AppChrome>()!;

  /// Home-indicator inset; prefers [MediaQuery.viewPadding] when padding is stripped.
  double get deviceBottomInset {
    final media = MediaQuery.of(this);
    return media.viewPadding.bottom > media.padding.bottom
        ? media.viewPadding.bottom
        : media.padding.bottom;
  }
}
