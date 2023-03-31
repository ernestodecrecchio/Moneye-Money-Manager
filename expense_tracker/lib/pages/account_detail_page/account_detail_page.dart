import 'package:expense_tracker/models/account.dart';
import 'package:expense_tracker/notifiers/transaction_provider.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: Text(account.name),
        backgroundColor: CustomColors.blue,
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
      //minimum: EdgeInsets.symmetric(horizontal: 17),
      child: ListView.builder(
        itemCount: transactionList.length,
        itemBuilder: (context, index) {
          return TransactionListCell(transaction: transactionList[index]);
        },
      ),
    );
  }
}
