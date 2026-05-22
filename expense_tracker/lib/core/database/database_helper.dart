import 'package:expense_tracker/features/accounts/data/database/database_account_helper.dart';
import 'package:expense_tracker/features/categories/data/database/database_category_helper.dart';
import 'package:expense_tracker/features/transactions/data/database/database_transaction_helper.dart';
import 'package:expense_tracker/features/recurring_rules/data/database/database_recurring_rule_helper.dart';
import 'package:expense_tracker/features/budgeting/data/database/database_budget_helper.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  DatabaseHelper._init();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'moneye_db.db');

    return await openDatabase(path,
        version: 4,
        onConfigure: _configureDB,
        onCreate: _createDB,
        onUpgrade: _upgradeDB);
  }

  Future _configureDB(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future _createDB(Database db, int version) async {
    await DatabaseCategoryHelper.inizializeTable(db);
    await DatabaseAccountHelper.inizializeTable(db);
    await DatabaseTransactionHelper.inizializeTable(db);
    await DatabaseRecurringRuleHelper.inizializeTable(db);
    await DatabaseBudgetHelper.initializeTable(db);
  }

  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    var batch = db.batch();

    if (oldVersion < 2) {
      _updateDBV1toV2(batch);
    }
    if (oldVersion < 3) {
      _updateDBV2toV3(batch);
    }
    if (oldVersion < 4) {
      _updateDBV3toV4(batch);
    }
    await batch.commit();
  }

  void _updateDBV1toV2(Batch batch) {
    DatabaseTransactionHelper.updateTransactionTableV1toV2(batch);
  }

  void _updateDBV2toV3(Batch batch) {
    DatabaseRecurringRuleHelper.createTableV2toV3(batch);
    DatabaseTransactionHelper.updateTransactionTableV2toV3(batch);
  }

  void _updateDBV3toV4(Batch batch) {
    DatabaseBudgetHelper.createTableV3toV4(batch);
  }
}
