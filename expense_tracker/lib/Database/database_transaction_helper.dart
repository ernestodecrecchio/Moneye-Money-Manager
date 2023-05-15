import 'package:expense_tracker/Database/database_helper.dart';
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
    const textTypeNullable = 'TEXT';
    const realType = 'REAL NOT NULL';
    const dateTimeType = 'DATETIME NOT NULL';
    const integerType = 'INTEGER';

    await db.execute('''
    CREATE TABLE $transactionsTable (
      ${TransactionFields.id} $idType,
      ${TransactionFields.title} $textType,
      ${TransactionFields.description} $textTypeNullable,
      ${TransactionFields.value} $realType,
      ${TransactionFields.date} $dateTimeType,
      ${TransactionFields.categoryId} $integerType,
      ${TransactionFields.accountId} $integerType,
      FOREIGN KEY (${TransactionFields.categoryId}) REFERENCES $categoriesTable (${CategoryFields.id}) ON DELETE SET NULL ON UPDATE NO ACTION,
      FOREIGN KEY (${TransactionFields.accountId}) REFERENCES $accountsTable (${AccountFields.id}) ON DELETE SET NULL ON UPDATE NO ACTION
      )
    ''');

    await insertDemoData(db);
  }

  static Future insertDemoData(Database db) async {
    final t1 = trans.Transaction(
      id: 1,
      title: 'Gas for car',
      value: -20,
      date: DateTime(2023, 5, 1),
      categoryId: 5,
      accountId: 1,
    );
    final t2 = trans.Transaction(
      id: 2,
      title: 'Balance',
      value: 500,
      date: DateTime(2023, 3, 1),
      accountId: 1,
    );
    final t3 = trans.Transaction(
      id: 3,
      title: 'Balance',
      value: 500,
      date: DateTime(2023, 3, 1),
      accountId: 3,
    );
    final t4 = trans.Transaction(
      id: 4,
      title: 'Movie tickets',
      value: -15,
      date: DateTime(2023, 5, 4),
      categoryId: 7,
      accountId: 3,
    );
    final t5 = trans.Transaction(
      id: 5,
      title: 'Electricity bill',
      value: -75,
      date: DateTime(2023, 5, 7),
      categoryId: 1,
      accountId: 3,
    );
    final t6 = trans.Transaction(
      id: 6,
      title: 'Gift for Mike',
      value: -50,
      date: DateTime(2023, 5, 2),
      categoryId: 2,
      accountId: 3,
    );
    final t7 = trans.Transaction(
      id: 7,
      title: 'Rome trip',
      value: -100,
      date: DateTime(2023, 5, 13),
      categoryId: 3,
      accountId: 3,
    );

    await db.insert(transactionsTable, t1.toJson());
    await db.insert(transactionsTable, t2.toJson());
    await db.insert(transactionsTable, t3.toJson());
    await db.insert(transactionsTable, t4.toJson());
    await db.insert(transactionsTable, t5.toJson());
    await db.insert(transactionsTable, t6.toJson());
    await db.insert(transactionsTable, t7.toJson());
  }

  Future<trans.Transaction> insertTransaction(
      {required trans.Transaction transaction}) async {
    final db = await DatabaseHelper.instance.database;

    final id = await db.insert(transactionsTable, transaction.toJson());

    return transaction.copy(id: id);
  }

  Future<bool> updateTransaction(
      {required trans.Transaction transactionToEdit,
      required trans.Transaction modifiedTransaction}) async {
    final db = await DatabaseHelper.instance.database;

    if (await db.update(transactionsTable, modifiedTransaction.toJson(),
            where: '${trans.TransactionFields.id} = ?',
            whereArgs: [transactionToEdit.id]) >
        0) {
      return true;
    }

    return false;
  }

  /// Returns the number of the row deleted
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
}
