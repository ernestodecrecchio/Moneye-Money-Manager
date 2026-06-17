import 'package:expense_tracker/core/configuration/constants.dart';
import 'package:expense_tracker/core/presentation/common/category_ui_extension.dart';
import 'package:expense_tracker/core/presentation/common/list_tiles/transaction_list_cell.dart';
import 'package:expense_tracker/core/presentation/common/widgets/custom_snackbar.dart';
import 'package:expense_tracker/core/presentation/common/widgets/icon_item.dart';
import 'package:expense_tracker/core/presentation/providers/app_localizations_provider.dart';
import 'package:expense_tracker/core/presentation/providers/currency_provider.dart';
import 'package:expense_tracker/core/style/app_theme.dart';
import 'package:expense_tracker/core/utils/double_helper.dart';
import 'package:expense_tracker/features/categories/domain/models/category.dart';
import 'package:expense_tracker/features/statistics/domain/models/category_statistics_detail.dart';
import 'package:expense_tracker/features/statistics/domain/models/monthly_spending_trend_series.dart';
import 'package:expense_tracker/features/statistics/presentation/pages/categories_statistics_page/category_account_breakdown_section.dart';
import 'package:expense_tracker/features/statistics/presentation/pages/spending_statistics_page/spending_monthly_trend_section.dart';
import 'package:expense_tracker/features/statistics/presentation/providers/queries/categories_statistics_notifier.dart';
import 'package:expense_tracker/features/statistics/presentation/providers/queries/category_statistics_detail_notifier.dart';
import 'package:expense_tracker/features/statistics/presentation/widgets/statistics_empty_states.dart';
import 'package:expense_tracker/features/statistics/presentation/widgets/statistics_period_chart_support.dart';
import 'package:expense_tracker/features/statistics/presentation/widgets/statistics_period_indicator.dart';
import 'package:expense_tracker/features/statistics/presentation/providers/statistics_period_provider.dart';
import 'package:expense_tracker/features/statistics/presentation/widgets/statistics_layout.dart';
import 'package:expense_tracker/features/statistics/presentation/widgets/statistics_section_card.dart';
import 'package:expense_tracker/features/statistics/presentation/widgets/statistics_surface_card.dart';
import 'package:expense_tracker/features/transactions/domain/models/transaction.dart';
import 'package:expense_tracker/features/transactions/presentation/providers/mutations/transaction_mutation_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoryStatisticsDetailPageArguments {
  const CategoryStatisticsDetailPageArguments({required this.category});

  final Category category;
}

class CategoryStatisticsDetailPage extends ConsumerWidget {
  static const routeName = '/statisticsCategoryDetailPage';

  const CategoryStatisticsDetailPage({
    super.key,
    required this.category,
  });

  final Category category;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocalizations = ref.watch(appLocalizationsProvider);
    final detailAsync = ref.watch(categoryStatisticsDetailProvider(category));

