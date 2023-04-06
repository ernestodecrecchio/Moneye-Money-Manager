import 'package:expense_tracker/Helper/Database/database_helper.dart';
import 'package:expense_tracker/models/account.dart';
import 'package:expense_tracker/models/transaction.dart';
import 'package:sqflite/sqlite_api.dart';

class DatabaseAccountHelper {
  static final DatabaseAccountHelper instance = DatabaseAccountHelper._init();
  DatabaseAccountHelper._init();

  static Future inizializeTable(Database db) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const integerType = 'INTEGER NOT NULL';

    await db.execute('''
      CREATE TABLE $accountsTable ( 
      ${AccountFields.id} $idType, 
      ${AccountFields.name} $textType,
      ${AccountFields.colorValue} $integerType,
      ${AccountFields.iconPath} $textType
      )
    ''');
  }

  Future<Account> insertAccount({required Account account}) async {
    final db = await DatabaseHelper.instance.database;

    final id = await db.insert(accountsTable, account.toJson());

    return account.copy(id: id);
  }

  Future<bool> updateAccount(
      {required Account accountToEdit,
      required Account modifiedAccount}) async {
    final db = await DatabaseHelper.instance.database;

    if (await db.update(accountsTable, modifiedAccount.toJson(),
            where: '${AccountFields.id} = ?', whereArgs: [accountToEdit.id]) >
        0) {
      return true;
    }

    return false;
  }

  Future<int> deleteAccount({required Account account}) async {
    final db = await DatabaseHelper.instance.database;

    return db.delete(
      accountsTable,
      where: '${AccountFields.id} = ?',
      whereArgs: [account.id],
    );
  }

  Future<List<Account>> getAllAccounts() async {
    final db = await DatabaseHelper.instance.database;

    const orderBy = '${AccountFields.name} ASC';

    final result = await db.query(accountsTable, orderBy: orderBy);
    return result.map((json) => Account.fromJson(json)).toList();
  }

  Future<List<Map<String, dynamic>>> getAllAccountsWithBalance() async {
    final db = await DatabaseHelper.instance.database;

    final result = await db.rawQuery('''
      SELECT a.${AccountFields.id}, a.${AccountFields.name}, COALESCE(SUM(${TransactionFields.value}), 0.0) AS balance
      FROM $accountsTable a LEFT JOIN $transactionsTable t ON  a.${AccountFields.id} = t.${TransactionFields.accountId}
      GROUP BY a.${AccountFields.id}''');

    List<Map<String, dynamic>> resultList = [];
    for (var resultEntry in result) {
      final account = Account.fromJson(resultEntry);

      resultList.add({
        'account': account,
        'balance': resultEntry['balance'],
      });
    }

    return resultList;
  }

  Future<Account?> getAccountFromId(int id) async {
    final db = await DatabaseHelper.instance.database;

    final result = await db.query(accountsTable,
        where: '${AccountFields.id} = ?', whereArgs: [id]);

    if (result.isNotEmpty) {
      return Account.fromJson(result.first);
    }

    return null;
  }
}
