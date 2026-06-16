/// Step size scales with amount magnitude (e.g. 20 → 0.5, 100 → 1, 1000 → 10).
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
