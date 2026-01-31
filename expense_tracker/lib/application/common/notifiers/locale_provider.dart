import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Notifier responsible for managing the application's locale state.
/// This includes setting the locale from local storage on startup,
/// updating the locale when the user changes it, and persisting the choice.
class LocaleNotifier extends Notifier<Locale?> {
  @override
  Locale? build() {
    // Initial state is null, meaning we default to the system locale.
    return null;
  }

  /// Sets the locale from a value stored in local storage (SharedPreferences).
  /// Typically called during app initialization.
  void setFromLocalStorage(String? localStorageValue) {
    if (localStorageValue == null || localStorageValue.isEmpty) {
      state = null;
    } else {
      Intl.defaultLocale = localStorageValue;
      state = Locale(localStorageValue);
    }
  }

  /// Updates the application locale and persists the change to SharedPreferences.
  Future<bool> updateLocale(Locale newLocale) async {
    state = newLocale;

    Intl.defaultLocale = newLocale.languageCode;

    final prefs = await SharedPreferences.getInstance();

    return await prefs.setString('locale', newLocale.languageCode);
  }

  /// Resets the locale to the system default and removes the persisted setting.
  Future<bool> resetLocale() async {
    state = null;

    SharedPreferences prefs = await SharedPreferences.getInstance();

    Intl.defaultLocale = Intl.shortLocale(Platform.localeName);

    return prefs.remove('locale');
  }
}

/// Provider for the [LocaleNotifier], which manages the user's preferred language.
/// This provider is watched by the [appLocalizationsProvider] to rebuild UI on language changes.
final localeProvider = NotifierProvider<LocaleNotifier, Locale?>(() {
  return LocaleNotifier();
});
