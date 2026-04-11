import 'package:expense_tracker/features/accounts/data/database/database_account_helper.dart';
import 'package:expense_tracker/features/accounts/domain/models/account.dart';
import 'package:expense_tracker/core/database/database_helper.dart';
import 'package:expense_tracker/core/database/database_types.dart';
import 'package:expense_tracker/features/recurring_rules/data/database/database_recurring_rule_helper.dart';
import 'package:expense_tracker/features/transactions/domain/models/transaction.dart' as trans;
import 'package:expense_tracker/core/utils/date_time_helper.dart';
import 'package:expense_tracker/features/categories/data/database/database_category_helper.dart';
import 'package:expense_tracker/features/categories/domain/models/category.dart';
import 'package:sqflite/sqlite_api.dart';

const String transactionsTable = 'transactions';

class TransactionFields {
  static final List<String> values = [
    id,
    title,
    description,
    amount,
    date,
    categoryId,
    accountId,
    includeInReports,
    isHidden,
    recurringId,
    originalDate,
  ];

  static const String id = '_id'; // Default id column
  static const String title = 'title';
  static const String description = 'description';
  static const String amount = 'amount';
  static const String date = 'date';
  static const String categoryId = 'categoryId';
  static const String accountId = 'accountId';
  static const String includeInReports = 'includeInReports';
  static const String isHidden = 'isHidden';
  static const String recurringId = 'recurringId';

  static const String originalDate = 'originalDate';
}

class TransactionMapper {
  static trans.Transaction fromJson(Map<String, Object?> json) => trans.Transaction(
        id: json[TransactionFields.id] as int?,
        title: json[TransactionFields.title] as String,
        description: json[TransactionFields.description] as String?,
        amount: (json[TransactionFields.amount] as num).toDouble(),
        date: DateTime.parse(json[TransactionFields.date] as String),
        categoryId: json[TransactionFields.categoryId] as int?,
        accountId: json[TransactionFields.accountId] as int?,
        includeInReports: (json[TransactionFields.includeInReports] as int) == 1,
        isHidden: (json[TransactionFields.isHidden] as int) == 1,
        recurringId: json[TransactionFields.recurringId]?.toString(),
        originalDate: json[TransactionFields.originalDate] != null
            ? DateTime.parse(json[TransactionFields.originalDate] as String)
            : null,
      );

