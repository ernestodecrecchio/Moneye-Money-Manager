import 'package:expense_tracker/notifiers/account_provider.dart';
import 'package:expense_tracker/pages/accounts_page/new_account_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccountsListPage extends StatefulWidget {
  const AccountsListPage({Key? key}) : super(key: key);

  @override
  State<AccountsListPage> createState() => _AccountsListPageState();
}

class _AccountsListPageState extends State<AccountsListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conti'),
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

            return Dismissible(
              key: Key(account.id.toString()),
              confirmDismiss: (_) {
                return accountProvider.deleteAccount(account);
              },
              background: Container(color: Colors.red),
              child: ListTile(
                title: Text(account.name),
                leading: Container(
                  color: Colors.black,
                  child: account.icon,
                ),
              ),
            );
          },
        );
      })),
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      child: const Icon(Icons.add),
      onPressed: () => Navigator.pushNamed(context, NewAccountPage.routeName),
    );
  }
}
