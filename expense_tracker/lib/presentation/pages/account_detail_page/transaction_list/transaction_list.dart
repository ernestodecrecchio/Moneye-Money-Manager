import 'package:expense_tracker/Helper/double_helper.dart';
import 'package:expense_tracker/application/common/notifiers/app_localizations_provider.dart';
import 'package:expense_tracker/l10n/app_localizations.dart';
import 'package:expense_tracker/domain/models/category.dart';
import 'package:expense_tracker/domain/models/transaction.dart';
import 'package:expense_tracker/application/categories/notifiers/queries/categories_list_notifier.dart';
import 'package:expense_tracker/application/common/notifiers/currency_provider.dart';
import 'package:expense_tracker/presentation/pages/account_detail_page/graphs/account_pie_chart.dart';
import 'package:expense_tracker/presentation/pages/account_detail_page/transaction_list_for_category_page.dart';
import 'package:expense_tracker/application/transactions/notifiers/queries/transactions_list_notifier.dart';
import 'package:expense_tracker/presentation/pages/common/delete_transaction_snackbar.dart';
import 'package:expense_tracker/presentation/pages/common/list_tiles/transaction_list_cell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vector_graphics/vector_graphics.dart';
import 'package:expense_tracker/style/app_theme.dart';
import 'package:collection/collection.dart';

enum AccountDetailTransactionListMode {
  transactionList,
  forCategory,
}

class TransactionList extends ConsumerStatefulWidget {
  final TransactionsListParams transactionsListParams;
  final WidgetRef topWidgetRef;

  const TransactionList({
    super.key,
    required this.transactionsListParams,
    required this.topWidgetRef,
  });

  @override
  ConsumerState<TransactionList> createState() => _TransactionListState();
}

class _TransactionListState extends ConsumerState<TransactionList> {
  AccountDetailTransactionListMode transactionListMode =
      AccountDetailTransactionListMode.transactionList;

  @override
  Widget build(BuildContext context) {
    final appLocalizations = ref.watch(appLocalizationsProvider);

    return ref
        .watch(transactionsListProvider(widget.transactionsListParams))
        .when(
          data: (transactionList) => Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        appLocalizations.transactionList,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      TextButton(
                        onPressed: () {
                          transactionListMode = transactionListMode ==
                                  AccountDetailTransactionListMode
                                      .transactionList
                              ? AccountDetailTransactionListMode.forCategory
                              : AccountDetailTransactionListMode
                                  .transactionList;

                          setState(() {});
                        },
                        style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 0, vertical: 10),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            alignment: Alignment.centerLeft),
                        child: Text(
                          transactionListMode ==
                                  AccountDetailTransactionListMode
                                      .transactionList
                              ? appLocalizations.byList
                              : appLocalizations.byCategory,
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                      ),
                    ]),
              ),
              transactionListMode ==
                      AccountDetailTransactionListMode.transactionList
                  ? _buildTransactionList(context, transactionList)
                  : _buildCategoryList(transactionList, appLocalizations)
            ],
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) =>
              const Center(child: Text('Error loading transactions')),
        );
  }

  Widget _buildTransactionList(
      BuildContext topContext, List<Transaction> transactionList) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: transactionList.length,
      itemBuilder: (_, index) => TransactionListCell(
        transaction: transactionList[index],
        showAccountLabel: false,
        onTransactionDelete: (transaction) {
          showDeleteTransactionSnackbar(
            super
                .context, // Passing the super.context because, if the transaction list becomes empty,the widget itself will be disposed and the snackbar action will not work with the transaction list context.
            widget.topWidgetRef,
            transaction,
            index,
          );
        },
      ),
    );
  }

  Widget _buildCategoryList(
    List<Transaction> transactionList,
    AppLocalizations appLocalizations,
  ) {
    final List<CategoryTotalValue> categoryTotalValuePairs = [];
    final categories = ref.watch(categoriesListProvider).asData?.value ?? [];

    for (var transaction in transactionList) {
      Category? category;

      if (transaction.categoryId != null) {
        category = categories.firstWhereOrNull(
          (element) => element.id == transaction.categoryId,
        );
      }

      if (category != null) {
        final indexFound = categoryTotalValuePairs
            .indexWhere((element) => element.category == category);

        if (indexFound != -1) {
          categoryTotalValuePairs[indexFound].totalValue += transaction.amount;
        } else {
          final newEntry = CategoryTotalValue(
            category: category,
            totalValue: transaction.amount,
          );

          categoryTotalValuePairs.add(newEntry);
        }
      } else {
        final indexFound = categoryTotalValuePairs
            .indexWhere((element) => element.category.id == null);

        if (indexFound != -1) {
          categoryTotalValuePairs[indexFound].totalValue += transaction.amount;
        } else {
          final otherEntry = CategoryTotalValue(
              category: Category(
                name: appLocalizations.other,
                colorValue: context.appColors.textSecondary.toARGB32(),
                iconPath: 'assets/icons/box.svg',
              ),
              totalValue: transaction.amount);

          categoryTotalValuePairs.add(otherEntry);
        }
      }
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: categoryTotalValuePairs.length,
      itemBuilder: (context, index) => _buildCategoryCell(
        category: categoryTotalValuePairs[index].category,
        totalValue: categoryTotalValuePairs[index].totalValue,
      ),
    );
  }

  InkWell _buildCategoryCell({
    required Category category,
    required double totalValue,
  }) {
    final currentCurrency = ref.watch(currentCurrencyProvider);
    final currentCurrencyPosition =
        ref.watch(currentCurrencySymbolPositionProvider);

    final args = TransactionListForCategoryPageArguments(
      params: widget.transactionsListParams.copyWith(
        category: category,
      ),
    );

    return InkWell(
      onTap: () => Navigator.of(context).pushNamed(
        TransactionListForCategoryPage.routeName,
        arguments: args,
      ),
      child: Container(
        height: 64,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 17),
        child: Row(
          children: [
            _buildCategoryIcon(context, category),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category.name,
                    maxLines: 1,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Text(
                    totalValue.toStringAsFixedRoundedWithCurrency(
                      2,
                      currentCurrency,
                      currentCurrencyPosition,
                    ),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: context.appColors.textSecondary,
                        ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
            ),
          ],
        ),
      ),
    );
  }

  Container _buildCategoryIcon(BuildContext context, Category category) {
    VectorGraphic? categoryIcon;
    if (category.iconPath != null) {
      categoryIcon = VectorGraphic(
        loader: AssetBytesLoader(category.iconPath!),
        colorFilter: ColorFilter.mode(
          context.appColors.onPrimary,
          BlendMode.srcIn,
        ),
      );
    }

    return Container(
      width: 32,
      height: 32,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(shape: BoxShape.circle, color: category.color),
      child: categoryIcon,
    );
  }
}