    return Scaffold(
      appBar: AppBar(
        title: Text(category.name),
      ),
      body: detailAsync.when(
        data: (detail) => _CategoryStatisticsDetailContent(
          category: category,
          detail: detail,
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => Center(
          child: Padding(
            padding: const EdgeInsets.all(Constants.horizontalPadding),
            child: Text(
              appLocalizations.statisticsCategoryDetailError,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: context.appColors.textSecondary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CategoryStatisticsDetailContent extends ConsumerStatefulWidget {
  const _CategoryStatisticsDetailContent({
    required this.category,
    required this.detail,
  });

  final Category category;
  final CategoryStatisticsDetail detail;

  @override
  ConsumerState<_CategoryStatisticsDetailContent> createState() =>
      _CategoryStatisticsDetailContentState();
}

class _CategoryStatisticsDetailContentState
    extends ConsumerState<_CategoryStatisticsDetailContent> {
  static const _scrollToTopThreshold = 240.0;

  late final ScrollController _scrollController;
  bool _showScrollToTop = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    final shouldShow = _scrollController.offset > _scrollToTopThreshold;
    if (shouldShow != _showScrollToTop) {
      setState(() => _showScrollToTop = shouldShow);
    }
  }

  Future<void> _scrollToTop() {
    return _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = ref.watch(appLocalizationsProvider);
    final colors = context.appColors;
    final currency = ref.watch(currentCurrencyProvider);
    final currencyPosition = ref.watch(currentCurrencySymbolPositionProvider);
    final entry = widget.detail.summary;
    final category = widget.category;
    final detail = widget.detail;

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
    final chartColor =
        category.colorValue != null ? category.color : colors.primary;

    return Stack(
      children: [
        Scrollbar(
          controller: _scrollController,
          thumbVisibility: true,
          child: CustomScrollView(
            controller: _scrollController,
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
              const StatisticsPeriodIndicator(),
              const SizedBox(height: StatisticsLayout.periodSectionSpacing),
              StatisticsSurfaceCard(
                padding: StatisticsLayout.cardPadding,
                child: Row(
                  spacing: 14,
                  children: [
                    IconItem(
                      backgroundColor: category.color,
                      iconPath: category.iconPath,
                      shape: BoxShape.circle,
                      size: 48,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 4,
                        children: [
                          Text(
                            category.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: StatisticsLayout.cardTitleStyle(context),
                          ),
                          Text(
                            shareLabel,
                            style: StatisticsLayout.cardSubtitleStyle(context),
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
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: amountColor,
                                letterSpacing: -0.5,
                              ),
                        ),
                        Text(
                          percentageLabel,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: colors.textSecondary,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: StatisticsLayout.sectionSpacing),
              _CategoryMonthlyTrendSection(
                monthlyTrend: detail.monthlyTrend,
                chartColor: chartColor,
                isExpense: entry.isExpense,
              ),
              const SizedBox(height: StatisticsLayout.sectionSpacing),
              CategoryAccountBreakdownSection(
                series: detail.accountBreakdown,
                isExpense: entry.isExpense,
              ),
              const SizedBox(height: StatisticsLayout.sectionSpacing),
              Padding(
                padding: const EdgeInsets.only(
                  left: 2,
                  bottom: 10,
                ),
                child: Text(
                  appLocalizations.transactionList,
                  style: StatisticsLayout.cardTitleStyle(context),
                ),
              ),
            ]),
          ),
        ),
        if (detail.transactions.isEmpty)
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              Constants.horizontalPadding,
              0,
              Constants.horizontalPadding,
              Constants.horizontalPadding,
            ),
            sliver: SliverToBoxAdapter(
              child: StatisticsSurfaceCard(
                padding: const EdgeInsets.all(24),
                child: StatisticsInlineEmptyMessage(
                  message: appLocalizations.statisticsNoTransactionsInPeriod,
                ),
              ),
            ),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              Constants.horizontalPadding,
              0,
              Constants.horizontalPadding,
              Constants.horizontalPadding,
            ),
            sliver: DecoratedSliver(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.08),
                    blurRadius: 8,
                    spreadRadius: 0,
                    offset: Offset(0, 2),
                  ),
                ],
                color: colors.surface,
              ),
              sliver: SliverPadding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                sliver: SliverList.separated(
                  itemCount: detail.transactions.length,
                  itemBuilder: (context, index) {
                    return _CategoryStatisticsTransactionRow(
                      transaction: detail.transactions[index],
                      onTransactionChanged: () {
                        ref.invalidate(
                            categoryStatisticsDetailProvider(category));
                        ref.invalidate(categoriesStatisticsProvider);
                      },
                    );
                  },
                  separatorBuilder: (context, index) => Divider(
                    height: 1,
                    indent: Constants.horizontalPadding,
                    color: colors.divider.withValues(alpha: 0.5),
                  ),
                ),
              ),
            ),
          ),
            ],
          ),
        ),
        Positioned(
          right: Constants.horizontalPadding,
          bottom: Constants.horizontalPadding,
          child: AnimatedOpacity(
            opacity: _showScrollToTop ? 1 : 0,
            duration: const Duration(milliseconds: 200),
            child: IgnorePointer(
              ignoring: !_showScrollToTop,
              child: Tooltip(
                message: appLocalizations.statisticsScrollToTop,
                child: FloatingActionButton.small(
                  onPressed: _scrollToTop,
                  backgroundColor: colors.surface,
                  foregroundColor: colors.primary,
                  elevation: 2,
                  child: const Icon(Icons.keyboard_arrow_up_rounded),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CategoryMonthlyTrendSection extends ConsumerWidget {
  const _CategoryMonthlyTrendSection({
    required this.monthlyTrend,
    required this.chartColor,
    required this.isExpense,
  });

  final MonthlySpendingTrendSeries monthlyTrend;
  final Color chartColor;
  final bool isExpense;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final period = ref.watch(statisticsPeriodProvider);
    if (!statisticsPeriodSupportsMultipleMonths(period)) {
      return const SizedBox.shrink();
    }

    final appLocalizations = ref.watch(appLocalizationsProvider);
    final emptyMessage = isExpense
        ? appLocalizations.statisticsNoExpensesInPeriod
        : appLocalizations.statisticsNoIncomeInPeriod;

    return StatisticsSectionCard(
      title: appLocalizations.statisticsCategoryMonthlyTrend,
      child: monthlyTrend.isEmpty
          ? StatisticsChartEmptyMessage(message: emptyMessage)
          : monthlyTrend.hasInsufficientData
              ? StatisticsChartEmptyMessage(
                  message: appLocalizations
                      .statisticsCategoryMonthlyTrendInsufficientData,
                )
              : MonthlySpendingTrendLineChart(
                  series: monthlyTrend,
                  lineColor: chartColor,
                ),
    );
  }
}

class _CategoryStatisticsTransactionRow extends ConsumerWidget {
  const _CategoryStatisticsTransactionRow({
    required this.transaction,
    required this.onTransactionChanged,
  });

  final Transaction transaction;
  final VoidCallback onTransactionChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocalizations = ref.watch(appLocalizationsProvider);

    return TransactionListCell(
      transaction: transaction,
      showAccountLabel: true,
      showCategoryIcon: false,
      onTransactionDelete: (_) {
        onTransactionChanged();
        CustomSnackBar.show(
          context,
          message: appLocalizations.transactionDeleted,
          type: SnackBarType.success,
          actionLabel: appLocalizations.cancel,
          onActionPressed: () async {
            await ref
                .read(transactionMutationProvider.notifier)
                .addTransaction(transaction);
            onTransactionChanged();
          },
        );
      },
    );
  }
}
