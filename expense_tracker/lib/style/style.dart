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

  // Picker Colors
  static const red1 = Color.fromARGB(255, 244, 67, 54);
  static const red2 = Color.fromARGB(255, 233, 30, 99);
  static const pink1 = Color.fromARGB(255, 255, 153, 187);
  static const pink2 = Color.fromARGB(255, 236, 87, 137);
  static const blue1 = Color.fromARGB(255, 63, 81, 181);
  static const blue2 = Color.fromARGB(255, 33, 150, 243);
  static const green1 = Color.fromARGB(255, 0, 150, 136);
  static const green2 = Color.fromARGB(255, 76, 175, 80);
  static const orange1 = Color.fromARGB(255, 255, 152, 0);
  static const yellow1 = Color.fromARGB(255, 255, 193, 7);
  static const brown1 = Color.fromARGB(255, 121, 85, 72);
  static const brown2 = Color.fromARGB(255, 172, 106, 82);
  static const black = Color.fromARGB(255, 0, 0, 0);
  static const grey = Color.fromARGB(255, 158, 158, 158);

  static const Color defaultPickerColor = red1;
  static const List<Color> pickerColorList = [
    CustomColors.red1,
    CustomColors.red2,
    CustomColors.pink1,
    CustomColors.pink2,
    CustomColors.blue1,
    CustomColors.blue2,
    CustomColors.green1,
    CustomColors.green2,
    CustomColors.orange1,
    CustomColors.yellow1,
    CustomColors.brown1,
    CustomColors.brown2,
    CustomColors.black,
    CustomColors.grey,
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
