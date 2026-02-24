import 'package:expense_tracker/domain/models/category.dart';
import 'package:expense_tracker/domain/models/transaction.dart';
import 'package:expense_tracker/presentation/pages/common/delete_transaction_snackbar.dart';
import 'package:expense_tracker/presentation/pages/common/list_tiles/transaction_list_cell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransactionListForCategoryPageArguments {
  final Category category;
  final List<Transaction> transactionList;

  TransactionListForCategoryPageArguments({
    required this.category,
    required this.transactionList,
  });
}

class TransactionListForCategoryPage extends ConsumerWidget {
  static const routeName = '/transactionListForCategoryPage';

  final Category category;
  final List<Transaction> transactionList;

  const TransactionListForCategoryPage({
    super.key,
    required this.category,
    required this.transactionList,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category.name),
      ),
      body: _buildList(context, ref),
    );
  }

  Widget _buildList(BuildContext context, WidgetRef ref) {
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
