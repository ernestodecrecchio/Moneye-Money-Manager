import 'package:expense_tracker/application/categories/notifiers/categories_repository_provider.dart';
import 'package:expense_tracker/application/categories/notifiers/queries/categories_list_notifier.dart';
import 'package:expense_tracker/domain/models/category.dart';
import 'package:expense_tracker/domain/repositories/categories_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoryMutationNotifier extends AsyncNotifier<void> {
  CategoriesRepository get _repo => ref.read(categoriesRepositoryProvider);

  @override
  Future<void> build() async {}

  Future<void> addCategory(Category category) async {
    state = AsyncLoading();

    state = await AsyncValue.guard(() async {
      await _repo.insertCategory(category: category);
      ref.invalidate(categoriesListProvider);
    });
  }

  Future<void> updateCategory(Category original, Category modified) async {
    await _repo.updateCategory(
      categoryToEdit: original,
      editedCategory: modified,
    );
    ref.invalidate(categoriesListProvider);
  }

  Future<void> deleteCategory(Category category) async {
    await _repo.deleteCategory(category: category);
    ref.invalidate(categoriesListProvider);
  }
}

final categoryMutationProvider =
    AsyncNotifierProvider<CategoryMutationNotifier, void>(
  CategoryMutationNotifier.new,
);
