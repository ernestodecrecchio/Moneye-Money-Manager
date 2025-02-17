import 'package:expense_tracker/models/currency.dart';
import 'package:expense_tracker/notifiers/currency_provider.dart';
import 'package:intl/intl.dart';

extension DoubleParsing on double {
  String toStringAsFixedRounded(int fractionDigits) {
    return toStringAsFixed(truncateToDouble() == this ? 0 : fractionDigits);
  }

  String toStringAsFixedRoundedWithCurrency(
    int fractionDigits,
    Currency? currencyCurrency,
    CurrencySymbolPosition currencySymbolPosition,
  ) {
    if (this >= 99999 || this <= -99999) {
      return '${currencySymbolPosition == CurrencySymbolPosition.leading ? currencyCurrency?.symbolNative : ''}${NumberFormat.compact().format(this)} ${currencySymbolPosition == CurrencySymbolPosition.trailing ? currencyCurrency?.symbolNative : ''}';
    } else {
      return '${currencySymbolPosition == CurrencySymbolPosition.leading ? currencyCurrency?.symbolNative : ''}${toStringAsFixedRounded(fractionDigits)}${currencySymbolPosition == CurrencySymbolPosition.trailing ? currencyCurrency?.symbolNative : ''}';
    }
  }

  double withPrecision(int precision) {
    return double.parse(toStringAsFixed(precision));
  }
}
