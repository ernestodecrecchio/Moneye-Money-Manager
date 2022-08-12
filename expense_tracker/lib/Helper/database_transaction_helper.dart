import 'package:expense_tracker/Helper/database_helper.dart';
import 'package:expense_tracker/models/transaction.dart';

import 'package:expense_tracker/models/transaction.dart' as trans;
import 'package:sqflite/sqlite_api.dart';

class DatabaseTransactionHelper {
  static final DatabaseTransactionHelper instance =
      DatabaseTransactionHelper._init();
  DatabaseTransactionHelper._init();

  static Future inizializeTable(Database db) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const realType = 'REAL NOT NULL';
    const dateTimeType = 'DATETIME NOT NULL';

    await db.execute('''
    CREATE TABLE $tableTransactions (
      ${TransactionFields.id} $idType,
      ${TransactionFields.title} $textType,
      ${TransactionFields.value} $realType,
      ${TransactionFields.date} $dateTimeType
      )
    ''');
  }

  Future<trans.Transaction> insertTransaction(
      {required trans.Transaction transaction}) async {
    final db = await DatabaseHelper.instance.database;

    final id = await db.insert(tableTransactions, transaction.toJson());

    return transaction.copy(id: id);
  }

  Future<trans.Transaction> readTransaction(int id) async {
    final db = await DatabaseHelper.instance.database;

    final maps = await db.query(
      tableTransactions,
      columns: TransactionFields.values,
      where: '${TransactionFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return trans.Transaction.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<trans.Transaction>> readAllTransactions() async {
    final db = await DatabaseHelper.instance.database;

    const orderBy = '${TransactionFields.date} ASC';

    final result = await db.query(tableTransactions, orderBy: orderBy);
    return result.map((json) => trans.Transaction.fromJson(json)).toList();
  }
}
