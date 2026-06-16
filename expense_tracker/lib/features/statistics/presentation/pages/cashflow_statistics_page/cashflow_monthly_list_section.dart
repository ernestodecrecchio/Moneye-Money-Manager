import 'package:expense_tracker/core/presentation/providers/app_localizations_provider.dart';
import 'package:expense_tracker/core/style/app_theme.dart';
import 'package:expense_tracker/features/statistics/presentation/widgets/statistics_surface_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CashflowMonthlyListSection extends ConsumerWidget {
  const CashflowMonthlyListSection({super.key});

  static const _placeholderRowCount = 3;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocalizations = ref.watch(appLocalizationsProvider);
    final colors = context.appColors;

    return StatisticsSurfaceCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16,
        children: [
          Text(
            appLocalizations.statisticsCashflowMonthlyList,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
          Column(
            spacing: 12,
            children: [
              for (var i = 0; i < _placeholderRowCount; i++)
                _CashflowListPlaceholderRow(
                  showDivider: i < _placeholderRowCount - 1,
                ),
            ],
          ),
          Text(
            appLocalizations.statisticsChartsComingSoon,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _CashflowListPlaceholderRow extends StatelessWidget {
  const _CashflowListPlaceholderRow({required this.showDivider});

  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Column(
      spacing: 12,
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                height: 12,
                decoration: BoxDecoration(
                  color: colors.divider.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Container(
              height: 12,
              width: 72,
              decoration: BoxDecoration(
                color: colors.divider.withValues(alpha: 0.16),
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              height: 12,
              width: 56,
              decoration: BoxDecoration(
                color: colors.divider.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ],
        ),
        if (showDivider)
          Divider(
            height: 1,
            color: colors.divider.withValues(alpha: 0.35),
          ),
      ],
    );
  }
}
