import 'dart:convert';

import 'package:expense_tracker/domain/models/currency.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provider that loads the list of available currencies from a JSON file.
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

/// Notifier responsible for managing the current application currency.
class CurrentCurrencyNotifier extends Notifier<Currency?> {
  CurrentCurrencyNotifier() : super();

  @override
  Currency? build() {
    // Default currency is Euro.
    return const Currency(
        symbol: '€',
        name: 'Euro',
        symbolNative: '€',
        decimalDigits: 2,
        rounding: 0,
        code: 'EUR',
        namePlural: 'euros');
  }

  /// Sets the current currency from a JSON string stored in local storage.
  void setFromLocalStorage(String? localStorageValue) {
    if (localStorageValue != null) {
      final Map<String, dynamic> x = jsonDecode(localStorageValue);

      state = Currency.fromJosn(x);
    }
  }

  /// Updates the current currency and persists it to local storage.
  Future<bool> updateCurrency(Currency newCurrency) async {
    state = newCurrency;

    final prefs = await SharedPreferences.getInstance();

    return await prefs.setString(
        'selected_currency', jsonEncode(newCurrency.toJson()));
  }
}

/// Provider for the [CurrentCurrencyNotifier], managing the user's selected currency.
final currentCurrencyProvider =
    NotifierProvider<CurrentCurrencyNotifier, Currency?>(() {
  return CurrentCurrencyNotifier();
});

/// Represents the possible positions for the currency symbol.
enum CurrencySymbolPosition {
  none,
  leading,
  trailing,
}

/// Helper function to convert a string representation to [CurrencySymbolPosition].
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

/// Notifier managing the position of the currency symbol.
class CurrencySymbolPositionNotifier extends Notifier<CurrencySymbolPosition> {
  @override
  CurrencySymbolPosition build() {
    return CurrencySymbolPosition.trailing;
  }

  /// Sets the symbol position from a persisted string.
  void setFromLocalStorage(String? localStorageValue) {
    if (localStorageValue != null) {
      state = getCurrencySymbolPositionFromString(localStorageValue);
    }
  }

  /// Updates and persists the currency symbol position.
  Future updateCurrencyPosition(
      CurrencySymbolPosition newCurrencySymbolPosition) async {
    state = newCurrencySymbolPosition;

    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
        'selected_currency_position', newCurrencySymbolPosition.toString());
  }
}

/// Provider for [CurrencySymbolPositionNotifier].
final currentCurrencySymbolPositionProvider =
    NotifierProvider<CurrencySymbolPositionNotifier, CurrencySymbolPosition>(
        () {
  return CurrencySymbolPositionNotifier();
});
