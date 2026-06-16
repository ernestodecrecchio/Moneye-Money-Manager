import 'package:expense_tracker/core/presentation/common/custom_modal_bottom_sheet.dart';
import 'package:expense_tracker/core/presentation/common/widgets/safe_vector_graphic.dart';
import 'package:expense_tracker/core/presentation/providers/app_localizations_provider.dart';
import 'package:expense_tracker/core/style/app_theme.dart';
import 'package:expense_tracker/features/statistics/domain/models/statistics_period_granularity.dart';
import 'package:expense_tracker/features/statistics/presentation/extensions/statistics_period_ui_extension.dart';
import 'package:expense_tracker/features/statistics/presentation/providers/statistics_period_provider.dart';
import 'package:expense_tracker/features/statistics/presentation/widgets/statistics_surface_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StatisticsPeriodSelector extends ConsumerWidget {
  const StatisticsPeriodSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocalizations = ref.watch(appLocalizationsProvider);
    final selection = ref.watch(statisticsPeriodSelectionProvider);
    final period = ref.watch(statisticsPeriodProvider);
    final colors = context.appColors;
    final textTheme = Theme.of(context).textTheme;

    return StatisticsSurfaceCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          FilledButton(
            onPressed: () => _showGranularityPicker(context, ref),
            style: FilledButton.styleFrom(
              backgroundColor: colors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              minimumSize: const Size(0, 36),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  period.granularityLabel(appLocalizations),
                  style: textTheme.bodyMedium?.copyWith(
                    color: colors.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(
                  Icons.arrow_drop_down_rounded,
                  color: colors.onPrimary,
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              period.titleLabel(appLocalizations),
              textAlign: TextAlign.end,
              style: textTheme.bodySmall?.copyWith(
                fontSize: 14,
                color: colors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 10),
          _PeriodChevronButton(
            icon: Icons.chevron_left_rounded,
            onPressed: () => ref
                .read(statisticsPeriodSelectionProvider.notifier)
                .goToPreviousPeriod(),
          ),
          const SizedBox(width: 8),
          _PeriodChevronButton(
            icon: Icons.chevron_right_rounded,
            onPressed: selection.canGoForward
                ? () => ref
                    .read(statisticsPeriodSelectionProvider.notifier)
                    .goToNextPeriod()
                : null,
          ),
        ],
      ),
    );
  }

  void _showGranularityPicker(BuildContext context, WidgetRef ref) {
    final appLocalizations = ref.read(appLocalizationsProvider);
    final selectedGranularity =
        ref.read(statisticsPeriodSelectionProvider).granularity;
    final colors = context.appColors;
    final textTheme = Theme.of(context).textTheme;

    showCustomModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 17),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        appLocalizations.statisticsSelectGranularity,
                        style: textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),
              ListView(
                padding: modalSheetScrollPadding(context),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  for (final granularity in StatisticsPeriodGranularity.values)
                    ListTile(
                      title: Text(granularity.label(appLocalizations)),
                      trailing: selectedGranularity == granularity
                          ? SafeVectorGraphic(
                              iconPath: 'assets/icons/checkmark.svg',
                              color: colors.primary,
                            )
                          : null,
                      onTap: () {
                        ref
                            .read(statisticsPeriodSelectionProvider.notifier)
                            .updateGranularity(granularity);
                        Navigator.of(context).pop();
                      },
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _PeriodChevronButton extends StatelessWidget {
  const _PeriodChevronButton({
    required this.icon,
    required this.onPressed,
  });

  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        minimumSize: const Size(35, 35),
        elevation: 0,
        backgroundColor: colors.primary,
        disabledBackgroundColor: colors.primary.withValues(alpha: 0.35),
        padding: EdgeInsets.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Icon(icon),
    );
  }
}
