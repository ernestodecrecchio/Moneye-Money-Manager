import 'package:expense_tracker/data/database/database_helper.dart';
import 'package:expense_tracker/data/database/database_types.dart';
import 'package:expense_tracker/domain/models/account.dart';
import 'package:expense_tracker/domain/models/category.dart';
import 'package:expense_tracker/domain/models/transaction.dart';
import 'package:expense_tracker/domain/models/transaction.dart' as trans;
import 'package:expense_tracker/helper/date_time_helper.dart';
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

  Future<List<trans.Transaction>> getLatestTransactions(int limit) async {
    final dbInstance = await DatabaseHelper.instance.database;

    const orderBy = '${TransactionFields.date} DESC';

    final result = await dbInstance.query(
      transactionsTable,
      where: '${TransactionFields.isHidden} = 0',
      limit: limit,
      orderBy: orderBy,
    );
    return result.map((json) => trans.Transaction.fromJson(json)).toList();
  }

  Future<double> getTotalBalance(
    DateTime? startDate,
    DateTime? endDate,
    Account? forAccount,
  ) async {
    final dbInstance = await DatabaseHelper.instance.database;

    String query = '''
      SELECT SUM(${TransactionFields.amount}) AS total_balance
      FROM $transactionsTable
      WHERE ${TransactionFields.isHidden} = 0
    ''';

    // Dynamic WHERE arguments
    List<dynamic> args = [];

    // Optional: filter start date
    if (startDate != null) {
      query += ' AND ${TransactionFields.date} >= ?';
      args.add(formatDate(startDate));
    }

    // Optional: filter end date
    if (endDate != null) {
      query += ' AND ${TransactionFields.date} <= ?';
      args.add(formatDate(endDate));
    }

    // Optional: filter by account
    if (forAccount != null) {
      query += ' AND ${TransactionFields.accountId} = ?';
      args.add(forAccount.id);
    }

    // Execute query
    final result = await dbInstance.rawQuery(query, args);

    // sqflite returns: [{ "total_balance": 123.45 }] OR [{ "total_balance": null }]
    final value = result.first['total_balance'];
    return (value is num) ? value.toDouble() : 0.0;
  }

  Future<List<trans.Transaction>> getTransactions(
    DateTime? startDate,
    DateTime? endDate,
    Account? forAccount,
    int? limit,
  ) async {
    final dbInstance = await DatabaseHelper.instance.database;

    // Dynamic WHERE arguments
    String whereClause = '${TransactionFields.isHidden} = 0';

    List<dynamic> args = [];

    // Optional: filter start date
    if (startDate != null) {
      whereClause += ' AND ${TransactionFields.date} >= ?';
      args.add(formatDate(startDate));
    }

    // Optional: filter end date
    if (endDate != null) {
      whereClause += ' AND ${TransactionFields.date} <= ?';
      args.add(formatDate(endDate));
    }

    // Optional: filter by account
    if (forAccount != null) {
      whereClause += ' AND ${TransactionFields.accountId} = ?';
      args.add(forAccount.id);
    }

    const orderBy = '${TransactionFields.date} DESC';

    final result = await dbInstance.query(
      transactionsTable,
      where: whereClause,
      whereArgs: args,
      limit: limit,
      orderBy: orderBy,
    );

    return result.map((json) => trans.Transaction.fromJson(json)).toList();
  }

  /*Future<Map<int, double>> getMonthlyBalanceForYear(int year) async {
    final dbInstance = await DatabaseHelper.instance.database;

    String query = '''
    SELECT STRFTIME('%m', ${TransactionFields.date}) AS month, SUM(${TransactionFields.amount}) AS total
    FROM $transactionsTable
    WHERE STRFTIME('%Y', ${TransactionFields.date}) = ?
    GROUP BY month
    ORDER BY month
    ''';

    final results = await dbInstance.rawQuery(query, [year.toString()]);

    // Always return a map with all 12 months
    final Map<int, double> monthlyTotals = {
      for (int m = 1; m <= 12; m++) m: 0.0,
    };

    for (final row in results) {
      final monthString = row['month'] as String; // "01", "02", ...
      final month = int.parse(monthString);

      final value = row['total'];
      monthlyTotals[month] = (value is num) ? value.toDouble() : 0.0;
    }

    return monthlyTotals;
  }*/
}
