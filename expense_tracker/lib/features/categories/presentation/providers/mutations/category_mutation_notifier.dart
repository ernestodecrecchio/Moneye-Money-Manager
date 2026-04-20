import 'package:expense_tracker/features/categories/presentation/providers/categories_repository_provider.dart';
import 'package:expense_tracker/features/categories/presentation/providers/queries/categories_list_notifier.dart';
import 'package:expense_tracker/features/categories/domain/models/category.dart';
import 'package:expense_tracker/features/categories/domain/repositories/categories_repository.dart';
import 'package:expense_tracker/features/transactions/presentation/providers/transactions_repository_provider.dart';
import 'package:expense_tracker/features/transactions/presentation/providers/queries/transactions_list_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoryMutationNotifier extends AsyncNotifier<void> {
  CategoriesRepository get _repo => ref.read(categoriesRepositoryProvider);

  @override
  Future<void> build() async {}

  Future<Category?> addCategory(Category category) async {
    state = const AsyncLoading();

    Category? newCategory;
    state = await AsyncValue.guard(() async {
      newCategory = await _repo.insertCategory(category: category);
      ref.invalidate(categoriesListProvider);
    });

    return newCategory;
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

  Future<void> deleteCategoryAndTransactions(Category category) async {
    final transactionsRepo = ref.read(transactionsRepositoryProvider);

    await transactionsRepo.deleteTransactionsByCategory(category: category);
    await _repo.deleteCategory(category: category);

    ref.invalidate(categoriesListProvider);
    ref.invalidate(transactionsListProvider);
  }

  Future<void> reassignTransactionsAndDelete({
    required Category source,
    required Category target,
  }) async {
    final transactionsRepo = ref.read(transactionsRepositoryProvider);

    await transactionsRepo.transferTransactions(from: source, to: target);
    await _repo.deleteCategory(category: source);

    ref.invalidate(categoriesListProvider);
    ref.invalidate(transactionsListProvider);
  }
}

final categoryMutationProvider =
    AsyncNotifierProvider<CategoryMutationNotifier, void>(
  CategoryMutationNotifier.new,
);
