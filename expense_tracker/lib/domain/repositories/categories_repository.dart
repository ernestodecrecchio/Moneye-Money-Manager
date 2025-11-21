import 'package:expense_tracker/domain/models/category.dart';

abstract class CategoriesRepository {
  Future<Category> insertCategory({required Category category});
  Future<bool> updateCategory({
    required Category categoryToEdit,
    required Category editedCategory,
  });
  Future<int> deleteCategory({required Category category});

  Future<List<Category>> getCategories();
  Future<Category?> getCategoryById({required int id});
}
