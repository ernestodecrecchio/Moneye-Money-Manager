import 'package:expense_tracker/data/database/database_category_helper.dart';
import 'package:expense_tracker/domain/models/category.dart';
import 'package:expense_tracker/domain/repositories/categories_repository.dart';

class CategoriesRepositoryImpl implements CategoriesRepository {
  final dbHelper = DatabaseCategoryHelper.instance;

  @override
  Future<Category> insertCategory({required Category category}) {
    return dbHelper.insertCategory(category: category);
  }

  @override
  Future<bool> updateCategory({
    required Category categoryToEdit,
    required Category editedCategory,
  }) {
    return dbHelper.updateCategory(
      categoryToEdit: categoryToEdit,
      modifiedCategory: editedCategory,
    );
  }

  @override
  Future<int> deleteCategory({required Category category}) {
    return dbHelper.deleteCategory(category: category);
  }
}
