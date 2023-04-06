import 'package:collection/collection.dart';
import 'package:expense_tracker/Helper/Database/database_category_helper.dart';
import 'package:expense_tracker/models/category.dart';
import 'package:expense_tracker/models/transaction.dart';
import 'package:flutter/material.dart';

class CategoryProvider with ChangeNotifier {
  List<Category> categoryList = [];

  CategoryProvider() {
    // getAllCategories();
  }

  Future getAllCategories() async {
    categoryList = await DatabaseCategoryHelper.instance.readAllCategories();

    notifyListeners();
  }

  Category? getCategoryForTransaction(Transaction transaction) {
    return categoryList
        .firstWhereOrNull((element) => element.id == transaction.categoryId);
  }

  Future addNewCategory({
    required String name,
    required int colorValue,
    required String iconPath,
  }) async {
    final newCategory = Category(
      name: name,
      colorValue: colorValue,
      iconPath: iconPath,
    );

    categoryList.add(await DatabaseCategoryHelper.instance
        .insertCategory(category: newCategory));

    notifyListeners();
  }

  /// Deletes the category without affecting the transactions viewed in the current session
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

  Future<Category?> getCategoryFromId(int id) async {
    return await DatabaseCategoryHelper.instance.getCategoryFromId(id);
  }
}
