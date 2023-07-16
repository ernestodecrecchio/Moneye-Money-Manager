class Currency {
  final String symbol;
  final String name;
  final String symbolNative;
  final double decimalDigits;
  final int rounding;
  final String code;
  final String namePlural;

  Currency({
    required this.symbol,
    required this.name,
    required this.symbolNative,
    required this.decimalDigits,
    required this.rounding,
    required this.code,
    required this.namePlural,
  });

  factory Currency.fromJosn(Map<String, dynamic> json) {
    return Currency(
      symbol: json['symbol'],
      name: json['name'],
      symbolNative: json['symbol_native'],
      decimalDigits: json['decimal_digits'],
      rounding: json['rounding'],
      code: json['code'],
      namePlural: json['name_plural'],
    );
  }

  Map<String, Object> toJson() {
    return {
      "symbol": symbol,
      "name": name,
      "symbol_native": symbolNative,
      "decimal_digits": decimalDigits,
      "code": code,
      "name_plural": namePlural,
    };
  }
}
