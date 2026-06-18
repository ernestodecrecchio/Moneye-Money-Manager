import 'dart:math';
import 'dart:ui' as ui;

import 'package:expense_tracker/core/models/currency.dart';
import 'package:expense_tracker/core/presentation/providers/currency_provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Shared Y-axis label formatting and layout for statistics charts.
abstract final class StatisticsChartAxis {
  static const double leftTitleSpace = 4;
  static const double reservedSizeBuffer = 4;
  static const double reservedSizeMin = 28;

  /// Compact currency label for chart axes (no decimals).
  static String formatValue(
    double value,
    Currency? currency,
    CurrencySymbolPosition currencyPosition,
  ) {
    final symbol = currency?.symbolNative ?? '';
    final formatted = NumberFormat.compact().format(value);
    return currencyPosition == CurrencySymbolPosition.leading
        ? '$symbol$formatted'
        : '$formatted$symbol';
  }

  static bool shouldShowLeftTitle({
    required double value,
    required double minY,
    required double maxY,
    bool showZeroWhenCrossing = false,
  }) {
    final midY = minY + (maxY - minY) / 2;
    if (value == minY || value == maxY) {
      return true;
    }
    if ((value - midY).abs() < 0.01) {
      return true;
    }
    if (showZeroWhenCrossing && minY < 0 && maxY > 0 && value == 0) {
      return true;
    }
    return false;
  }

  static Iterable<double> leftTitleValues({
    required double minY,
    required double maxY,
    bool showZeroWhenCrossing = false,
  }) sync* {
    yield minY;
    yield minY + (maxY - minY) / 2;
    yield maxY;
    if (showZeroWhenCrossing && minY < 0 && maxY > 0) {
      yield 0;
    }
  }

  static double computeLeftReservedSize({
    required TextStyle style,
    required double minY,
    required double maxY,
    required Currency? currency,
    required CurrencySymbolPosition currencyPosition,
    bool showZeroWhenCrossing = false,
  }) {
    final painter = TextPainter(textDirection: ui.TextDirection.ltr);
    var maxWidth = 0.0;

    for (final value in leftTitleValues(
      minY: minY,
      maxY: maxY,
      showZeroWhenCrossing: showZeroWhenCrossing,
    )) {
      painter.text = TextSpan(
        text: formatValue(value, currency, currencyPosition),
        style: style,
      );
      painter.layout();
      maxWidth = max(maxWidth, painter.width);
    }

    return max(maxWidth + reservedSizeBuffer, reservedSizeMin);
  }

  static Widget buildLeftTitle({
    required TitleMeta meta,
    required double value,
    required double minY,
    required double maxY,
    required Currency? currency,
    required CurrencySymbolPosition currencyPosition,
    required TextStyle style,
    bool showZeroWhenCrossing = false,
  }) {
    if (!shouldShowLeftTitle(
      value: value,
      minY: minY,
      maxY: maxY,
      showZeroWhenCrossing: showZeroWhenCrossing,
    )) {
      return const SizedBox.shrink();
    }

    return SideTitleWidget(
      meta: meta,
      space: leftTitleSpace,
      child: Text(
        formatValue(value, currency, currencyPosition),
        style: style,
        textAlign: TextAlign.right,
        maxLines: 1,
        softWrap: false,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
