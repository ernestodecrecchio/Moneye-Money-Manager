import 'package:expense_tracker/features/transaction_shortcuts/domain/models/transaction_shortcut.dart';
import 'package:expense_tracker/features/transaction_shortcuts/domain/repositories/transaction_shortcuts_repository.dart';
import 'package:expense_tracker/features/transaction_shortcuts/presentation/providers/queries/transaction_shortcuts_list_notifier.dart';
import 'package:expense_tracker/features/transaction_shortcuts/presentation/providers/transaction_shortcuts_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransactionShortcutsMutationNotifier extends AsyncNotifier<void> {
  TransactionShortcutsRepository get _repo =>
      ref.read(transactionShortcutsRepositoryProvider);

  @override
  Future<void> build() async {}

  Future<TransactionShortcut?> addTransactionShortcut(
    TransactionShortcut shortcut,
  ) async {
    TransactionShortcut? inserted;
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      inserted = await _repo.insertTransactionShortcut(shortcut: shortcut);
      ref.invalidate(transactionShortcutsListProvider);
    });

    return inserted;
  }

  Future<void> updateTransactionShortcut(
    TransactionShortcut original,
    TransactionShortcut modified,
  ) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      await _repo.updateTransactionShortcut(
        original: original,
        modified: modified,
      );
      ref.invalidate(transactionShortcutsListProvider);
    });
  }

  Future<void> deleteTransactionShortcut(
    TransactionShortcut shortcut,
  ) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final removedCount =
          await _repo.deleteTransactionShortcut(shortcut: shortcut);

      if (removedCount > 0) {
        ref.invalidate(transactionShortcutsListProvider);
      }
    });
  }
}

final transactionShortcutsMutationProvider =
    AsyncNotifierProvider<TransactionShortcutsMutationNotifier, void>(
  TransactionShortcutsMutationNotifier.new,
);
