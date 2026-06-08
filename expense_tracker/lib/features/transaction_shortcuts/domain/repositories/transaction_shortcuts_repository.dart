import 'package:expense_tracker/features/transaction_shortcuts/domain/models/transaction_shortcut.dart';

abstract class TransactionShortcutsRepository {
  Future<List<TransactionShortcut>> getTransactionShortcuts();
  Future<TransactionShortcut> insertTransactionShortcut({
    required TransactionShortcut shortcut,
  });
  Future<bool> updateTransactionShortcut({
    required TransactionShortcut original,
    required TransactionShortcut modified,
  });
  Future<int> deleteTransactionShortcut({
    required TransactionShortcut shortcut,
  });
}
