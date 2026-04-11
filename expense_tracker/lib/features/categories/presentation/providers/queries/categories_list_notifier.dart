import 'package:expense_tracker/features/categories/presentation/providers/categories_repository_provider.dart';
import 'package:expense_tracker/features/categories/domain/models/category.dart';
import 'package:expense_tracker/features/categories/domain/repositories/categories_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoriesListNotifier extends AsyncNotifier<List<Category>> {
  CategoriesRepository get _repo => ref.read(categoriesRepositoryProvider);

  @override
  Future<List<Category>> build() async {
    return _repo.getCategories();
  }

  void refresh() async {
    ref.invalidateSelf();
  }
}

final categoriesListProvider =
    AsyncNotifierProvider<CategoriesListNotifier, List<Category>>(
  CategoriesListNotifier.new,
);
