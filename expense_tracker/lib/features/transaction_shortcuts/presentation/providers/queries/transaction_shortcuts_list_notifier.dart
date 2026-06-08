import 'package:expense_tracker/features/transaction_shortcuts/domain/models/transaction_shortcut.dart';
import 'package:expense_tracker/features/transaction_shortcuts/presentation/providers/transaction_shortcuts_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransactionShortcutsListNotifier
    extends AsyncNotifier<List<TransactionShortcut>> {
  @override
  Future<List<TransactionShortcut>> build() async {
    return ref
        .read(transactionShortcutsRepositoryProvider)
        .getTransactionShortcuts();
  }
}

final transactionShortcutsListProvider = AsyncNotifierProvider<
    TransactionShortcutsListNotifier, List<TransactionShortcut>>(
  TransactionShortcutsListNotifier.new,
);
