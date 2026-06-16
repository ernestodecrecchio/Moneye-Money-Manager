import 'package:expense_tracker/core/configuration/constants.dart';
import 'package:expense_tracker/core/models/currency.dart';
import 'package:expense_tracker/core/presentation/common/category_ui_extension.dart';
import 'package:expense_tracker/core/presentation/common/widgets/icon_item.dart';
import 'package:expense_tracker/core/presentation/providers/app_localizations_provider.dart';
import 'package:expense_tracker/core/presentation/providers/currency_provider.dart';
import 'package:expense_tracker/core/style/app_theme.dart';
import 'package:expense_tracker/core/utils/double_helper.dart';
import 'package:expense_tracker/features/statistics/domain/models/category_statistics_entry.dart';
import 'package:expense_tracker/features/statistics/domain/models/categories_statistics_series.dart';
import 'package:expense_tracker/features/statistics/presentation/pages/categories_statistics_page/category_statistics_detail_page.dart';
import 'package:expense_tracker/features/statistics/presentation/providers/queries/categories_statistics_notifier.dart';
import 'package:expense_tracker/features/statistics/presentation/widgets/statistics_period_indicator.dart';
import 'package:expense_tracker/features/statistics/presentation/widgets/statistics_surface_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoriesStatisticsPage extends ConsumerWidget {
  static const routeName = '/statisticsCategoriesPage';

  const CategoriesStatisticsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocalizations = ref.watch(appLocalizationsProvider);
    final seriesAsync = ref.watch(categoriesStatisticsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations.statisticsCategoriesTitle),
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
          seriesAsync.when(
            data: (series) {
              if (series.isEmpty) {
                return _EmptyCategoriesMessage(
                  message: appLocalizations.statisticsNoTransactionsInPeriod,
                );
              }

              return _CategoriesStatisticsList(series: series);
            },
            loading: () => const SizedBox(
              height: 200,
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (_, __) => _EmptyCategoriesMessage(
              message: appLocalizations.statisticsCategoriesListError,
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoriesStatisticsList extends ConsumerWidget {
  const _CategoriesStatisticsList({required this.series});

  final CategoriesStatisticsSeries series;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final currency = ref.watch(currentCurrencyProvider);
    final currencyPosition = ref.watch(currentCurrencySymbolPositionProvider);

    return StatisticsSurfaceCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          for (var i = 0; i < series.entries.length; i++) ...[
            _CategoryStatisticsRow(
              entry: series.entries[i],
              currency: currency,
              currencyPosition: currencyPosition,
              onTap: () {
                Navigator.of(context).pushNamed(
                  CategoryStatisticsDetailPage.routeName,
                  arguments: CategoryStatisticsDetailPageArguments(
                    category: series.entries[i].category,
                  ),
                );
              },
            ),
            if (i < series.entries.length - 1)
              Divider(
                height: 1,
                indent: 68,
                color: colors.divider.withValues(alpha: 0.5),
              ),
          ],
        ],
      ),
    );
  }
}

class _CategoryStatisticsRow extends StatelessWidget {
  const _CategoryStatisticsRow({
    required this.entry,
    required this.currency,
    required this.currencyPosition,
    required this.onTap,
  });

  final CategoryStatisticsEntry entry;
  final Currency? currency;
  final CurrencySymbolPosition currencyPosition;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final amountColor = entry.isExpense ? colors.expense : colors.income;
    final amountLabel = entry.amount.toStringAsFixedRoundedWithCurrency(
      2,
      currency,
      currencyPosition,
    );
    final percentageLabel = '${entry.percentage.toStringAsFixedRounded(1)}%';

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          spacing: 14,
          children: [
            IconItem(
              backgroundColor: entry.category.color,
              iconPath: entry.category.iconPath,
              shape: BoxShape.circle,
              size: 40,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 4,
                children: [
                  Text(
                    entry.category.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    percentageLabel,
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
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: amountColor,
                    letterSpacing: -0.3,
                  ),
                ),
              ],
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: colors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyCategoriesMessage extends StatelessWidget {
  const _EmptyCategoriesMessage({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return StatisticsSurfaceCard(
      padding: const EdgeInsets.all(24),
      child: SizedBox(
        width: double.infinity,
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            height: 1.5,
            color: colors.textSecondary,
          ),
        ),
      ),
    );
  }
}
