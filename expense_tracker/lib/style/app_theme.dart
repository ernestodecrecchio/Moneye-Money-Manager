import 'package:expense_tracker/style.dart';
import 'package:flutter/material.dart';

class AppColors extends ThemeExtension<AppColors> {
  final Color primary;
  final Color onPrimary;
  final Color secondary;
  final Color onSecondary;
  final Color scaffoldBackground;
  final Color surface;
  final Color onSurface;
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
    required this.scaffoldBackground,
    required this.surface,
    required this.onSurface,
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
    Color? scaffoldBackground,
    Color? surface,
    Color? onSurface,
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
      scaffoldBackground: scaffoldBackground ?? this.scaffoldBackground,
      surface: surface ?? this.surface,
      onSurface: onSurface ?? this.onSurface,
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
      scaffoldBackground:
          Color.lerp(scaffoldBackground, other.scaffoldBackground, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      onSurface: Color.lerp(onSurface, other.onSurface, t)!,
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
    scaffoldBackground: Colors.white,
    surface: CustomColors.lightSurface,
    onSurface: CustomColors.lightBlack,
    textPrimary: CustomColors.lightBlack,
    textSecondary: CustomColors.clearGreyText,
    divider: CustomColors.clearGrey,
    income: CustomColors.income,
    expense: CustomColors.expense,
  );

  static const dark = AppColors(
    primary: Colors.orange,
    onPrimary: Colors.black,
    secondary: Colors.orange,
    onSecondary: Colors.black,
    scaffoldBackground: CustomColors.darkScaffoldBackground,
    surface: CustomColors.darkSurface,
    onSurface: Colors.white,
    textPrimary: Colors.white,
    textSecondary: Colors.grey,
    divider: CustomColors.darkDivider,
    income: CustomColors.darkIncome,
    expense: CustomColors.darkExpense,
  );
}

class AppTheme {
  static ThemeData get light {
    final colors = AppColors.light;
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Ubuntu',
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        primary: colors.primary,
        onPrimary: colors.onPrimary,
        secondary: colors.secondary,
        onSecondary: colors.onSecondary,
        surface: colors.scaffoldBackground,
        onSurface: colors.textPrimary,
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
          fontFamily: 'Ubuntu',
          color: Colors.white,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
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
          textStyle: const TextStyle(fontFamily: 'Ubuntu'),
        ),
      ),
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
        labelStyle:
            const TextStyle(fontFamily: 'Ubuntu', fontWeight: FontWeight.bold),
        unselectedLabelStyle: const TextStyle(
            fontFamily: 'Ubuntu', fontWeight: FontWeight.normal),
        labelColor: colors.primary,
        unselectedLabelColor: colors.textSecondary,
        indicatorColor: colors.primary,
        indicatorSize: TabBarIndicatorSize.tab,
      ),
      extensions: [colors],
    );
  }

  static ThemeData get dark {
    final colors = AppColors.dark;
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Ubuntu',
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
        foregroundColor: colors.onSurface,
        elevation: 0,
        titleTextStyle: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 20,
          fontFamily: 'Ubuntu',
          color: colors.primary,
        ),
        iconTheme: IconThemeData(color: colors.primary),
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
          textStyle: const TextStyle(fontFamily: 'Ubuntu'),
        ),
      ),
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
        labelStyle:
            const TextStyle(fontFamily: 'Ubuntu', fontWeight: FontWeight.bold),
        unselectedLabelStyle: const TextStyle(
            fontFamily: 'Ubuntu', fontWeight: FontWeight.normal),
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
