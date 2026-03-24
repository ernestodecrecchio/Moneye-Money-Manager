import 'package:intl/intl.dart';
import 'package:expense_tracker/Helper/double_helper.dart';
import 'package:expense_tracker/application/categories/notifiers/queries/categories_list_notifier.dart';
import 'package:expense_tracker/application/common/notifiers/app_localizations_provider.dart';
import 'package:expense_tracker/application/transactions/notifiers/mutations/transaction_mutation_notifier.dart';
import 'package:expense_tracker/configuration/constants.dart';
import 'package:expense_tracker/l10n/app_localizations.dart';
import 'package:expense_tracker/domain/models/account.dart';
import 'package:expense_tracker/domain/models/transaction.dart';
import 'package:expense_tracker/application/accounts/notifiers/queries/accounts_list_notifier.dart';
import 'package:expense_tracker/application/common/notifiers/currency_provider.dart';
import 'package:collection/collection.dart';
import 'package:expense_tracker/presentation/pages/common/widgets/icon_item.dart';
import 'package:expense_tracker/presentation/pages/new_edit_transaction_flow/new_edit_transaction_page.dart';

import 'package:expense_tracker/style/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:expense_tracker/style/app_theme.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TransactionListCell extends ConsumerWidget {
  final Transaction transaction;
  final bool showAccountLabel;

  final Function(Transaction transactionDeleted) onTransactionDelete;

  const TransactionListCell({
    super.key,
    required this.transaction,
    bool? dismissible = true,
    this.showAccountLabel = true,
    required this.onTransactionDelete,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocalizations = ref.watch(appLocalizationsProvider);

    return Slidable(
      key: UniqueKey(),
      startActionPane: _buildDeleteActionPane(context, ref, appLocalizations),
      endActionPane: _buildDeleteActionPane(context, ref, appLocalizations),
      child: InkWell(
        onTap: () async {
          Navigator.of(context).pushNamed(
            NewEditTransactionPage.routeName,
            arguments:
                NewEditTransactionPageScreenArguments(transaction: transaction),
          );
        },
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: 8, horizontal: Constants.horizontalPadding),
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
                  mainAxisSize: MainAxisSize.min,
                  spacing: 2,
                  children: [
                    Text(
                      transaction.title,
                      maxLines: 2,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis,
                      ),
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
      ],
    );
  }

  SlidableAction _buildDeleteAction(
      BuildContext context, WidgetRef ref, AppLocalizations appLocalizations) {
    return SlidableAction(
      onPressed: (_) async => await _removeTransaction(context, ref),
      backgroundColor: CustomColors.swipeActionRed,
      foregroundColor: Colors.white,
      icon: Icons.delete,
      label: appLocalizations.delete,
    );
  }

  Future _removeTransaction(BuildContext context, WidgetRef ref) async {
    await ref
        .read(transactionMutationProvider.notifier)
        .deleteTransaction(transaction)
        .then(
      (result) {
        onTransactionDelete(transaction);
      },
    );
  }

  Widget _buildCategoryIcon(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoriesListProvider).asData?.value ?? [];
    final category = categories.firstWhereOrNull(
      (element) => element.id == transaction.categoryId,
    );

    return IconItem(
      backgroundColor: category?.color ?? context.appColors.textSecondary,
      shape: BoxShape.circle,
      iconPath: category?.iconPath,
    );
  }

  Widget _buildDate(BuildContext context, AppLocalizations appLocalizations) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);

    String dateString = DateFormat.yMd(appLocalizations.localeName)
        .format(transaction.date)
        .toString();

    DateTime dateToCheck = DateTime(
        transaction.date.year, transaction.date.month, transaction.date.day);

    if (dateToCheck == today) {
      dateString = '$dateString (${appLocalizations.today})';
    } else if (dateToCheck == yesterday) {
      dateString = '$dateString (${appLocalizations.yesterday})';
    }

    return Flexible(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 4,
        children: [
          if (transaction.isGenerated)
            Icon(
              Icons.repeat,
              size: 14,
              color: context.appColors.textSecondary,
            ),
          Flexible(
            child: Text(
              dateString,
              style: TextStyle(
                fontSize: 12,
                color: context.appColors.textSecondary,
              ),
            ),
          ),
        ],
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
          .watch(accountsListProvider)
          .asData
          ?.value
          .firstWhereOrNull((a) => a.id == transaction.accountId);
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
            color: transaction.amount >= 0
                ? context.appColors.income
                : context.appColors.expense,
          ),
        ),
        if (showAccountLabel && account != null)
          Text(
            account.name,
            style:
                TextStyle(fontSize: 12, color: context.appColors.textSecondary),
          ),
      ],
    );
  }
}
