import 'package:expense_tracker/core/database/database_helper.dart';
import 'package:expense_tracker/core/database/database_types.dart';
import 'package:expense_tracker/features/transaction_shortcuts/domain/models/transaction_shortcut.dart';
import 'package:sqflite/sqflite.dart';

const String transactionShortcutsTable = 'transaction_shortcuts';

class TransactionShortcutFields {
  static final List<String> values = [
    id,
    title,
    description,
    amount,
    categoryId,
    accountId,
    includeInReports,
  ];

  static const String id = '_id';
  static const String title = 'title';
  static const String description = 'description';
  static const String amount = 'amount';
  static const String categoryId = 'categoryId';
  static const String accountId = 'accountId';
  static const String includeInReports = 'includeInReports';
}

class TransactionShortcutMapper {
  static TransactionShortcut fromJson(Map<String, Object?> json) =>
      TransactionShortcut(
        id: json[TransactionShortcutFields.id] as int?,
        title: json[TransactionShortcutFields.title] as String,
        description: json[TransactionShortcutFields.description] as String?,
        amount: (json[TransactionShortcutFields.amount] as num).toDouble(),
        categoryId: json[TransactionShortcutFields.categoryId] as int?,
        accountId: json[TransactionShortcutFields.accountId] as int?,
        includeInReports:
            (json[TransactionShortcutFields.includeInReports] as int) == 1,
      );

  static Map<String, Object?> toJson(TransactionShortcut shortcut) => {
        TransactionShortcutFields.id: shortcut.id,
        TransactionShortcutFields.title: shortcut.title,
        TransactionShortcutFields.description: shortcut.description,
        TransactionShortcutFields.amount: shortcut.amount,
        TransactionShortcutFields.categoryId: shortcut.categoryId,
        TransactionShortcutFields.accountId: shortcut.accountId,
        TransactionShortcutFields.includeInReports:
            shortcut.includeInReports ? 1 : 0,
      };
}

class DatabaseTransactionShortcutHelper {
  static final DatabaseTransactionShortcutHelper instance =
      DatabaseTransactionShortcutHelper._init();
  DatabaseTransactionShortcutHelper._init();

  static Future inizializeTable(Database db) async {
    await db.execute('''
    CREATE TABLE $transactionShortcutsTable (
      ${TransactionShortcutFields.id} ${DatabaseTypes.idType},
      ${TransactionShortcutFields.title} ${DatabaseTypes.textType},
      ${TransactionShortcutFields.description} ${DatabaseTypes.textTypeNullable},
      ${TransactionShortcutFields.amount} ${DatabaseTypes.realType},
      ${TransactionShortcutFields.categoryId} ${DatabaseTypes.integerTypeNullable},
      ${TransactionShortcutFields.accountId} ${DatabaseTypes.integerTypeNullable},
      ${TransactionShortcutFields.includeInReports} ${DatabaseTypes.integerType} DEFAULT 1
    )
    ''');
  }

  static void createTableV6toV7(Batch batch) {
    batch.execute('''
    CREATE TABLE $transactionShortcutsTable (
      ${TransactionShortcutFields.id} ${DatabaseTypes.idType},
      ${TransactionShortcutFields.title} ${DatabaseTypes.textType},
      ${TransactionShortcutFields.description} ${DatabaseTypes.textTypeNullable},
      ${TransactionShortcutFields.amount} ${DatabaseTypes.realType},
      ${TransactionShortcutFields.categoryId} ${DatabaseTypes.integerTypeNullable},
      ${TransactionShortcutFields.accountId} ${DatabaseTypes.integerTypeNullable},
      ${TransactionShortcutFields.includeInReports} ${DatabaseTypes.integerType} DEFAULT 1
    )
    ''');
  }

  Future<List<TransactionShortcut>> getAllTransactionShortcuts() async {
    final db = await DatabaseHelper.instance.database;
    final result = await db.query(
      transactionShortcutsTable,
      orderBy: '${TransactionShortcutFields.title} COLLATE NOCASE ASC',
    );
    return result.map((json) => TransactionShortcutMapper.fromJson(json)).toList();
  }

  Future<TransactionShortcut> insertTransactionShortcut({
    required TransactionShortcut shortcut,
  }) async {
    final db = await DatabaseHelper.instance.database;
    final id = await db.insert(
      transactionShortcutsTable,
      TransactionShortcutMapper.toJson(shortcut),
    );
    return shortcut.copy(id: id);
  }

  Future<bool> updateTransactionShortcut({
    required TransactionShortcut original,
    required TransactionShortcut modified,
  }) async {
    final db = await DatabaseHelper.instance.database;
    final values = TransactionShortcutMapper.toJson(modified);
    values.remove(TransactionShortcutFields.id);

    return await db.update(
          transactionShortcutsTable,
          values,
          where: '${TransactionShortcutFields.id} = ?',
          whereArgs: [original.id],
        ) >
        0;
  }

  Future<int> deleteTransactionShortcut({
    required TransactionShortcut shortcut,
  }) async {
    final db = await DatabaseHelper.instance.database;
    return db.delete(
      transactionShortcutsTable,
      where: '${TransactionShortcutFields.id} = ?',
      whereArgs: [shortcut.id],
    );
  }
}
