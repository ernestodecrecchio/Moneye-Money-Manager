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
  eur,
  usd,
  gbp,
  jpy,
  chf,
}

CurrencyEnum? getCurrencyEnumFromString(String currencyString) {
  switch (currencyString) {
    case 'CurrencyEnum.eur':
      return CurrencyEnum.eur;
    case 'CurrencyEnum.usd':
      return CurrencyEnum.usd;
    case 'CurrencyEnum.gbp':
      return CurrencyEnum.gbp;
    case 'CurrencyEnum.jpy':
      return CurrencyEnum.jpy;
    case 'CurrencyEnum.chf':
      return CurrencyEnum.chf;
    default:
      return null;
  }
}

String getSymbolForCurrency(CurrencyEnum currency) {
  switch (currency) {
    case CurrencyEnum.eur:
      return '€';
    case CurrencyEnum.usd:
      return '\$';
    case CurrencyEnum.jpy:
      return '¥';
    case CurrencyEnum.gbp:
      return '£';
    case CurrencyEnum.chf:
      return 'CHF';
  }
}

class CurrencyProvider with ChangeNotifier {
  CurrencyEnum? _currentCurrencySymbol = CurrencyEnum.eur;
  CurrencyEnum? get currentCurrencySymbol => _currentCurrencySymbol;

  CurrencySymbolPosition? _currentCurrencySymbolPosition =
      CurrencySymbolPosition.trailing;
  CurrencySymbolPosition? get currentCurrencySymbolPosition =>
      _currentCurrencySymbolPosition;

  CurrencyProvider(
      {CurrencyEnum? savedCurrency,
      CurrencySymbolPosition? savedCurrencySymbolPosition}) {
    _currentCurrencySymbol = savedCurrency ?? CurrencyEnum.eur;
    _currentCurrencySymbolPosition =
        savedCurrencySymbolPosition ?? CurrencySymbolPosition.trailing;
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
