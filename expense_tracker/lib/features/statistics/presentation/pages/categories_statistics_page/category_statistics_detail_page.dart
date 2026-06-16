import 'package:expense_tracker/core/configuration/constants.dart';
import 'package:expense_tracker/core/presentation/common/category_ui_extension.dart';
import 'package:expense_tracker/core/presentation/common/widgets/icon_item.dart';
import 'package:expense_tracker/core/presentation/providers/app_localizations_provider.dart';
import 'package:expense_tracker/core/presentation/providers/currency_provider.dart';
import 'package:expense_tracker/core/style/app_theme.dart';
import 'package:expense_tracker/core/utils/double_helper.dart';
import 'package:expense_tracker/features/statistics/domain/models/category_statistics_entry.dart';
import 'package:expense_tracker/features/statistics/presentation/widgets/statistics_period_indicator.dart';
import 'package:expense_tracker/features/statistics/presentation/widgets/statistics_surface_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoryStatisticsDetailPageArguments {
  const CategoryStatisticsDetailPageArguments({required this.entry});

  final CategoryStatisticsEntry entry;
}

class CategoryStatisticsDetailPage extends ConsumerWidget {
  static const routeName = '/statisticsCategoryDetailPage';

  const CategoryStatisticsDetailPage({
    super.key,
    required this.entry,
  });

  final CategoryStatisticsEntry entry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocalizations = ref.watch(appLocalizationsProvider);
    final colors = context.appColors;
    final currency = ref.watch(currentCurrencyProvider);
    final currencyPosition = ref.watch(currentCurrencySymbolPositionProvider);

    final amountColor = entry.isExpense ? colors.expense : colors.income;
    final amountLabel = entry.amount.toStringAsFixedRoundedWithCurrency(
      2,
      currency,
      currencyPosition,
    );
    final percentageLabel = '${entry.percentage.toStringAsFixedRounded(1)}%';
    final shareLabel = entry.isExpense
        ? appLocalizations.statisticsCategoryShareOfExpenses
        : appLocalizations.statisticsCategoryShareOfIncome;

    return Scaffold(
      appBar: AppBar(
        title: Text(entry.category.name),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          Constants.horizontalPadding,
          Constants.horizontalPadding,
          Constants.horizontalPadding,
          Constants.horizontalPadding,
        ),
        children: [
          const StatisticsPeriodIndicator(),
          const SizedBox(height: 20),
          StatisticsSurfaceCard(
            padding: const EdgeInsets.all(20),
            child: Row(
              spacing: 14,
              children: [
                IconItem(
                  backgroundColor: entry.category.color,
                  iconPath: entry.category.iconPath,
                  shape: BoxShape.circle,
                  size: 48,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 4,
                    children: [
                      Text(
                        entry.category.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.5,
                        ),
                      ),
                      Text(
                        shareLabel,
                        style: TextStyle(
                          fontSize: 13,
                          color: colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  spacing: 2,
                  children: [
                    Text(
                      amountLabel,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: amountColor,
                        letterSpacing: -0.5,
                      ),
                    ),
                    Text(
                      percentageLabel,
                      style: TextStyle(
                        fontSize: 14,
                        color: colors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          StatisticsSurfaceCard(
            padding: const EdgeInsets.all(24),
            child: Text(
              appLocalizations.statisticsCategoryDetailComingSoon,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
                color: colors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
