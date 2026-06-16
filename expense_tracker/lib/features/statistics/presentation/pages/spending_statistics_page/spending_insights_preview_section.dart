import 'package:expense_tracker/core/presentation/providers/app_localizations_provider.dart';
import 'package:expense_tracker/core/style/app_theme.dart';
import 'package:expense_tracker/features/statistics/presentation/widgets/statistics_surface_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SpendingInsightsPreviewSection extends ConsumerWidget {
  const SpendingInsightsPreviewSection({super.key});

  static const _placeholderInsightCount = 2;

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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 4,
            children: [
              Text(
                appLocalizations.statisticsSpendingInsightsPreview,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
              Text(
                appLocalizations.statisticsSpendingInsightsPreviewSubtitle,
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
              for (var i = 0; i < _placeholderInsightCount; i++)
                _InsightPreviewPlaceholderRow(
                  showDivider: i < _placeholderInsightCount - 1,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InsightPreviewPlaceholderRow extends StatelessWidget {
  const _InsightPreviewPlaceholderRow({required this.showDivider});

  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Column(
      spacing: 12,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 12,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: colors.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.lightbulb_outline_rounded,
                size: 18,
                color: colors.primary.withValues(alpha: 0.6),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8,
                children: [
                  Container(
                    height: 12,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: colors.divider.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  Container(
                    height: 12,
                    width: 180,
                    decoration: BoxDecoration(
                      color: colors.divider.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ],
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
