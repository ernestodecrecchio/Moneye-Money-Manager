import 'package:expense_tracker/Helper/database_category_helper.dart';
import 'package:expense_tracker/models/category.dart';
import 'package:flutter/material.dart';

class CategoriesListPage extends StatefulWidget {
  const CategoriesListPage({Key? key}) : super(key: key);

  @override
  State<CategoriesListPage> createState() => _CategoriesListPageState();
}

class _CategoriesListPageState extends State<CategoriesListPage> {
  late List<Category> categoryList;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    _getCategories();
  }

  Future _getCategories() async {
    setState(() => isLoading = true);

    categoryList = await DatabaseCategoryHelper.readAllCategories();

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categorie'),
      ),
      body:
          isLoading ? const CircularProgressIndicator.adaptive() : _buildList(),
      floatingActionButton: _buildFloatingActionButton(context),
    );
  }

  Widget _buildList() {
    return ListView.builder(
      itemCount: categoryList.length,
      itemBuilder: (context, index) {
        final category = categoryList[index];

        return ListTile(
          title: Text(category.name),
          trailing: Container(
            height: 20,
            width: 20,
            color: Color(category.colorValue),
          ),
        );
      },
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      child: const Icon(Icons.add),
      onPressed: () {
        Navigator.pushNamed(context, '/newCategory')
            .then((value) => _getCategories());
      },
    );
  }
}
