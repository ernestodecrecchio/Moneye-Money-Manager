import 'package:expense_tracker/core/presentation/providers/app_localizations_provider.dart';
import 'package:expense_tracker/core/style/app_theme.dart';
import 'package:expense_tracker/features/statistics/presentation/extensions/statistics_period_ui_extension.dart';
import 'package:expense_tracker/features/statistics/presentation/providers/statistics_period_provider.dart';
import 'package:expense_tracker/features/statistics/presentation/widgets/statistics_layout.dart';
import 'package:expense_tracker/features/statistics/presentation/widgets/statistics_surface_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Read-only display of the currently selected statistics period.
class StatisticsPeriodIndicator extends ConsumerWidget {
  const StatisticsPeriodIndicator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocalizations = ref.watch(appLocalizationsProvider);
    final period = ref.watch(statisticsPeriodProvider);
    final colors = context.appColors;

    return StatisticsSurfaceCard(
      padding: const EdgeInsets.symmetric(
        horizontal: StatisticsLayout.periodCardPaddingH,
        vertical: StatisticsLayout.periodCardPaddingV,
      ),
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
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
                Text(
                  '${period.granularityLabel(appLocalizations)} · ${period.titleLabel(appLocalizations)}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colors.textPrimary,
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
