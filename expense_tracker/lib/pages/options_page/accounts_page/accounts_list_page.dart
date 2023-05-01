import 'package:expense_tracker/notifiers/account_provider.dart';
import 'package:expense_tracker/pages/options_page/accounts_page/account_list_cell.dart';
import 'package:expense_tracker/pages/options_page/accounts_page/new_account_page.dart';
import 'package:expense_tracker/style.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AccountsListPage extends StatefulWidget {
  static const routeName = '/accountsListPage';

  const AccountsListPage({Key? key}) : super(key: key);

  @override
  State<AccountsListPage> createState() => _AccountsListPageState();
}

class _AccountsListPageState extends State<AccountsListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.accounts),
        elevation: 0,
        backgroundColor: CustomColors.blue,
      ),
      floatingActionButton: _buildFloatingActionButton(context),
      body: _buildList(),
    );
  }

  Widget _buildList() {
    return RefreshIndicator(
      onRefresh: () =>
          Provider.of<AccountProvider>(context, listen: false).getAllAccounts(),
      child: Consumer<AccountProvider>(
          builder: ((context, accountProvider, child) {
        return ListView.builder(
          itemCount: accountProvider.accountList.length,
          itemBuilder: (context, index) {
            final account = accountProvider.accountList[index];

            return AccountListCell(account: account);
          },
        );
      })),
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: CustomColors.darkBlue,
      child: const Icon(Icons.add),
      onPressed: () => Navigator.pushNamed(context, NewAccountPage.routeName),
    );
  }
}
