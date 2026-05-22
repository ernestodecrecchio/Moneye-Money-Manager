import 'package:expense_tracker/features/budgeting/data/repositories/budgets_repository_impl.dart';
import 'package:expense_tracker/features/budgeting/domain/repositories/budgets_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final budgetsRepositoryProvider = Provider<BudgetsRepository>((ref) {
  return BudgetsRepositoryImpl();
});
