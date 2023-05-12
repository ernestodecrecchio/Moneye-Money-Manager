import 'package:expense_tracker/models/transaction.dart';
import 'package:expense_tracker/pages/common/list_tiles/transaction_list_cell.dart';
import 'package:expense_tracker/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TransactionList extends StatelessWidget {
  static const routeName = '/transactionList';

  final List<Transaction> transactionList;

  const TransactionList({super.key, required this.transactionList});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.allTransactions),
        backgroundColor: CustomColors.blue,
        elevation: 0,
      ),
      body: _buildList(context),
    );
  }

  Widget _buildList(BuildContext context) {
    return ListView.builder(
      itemCount: transactionList.length,
      itemBuilder: (context, index) {
        return TransactionListCell(
          transaction: transactionList[index],
        );
      },
    );
  }
}
