extension DoubleParsing on double {
  String toStringAsFixedRounded(int fractionDigits) {
    return toStringAsFixed(truncateToDouble() == this ? 0 : fractionDigits);
  }
}
