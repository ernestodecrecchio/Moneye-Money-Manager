import 'package:expense_tracker/l10n/app_localizations.dart';
import 'package:expense_tracker/application/transactions/models/transaction.dart';
import 'package:expense_tracker/presentation/pages/common/delete_transaction_snackbar.dart';
import 'package:expense_tracker/presentation/pages/common/list_tiles/transaction_list_cell.dart';
import 'package:expense_tracker/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransactionListPage extends ConsumerWidget {
  static const routeName = '/transactionListPage';

  final List<Transaction> transactionList;

  const TransactionListPage({super.key, required this.transactionList});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.allTransactions),
        backgroundColor: CustomColors.blue,
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
