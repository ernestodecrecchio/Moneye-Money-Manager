// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum CurrencySymbolPosition {
  none,
  leading,
  trailing,
}

CurrencySymbolPosition? getCurrencySymbolPositionFromString(
    String currencySymbolPosition) {
  switch (currencySymbolPosition) {
    case 'CurrencySymbolPosition.none':
      return CurrencySymbolPosition.none;
    case 'CurrencySymbolPosition.leading':
      return CurrencySymbolPosition.leading;
    case 'CurrencySymbolPosition.trailing':
      return CurrencySymbolPosition.trailing;
    default:
      return null;
  }
}

enum CurrencyEnum {
  EUR,
  USD,
  GBP,
  JPY,
}

CurrencyEnum? getCurrencyEnumFromString(String currencyString) {
  switch (currencyString) {
    case 'CurrencyEnum.EUR':
      return CurrencyEnum.EUR;
    case 'CurrencyEnum.USD':
      return CurrencyEnum.USD;
    case 'CurrencyEnum.GBP':
      return CurrencyEnum.GBP;
    case 'CurrencyEnum.JPY':
      return CurrencyEnum.JPY;
    default:
      return null;
  }
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

  CurrencyEnum? _currentCurrencySymbol = CurrencyEnum.EUR;
  CurrencyEnum? get currentCurrencySymbol => _currentCurrencySymbol;

  CurrencySymbolPosition? _currentCurrencySymbolPosition =
      CurrencySymbolPosition.trailing;
  CurrencySymbolPosition? get currentCurrencySymbolPosition =>
      _currentCurrencySymbolPosition;

  LocaleProvider(
      {Locale? savedLocale,
      CurrencyEnum? savedCurrency,
      CurrencySymbolPosition? savedCurrencySymbolPosition}) {
    _locale = savedLocale;
    _currentCurrencySymbol = savedCurrency ?? CurrencyEnum.EUR;
    _currentCurrencySymbolPosition =
        savedCurrencySymbolPosition ?? CurrencySymbolPosition.none;
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

  void setCurrencySymbol(CurrencyEnum currency) async {
    _currentCurrencySymbol = currency;

    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString('currency', _currentCurrencySymbol.toString());

    notifyListeners();
  }

  void setCurrencySymbolPosition(CurrencySymbolPosition position) async {
    _currentCurrencySymbolPosition = position;

    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString(
        'currencySymbolPosition', _currentCurrencySymbolPosition.toString());

    notifyListeners();
  }
}
