import 'package:expense_tracker/features/budgeting/presentation/providers/queries/budget_progress_notifier.dart';
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
    Category? inserted;

    state = await AsyncValue.guard(() async {
      inserted = await _repo.insertCategory(category: category);
      ref.invalidate(categoriesListProvider);
    });

    return inserted;
  }

  Future<void> updateCategory(Category original, Category modified) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await _repo.updateCategory(
        categoryToEdit: original,
        editedCategory: modified,
      );

      ref.invalidate(categoriesListProvider);
    });
  }

  Future<void> deleteCategory(Category category) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await _repo.deleteCategory(category: category);
      ref.invalidate(categoriesListProvider);
    });
  }

  Future<void> deleteCategoryAndTransactions(Category category) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final transactionsRepo = ref.read(transactionsRepositoryProvider);

      await transactionsRepo.deleteTransactionsByCategory(category: category);
      await _repo.deleteCategory(category: category);

      ref.invalidate(categoriesListProvider);
      ref.invalidate(transactionsListProvider);
      ref.invalidate(budgetProgressProvider);
    });
  }

  Future<void> reassignTransactionsAndDelete({
    required Category source,
    required Category target,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final transactionsRepo = ref.read(transactionsRepositoryProvider);

      await transactionsRepo.transferTransactions(from: source, to: target);
      await _repo.deleteCategory(category: source);

      ref.invalidate(categoriesListProvider);
      ref.invalidate(transactionsListProvider);
      ref.invalidate(budgetProgressProvider);
    });
  }
}

final categoryMutationProvider =
    AsyncNotifierProvider<CategoryMutationNotifier, void>(
  CategoryMutationNotifier.new,
);
