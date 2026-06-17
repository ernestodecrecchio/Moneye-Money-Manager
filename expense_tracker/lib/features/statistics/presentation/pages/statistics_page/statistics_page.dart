import 'package:expense_tracker/core/configuration/constants.dart';
import 'package:expense_tracker/core/models/currency.dart';
import 'package:expense_tracker/core/presentation/providers/app_localizations_provider.dart';
import 'package:expense_tracker/core/presentation/providers/currency_provider.dart';
import 'package:expense_tracker/core/style/app_theme.dart';
import 'package:expense_tracker/core/utils/double_helper.dart';
import 'package:expense_tracker/features/statistics/domain/models/overview_period_kpis.dart';
import 'package:expense_tracker/features/statistics/presentation/providers/queries/overview_kpis_notifier.dart';
import 'package:expense_tracker/features/statistics/presentation/pages/cashflow_statistics_page/cashflow_statistics_page.dart';
import 'package:expense_tracker/features/statistics/presentation/pages/categories_statistics_page/categories_statistics_page.dart';
import 'package:expense_tracker/features/statistics/presentation/pages/income_statistics_page/income_statistics_page.dart';
import 'package:expense_tracker/features/statistics/presentation/pages/insights_statistics_page/insights_statistics_page.dart';
import 'package:expense_tracker/features/statistics/presentation/pages/overview_statistics_page/overview_statistics_page.dart';
import 'package:expense_tracker/features/statistics/presentation/pages/spending_statistics_page/spending_statistics_page.dart';
import 'package:expense_tracker/features/statistics/presentation/widgets/statistics_empty_states.dart';
import 'package:expense_tracker/features/statistics/presentation/widgets/statistics_kpi_card.dart';
import 'package:expense_tracker/features/statistics/presentation/widgets/statistics_layout.dart';
import 'package:expense_tracker/features/statistics/presentation/widgets/statistics_period_selector.dart';
import 'package:expense_tracker/features/statistics/presentation/widgets/statistics_surface_card.dart';
import 'package:expense_tracker/features/home/presentation/widgets/tab_bar/tab_bar_shell.dart';
import 'package:expense_tracker/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StatisticsPage extends ConsumerWidget {
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocalizations = ref.watch(appLocalizationsProvider);

    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(appLocalizations.statistics),
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              Constants.horizontalPadding,
              Constants.horizontalPadding,
              Constants.horizontalPadding,
              0,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const StatisticsPeriodSelector(),
                const SizedBox(height: StatisticsLayout.sectionSpacing),
                _StatisticsOverviewPreviewCard(
                  appLocalizations: appLocalizations,
                ),
                const SizedBox(height: StatisticsLayout.sectionSpacing),
                _StatisticsNavigationSection(
                  appLocalizations: appLocalizations,
                ),
              ]),
            ),
          ),
          const TabBarScrollBottomSliver(),
        ],
      ),
    );
  }
}

class _StatisticsOverviewPreviewCard extends ConsumerWidget {
  const _StatisticsOverviewPreviewCard({required this.appLocalizations});

  final AppLocalizations appLocalizations;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final kpisAsync = ref.watch(overviewKpisProvider);
    final currency = ref.watch(currentCurrencyProvider);
    final currencyPosition = ref.watch(currentCurrencySymbolPositionProvider);
    final placeholder = appLocalizations.statisticsPlaceholderValue;

