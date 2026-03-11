import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeNotifier extends Notifier<ThemeMode> {
  static const _themeKey = 'theme_mode';

  @override
  ThemeMode build() {
    return ThemeMode.system;
  }

  void setFromLocalStorage(String? themeModeString) {
    if (themeModeString == null) {
      state = ThemeMode.system;
      return;
    }

    state = ThemeMode.values.firstWhere(
      (e) => e.name == themeModeString,
      orElse: () => ThemeMode.system,
    );
  }

  Future<void> updateThemeMode(ThemeMode mode) async {
    state = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, mode.name);
  }
}

final themeProvider = NotifierProvider<ThemeNotifier, ThemeMode>(() {
  return ThemeNotifier();
});
