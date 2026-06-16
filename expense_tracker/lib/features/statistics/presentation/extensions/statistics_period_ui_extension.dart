import 'package:expense_tracker/features/statistics/domain/models/statistics_period.dart';
import 'package:expense_tracker/features/statistics/domain/models/statistics_period_granularity.dart';
import 'package:expense_tracker/l10n/app_localizations.dart';
import 'package:intl/intl.dart';

extension StatisticsPeriodGranularityUiExtension on StatisticsPeriodGranularity {
  String label(AppLocalizations appLocalizations) {
    return switch (this) {
      StatisticsPeriodGranularity.month => appLocalizations.month,
      StatisticsPeriodGranularity.quarter =>
        appLocalizations.statisticsPeriodQuarter,
      StatisticsPeriodGranularity.year => appLocalizations.year,
    };
  }
}

extension StatisticsPeriodUiExtension on StatisticsPeriod {
  String granularityLabel(AppLocalizations appLocalizations) {
    return granularity.label(appLocalizations);
  }

  String titleLabel(AppLocalizations appLocalizations) {
    final locale = appLocalizations.localeName;

    return switch (granularity) {
      StatisticsPeriodGranularity.month =>
        DateFormat.yMMMM(locale).format(anchorDate),
      StatisticsPeriodGranularity.quarter => 'Q$quarter ${anchorDate.year}',
      StatisticsPeriodGranularity.year =>
        DateFormat.y(locale).format(anchorDate),
    };
  }
}
