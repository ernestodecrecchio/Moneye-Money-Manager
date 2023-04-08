import 'package:expense_tracker/notifiers/category_provider.dart';
import 'package:expense_tracker/pages/categories_page/category_list_cell.dart';
import 'package:expense_tracker/pages/categories_page/new_category_page.dart';
import 'package:expense_tracker/style.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoriesListPage extends StatefulWidget {
  static const routeName = '/categoriesListPage';

  const CategoriesListPage({Key? key}) : super(key: key);

  @override
  State<CategoriesListPage> createState() => _CategoriesListPageState();
}

class _CategoriesListPageState extends State<CategoriesListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categorie'),
        backgroundColor: CustomColors.blue,
        elevation: 0,
      ),
      floatingActionButton: _buildFloatingActionButton(context),
      body: _buildList(),
    );
  }

  Widget _buildList() {
    return RefreshIndicator(
      onRefresh: () => Provider.of<CategoryProvider>(context, listen: false)
          .getAllCategories(),
      child: Consumer<CategoryProvider>(
          builder: ((context, categoryProvider, child) {
        return ListView.builder(
          itemCount: categoryProvider.categoryList.length,
          itemBuilder: (context, index) {
            return CategoryListCell(
                category: categoryProvider.categoryList[index]);
          },
        );
      })),
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      child: const Icon(Icons.add),
      onPressed: () => Navigator.pushNamed(context, NewCategoryPage.routeName),
    );
  }
}
