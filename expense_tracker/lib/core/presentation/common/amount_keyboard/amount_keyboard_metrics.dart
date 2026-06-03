import 'package:flutter/material.dart';

/// Layout constants for [AmountKeyboard] height.
///
/// Used by [AmountKeyboardController] (overlay + [MediaQuery.viewInsets]) and
/// [AmountTextField] (scroll-into-view). Values must stay in sync with
/// [AmountKeyboard] (row height, `SizedBox(height: 8)` gaps, outer padding).
class AmountKeyboardMetrics {
  AmountKeyboardMetrics._();

  /// Vertical stack size in [AmountKeyboard]: four digit rows plus the Done row.
  ///
  /// When [AmountKeyboard.onDone] is null there are only four rows; this
  /// metric assumes Done is shown (as with [AmountKeyboardScope]).
  static const int numRows = 5;

  /// Height of each key row and the Done key in [AmountKeyboard].
  static const double rowHeight = 52;

  /// Gap between rows (`SizedBox(height: 8)` in [AmountKeyboard]).
  static const double spacing = 8;

  /// Combined vertical padding around the key column (8 top + 8 bottom in the widget).
  static const double padding = 16;

  /// Total keyboard height including the device bottom safe area (home indicator).
  ///
  /// Breakdown:
  /// - [numRows] × [rowHeight] — row content
  /// - ([numRows] - 1) × [spacing] — gaps *between* rows (N rows ⇒ N − 1 gaps)
  /// - [padding] — inset around the column
  /// - [MediaQuery.paddingOf] bottom — not duplicated by [AmountKeyboard]'s [SafeArea]
  static double fullHeight(BuildContext context) {
    final bottomSafeArea = MediaQuery.paddingOf(context).bottom;
    return (numRows * rowHeight) +
        ((numRows - 1) * spacing) +
        padding +
        bottomSafeArea;
  }
}
