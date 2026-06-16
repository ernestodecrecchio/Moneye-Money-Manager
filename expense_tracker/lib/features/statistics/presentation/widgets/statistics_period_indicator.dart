import 'package:expense_tracker/core/style/app_theme.dart';
import 'package:expense_tracker/features/statistics/presentation/widgets/statistics_surface_card.dart';
import 'package:expense_tracker/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Read-only display of the currently selected statistics period.
class StatisticsPeriodIndicator extends StatelessWidget {
  const StatisticsPeriodIndicator({
    super.key,
    required this.appLocalizations,
  });

  final AppLocalizations appLocalizations;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final periodLabel =
        DateFormat.yMMMM(appLocalizations.localeName).format(DateTime.now());

    return StatisticsSurfaceCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        spacing: 10,
        children: [
          Icon(
            Icons.calendar_today_rounded,
            size: 18,
            color: colors.primary,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 2,
              children: [
                Text(
                  appLocalizations.statisticsSelectedPeriod,
                  style: TextStyle(
                    fontSize: 12,
                    color: colors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '${appLocalizations.month} · $periodLabel',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
