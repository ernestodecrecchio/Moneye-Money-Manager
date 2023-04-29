import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum CurrencySymbolPosition {
  none,
  leading,
  trailing,
}

enum CurrencyEnum {
  EUR,
  USD,
  GBP,
  JPY,
}

String getSymbolForCurrency(CurrencyEnum currency) {
  switch (currency) {
    case CurrencyEnum.EUR:
      return '€';
    case CurrencyEnum.USD:
      return '\$';
    case CurrencyEnum.JPY:
      return '¥';
    case CurrencyEnum.GBP:
      return '£';
  }
}

class LocaleProvider extends ChangeNotifier {
  Locale? _locale;
  Locale? get locale => _locale;

  LocaleProvider({Locale? savedLocale}) {
    _locale = savedLocale;
  }

  void setLocale(Locale locale) async {
    _locale = locale;

    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString('locale', locale.languageCode);

    notifyListeners();
  }

  void clearLocale() {
    _locale = null;

    notifyListeners();
  }
}
