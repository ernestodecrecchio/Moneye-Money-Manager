import 'package:expense_tracker/Helper/database_helper.dart';
import 'package:expense_tracker/models/account.dart';
import 'package:sqflite/sqlite_api.dart';

class DatabaseAccountHelper {
  static final DatabaseAccountHelper instance = DatabaseAccountHelper._init();
  DatabaseAccountHelper._init();

  static Future inizializeTable(Database db) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';

    await db.execute('''
      CREATE TABLE $tableAccounts ( 
      ${AccountFields.id} $idType, 
      ${AccountFields.name} $textType
      )
    ''');

    final accountCash = Account(name: 'Contanti');

    await db.insert(tableAccounts, accountCash.toJson());
  }

  Future<Account> insertAccount({required Account account}) async {
    final db = await DatabaseHelper.instance.database;

    final id = await db.insert(tableAccounts, account.toJson());

    return account.copy(id: id);
  }

  Future<int> deleteAccount({required Account account}) async {
    final db = await DatabaseHelper.instance.database;

    return db.delete(
      tableAccounts,
      where: '${AccountFields.id} = ?',
      whereArgs: [account.id],
    );
  }

  Future<List<Account>> readAllAccounts() async {
    final db = await DatabaseHelper.instance.database;

    const orderBy = '${AccountFields.name} ASC';

    final result = await db.query(tableAccounts, orderBy: orderBy);
    return result.map((json) => Account.fromJson(json)).toList();
  }
}
