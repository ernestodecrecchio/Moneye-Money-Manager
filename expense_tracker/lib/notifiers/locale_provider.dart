import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider extends ChangeNotifier {
  Locale? _locale;
  Locale? get locale => _locale;

  LocaleProvider({
    Locale? savedLocale,
  }) {
    _locale = savedLocale;
  }

  void resetLocale() async {
    _locale = null;

    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.remove('locale');

    Intl.defaultLocale = Platform.localeName;

    notifyListeners();
  }

  void setLocale(Locale locale) async {
    _locale = locale;

    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString('locale', locale.languageCode);

    Intl.defaultLocale = locale.languageCode;

    notifyListeners();
  }

  void clearLocale() {
    _locale = null;

    notifyListeners();
  }
}
