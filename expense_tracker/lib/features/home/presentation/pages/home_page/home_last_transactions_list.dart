import 'package:expense_tracker/core/configuration/constants.dart';
import 'package:expense_tracker/core/presentation/common/list_tiles/transaction_list_cell.dart';
import 'package:expense_tracker/core/presentation/common/widgets/custom_snackbar.dart';
import 'package:expense_tracker/core/presentation/providers/app_localizations_provider.dart';
import 'package:expense_tracker/core/style/app_theme.dart';
import 'package:expense_tracker/features/accounts/presentation/pages/account_detail_page/account_detail_page.dart';
import 'package:expense_tracker/features/transactions/domain/models/transaction.dart';
import 'package:expense_tracker/features/transactions/presentation/providers/mutations/transaction_mutation_notifier.dart';
import 'package:expense_tracker/features/transactions/presentation/providers/queries/transactions_list_notifier.dart';
import 'package:expense_tracker/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LastTransactionsList extends ConsumerWidget {
  const LastTransactionsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocalizations = ref.watch(appLocalizationsProvider);

    final latestTransactionsListParam = TransactionsListParams(limit: 5);

    final latestTransactionsAsync =
        ref.watch(transactionsListProvider(latestTransactionsListParam));

    return latestTransactionsAsync.when(
      data: (lastTransactionList) {
        return Column(
          children: [
            _buildHeader(context, appLocalizations),
            if (lastTransactionList.isEmpty)
              _buildEmptyState(context, appLocalizations)
            else
              _buildTransactionsList(
                  context, appLocalizations, lastTransactionList, ref)
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(
        child: Text('Error loading transactions: $err'),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppLocalizations appLocalizations) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Constants.horizontalPadding),
      child: Row(
        children: [
          Text(
            appLocalizations.lastTransactions,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          TextButton(
            onPressed: () =>
                Navigator.of(context).pushNamed(AccountDetailPage.routeName),
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Row(
              children: [
                Text(
                  appLocalizations.viewAll,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                const Icon(Icons.chevron_right_rounded),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(
      BuildContext context, AppLocalizations appLocalizations) {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.only(top: 12.0),
        child: Text(
          appLocalizations.noTransactions,
          style: TextStyle(
            color: context.appColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionsList(
      BuildContext context,
      AppLocalizations appLocalizations,
      List<Transaction> lastTransactionList,
      WidgetRef ref) {
    return ListView.separated(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: lastTransactionList.length,
      itemBuilder: (_, index) {
        return TransactionListCell(
          transaction: lastTransactionList[index],
          onTransactionDelete: (transaction) {
            CustomSnackBar.show(
              context,
              message: appLocalizations.transactionDeleted,
              type: SnackBarType.success,
              actionLabel: appLocalizations.cancel,
              onActionPressed: () async {
                await ref
                    .read(transactionMutationProvider.notifier)
                    .addTransaction(transaction);
              },
            );
          },
        );
      },
      separatorBuilder: (_, __) => const Divider(),
    );
  }
}
