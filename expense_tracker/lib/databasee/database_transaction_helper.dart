import 'package:expense_tracker/Database/database_helper.dart';
import 'package:expense_tracker/Database/database_types.dart';
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
    await db.execute('''
    CREATE TABLE $transactionsTable (
      ${TransactionFields.id} ${DatabaseTypes.idType},
      ${TransactionFields.title} ${DatabaseTypes.textType},
      ${TransactionFields.description} ${DatabaseTypes.textTypeNullable},
      ${TransactionFields.amount} ${DatabaseTypes.realType},
      ${TransactionFields.date} ${DatabaseTypes.dateTimeType},
      ${TransactionFields.categoryId} ${DatabaseTypes.integerTypeNullable},
      ${TransactionFields.accountId} ${DatabaseTypes.integerTypeNullable},
      ${TransactionFields.includeInReports} ${DatabaseTypes.integerType} DEFAULT 1,
      ${TransactionFields.isHidden} ${DatabaseTypes.integerType} DEFAULT 0,
      FOREIGN KEY (${TransactionFields.categoryId}) REFERENCES $categoriesTable (${CategoryFields.id}) ON DELETE SET NULL ON UPDATE NO ACTION,
      FOREIGN KEY (${TransactionFields.accountId}) REFERENCES $accountsTable (${AccountFields.id}) ON DELETE CASCADE ON UPDATE NO ACTION
      )
    ''');
  }

  // Update DB functions
  static void updateTransactionTableV1toV2(Batch batch) {
    batch.execute(
        '''ALTER TABLE $transactionsTable RENAME value TO ${TransactionFields.amount}''');
    batch.execute(
        '''ALTER TABLE $transactionsTable ADD ${TransactionFields.includeInReports} ${DatabaseTypes.integerType} DEFAULT 1''');
    batch.execute(
        '''ALTER TABLE $transactionsTable ADD ${TransactionFields.isHidden} ${DatabaseTypes.integerType} DEFAULT 0''');
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
