import 'package:expense_tracker/notifiers/category_provider.dart';
import 'package:expense_tracker/pages/options_page/categories_page/category_list_cell.dart';
import 'package:expense_tracker/pages/options_page/categories_page/new_category_page.dart';
import 'package:expense_tracker/style.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
        title: Text(AppLocalizations.of(context)!.categories),
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
      backgroundColor: CustomColors.darkBlue,
      child: const Icon(Icons.add),
      onPressed: () => Navigator.pushNamed(context, NewCategoryPage.routeName),
    );
  }
}
