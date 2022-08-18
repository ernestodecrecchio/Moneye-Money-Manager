import 'package:expense_tracker/notifiers/category_provider.dart';
import 'package:expense_tracker/pages/categories_list_page.dart';
import 'package:expense_tracker/pages/expenses_list_page.dart';
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
    const ExpenseListPage(),
    const CategoriesListPage(),
  ];

  @override
  void initState() {
    super.initState();

    Provider.of<CategoryProvider>(context, listen: false).getAllCategories();
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
          ],
        ),
        body: screen[index]);
  }
}
