class ShortcutAmountBounds {
  final double minSigned;
  final double maxSigned;
  final double step;

  const ShortcutAmountBounds({
    required this.minSigned,
    required this.maxSigned,
    required this.step,
  });
}

ShortcutAmountBounds shortcutAmountBounds(double presetSigned) {
  final magnitude = presetSigned.abs();
  final step = shortcutStepForMagnitude(magnitude);

  if (magnitude == 0) {
    return ShortcutAmountBounds(minSigned: -10, maxSigned: 10, step: step);
  }

  return ShortcutAmountBounds(
    minSigned: presetSigned - magnitude,
    maxSigned: presetSigned + magnitude,
    step: step,
  );
}

/// Step size scales with preset magnitude (e.g. 20 → 0.5, 100 → 1, 1000 → 10).
double shortcutStepForMagnitude(double magnitude) {
  if (magnitude == 0) return 0.5;
  if (magnitude < 100) return 0.5;
  if (magnitude < 1000) return 1;
  if (magnitude < 10000) return 10;
  return 100;
}

int shortcutFractionDigitsForStep(double step) {
  if (step >= 1) return 0;
  if (step >= 0.1) return 1;
  return 2;
}

double snapShortcutAmount(double amount, double step) {
  if (step <= 0) return amount;
  return (amount / step).round() * step;
}

double clampShortcutAmount(
  double amount,
  ShortcutAmountBounds bounds,
) {
  return snapShortcutAmount(amount, bounds.step)
      .clamp(bounds.minSigned, bounds.maxSigned);
}
