import 'package:expense_tracker/pages/accounts_page/accounts_list_page.dart';
import 'package:expense_tracker/pages/categories_page/categories_list_page.dart';
import 'package:expense_tracker/style.dart';
import 'package:flutter/material.dart';

class OptionsPage extends StatelessWidget {
  const OptionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Opzioni'),
        backgroundColor: CustomColors.blue,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(top: 10),
      children: [
        ListTile(
          leading: const Icon(
            Icons.grid_view_rounded,
            color: CustomColors.darkBlue,
          ),
          title: const Text('Categorie'),
          subtitle: const Text('Gestisci le categorie e creane di nuove'),
          trailing: const Icon(Icons.chevron_right_rounded),
          onTap: () =>
              Navigator.of(context).pushNamed(CategoriesListPage.routeName),
        ),
        const Divider(),
        ListTile(
          leading: const Icon(
            Icons.account_balance_rounded,
            color: CustomColors.darkBlue,
          ),
          title: const Text('Conti'),
          subtitle: const Text('Gestisci i tuoi conti e creane di nuovi'),
          trailing: const Icon(Icons.chevron_right_rounded),
          onTap: () =>
              Navigator.of(context).pushNamed(AccountsListPage.routeName),
        ),
      ],
    );
  }
}
