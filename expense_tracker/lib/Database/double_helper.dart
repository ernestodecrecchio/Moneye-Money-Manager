import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../notifiers/locale_provider.dart';

extension DoubleParsing on double {
  String toStringAsFixedRounded(int fractionDigits) {
    return toStringAsFixed(truncateToDouble() == this ? 0 : fractionDigits);
  }

  String toStringAsFixedRoundedWithCurrency(
      BuildContext context, int fractionDigits) {
    final localeProvider = Provider.of<LocaleProvider>(context);

    return '${localeProvider.currentCurrencySymbolPosition == CurrencySymbolPosition.leading ? getSymbolForCurrency(localeProvider.currentCurrencySymbol!) : ''}${toStringAsFixedRounded(fractionDigits)}${localeProvider.currentCurrencySymbolPosition == CurrencySymbolPosition.trailing ? getSymbolForCurrency(localeProvider.currentCurrencySymbol!) : ''}';
  }
}
