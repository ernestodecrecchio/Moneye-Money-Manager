import 'package:expense_tracker/Helper/database_category_helper.dart';
import 'package:expense_tracker/models/transaction.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDB('myDb2.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const boolType = 'BOOLEAN NOT NULL';
    const integerType = 'INTEGER NOT NULL';
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

    await DatabaseCategoryHelper.inizializeTable(db);
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
