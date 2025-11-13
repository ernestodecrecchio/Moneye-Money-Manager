import 'dart:convert';

import 'package:expense_tracker/application/transactions/models/currency.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final currencyListProvider = FutureProvider<List<Currency>>((ref) async {
  try {
    String jsonString =
        await rootBundle.loadString('lib/Configuration/currencies.json');

    final Map<String, dynamic> jsonData = json.decode(jsonString);

    final List<Currency> arr = [];

    jsonData.forEach((key, value) {
      arr.add(Currency.fromJosn(value));
    });

    return arr;
  } catch (error) {
    return [];
  }
});

class CurrentCurrencyNotifier extends Notifier<Currency?> {
  CurrentCurrencyNotifier() : super();

  @override
  Currency? build() {
    return const Currency(
        symbol: '€',
        name: 'Euro',
        symbolNative: '€',
        decimalDigits: 2,
        rounding: 0,
        code: 'EUR',
        namePlural: 'euros');
  }

  void setFromLocalStorage(String? localStorageValue) {
    if (localStorageValue != null) {
      final Map<String, dynamic> x = jsonDecode(localStorageValue);

      state = Currency.fromJosn(x);
    }
  }

  Future<bool> updateCurrency(Currency newCurrency) async {
    state = newCurrency;

    final prefs = await SharedPreferences.getInstance();

    return await prefs.setString(
        'selected_currency', jsonEncode(newCurrency.toJson()));
  }
}

final currentCurrencyProvider =
    NotifierProvider<CurrentCurrencyNotifier, Currency?>(() {
  return CurrentCurrencyNotifier();
});

enum CurrencySymbolPosition {
  none,
  leading,
  trailing,
}

CurrencySymbolPosition getCurrencySymbolPositionFromString(
    String currencySymbolPosition) {
  switch (currencySymbolPosition) {
    case 'CurrencySymbolPosition.none':
      return CurrencySymbolPosition.none;
    case 'CurrencySymbolPosition.leading':
      return CurrencySymbolPosition.leading;
    case 'CurrencySymbolPosition.trailing':
      return CurrencySymbolPosition.trailing;
    default:
      return CurrencySymbolPosition.trailing;
  }
}

class CurrencySymbolPositionNotifier extends Notifier<CurrencySymbolPosition> {
  @override
  CurrencySymbolPosition build() {
    return CurrencySymbolPosition.trailing;
  }

  void setFromLocalStorage(String? localStorageValue) {
    if (localStorageValue != null) {
      state = getCurrencySymbolPositionFromString(localStorageValue);
    }
  }

  Future updateCurrencyPosition(
      CurrencySymbolPosition newCurrencySymbolPosition) async {
    state = newCurrencySymbolPosition;

    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
        'selected_currency_position', newCurrencySymbolPosition.toString());
  }
}

final currentCurrencySymbolPositionProvider =
    NotifierProvider<CurrencySymbolPositionNotifier, CurrencySymbolPosition>(
        () {
  return CurrencySymbolPositionNotifier();
});
