import 'package:expense_tracker/core/utils/double_helper.dart';
import 'package:expense_tracker/features/transactions/presentation/providers/mutations/transaction_mutation_notifier.dart';
import 'package:expense_tracker/core/presentation/providers/app_localizations_provider.dart';
import 'package:expense_tracker/core/configuration/constants.dart';
import 'package:expense_tracker/l10n/app_localizations.dart';
import 'package:expense_tracker/features/categories/domain/models/category.dart';
import 'package:expense_tracker/features/transactions/domain/models/transaction.dart';
import 'package:expense_tracker/features/categories/presentation/providers/queries/categories_list_notifier.dart';
import 'package:expense_tracker/core/presentation/providers/currency_provider.dart';
import 'package:expense_tracker/features/accounts/presentation/pages/account_detail_page/transaction_list_for_category_page.dart';
import 'package:expense_tracker/features/transactions/presentation/providers/queries/transactions_list_notifier.dart';
import 'package:expense_tracker/core/presentation/common/widgets/custom_snackbar.dart';
import 'package:expense_tracker/core/presentation/common/list_tiles/transaction_list_cell.dart';
import 'package:expense_tracker/core/presentation/common/widgets/icon_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:expense_tracker/core/style/app_theme.dart';
import 'package:collection/collection.dart';
import 'package:expense_tracker/core/presentation/common/extensions/category_extensions.dart';

enum AccountDetailTransactionListMode {
  transactionList,
  forCategory,
}

class TransactionList extends ConsumerStatefulWidget {
  final String title;
  final TransactionsListParams transactionsListParams;
  final bool showListModeButton;
  final bool showAccountLabel;
  final WidgetRef topWidgetRef;

  const TransactionList({
    super.key,
    required this.title,
    required this.transactionsListParams,
    this.showListModeButton = true,
    required this.showAccountLabel,
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
                padding: const EdgeInsets.symmetric(
                    horizontal: Constants.horizontalPadding),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.title,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      if (widget.showListModeButton)
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
              if (transactionList.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: Center(
                    child: Text(
                      appLocalizations.noTransactions,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: context.appColors.textSecondary,
                          ),
                    ),
                  ),
                )
              else
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
        showAccountLabel: widget.showAccountLabel,
        onTransactionDelete: (transaction) {
          CustomSnackBar.show(
            context,
            message: ref.read(appLocalizationsProvider).transactionDeleted,
            type: SnackBarType.success,
            actionLabel: ref.read(appLocalizationsProvider).cancel,
            onActionPressed: () async {
              await widget.topWidgetRef
                  .read(transactionMutationProvider.notifier)
                  .addTransaction(transaction);
            },
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
                isOtherCategory: true,
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
                spacing: 2,
                children: [
                  Text(
                    category.name,
                    maxLines: 1,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
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

  Widget _buildCategoryIcon(BuildContext context, Category category) {
    return IconItem(
      backgroundColor: category.color,
      shape: BoxShape.circle,
      iconPath: category.iconPath,
    );
  }
}

class CategoryTotalValue {
  final Category category;
  double totalValue;

  CategoryTotalValue({
    required this.category,
    required this.totalValue,
  });
}
