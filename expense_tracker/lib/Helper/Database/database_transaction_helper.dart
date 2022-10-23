import 'package:expense_tracker/Helper/Database/database_helper.dart';
import 'package:expense_tracker/Helper/Database/database_populate.dart';
import 'package:expense_tracker/models/account.dart';
import 'package:expense_tracker/models/category.dart';
import 'package:expense_tracker/models/transaction.dart';

import 'package:expense_tracker/models/transaction.dart' as trans;
import 'package:intl/intl.dart';
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
    const integerType = 'INTEGER';

    await db.execute('''
    CREATE TABLE $transactionsTable (
      ${TransactionFields.id} $idType,
      ${TransactionFields.title} $textType,
      ${TransactionFields.value} $realType,
      ${TransactionFields.date} $dateTimeType,
      ${TransactionFields.categoryId} $integerType,
      ${TransactionFields.accountId} $integerType,
      FOREIGN KEY (${TransactionFields.categoryId}) REFERENCES $categoriesTable (${CategoryFields.id}) ON DELETE SET NULL ON UPDATE NO ACTION,
      FOREIGN KEY (${TransactionFields.accountId}) REFERENCES $accountsTable (${AccountFields.id}) ON DELETE SET NULL ON UPDATE NO ACTION
      )
    ''');

    await DatabasePopulate.addData(db);
  }

  Future<trans.Transaction> insertTransaction(
      {required trans.Transaction transaction}) async {
    final db = await DatabaseHelper.instance.database;

    final id = await db.insert(transactionsTable, transaction.toJson());

    return transaction.copy(id: id);
  }

  Future<int> deleteTransaction(
      {required trans.Transaction transaction}) async {
    final db = await DatabaseHelper.instance.database;

    return db.delete(
      transactionsTable,
      where: '${TransactionFields.id} = ?',
      whereArgs: [transaction.id],
    );
  }

  Future<trans.Transaction> getTransactionFromId(int id) async {
    final db = await DatabaseHelper.instance.database;

    final maps = await db.query(
      transactionsTable,
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

  Future<List<trans.Transaction>> getAllTransactions() async {
    final db = await DatabaseHelper.instance.database;

    const orderBy = '${TransactionFields.date} ASC';

    final result = await db.query(transactionsTable, orderBy: orderBy);
    return result.map((json) => trans.Transaction.fromJson(json)).toList();
  }

  Future<Map<String, Object?>> getBalanceBetweenDates(
      {required DateTime startDate, required DateTime endDate}) async {
    final db = await DatabaseHelper.instance.database;

    final result = await db.rawQuery('''
      SELECT 
				SUM(CASE WHEN ${TransactionFields.value} >= 0 THEN value END ) AS income, 
				SUM(CASE WHEN ${TransactionFields.value} < 0  THEN value END ) AS expense
      FROM $transactionsTable
      WHERE ${TransactionFields.date} BETWEEN date(?, 'localtime') AND date(?, 'localtime')
      ''', [
      DateFormat('yyyy-MM-dd').format(startDate).toString(),
      DateFormat('yyyy-MM-dd').format(endDate).toString(),
    ]);

    return result.first;
  }

  Future<List<trans.Transaction>> getTransactionsBetweenDates(
      {required DateTime startDate, required DateTime endDate}) async {
    final db = await DatabaseHelper.instance.database;

    const orderBy = '${TransactionFields.date} ASC';

    final result = await db.query(transactionsTable,
        orderBy: orderBy,
        where:
            "${TransactionFields.date} BETWEEN date(?, 'localtime') AND date(?, 'localtime')",
        whereArgs: [
          DateFormat('yyyy-MM-dd').format(startDate).toString(),
          DateFormat('yyyy-MM-dd').format(endDate).toString(),
        ]);

    return result.map((json) => trans.Transaction.fromJson(json)).toList();
  }

  Future<List<trans.Transaction>> getLastTransactions(int limit) async {
    final db = await DatabaseHelper.instance.database;

    const orderBy = '${TransactionFields.date} ASC';

    final result =
        await db.query(transactionsTable, orderBy: orderBy, limit: limit);
    return result.map((json) => trans.Transaction.fromJson(json)).toList();
  }

  /*
    Returns a map formatted like: 
    [
      {
        'month': 01,
        'balance': 1234.0
      }
    ]
  */
  Future<List<Map<String, dynamic>>> getMonthlyBalanceForYear(int year) async {
    final db = await DatabaseHelper.instance.database;

    final result = await db.rawQuery('''
        SELECT strftime('%m', ${TransactionFields.date} ) as 'month', coalesce(SUM(${TransactionFields.value}),0) as 'balance'
        FROM transactions
        GROUP BY strftime('%m', ${TransactionFields.date} )
    ''');

    return result;
  }
}
