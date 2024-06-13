import 'package:expense_tracker/Helper/double_helper.dart';
import 'package:expense_tracker/models/category.dart';
import 'package:expense_tracker/models/transaction.dart';
import 'package:expense_tracker/notifiers/category_provider.dart';
import 'package:expense_tracker/notifiers/currency_provider.dart';
import 'package:expense_tracker/pages/account_detail_page/graphs/account_pie_chart.dart';
import 'package:expense_tracker/pages/account_detail_page/transaction_list_page.dart';
import 'package:expense_tracker/pages/common/delete_transaction_snackbar.dart';
import 'package:expense_tracker/pages/common/list_tiles/transaction_list_cell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum AccountDetailTransactionListMode {
  transactionList,
  forCategory,
}

class TransactionList extends ConsumerStatefulWidget {
  final List<Transaction> transactionList;
  final WidgetRef topWidgetRef;

  const TransactionList({
    super.key,
    required this.transactionList,
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
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(
              AppLocalizations.of(context)!.transactionList,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {
                transactionListMode = transactionListMode ==
                        AccountDetailTransactionListMode.transactionList
                    ? AccountDetailTransactionListMode.forCategory
                    : AccountDetailTransactionListMode.transactionList;

                setState(() {});
              },
              style: TextButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  alignment: Alignment.centerLeft),
              child: Text(
                transactionListMode ==
                        AccountDetailTransactionListMode.transactionList
                    ? AppLocalizations.of(context)!.byList
                    : AppLocalizations.of(context)!.byCategory,
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
          ]),
        ),
        transactionListMode == AccountDetailTransactionListMode.transactionList
            ? _buildTransactionList(context, widget.transactionList)
            : _buildCategoryList(widget.transactionList)
      ],
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
        onTransactionDelete: (transaction, index) {
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

  Widget _buildCategoryList(List<Transaction> transactionList) {
    final List<CategoryTotalValue> categoryTotalValuePairs = [];

    categoryTotalValuePairs.clear();

    for (var transaction in transactionList) {
      Category? category;

      if (transaction.categoryId != null) {
        category = ref
            .read(categoryProvider.notifier)
            .getCategoryFromId(transaction.categoryId!);
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
                name: AppLocalizations.of(context)!.other,
                colorValue: Colors.grey.value,
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
      itemBuilder: (context, index) => _buildCategoryListCell(
        categoryTotalValuePair: categoryTotalValuePairs[index],
        transactionList: transactionList
            .where((transaction) =>
                transaction.categoryId ==
                categoryTotalValuePairs[index].category.id)
            .toList(),
      ),
    );
  }

  _buildCategoryListCell(
      {required CategoryTotalValue categoryTotalValuePair,
      required List<Transaction> transactionList}) {
    final currentCurrency = ref.watch(currentCurrencyProvider);
    final currentCurrencyPosition =
        ref.watch(currentCurrencySymbolPositionProvider);

    return InkWell(
      onTap: () => Navigator.of(context)
          .pushNamed(TransactionListPage.routeName, arguments: transactionList),
      child: Container(
        height: 64,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 17),
        child: Row(
          children: [
            _buildCategoryIcon(context, categoryTotalValuePair.category),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    categoryTotalValuePair.category.name,
                    maxLines: 1,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Text(
                    categoryTotalValuePair.totalValue
                        .toStringAsFixedRoundedWithCurrency(
                      2,
                      currentCurrency,
                      currentCurrencyPosition,
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

  _buildCategoryIcon(BuildContext context, Category category) {
    SvgPicture? categoryIcon;
    if (category.iconPath != null) {
      categoryIcon = SvgPicture.asset(
        category.iconPath!,
        colorFilter: const ColorFilter.mode(
          Colors.white,
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
