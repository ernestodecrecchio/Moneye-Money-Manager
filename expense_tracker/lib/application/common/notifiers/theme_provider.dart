import 'package:expense_tracker/style/app_theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeNotifier extends Notifier<AppThemeMode> {
  static const _themeKey = 'theme_mode';

  @override
  AppThemeMode build() {
    return AppThemeMode.system;
  }

  void setFromLocalStorage(String? themeModeString) {
    if (themeModeString == null) {
      state = AppThemeMode.system;
      return;
    }

    state = AppThemeMode.values.firstWhere(
      (e) => e.name == themeModeString,
      orElse: () => AppThemeMode.system,
    );
  }

  Future<void> updateThemeMode(AppThemeMode mode) async {
    state = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, mode.name);
  }
}

final themeProvider = NotifierProvider<ThemeNotifier, AppThemeMode>(() {
  return ThemeNotifier();
});
