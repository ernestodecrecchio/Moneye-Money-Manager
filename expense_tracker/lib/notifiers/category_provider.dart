import 'package:expense_tracker/Helper/database_category_helper.dart';
import 'package:expense_tracker/models/category.dart';
import 'package:flutter/material.dart';

class CategoryProvider with ChangeNotifier {
  List<Category> categoryList = [];

  Future getAllCategories() async {
    categoryList = await DatabaseCategoryHelper.instance.readAllCategories();

    notifyListeners();
  }

  Future addNewCategory(Category newCategory) async {
    categoryList.add(await DatabaseCategoryHelper.instance
        .insertCategory(category: newCategory));

    notifyListeners();
  }
}
