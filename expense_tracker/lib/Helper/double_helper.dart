import 'package:expense_tracker/models/currency.dart';
import 'package:expense_tracker/notifiers/currency_riverpod.dart';

extension DoubleParsing on double {
  String toStringAsFixedRounded(int fractionDigits) {
    return toStringAsFixed(truncateToDouble() == this ? 0 : fractionDigits);
  }

  String toStringAsFixedRoundedWithCurrency(
    int fractionDigits,
    Currency? currencyCurrency,
    CurrencySymbolPosition currencySymbolPosition,
  ) {
    return '${currencySymbolPosition == CurrencySymbolPosition.leading ? currencyCurrency?.symbolNative : ''}${toStringAsFixedRounded(fractionDigits)}${currencySymbolPosition == CurrencySymbolPosition.trailing ? currencyCurrency?.symbolNative : ''}';
  }
}
