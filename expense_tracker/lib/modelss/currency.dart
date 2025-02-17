class Currency {
  final String symbol;
  final String name;
  final String symbolNative;
  final int decimalDigits;
  final double rounding;
  final String code;
  final String namePlural;

  const Currency({
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
      decimalDigits: json['decimal_digits'] as int,
      rounding: double.parse(json['rounding'].toString()),
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
      "rounding": rounding,
      "code": code,
      "name_plural": namePlural,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Currency &&
          runtimeType == other.runtimeType &&
          symbol == other.symbol &&
          name == other.name &&
          symbolNative == other.symbolNative &&
          decimalDigits == other.decimalDigits &&
          rounding == other.rounding &&
          code == other.code &&
          namePlural == other.namePlural;

  @override
  int get hashCode =>
      symbol.hashCode ^
      name.hashCode ^
      symbolNative.hashCode ^
      decimalDigits.hashCode ^
      rounding.hashCode ^
      code.hashCode ^
      namePlural.hashCode;
}
