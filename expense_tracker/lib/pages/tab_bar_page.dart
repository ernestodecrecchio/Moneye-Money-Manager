import 'package:expense_tracker/notifiers/account_provider.dart';
import 'package:expense_tracker/notifiers/category_provider.dart';
import 'package:expense_tracker/pages/accounts_page/accounts_list_page.dart';
import 'package:expense_tracker/pages/categories_page/categories_list_page.dart';
import 'package:expense_tracker/pages/home_page/home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TabBarPage extends StatefulWidget {
  const TabBarPage({Key? key}) : super(key: key);

  @override
  State<TabBarPage> createState() => _TabBarPageState();
}

class _TabBarPageState extends State<TabBarPage> {
  int index = 0;

  final screen = [
    const HomePage(),
    const CategoriesListPage(),
    const AccountsListPage(),
  ];

  @override
  void initState() {
    super.initState();

    Provider.of<CategoryProvider>(context, listen: false).getAllCategories();
    Provider.of<AccountProvider>(context, listen: false).getAllAccounts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: NavigationBar(
          selectedIndex: index,
          onDestinationSelected: (newIndex) {
            setState(() => index = newIndex);
          },
          destinations: const [
            NavigationDestination(
              label: 'Spese',
              icon: Icon(Icons.money),
            ),
            NavigationDestination(
              label: 'Categorie',
              icon: Icon(Icons.abc),
            ),
            NavigationDestination(
              label: 'Conti',
              icon: Icon(Icons.abc),
            ),
          ],
        ),
        body: screen[index]);
  }
}
