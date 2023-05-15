import 'package:expense_tracker/notifiers/currency_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

extension DoubleParsing on double {
  String toStringAsFixedRounded(int fractionDigits) {
    return toStringAsFixed(truncateToDouble() == this ? 0 : fractionDigits);
  }

  String toStringAsFixedRoundedWithCurrency(
      BuildContext context, int fractionDigits) {
    final currencyProvider = Provider.of<CurrencyProvider>(context);

    return '${currencyProvider.currentCurrencySymbolPosition == CurrencySymbolPosition.leading ? getSymbolForCurrency(currencyProvider.currentCurrencySymbol!) : ''}${toStringAsFixedRounded(fractionDigits)}${currencyProvider.currentCurrencySymbolPosition == CurrencySymbolPosition.trailing ? getSymbolForCurrency(currencyProvider.currentCurrencySymbol!) : ''}';
  }
}
