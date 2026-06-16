import 'package:expense_tracker/core/presentation/providers/app_localizations_provider.dart';
import 'package:expense_tracker/core/style/app_theme.dart';
import 'package:expense_tracker/features/statistics/presentation/widgets/statistics_surface_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SpendingCategoryComparisonSection extends ConsumerWidget {
  const SpendingCategoryComparisonSection({super.key});

  static const _placeholderRowCount = 3;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocalizations = ref.watch(appLocalizationsProvider);
    final colors = context.appColors;
    final placeholder = appLocalizations.statisticsPlaceholderValue;

    return StatisticsSurfaceCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 4,
            children: [
              Text(
                appLocalizations.statisticsSpendingCategoryComparison,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
              Text(
                appLocalizations.statisticsSpendingCategoryComparisonSubtitle,
                style: TextStyle(
                  fontSize: 13,
                  color: colors.textSecondary,
                ),
              ),
            ],
          ),
          Column(
            spacing: 12,
            children: [
              for (var i = 0; i < _placeholderRowCount; i++) ...[
                _CategoryComparisonPlaceholderRow(
                  amount: placeholder,
                  showDivider: i < _placeholderRowCount - 1,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _CategoryComparisonPlaceholderRow extends StatelessWidget {
  const _CategoryComparisonPlaceholderRow({
    required this.amount,
    required this.showDivider,
  });

  final String amount;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Column(
      spacing: 12,
      children: [
        Row(
          spacing: 12,
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: colors.divider.withValues(alpha: 0.45),
                shape: BoxShape.circle,
              ),
            ),
            Expanded(
              child: Container(
                height: 12,
                decoration: BoxDecoration(
                  color: colors.divider.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
            Text(
              amount,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: colors.textSecondary,
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
