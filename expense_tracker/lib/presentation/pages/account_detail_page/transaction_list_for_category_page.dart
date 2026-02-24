import 'package:expense_tracker/domain/models/category.dart';
import 'package:expense_tracker/domain/models/transaction.dart';
import 'package:expense_tracker/presentation/pages/common/delete_transaction_snackbar.dart';
import 'package:expense_tracker/presentation/pages/common/list_tiles/transaction_list_cell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:expense_tracker/application/transactions/notifiers/queries/transactions_list_notifier.dart';

class TransactionListForCategoryPageArguments {
  final Category category;
  final TransactionsListParams params;

  TransactionListForCategoryPageArguments({
    required this.category,
    required this.params,
  });
}

class TransactionListForCategoryPage extends ConsumerWidget {
  static const routeName = '/transactionListForCategoryPage';

  final Category category;
  final TransactionsListParams params;

  const TransactionListForCategoryPage({
    super.key,
    required this.category,
    required this.params,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category.name),
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
            showDeleteTransactionSnackbar(
              context,
              ref,
              transaction,
              index,
            );
          },
        );
      },
    );
  }
}
