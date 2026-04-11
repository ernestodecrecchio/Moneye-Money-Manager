import 'package:flutter/material.dart';

class CustomColors {
  /// #3860E4
  static const blue = Color.fromARGB(255, 56, 96, 228);

  /// #F9FAFE
  static const lightBlue = Color.fromARGB(255, 249, 250, 254);

  /// 000C33
  static const darkBlue = Color.fromARGB(255, 0, 12, 51);

  /// #020319
  static const lightBlack = Color.fromARGB(255, 2, 3, 25);

  /// #F6F6F6
  static const clearGrey = Color.fromARGB(255, 246, 246, 246);

  ///
  static const clearGreyText = Color.fromARGB(255, 132, 132, 132);

  /// #6BBC98
  static const income = Color.fromARGB(255, 107, 188, 152);

  /// #FC5757
  static const expense = Color.fromARGB(255, 252, 87, 87);

  /// #F5F7FB
  static const lightSurface = Color(0xFFF5F7FB);

  /// #121212
  static const darkScaffoldBackground = Color(0xFF121212);

  /// #1E1E1E
  static const darkSurface = Color(0xFF1E1E1E);

  /// #2C2C2C
  static const darkDivider = Color.fromARGB(255, 28, 28, 28);

  /// #81C784
  static const darkIncome = Color(0xFF81C784);

  /// #E57373
  static const darkExpense = Color(0xFFE57373);

  /// #FE4A49 (Swipe Action Red)
  static const swipeActionRed = Color(0xFFFE4A49);

  /// #7589A2 (Chart Labels Gray)
  static const chartLabelsGray = Color(0xFF7589A2);

  // Picker Colors - Organized by shade/hue
  static const red300 = Color(0xFFE57373);
  static const red500 = Color(0xFFF44336);
  static const red700 = Color(0xFFD32F2F);

  static const pink300 = Color(0xFFF06292);
  static const pink500 = Color(0xFFE91E63);
  static const pink700 = Color(0xFFC2185B);

  static const deepOrange300 = Color(0xFFFF8A65);
  static const deepOrange500 = Color(0xFFFF5722);
  static const deepOrange700 = Color(0xFFE64A19);

  static const orange300 = Color(0xFFFFB74D);
  static const orange500 = Color(0xFFFF9800);
  static const orange700 = Color(0xFFF57C00);

  static const amber500 = Color(0xFFFFC107);
  static const yellow500 = Color(0xFFFFEB3B);

  static const lime300 = Color(0xFFDCE775);
  static const lime500 = Color(0xFFCDDC39);
  static const lime700 = Color(0xFFAFB42B);

  static const lightGreen300 = Color(0xFFAED581);
  static const lightGreen500 = Color(0xFF8BC34A);
  static const lightGreen700 = Color(0xFF689F38);

  static const green300 = Color(0xFF81C784);
  static const green500 = Color(0xFF4CAF50);
  static const green700 = Color(0xFF388E3C);

  static const teal300 = Color(0xFF4DB6AC);
  static const teal500 = Color(0xFF009688);
  static const teal700 = Color(0xFF00796B);

  static const cyan300 = Color(0xFF4DD0E1);
  static const cyan500 = Color(0xFF00BCD4);
  static const cyan700 = Color(0xFF0097A7);

  static const blue300 = Color(0xFF64B5F6);
  static const blue500 = Color(0xFF2196F3);
  static const blue700 = Color(0xFF1976D2);

  static const indigo300 = Color(0xFF7986CB);
  static const indigo500 = Color(0xFF3F51B5);
  static const indigo700 = Color(0xFF303F9F);

  static const deepPurple300 = Color(0xFF9575CD);
  static const deepPurple500 = Color(0xFF673AB7);
  static const deepPurple700 = Color(0xFF512DA8);

  static const purple300 = Color(0xFFBA68C8);
  static const purple500 = Color(0xFF9C27B0);
  static const purple700 = Color(0xFF7B1FA2);

  static const brown300 = Color(0xFFA1887F);
  static const brown500 = Color(0xFF795548);
  static const brown700 = Color(0xFF5D4037);

  static const blueGrey300 = Color(0xFF90A4AE);
  static const blueGrey500 = Color(0xFF607D8B);
  static const blueGrey700 = Color(0xFF455A64);

  static const grey300 = Color(0xFFE0E0E0);
  static const grey500 = Color(0xFF9E9E9E);
  static const grey700 = Color(0xFF616161);

  static const black = Color(0xFF000000);

  static const Color defaultPickerColor = red500;
  static const List<Color> pickerColorList = [
    // Reds
    red300, red500, red700,
    // Pinks
    pink300, pink500, pink700,
    // Oranges
    deepOrange300, deepOrange500, deepOrange700,
    orange300, orange500, orange700,
    // Yellows
    amber500, yellow500,
    // Greens
    lime300, lime500, lime700,
    lightGreen300, lightGreen500, lightGreen700,
    green300, green500, green700,
    teal300, teal500, teal700,
    // Blues
    cyan300, cyan500, cyan700,
    blue300, blue500, blue700,
    indigo300, indigo500, indigo700,
    // Purples
    deepPurple300, deepPurple500, deepPurple700,
    purple300, purple500, purple700,
    // Neutrals
    brown300, brown500, brown700,
    blueGrey300, blueGrey500, blueGrey700,
    grey300, grey500, grey700,
    black,
  ];
}

extension ColorExtension on Color {
  Color darken([double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(this);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

    return hslDark.toColor();
  }

  Color lighten([double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(this);
    final hslLight =
        hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));

    return hslLight.toColor();
  }
}
