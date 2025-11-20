import 'package:expense_tracker/application/accounts/models/account_with_balance.dart';
import 'package:expense_tracker/data/database/database_helper.dart';
import 'package:expense_tracker/data/database/database_types.dart';
import 'package:expense_tracker/domain/models/account.dart';
import 'package:expense_tracker/domain/models/transaction.dart';
import 'package:sqflite/sqlite_api.dart';

class DatabaseAccountHelper {
  static final DatabaseAccountHelper instance = DatabaseAccountHelper._init();
  DatabaseAccountHelper._init();

  static Future inizializeTable(Database db) async {
    await db.execute('''
      CREATE TABLE $accountsTable ( 
      ${AccountFields.id} ${DatabaseTypes.idType}, 
      ${AccountFields.name} ${DatabaseTypes.textType},
      ${AccountFields.description} ${DatabaseTypes.textTypeNullable},
      ${AccountFields.colorValue} ${DatabaseTypes.integerTypeNullable},
      ${AccountFields.iconPath} ${DatabaseTypes.textTypeNullable}
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
    final dbInstance = await DatabaseHelper.instance.database;

    const orderBy = '${AccountFields.name} ASC';

    final result = await dbInstance.query(accountsTable, orderBy: orderBy);
    return result.map((json) => Account.fromJson(json)).toList();
  }

  Future<List<AccountWithBalance>> getAllAccountsWithBalance() async {
    final dbInstance = await DatabaseHelper.instance.database;

    final query = '''
    SELECT a.${AccountFields.id} AS id,
           a.${AccountFields.name} AS name,
           COALESCE(SUM(t.${TransactionFields.amount}), 0.0) AS balance
    FROM $accountsTable a
    LEFT JOIN $transactionsTable t
    ON a.${AccountFields.id} = t.${TransactionFields.accountId}
    GROUP BY a.${AccountFields.id}
    
    UNION ALL
    
    SELECT -1 AS id, 
           'No account' AS name,
            COALESCE(SUM(${TransactionFields.amount}), 0.0) AS balance
    FROM $transactionsTable
    WHERE ${TransactionFields.accountId} IS NULL
    ''';

    final result = await dbInstance.rawQuery(query);

    return result.map((row) {
      final account = Account(
        id: row['id'] as int,
        name: row['name'] as String,
      );

      return AccountWithBalance(
        account: account,
        balance: (row['balance'] as num).toDouble(),
      );
    }).toList();
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
