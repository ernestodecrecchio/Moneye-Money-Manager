import 'package:expense_tracker/Helper/database_helper.dart';
import 'package:expense_tracker/models/category.dart';
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
    const integerType = 'INTEGER NOT NULL';

    await db.execute('''
    CREATE TABLE $tableTransactions (
      ${TransactionFields.id} $idType,
      ${TransactionFields.title} $textType,
      ${TransactionFields.value} $realType,
      ${TransactionFields.date} $dateTimeType,
      ${TransactionFields.categoryId} $integerType,
      FOREIGN KEY (${TransactionFields.categoryId}) REFERENCES $tableCategories (${CategoryFields.id}) ON DELETE NO ACTION ON UPDATE NO ACTION
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

  Future<List<trans.Transaction>> getTransactionsForDate(
      {required DateTime date}) async {
    final db = await DatabaseHelper.instance.database;

    const orderBy = '${TransactionFields.date} ASC';

    /*final result = await db.rawQuery('''
      SELECT t._id, title, value, date, categoryId, c.name  AS  'categoryName', c.colorValue AS 'categoryColor'
      FROM transactions AS t
      INNER JOIN categories AS  c ON t.categoryId =  c._id
      WHERE date(${TransactionFields.date}) = date(?)
      ORDER BY ${TransactionFields.date} ASC
    ''', [date.toIso8601String()]);*/

    final result = await db.query(tableTransactions,
        orderBy: orderBy,
        where: 'date(${TransactionFields.date}) = date(?)',
        whereArgs: [date.toIso8601String()]);

    return result.map((json) => trans.Transaction.fromJson(json)).toList();
  }
}
