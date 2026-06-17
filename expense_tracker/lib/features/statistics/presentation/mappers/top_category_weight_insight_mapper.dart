import 'package:expense_tracker/core/utils/double_helper.dart';
import 'package:expense_tracker/features/statistics/domain/models/insight_severity.dart';
import 'package:expense_tracker/features/statistics/domain/models/statistics_insight.dart';
import 'package:expense_tracker/features/statistics/domain/models/top_category_weight_insight.dart';
import 'package:expense_tracker/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class TopCategoryWeightInsightMapper {
  const TopCategoryWeightInsightMapper._();

  static StatisticsInsight toStatisticsInsight({
    required TopCategoryWeightInsight insight,
    required AppLocalizations appLocalizations,
  }) {
    final percentLabel = '${insight.sharePercent.toStringAsFixedRounded(1)}%';

    return StatisticsInsight(
      title: appLocalizations.statisticsInsightTopCategoryWeightTitle,
      description: appLocalizations
          .statisticsInsightTopCategoryWeightDescription(
        insight.category.name,
        percentLabel,
      ),
      icon: Icons.pie_chart_outline_rounded,
      severity: InsightSeverity.info,
    );
  }
}
