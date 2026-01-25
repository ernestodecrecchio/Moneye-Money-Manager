import 'package:expense_tracker/Helper/double_helper.dart';
import 'package:expense_tracker/application/common/notifiers/app_localizations_provider.dart';
import 'package:expense_tracker/application/transactions/notifiers/mutations/transaction_mutation_notifier.dart';
import 'package:expense_tracker/l10n/app_localizations.dart';
import 'package:expense_tracker/domain/models/account.dart';
import 'package:expense_tracker/domain/models/transaction.dart';
import 'package:expense_tracker/application/accounts/notifiers/account_provider.dart';
import 'package:expense_tracker/application/categories/notifiers/category_provider.dart';
import 'package:expense_tracker/application/common/notifiers/currency_provider.dart';
import 'package:expense_tracker/presentation/pages/new_edit_transaction_flow/new_edit_transaction_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:vector_graphics/vector_graphics.dart';

class TransactionListCell extends ConsumerWidget {
  final Transaction transaction;
  final double horizontalPadding;
  final bool showAccountLabel;

  final Function(Transaction transactionDeleted) onTransactionDelete;

  const TransactionListCell({
    super.key,
    required this.transaction,
    bool? dismissible = true,
    this.horizontalPadding = 17,
    this.showAccountLabel = true,
    required this.onTransactionDelete,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocalizations = ref.watch(appLocalizationsProvider);

    return Slidable(
      key: UniqueKey(), // Key(transaction.id.toString()),
      startActionPane: _buildDeleteActionPane(context, ref, appLocalizations),
      endActionPane: _buildDeleteActionPane(context, ref, appLocalizations),
      child: InkWell(
        onTap: () => Navigator.of(context).pushNamed(
          NewEditTransactionPage.routeName,
          arguments:
              NewEditTransactionPageScreenArguments(transaction: transaction),
        ),
        child: Container(
          height: 64,
          padding:
              EdgeInsets.symmetric(vertical: 8, horizontal: horizontalPadding),
          child: Row(
            children: [
              _buildCategoryIcon(context, ref),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transaction.title,
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
                    _buildDate(context, appLocalizations),
                  ],
                ),
              ),
              _buildValue(context, ref),
            ],
          ),
        ),
      ),
    );
  }

  ActionPane _buildDeleteActionPane(
      BuildContext context, WidgetRef ref, AppLocalizations appLocalizations) {
    return ActionPane(
      motion: const ScrollMotion(),
      dismissible: DismissiblePane(
          onDismissed: () async => await _removeTransaction(context, ref)),
      children: [
        _buildDeleteAction(context, ref, appLocalizations),
        // _buildEditAction(),
      ],
    );
  }

  SlidableAction _buildDeleteAction(
      BuildContext context, WidgetRef ref, AppLocalizations appLocalizations) {
    return SlidableAction(
      onPressed: (_) async => await _removeTransaction(context, ref),
      backgroundColor: const Color(0xFFFE4A49),
      foregroundColor: Colors.white,
      icon: Icons.delete,
      label: appLocalizations.delete,
    );
  }

  // SlidableAction _buildEditAction() {
  //   return SlidableAction(
  //     onPressed: (context) => Navigator.of(context)
  //         .pushNamed(NewTransactionPage.routeName, arguments: transaction),
  //     backgroundColor: const Color(0xFF21B7CA),
  //     foregroundColor: Colors.white,
  //     icon: Icons.edit,
  //     label: 'Modifica',
  //   );
  // }

  Future _removeTransaction(BuildContext context, WidgetRef ref) async {
    await ref
        .read(transactionMutationProvider.notifier)
        .delete(transaction)
        .then(
      (result) {
        onTransactionDelete(transaction);
      },
    );
  }

  Container _buildCategoryIcon(BuildContext context, WidgetRef ref) {
    final category = ref
        .read(categoryProvider.notifier)
        .getCategoryForTransaction(transaction);

    VectorGraphic? categoryIcon;
    if (category != null && category.iconPath != null) {
      categoryIcon = VectorGraphic(
        loader: AssetBytesLoader(category.iconPath!),
        colorFilter: const ColorFilter.mode(
          Colors.white,
          BlendMode.srcIn,
        ),
      );
    } else {
      categoryIcon = VectorGraphic(
        loader: AssetBytesLoader('assets/icons/box.svg'),
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
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: category != null ? category.color : Colors.grey),
      child: categoryIcon,
    );
  }

  Widget _buildDate(BuildContext context, AppLocalizations appLocalizations) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);

    String dateString = transaction.date.toIso8601String().substring(0, 10);

    DateTime dateToCheck = DateTime(
        transaction.date.year, transaction.date.month, transaction.date.day);

    if (dateToCheck == today) {
      dateString = '$dateString (${appLocalizations.today})';
    } else if (dateToCheck == yesterday) {
      dateString = '$dateString (${appLocalizations.yesterday})';
    }

    return Flexible(
      child: Text(
        dateString,
        style: const TextStyle(
          fontSize: 12,
          color: Colors.black54,
        ),
      ),
    );
  }

  Widget _buildValue(BuildContext context, WidgetRef ref) {
    final currentCurrency = ref.watch(currentCurrencyProvider);
    final currentCurrencyPosition =
        ref.watch(currentCurrencySymbolPositionProvider);

    Account? account;

    if (showAccountLabel && transaction.accountId != null) {
      account = ref
          .read(accountProvider.notifier)
          .getAccountFromId(transaction.accountId!);
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          transaction.amount.toStringAsFixedRoundedWithCurrency(
              2, currentCurrency, currentCurrencyPosition),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: transaction.amount >= 0 ? Colors.green : Colors.red,
          ),
        ),
        if (showAccountLabel && account != null)
          Text(
            account.name,
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
      ],
    );
  }
}
