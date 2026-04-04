import 'package:expense_tracker/core/presentation/providers/app_localizations_provider.dart';
import 'package:expense_tracker/features/transactions/presentation/providers/mutations/transaction_mutation_notifier.dart';
import 'package:expense_tracker/features/transactions/domain/models/transaction.dart';
import 'package:expense_tracker/core/presentation/common/widgets/custom_snackbar.dart';
import 'package:expense_tracker/core/presentation/common/list_tiles/transaction_list_cell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:expense_tracker/features/transactions/presentation/providers/queries/transactions_list_notifier.dart';

class TransactionListForCategoryPageArguments {
  final TransactionsListParams params;

  TransactionListForCategoryPageArguments({
    required this.params,
  });
}

class TransactionListForCategoryPage extends ConsumerWidget {
  static const routeName = '/transactionListForCategoryPage';

  final TransactionsListParams params;

  const TransactionListForCategoryPage({
    super.key,
    required this.params,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(params.category?.name ?? ""),
      ),
      body: ref.watch(transactionsListProvider(params)).when(
            data: (transactionList) =>
                _buildList(context, ref, transactionList),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) =>
                const Center(child: Text('Error loading transactions')),
          ),
    );
  }

  Widget _buildList(
      BuildContext context, WidgetRef ref, List<Transaction> transactionList) {
    return ListView.builder(
      itemCount: transactionList.length,
      itemBuilder: (context, index) {
        return TransactionListCell(
          transaction: transactionList[index],
          onTransactionDelete: (transaction) {
            CustomSnackBar.show(
              context,
              message: ref.read(appLocalizationsProvider).transactionDeleted,
              type: SnackBarType.success,
              actionLabel: ref.read(appLocalizationsProvider).cancel,
              onActionPressed: () async {
                await ref
                    .read(transactionMutationProvider.notifier)
                    .addTransaction(transaction);
              },
            );
          },
        );
      },
    );
  }
}