  static Map<String, Object?> toJson(trans.Transaction transaction) => {
        TransactionFields.id: transaction.id,
        TransactionFields.title: transaction.title,
        TransactionFields.description: transaction.description,
        TransactionFields.amount: transaction.amount,
        TransactionFields.date: transaction.date.toIso8601String(),
        TransactionFields.categoryId: transaction.categoryId,
        TransactionFields.accountId: transaction.accountId,
        TransactionFields.includeInReports: transaction.includeInReports ? 1 : 0,
        TransactionFields.isHidden: transaction.isHidden ? 1 : 0,
        TransactionFields.recurringId: transaction.recurringId,
        if (transaction.originalDate != null)
          TransactionFields.originalDate: transaction.originalDate!.toIso8601String(),
      };
}

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
      ${TransactionFields.date} ${DatabaseTypes.textType},
      ${TransactionFields.categoryId} ${DatabaseTypes.integerTypeNullable},
      ${TransactionFields.accountId} ${DatabaseTypes.integerTypeNullable},
      ${TransactionFields.includeInReports} ${DatabaseTypes.integerType} DEFAULT 1,
      ${TransactionFields.isHidden} ${DatabaseTypes.integerType} DEFAULT 0,
      ${TransactionFields.recurringId} ${DatabaseTypes.textTypeNullable},

      ${TransactionFields.originalDate} ${DatabaseTypes.textTypeNullable},
      FOREIGN KEY (${TransactionFields.categoryId}) REFERENCES $categoriesTable (${CategoryFields.id}) ON DELETE SET NULL ON UPDATE NO ACTION,
      FOREIGN KEY (${TransactionFields.accountId}) REFERENCES $accountsTable (${AccountFields.id}) ON DELETE CASCADE ON UPDATE NO ACTION
      )
    ''');

    await db.execute(
        'CREATE UNIQUE INDEX idx_recurring_unique ON $transactionsTable(${TransactionFields.recurringId}, ${TransactionFields.originalDate})');
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

  static void updateTransactionTableV2toV3(Batch batch) {
    batch.execute('''
    CREATE TABLE transactions_migration (
      ${TransactionFields.id} ${DatabaseTypes.idType},
      ${TransactionFields.title} ${DatabaseTypes.textType},
      ${TransactionFields.description} ${DatabaseTypes.textTypeNullable},
      ${TransactionFields.amount} ${DatabaseTypes.realType},
      ${TransactionFields.date} ${DatabaseTypes.textType},
      ${TransactionFields.categoryId} ${DatabaseTypes.integerTypeNullable},
      ${TransactionFields.accountId} ${DatabaseTypes.integerTypeNullable},
      ${TransactionFields.includeInReports} ${DatabaseTypes.integerType} DEFAULT 1,
      ${TransactionFields.isHidden} ${DatabaseTypes.integerType} DEFAULT 0,
      ${TransactionFields.recurringId} ${DatabaseTypes.textTypeNullable},

      ${TransactionFields.originalDate} ${DatabaseTypes.textTypeNullable},
      FOREIGN KEY (${TransactionFields.categoryId}) REFERENCES $categoriesTable (${CategoryFields.id}) ON DELETE SET NULL ON UPDATE NO ACTION,
      FOREIGN KEY (${TransactionFields.accountId}) REFERENCES $accountsTable (${AccountFields.id}) ON DELETE CASCADE ON UPDATE NO ACTION
      )
    ''');

    batch.execute('''
    INSERT INTO transactions_migration (
      ${TransactionFields.id}, 
      ${TransactionFields.title}, 
      ${TransactionFields.description}, 
      ${TransactionFields.amount},
      ${TransactionFields.date}, 
      ${TransactionFields.categoryId},
       ${TransactionFields.accountId},
      ${TransactionFields.includeInReports}, 
      ${TransactionFields.isHidden}
    )
    SELECT 
      ${TransactionFields.id}, 
      ${TransactionFields.title}, 
      ${TransactionFields.description}, 
      ${TransactionFields.amount},
      ${TransactionFields.date}, 
      ${TransactionFields.categoryId}, 
      ${TransactionFields.accountId},
      ${TransactionFields.includeInReports}, 
      ${TransactionFields.isHidden}
    FROM $transactionsTable
    ''');

    batch.execute('DROP TABLE $transactionsTable');

    batch.execute(
        'ALTER TABLE transactions_migration RENAME TO $transactionsTable');

    batch.execute(
        'CREATE UNIQUE INDEX idx_recurring_unique ON $transactionsTable(${TransactionFields.recurringId}, ${TransactionFields.originalDate})');
  }

  Future<int> generateRecurringTransactionsUntil(DateTime targetDate) async {
    final db = await DatabaseHelper.instance.database;
    int generatedCount = 0;

    final rules =
        await DatabaseRecurringRuleHelper.instance.getRecurringRules();

    for (final rule in rules) {
      bool generatedAny = false;
      DateTime? lastGeneratedDate;

      for (final occurrenceDate
          in rule.generateOccurrences(until: targetDate)) {
        final transaction = trans.Transaction(
          title: rule.title,
          description: rule.description,
          amount: rule.amount,
          date: occurrenceDate,
          categoryId: rule.categoryId,
          accountId: rule.accountId,
          includeInReports: rule.includeInReports,
          isHidden: rule.isHidden,
          recurringId: rule.id,
          originalDate: occurrenceDate,
        );

        try {
          await db.insert(transactionsTable, TransactionMapper.toJson(transaction));
          generatedCount++;
        } on DatabaseException catch (e) {
          if (!e.isUniqueConstraintError()) rethrow;
        }

        generatedAny = true;
        lastGeneratedDate = occurrenceDate;
      }

      if (generatedAny && lastGeneratedDate != null) {
        final updatedRule = rule.copy(lastGeneratedDate: lastGeneratedDate);
        await DatabaseRecurringRuleHelper.instance
            .updateRecurringRule(original: rule, modified: updatedRule);
      }
    }

    return generatedCount;
  }

  Future<trans.Transaction> insertTransaction(
      {required trans.Transaction transaction}) async {
    final db = await DatabaseHelper.instance.database;

    final id = await db.insert(transactionsTable, TransactionMapper.toJson(transaction));

    return transaction.copy(id: id);
  }

  Future<bool> updateTransaction(
      {required trans.Transaction transactionToEdit,
      required trans.Transaction modifiedTransaction}) async {
    final db = await DatabaseHelper.instance.database;

    final values = TransactionMapper.toJson(modifiedTransaction);
    values.remove(TransactionFields.id); // Remove id from values to avoid error while updating the transaction avoiding to update the id

    if (await db.update(transactionsTable, values,
            where: '${TransactionFields.id} = ?',
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
      return TransactionMapper.fromJson(maps.first);
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
        where: "date(${TransactionFields.date}) BETWEEN ? AND ?",
        whereArgs: [
          formatDate(startDate),
          formatDate(endDate),
        ]);

    return result.map((json) => TransactionMapper.fromJson(json)).toList();
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
    return result.map((json) => TransactionMapper.fromJson(json)).toList();
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
      query += ' AND date(${TransactionFields.date}) >= ?';
      args.add(formatDate(startDate));
    }

    // Optional: filter end date
    if (endDate != null) {
      query += ' AND date(${TransactionFields.date}) <= ?';
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
    Category? forCategory,
    bool? includeIncomes, // null = default = true
    bool? includeExpenses, // null = default = true
    int? limit,
    String? recurringId,
  ) async {
    final dbInstance = await DatabaseHelper.instance.database;

    // Defaults
    final incIncome = includeIncomes ?? true;
    final incExpense = includeExpenses ?? true;

    // Collect conditions
    final List<String> conditions = ['${TransactionFields.isHidden} = 0'];
    final List<dynamic> args = [];

    // Date filters
    if (startDate != null) {
      conditions.add('date(${TransactionFields.date}) >= ?');
      args.add(formatDate(startDate));
    }

    if (endDate != null) {
      conditions.add('date(${TransactionFields.date}) <= ?');
      args.add(formatDate(endDate));
    }

    // Account filter
    if (forAccount?.isOtherAccount == true) {
      conditions.add('${TransactionFields.accountId} IS NULL');
    } else if (forAccount != null) {
      conditions.add('${TransactionFields.accountId} = ?');
      args.add(forAccount.id);
    }

    // Category filter
    if (forCategory?.isOtherCategory == true) {
      conditions.add('${TransactionFields.categoryId} IS NULL');
    } else if (forCategory != null) {
      conditions.add('${TransactionFields.categoryId} = ?');
      args.add(forCategory.id);
    }

    if (recurringId != null) {
      conditions.add('${TransactionFields.recurringId} = ?');
      args.add(recurringId);
    }

    // Income/Expense filtering
    if (incIncome != incExpense) {
      conditions.add(
        incIncome
            ? '${TransactionFields.amount} >= 0'
            : '${TransactionFields.amount} < 0',
      );
    }

    final whereClause = conditions.join(' AND ');

    const orderBy = '${TransactionFields.date} DESC';

    final result = await dbInstance.query(
      transactionsTable,
      where: whereClause,
      whereArgs: args,
      limit: limit,
      orderBy: orderBy,
    );

    return result.map((json) => TransactionMapper.fromJson(json)).toList();
  }
}
