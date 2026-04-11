import 'package:expense_tracker/style/style.dart';
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
  final Color onSurface;
  final Color onSurfaceAppBar;
  final Color onSurfaceTextAppBar;
  final Color textPrimary;
  final Color textSecondary;
  final Color divider;
  final Color income;
  final Color expense;

  const AppColors({
    required this.primary,
    required this.onPrimary,
    required this.secondary,
    required this.onSecondary,
    required this.accent,
    required this.scaffoldBackground,
    required this.surface,
    required this.onSurface,
    required this.onSurfaceAppBar,
    required this.onSurfaceTextAppBar,
    required this.textPrimary,
    required this.textSecondary,
    required this.divider,
    required this.income,
    required this.expense,
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
    Color? onSurface,
    Color? onSurfaceAppBar,
    Color? onSurfaceTextAppBar,
    Color? textPrimary,
    Color? textSecondary,
    Color? divider,
    Color? income,
    Color? expense,
  }) {
    return AppColors(
      primary: primary ?? this.primary,
      onPrimary: onPrimary ?? this.onPrimary,
      secondary: secondary ?? this.secondary,
      onSecondary: onSecondary ?? this.onSecondary,
      accent: accent ?? this.accent,
      scaffoldBackground: scaffoldBackground ?? this.scaffoldBackground,
      surface: surface ?? this.surface,
      onSurface: onSurface ?? this.onSurface,
      onSurfaceAppBar: onSurfaceAppBar ?? this.onSurfaceAppBar,
      onSurfaceTextAppBar: onSurfaceTextAppBar ?? this.onSurfaceTextAppBar,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      divider: divider ?? this.divider,
      income: income ?? this.income,
      expense: expense ?? this.expense,
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
      onSurface: Color.lerp(onSurface, other.onSurface, t)!,
      onSurfaceAppBar: Color.lerp(onSurfaceAppBar, other.onSurfaceAppBar, t)!,
      onSurfaceTextAppBar:
          Color.lerp(onSurfaceTextAppBar, other.onSurfaceTextAppBar, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      income: Color.lerp(income, other.income, t)!,
      expense: Color.lerp(expense, other.expense, t)!,
    );
  }

  static const light = AppColors(
    primary: CustomColors.blue,
    onPrimary: Colors.white,
    secondary: CustomColors.darkBlue,
    onSecondary: Colors.white,
    accent: CustomColors.darkBlue,
    scaffoldBackground: Colors.white,
    surface: CustomColors.lightSurface,
    onSurface: CustomColors.lightBlack,
    onSurfaceAppBar: Colors.white,
    onSurfaceTextAppBar: Colors.white,
    textPrimary: CustomColors.lightBlack,
    textSecondary: CustomColors.clearGreyText,
    divider: CustomColors.clearGrey,
    income: CustomColors.income,
    expense: CustomColors.expense,
  );

  static const dark = AppColors(
    primary: Colors.white,
    onPrimary: Colors.black,
    secondary: Colors.white,
    onSecondary: Colors.black,
    accent: Colors.white,
    scaffoldBackground: CustomColors.darkScaffoldBackground,
    surface: CustomColors.darkSurface,
    onSurface: Colors.white,
    onSurfaceAppBar: Colors.white,
    onSurfaceTextAppBar: Colors.white,
    textPrimary: Colors.white,
    textSecondary: CustomColors.clearGreyText,
    divider: CustomColors.darkDivider,
    income: CustomColors.darkIncome,
    expense: CustomColors.darkExpense,
  );

  static const darkBlue = AppColors(
    primary: Color.fromARGB(255, 100, 184, 252),
    onPrimary: Colors.white,
    secondary: Color.fromARGB(255, 100, 184, 252),
    onSecondary: Colors.white,
    accent: Color.fromARGB(255, 100, 184, 252),
    scaffoldBackground: CustomColors.darkScaffoldBackground,
    surface: CustomColors.darkSurface,
    onSurface: Colors.white,
    onSurfaceAppBar: Colors.white,
    onSurfaceTextAppBar: Color.fromARGB(255, 100, 184, 252),
    textPrimary: Colors.white,
    textSecondary: CustomColors.clearGreyText,
    divider: CustomColors.darkDivider,
    income: CustomColors.darkIncome,
    expense: CustomColors.darkExpense,
  );
}

class AppTheme {
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
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colors.secondary,
        foregroundColor: colors.onSecondary,
        shape: const CircleBorder(),
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
        fillColor: colors.surface,
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
      extensions: [colors],
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
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
        shape: const CircleBorder(),
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
        fillColor: colors.surface,
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
      extensions: [colors],
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
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
        shape: const CircleBorder(),
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
        fillColor: colors.surface,
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
      extensions: [colors],
    );
  }
}

extension ThemeExt on BuildContext {
  AppColors get appColors => Theme.of(this).extension<AppColors>()!;
}
