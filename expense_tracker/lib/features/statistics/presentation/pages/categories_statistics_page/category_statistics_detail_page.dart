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
import 'package:expense_tracker/features/statistics/presentation/providers/queries/categories_statistics_notifier.dart';
import 'package:expense_tracker/features/statistics/presentation/providers/queries/category_statistics_detail_notifier.dart';
import 'package:expense_tracker/features/statistics/presentation/widgets/statistics_period_indicator.dart';
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

class _CategoryStatisticsDetailContent extends ConsumerWidget {
  const _CategoryStatisticsDetailContent({
    required this.category,
    required this.detail,
  });

  final Category category;
  final CategoryStatisticsDetail detail;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocalizations = ref.watch(appLocalizationsProvider);
    final colors = context.appColors;
    final currency = ref.watch(currentCurrencyProvider);
    final currencyPosition = ref.watch(currentCurrencySymbolPositionProvider);
    final entry = detail.summary;

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

    return ListView(
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
        Padding(
          padding: const EdgeInsets.only(left: 2, bottom: 10),
          child: Text(
            appLocalizations.transactionList,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        if (detail.transactions.isEmpty)
          StatisticsSurfaceCard(
            padding: const EdgeInsets.all(24),
            child: Text(
              appLocalizations.statisticsNoTransactionsInPeriod,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
                color: colors.textSecondary,
              ),
            ),
          )
        else
          StatisticsSurfaceCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                for (var i = 0; i < detail.transactions.length; i++) ...[
                  _CategoryStatisticsTransactionRow(
                    transaction: detail.transactions[i],
                    onTransactionChanged: () {
                      ref.invalidate(categoryStatisticsDetailProvider(category));
                      ref.invalidate(categoriesStatisticsProvider);
                    },
                  ),
                  if (i < detail.transactions.length - 1)
                    Divider(
                      height: 1,
                      indent: Constants.horizontalPadding,
                      color: colors.divider.withValues(alpha: 0.5),
                    ),
                ],
              ],
            ),
          ),
      ],
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
