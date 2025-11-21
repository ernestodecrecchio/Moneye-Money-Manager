import 'package:expense_tracker/application/categories/notifiers/categories_repository_provider.dart';
import 'package:expense_tracker/domain/models/category.dart';
import 'package:expense_tracker/domain/repositories/categories_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoryMutationNotifier extends Notifier<void> {
  CategoriesRepository get _repo => ref.read(categoriesRepositoryProvider);

  @override
  void build() {
    return;
  }

  Future<Category> add(Category category) async {
    final inserted = await _repo.insertCategory(category: category);

    return inserted;
  }

  Future<void> update(Category original, Category modified) async {
    await _repo.updateCategory(
      categoryToEdit: original,
      editedCategory: modified,
    );
  }

  Future<void> delete(Category category) async {
    await _repo.deleteCategory(category: category);
  }
}

final accountMutationProvider =
    NotifierProvider<CategoryMutationNotifier, void>(
  CategoryMutationNotifier.new,
);
