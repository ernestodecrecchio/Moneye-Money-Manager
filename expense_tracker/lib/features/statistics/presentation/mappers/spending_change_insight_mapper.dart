import 'package:expense_tracker/core/models/currency.dart';
import 'package:expense_tracker/core/presentation/providers/currency_provider.dart';
import 'package:expense_tracker/core/utils/double_helper.dart';
import 'package:expense_tracker/features/statistics/domain/models/insight_severity.dart';
import 'package:expense_tracker/features/statistics/domain/models/spending_change_insight.dart';
import 'package:expense_tracker/features/statistics/domain/models/statistics_insight.dart';
import 'package:expense_tracker/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class SpendingChangeInsightMapper {
  const SpendingChangeInsightMapper._();

  static StatisticsInsight toStatisticsInsight({
    required SpendingChangeInsight insight,
    required AppLocalizations appLocalizations,
    required Currency? currency,
    required CurrencySymbolPosition currencyPosition,
  }) {
    final amountLabel = insight.absoluteChange.abs().toStringAsFixedRoundedWithCurrency(
      2,
      currency,
      currencyPosition,
    );
    final percentLabel = _formatPercentChange(insight.percentChange);

    if (insight.isIncrease) {
      return StatisticsInsight(
        title: appLocalizations.statisticsInsightSpendingChangeIncreasedTitle,
        description: appLocalizations
            .statisticsInsightSpendingChangeIncreasedDescription(
          amountLabel,
          percentLabel,
        ),
        icon: Icons.trending_up_rounded,
        severity: InsightSeverity.warning,
      );
    }

    return StatisticsInsight(
      title: appLocalizations.statisticsInsightSpendingChangeDecreasedTitle,
      description: appLocalizations
          .statisticsInsightSpendingChangeDecreasedDescription(
        amountLabel,
        percentLabel,
      ),
      icon: Icons.trending_down_rounded,
      severity: InsightSeverity.positive,
    );
  }

  static String _formatPercentChange(double percentChange) {
    final rounded = percentChange.toStringAsFixedRounded(1);
    if (percentChange > 0) {
      return '+$rounded%';
    }
    return '$rounded%';
  }
}
