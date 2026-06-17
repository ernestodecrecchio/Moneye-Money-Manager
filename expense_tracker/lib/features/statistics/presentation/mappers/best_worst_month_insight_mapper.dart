import 'package:expense_tracker/core/models/currency.dart';
import 'package:expense_tracker/core/presentation/providers/currency_provider.dart';
import 'package:expense_tracker/core/utils/double_helper.dart';
import 'package:expense_tracker/features/statistics/domain/models/best_worst_month_insight.dart';
import 'package:expense_tracker/features/statistics/domain/models/insight_severity.dart';
import 'package:expense_tracker/features/statistics/domain/models/statistics_insight.dart';
import 'package:expense_tracker/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class BestWorstMonthInsightMapper {
  const BestWorstMonthInsightMapper._();

  static List<StatisticsInsight> toStatisticsInsights({
    required BestWorstMonthInsight insight,
    required AppLocalizations appLocalizations,
    required Currency? currency,
    required CurrencySymbolPosition currencyPosition,
  }) {
    return [
      StatisticsInsight(
        title: appLocalizations.statisticsInsightBestMonthTitle,
        description: appLocalizations.statisticsInsightBestMonthDescription(
          insight.best.label,
          _formatNetResult(
            insight.best.netResult,
            currency,
            currencyPosition,
          ),
        ),
        icon: Icons.trending_up_rounded,
        severity: InsightSeverity.positive,
      ),
      StatisticsInsight(
        title: appLocalizations.statisticsInsightWorstMonthTitle,
        description: appLocalizations.statisticsInsightWorstMonthDescription(
          insight.worst.label,
          _formatNetResult(
            insight.worst.netResult,
            currency,
            currencyPosition,
          ),
        ),
        icon: Icons.trending_down_rounded,
        severity: insight.worst.netResult < 0
            ? InsightSeverity.negative
            : InsightSeverity.warning,
      ),
    ];
  }

  static String _formatNetResult(
    double netResult,
    Currency? currency,
    CurrencySymbolPosition currencyPosition,
  ) {
    return netResult.toStringAsFixedRoundedWithCurrency(
      2,
      currency,
      currencyPosition,
    );
  }
}