    return StatisticsSurfaceCard(
      padding: StatisticsLayout.cardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: StatisticsLayout.cardHeaderSpacing,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 4,
            children: [
              Text(
                appLocalizations.statisticsOverviewTitle,
                style: StatisticsLayout.cardTitleStyle(context),
              ),
              Text(
                appLocalizations.statisticsOverviewPreviewSubtitle,
                style: StatisticsLayout.cardSubtitleStyle(context),
              ),
            ],
          ),
          kpisAsync.when(
            data: (kpis) {
              final emptyMessage = _previewEmptyMessage(appLocalizations, kpis);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 12,
                children: [
                  if (emptyMessage != null)
                    StatisticsInlineEmptyMessage(message: emptyMessage),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 12,
                    children: [
                      Expanded(
                        child: StatisticsKpiCard(
                          label: appLocalizations.income,
                          value: kpis.isEmpty
                              ? placeholder
                              : _formatAmount(
                                  kpis.totalIncome,
                                  currency,
                                  currencyPosition,
                                ),
                          valueColor: colors.income,
                        ),
                      ),
                      Expanded(
                        child: StatisticsKpiCard(
                          label: appLocalizations.expense,
                          value: kpis.isEmpty
                              ? placeholder
                              : _formatAmount(
                                  kpis.totalExpenses,
                                  currency,
                                  currencyPosition,
                                ),
                          valueColor: colors.expense,
                        ),
                      ),
                      Expanded(
                        child: StatisticsKpiCard(
                          label: appLocalizations.statisticsNetBalance,
                          value: kpis.isEmpty
                              ? placeholder
                              : _formatAmount(
                                  kpis.netResult,
                                  currency,
                                  currencyPosition,
                                ),
                          valueColor: kpis.netResult > 0
                              ? colors.income
                              : kpis.netResult < 0
                                  ? colors.expense
                                  : colors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
            loading: () => const StatisticsChartLoading(height: 72),
            error: (_, __) => StatisticsInlineEmptyMessage(
              message: appLocalizations.statisticsOverviewKpisError,
            ),
          ),
        ],
      ),
    );
  }

  String _formatAmount(
    double amount,
    Currency? currency,
    CurrencySymbolPosition currencyPosition,
  ) {
    return amount.toStringAsFixedRoundedWithCurrency(
      2,
      currency,
      currencyPosition,
    );
  }

  String? _previewEmptyMessage(
    AppLocalizations appLocalizations,
    OverviewPeriodKpis kpis,
  ) {
    if (kpis.isEmpty) {
      return appLocalizations.statisticsNoTransactionsInPeriod;
    }
    if (kpis.totalIncome == 0) {
      return appLocalizations.statisticsNoIncomeInPeriod;
    }
    if (kpis.totalExpenses == 0) {
      return appLocalizations.statisticsNoExpensesInPeriod;
    }
    return null;
  }
}

class _StatisticsNavigationSection extends StatelessWidget {
  const _StatisticsNavigationSection({required this.appLocalizations});

  final AppLocalizations appLocalizations;

  @override
  Widget build(BuildContext context) {
    final items = [
      _StatisticsNavItem(
        title: appLocalizations.statisticsOverviewTitle,
        description: appLocalizations.statisticsOverviewDescription,
        icon: Icons.pie_chart_outline_rounded,
        routeName: OverviewStatisticsPage.routeName,
      ),
      _StatisticsNavItem(
        title: appLocalizations.statisticsSpendingTitle,
        description: appLocalizations.statisticsSpendingDescription,
        icon: Icons.trending_down_rounded,
        routeName: SpendingStatisticsPage.routeName,
      ),
      _StatisticsNavItem(
        title: appLocalizations.statisticsIncomeTitle,
        description: appLocalizations.statisticsIncomeDescription,
        icon: Icons.trending_up_rounded,
        routeName: IncomeStatisticsPage.routeName,
      ),
      _StatisticsNavItem(
        title: appLocalizations.statisticsCashflowTitle,
        description: appLocalizations.statisticsCashflowDescription,
        icon: Icons.swap_horiz_rounded,
        routeName: CashflowStatisticsPage.routeName,
      ),
      _StatisticsNavItem(
        title: appLocalizations.statisticsCategoriesTitle,
        description: appLocalizations.statisticsCategoriesDescription,
        icon: Icons.grid_view_rounded,
        routeName: CategoriesStatisticsPage.routeName,
      ),
      _StatisticsNavItem(
        title: appLocalizations.statisticsInsightsTitle,
        description: appLocalizations.statisticsInsightsDescription,
        icon: Icons.lightbulb_outline_rounded,
        routeName: InsightsStatisticsPage.routeName,
      ),
    ];

    return StatisticsSurfaceCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          for (var i = 0; i < items.length; i++) ...[
            _StatisticsNavCard(item: items[i]),
            if (i < items.length - 1)
              Divider(
                height: 1,
                indent: 68,
                color: context.appColors.divider.withValues(alpha: 0.5),
              ),
          ],
        ],
      ),
    );
  }
}

class _StatisticsNavItem {
  const _StatisticsNavItem({
    required this.title,
    required this.description,
    required this.icon,
    required this.routeName,
  });

  final String title;
  final String description;
  final IconData icon;
  final String routeName;
}

class _StatisticsNavCard extends StatelessWidget {
  const _StatisticsNavCard({required this.item});

  final _StatisticsNavItem item;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return InkWell(
      onTap: () => Navigator.of(context).pushNamed(item.routeName),
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 14,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: colors.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                item.icon,
                color: colors.primary,
                size: 22,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 2,
                children: [
                  Text(
                    item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  Text(
                    item.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colors.textSecondary,
                        ),
                  ),
                ],
              ),
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
