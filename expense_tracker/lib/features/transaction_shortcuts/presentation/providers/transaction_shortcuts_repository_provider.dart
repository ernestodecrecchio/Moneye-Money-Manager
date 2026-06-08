import 'package:expense_tracker/features/transaction_shortcuts/data/repositories/transaction_shortcuts_repository_impl.dart';
import 'package:expense_tracker/features/transaction_shortcuts/domain/repositories/transaction_shortcuts_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final transactionShortcutsRepositoryProvider =
    Provider<TransactionShortcutsRepository>((ref) {
  return TransactionShortcutsRepositoryImpl();
});
