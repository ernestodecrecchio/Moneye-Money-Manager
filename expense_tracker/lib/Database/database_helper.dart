import 'package:expense_tracker/Database/database_account_helper.dart';
import 'package:expense_tracker/Database/database_category_helper.dart';
import 'package:expense_tracker/Database/database_transaction_helper.dart';
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
        version: 2,
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
  }

  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    var batch = db.batch();

    if (oldVersion == 1) {
      _updateDBV1toV2(batch);
      await batch.commit();
    }
  }

  _updateDBV1toV2(Batch batch) {
    DatabaseTransactionHelper.updateTransactionTableV1toV2(batch);
  }
}
