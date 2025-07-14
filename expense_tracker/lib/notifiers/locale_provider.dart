import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleNotifier extends Notifier<Locale?> {
  @override
  Locale? build() {
    return null;
  }

  void setFromLocalStorage(String? localStorageValue) {
    Intl.defaultLocale =
        localStorageValue ?? Intl.shortLocale(Platform.localeName);

    state = Locale(localStorageValue ?? Intl.shortLocale(Platform.localeName));
  }

  Future<bool> updateLocale(Locale newLocale) async {
    state = newLocale;

    Intl.defaultLocale = newLocale.languageCode;

    final prefs = await SharedPreferences.getInstance();

    return await prefs.setString('locale', newLocale.languageCode);
  }

  Future<bool> resetLocale() async {
    state = null;

    SharedPreferences prefs = await SharedPreferences.getInstance();

    Intl.defaultLocale = Platform.localeName;

    return prefs.remove('locale');
  }
}

final localeProvider = NotifierProvider<LocaleNotifier, Locale?>(() {
  return LocaleNotifier();
});
