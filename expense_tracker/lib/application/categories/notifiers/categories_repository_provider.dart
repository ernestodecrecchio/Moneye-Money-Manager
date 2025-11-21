import 'package:expense_tracker/data/repositories/categories_repository_impl.dart';
import 'package:expense_tracker/domain/repositories/categories_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final categoriesRepositoryProvider = Provider<CategoriesRepository>((ref) {
  return CategoriesRepositoryImpl();
});
