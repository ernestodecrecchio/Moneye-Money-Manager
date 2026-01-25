import 'package:collection/collection.dart';
import 'package:expense_tracker/data/database/database_category_helper.dart';
import 'package:expense_tracker/domain/models/category.dart';
import 'package:expense_tracker/domain/models/transaction.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Legacy notifier responsible for managing the list of transaction categories.
class CategoryNotifier extends Notifier<List<Category>> {
  @override
  List<Category> build() {
    return [];
  }

  /// Returns the [Category] associated with a given [Transaction].
  Category? getCategoryForTransaction(Transaction transaction) {
    return state
        .firstWhereOrNull((element) => element.id == transaction.categoryId);
  }

  /// Creates and persists a new category based on parameters.
  Future addNewCategoryByParameters({
    required String name,
    String? description,
    required int? colorValue,
    required String? iconPath,
  }) async {
    final newCategory = Category(
      name: name,
      description: description,
      colorValue: colorValue,
      iconPath: iconPath,
    );

    final addedCategory = await DatabaseCategoryHelper.instance
        .insertCategory(category: newCategory);

    state = [...state, addedCategory];
  }

  /// Persists a new [Category] instance and updates state.
  Future addNewCategory({required Category category}) async {
    final addedCategory = await DatabaseCategoryHelper.instance
        .insertCategory(category: category);

    state = [...state, addedCategory];
  }

  /// Updates an existing category's properties.
  Future updateCategory({
    required Category categoryToEdit,
    required String name,
    String? description,
    required int? colorValue,
    required String? iconPath,
  }) async {
    final modifiedCategory = Category(
      id: categoryToEdit.id,
      name: name,
      description: description,
      colorValue: colorValue,
      iconPath: iconPath,
    );

    if (await DatabaseCategoryHelper.instance.updateCategory(
        categoryToEdit: categoryToEdit, modifiedCategory: modifiedCategory)) {
      final categoryIndexToModify =
          state.indexWhere((element) => element.id == categoryToEdit.id);

      if (categoryIndexToModify != -1) {
        final tempList = List<Category>.of(state);
        tempList[categoryIndexToModify] = modifiedCategory;

        state = tempList;
      }
    }
  }

  /// Deletes a category and removes it from the current state.
  Future<bool> deleteCategory(Category category) async {
    final removedCategoryCount = await DatabaseCategoryHelper.instance
        .deleteCategory(category: category);

    if (removedCategoryCount > 0) {
      final tempList = List<Category>.of(state);
      tempList.removeWhere((element) => element.id == category.id);

      state = tempList;

      return true;
    }

    return false;
  }

  /// Finds a [Category] by its ID in the current state.
  Category? getCategoryFromId(int id) {
    return state.firstWhereOrNull((element) => element.id == id);
  }
}

/// Provider for the [CategoryNotifier], managing transaction categories.
final categoryProvider = NotifierProvider<CategoryNotifier, List<Category>>(() {
  return CategoryNotifier();
});
