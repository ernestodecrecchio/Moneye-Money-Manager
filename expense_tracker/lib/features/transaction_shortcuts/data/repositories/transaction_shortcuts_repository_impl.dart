import 'package:expense_tracker/features/transaction_shortcuts/data/database/database_transaction_shortcut_helper.dart';
import 'package:expense_tracker/features/transaction_shortcuts/domain/models/transaction_shortcut.dart';
import 'package:expense_tracker/features/transaction_shortcuts/domain/repositories/transaction_shortcuts_repository.dart';

class TransactionShortcutsRepositoryImpl
    implements TransactionShortcutsRepository {
  final dbHelper = DatabaseTransactionShortcutHelper.instance;

  @override
  Future<List<TransactionShortcut>> getTransactionShortcuts() async {
    return dbHelper.getAllTransactionShortcuts();
  }

  @override
  Future<TransactionShortcut> insertTransactionShortcut({
    required TransactionShortcut shortcut,
  }) async {
    return dbHelper.insertTransactionShortcut(shortcut: shortcut);
  }

  @override
  Future<bool> updateTransactionShortcut({
    required TransactionShortcut original,
    required TransactionShortcut modified,
  }) async {
    return dbHelper.updateTransactionShortcut(
      original: original,
      modified: modified,
    );
  }

  @override
  Future<int> deleteTransactionShortcut({
    required TransactionShortcut shortcut,
  }) async {
    return dbHelper.deleteTransactionShortcut(shortcut: shortcut);
  }
}
