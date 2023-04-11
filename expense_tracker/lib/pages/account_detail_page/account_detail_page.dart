import 'package:collection/collection.dart';
import 'package:expense_tracker/models/account.dart';
import 'package:expense_tracker/notifiers/account_provider.dart';
import 'package:expense_tracker/notifiers/transaction_provider.dart';
import 'package:expense_tracker/pages/account_detail_page/account_pie_chart.dart';
import 'package:expense_tracker/pages/accounts_page/new_account_page.dart';
import 'package:expense_tracker/pages/home_page/transaction_list_cell.dart';
import 'package:expense_tracker/style.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccountDetailPage extends StatelessWidget {
  static const routeName = '/accountDetailPage';

  final Account account;

  const AccountDetailPage({super.key, required this.account});

  @override
  Widget build(BuildContext context) {
    final referenceAccount = Provider.of<AccountProvider>(context, listen: true)
        .accountList
        .firstWhereOrNull((element) => element.id == account.id);

    return Scaffold(
      appBar: AppBar(
        title: Text(referenceAccount?.name ?? account.name),
        backgroundColor: CustomColors.blue,
        elevation: 0,
        actions: [if (account.id != null) _buildEditAction(context)],
      ),
      backgroundColor: Colors.white,
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    final transactionList =
        Provider.of<TransactionProvider>(context, listen: true)
            .getTransactionListForAccount(account);

    return SafeArea(
      child: Column(
        children: [
          AccountPieChart(
            timeMode: AccountPieChartModeTime.all,
            transactionType: AccountPieChartModeTransactionType.expense,
            transactionList: transactionList,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: transactionList.length,
              itemBuilder: (context, index) {
                return TransactionListCell(
                  transaction: transactionList[index],
                  showAccountLabel: false,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditAction(BuildContext context) {
    return TextButton(
      child: const Text(
        'Modifica',
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () => Navigator.of(context).pushNamed(
        NewAccountPage.routeName,
        arguments: account,
      ),
    );
  }
}
