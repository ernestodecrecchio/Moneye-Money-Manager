import 'package:expense_tracker/Helper/database_category_helper.dart';
import 'package:expense_tracker/models/category.dart';
import 'package:flutter/material.dart';

class CategoryProvider with ChangeNotifier {
  List<Category> categoryList = [];

  Future getAllCategories() async {
    categoryList = await DatabaseCategoryHelper.instance.readAllCategories();

    notifyListeners();
  }

  Category? getCategoryFromId(int id) {
    try {
      return categoryList.firstWhere((element) => element.id == id);
    } catch (e) {
      return null;
    }
  }

  Future addNewCategory(Category newCategory) async {
    categoryList.add(await DatabaseCategoryHelper.instance
        .insertCategory(category: newCategory));

    notifyListeners();
  }

  Future<bool> deleteCategory(Category category) async {
    final removedCategoryCount = await DatabaseCategoryHelper.instance
        .deleteCategory(category: category);

    if (removedCategoryCount > 0) {
      categoryList.removeWhere((element) => element.id == category.id);

      notifyListeners();

      return true;
    }

    return false;
  }
}
