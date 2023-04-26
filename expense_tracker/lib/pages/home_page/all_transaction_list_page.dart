import 'package:expense_tracker/notifiers/transaction_provider.dart';
import 'package:expense_tracker/pages/home_page/transaction_list_cell.dart';
import 'package:expense_tracker/style.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AllTransactionList extends StatelessWidget {
  static const routeName = '/allTransactionList';

  const AllTransactionList({super.key});

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
    return RefreshIndicator(
      onRefresh: () => Provider.of<TransactionProvider>(context, listen: false)
          .getAllTransactions(),
      child: Consumer<TransactionProvider>(
          builder: ((context, transactionProvider, child) {
        return ListView.builder(
          itemCount: transactionProvider.transactionList.length,
          itemBuilder: (context, index) {
            final transaction = transactionProvider.transactionList[index];

            return TransactionListCell(transaction: transaction);
          },
        );
      })),
    );
  }
}
