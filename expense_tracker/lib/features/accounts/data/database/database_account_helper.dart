import 'package:expense_tracker/features/accounts/domain/models/account_with_balance.dart';
import 'package:expense_tracker/core/database/database_helper.dart';
import 'package:expense_tracker/core/database/database_types.dart';
import 'package:expense_tracker/features/accounts/domain/models/account.dart';
import 'package:expense_tracker/features/transactions/data/database/database_transaction_helper.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqlite_api.dart';

const String accountsTable = 'accounts';

class AccountFields {
  static final List<String> values = [
    id,
    name,
    description,
    colorValue,
    iconPath,
    rebalanceOffset,
  ];

  static const String id = '_id';
  static const String name = 'name';
  static const String description = 'description';
  static const String colorValue = 'colorValue';
  static const String iconPath = 'iconPath';
  static const String rebalanceOffset = 'rebalance_offset';
}

class AccountMapper {
  static Account fromJson(Map<String, Object?> json) => Account(
        id: json[AccountFields.id] as int?,
        name: json[AccountFields.name] as String,
        description: json[AccountFields.description] as String?,
        colorValue: json[AccountFields.colorValue] as int?,
        iconPath: json[AccountFields.iconPath] as String?,
        rebalanceOffset:
            (json[AccountFields.rebalanceOffset] as num?)?.toDouble() ?? 0.0,
      );

  static Map<String, Object?> toJson(Account account) => {
        AccountFields.id: account.id,
        AccountFields.name: account.name,
        AccountFields.description: account.description,
        AccountFields.colorValue: account.colorValue,
        AccountFields.iconPath: account.iconPath,
        AccountFields.rebalanceOffset: account.rebalanceOffset,
      };
}

class DatabaseAccountHelper {
  static const int otherAccountId = -1;

  static final DatabaseAccountHelper instance = DatabaseAccountHelper._init();
  DatabaseAccountHelper._init();

  static Future inizializeTable(Database db) async {
    await db.execute('''
      CREATE TABLE $accountsTable ( 
      ${AccountFields.id} ${DatabaseTypes.idType}, 
      ${AccountFields.name} ${DatabaseTypes.textType},
      ${AccountFields.description} ${DatabaseTypes.textTypeNullable},
      ${AccountFields.colorValue} ${DatabaseTypes.integerTypeNullable},
      ${AccountFields.iconPath} ${DatabaseTypes.textTypeNullable},
      ${AccountFields.rebalanceOffset} ${DatabaseTypes.realType} DEFAULT 0
      )
    ''');
  }

  static void updateAccountsTableV4toV5(Batch batch) {
    batch.execute('''
      ALTER TABLE $accountsTable
      ADD COLUMN ${AccountFields.rebalanceOffset} ${DatabaseTypes.realType} DEFAULT 0
    ''');
  }

  Future<Account> insertAccount({required Account account}) async {
    final db = await DatabaseHelper.instance.database;

    final id = await db.insert(accountsTable, AccountMapper.toJson(account));

    return account.copy(id: id);
  }

  Future<bool> updateAccount(
      {required Account accountToEdit,
      required Account modifiedAccount}) async {
    final db = await DatabaseHelper.instance.database;

    if (await db.update(accountsTable, AccountMapper.toJson(modifiedAccount),
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
    return result.map((json) => AccountMapper.fromJson(json)).toList();
  }

  Future<List<AccountWithBalance>> getAllAccountsWithBalance(
      {String? otherAccountName}) async {
    final dbInstance = await DatabaseHelper.instance.database;

    final query = '''
    SELECT a.${AccountFields.id} AS id,
           a.${AccountFields.name} AS name,
           a.${AccountFields.colorValue} AS color,
           a.${AccountFields.iconPath} AS iconPath,
           COALESCE(SUM(t.${TransactionFields.amount}), 0.0)
             + COALESCE(a.${AccountFields.rebalanceOffset}, 0.0) AS balance
    FROM $accountsTable a
    LEFT JOIN $transactionsTable t
    ON a.${AccountFields.id} = t.${TransactionFields.accountId}
    GROUP BY a.${AccountFields.id}
    
    UNION ALL
    
    SELECT $otherAccountId AS id, 
           '${otherAccountName ?? 'No account'}' AS name,
            ${Colors.grey.toARGB32()} AS color,
            'assets/icons/box.svg' AS iconPath,
            COALESCE(SUM(${TransactionFields.amount}), 0.0) AS balance
    FROM $transactionsTable
    WHERE ${TransactionFields.accountId} IS NULL
    ''';

    final result = await dbInstance.rawQuery(query);

    final list = <AccountWithBalance>[];

    for (final row in result) {
      final account = Account(
        id: row['id'] as int?,
        name: row['name'] as String,
        colorValue: row['color'] as int?,
        iconPath: row['iconPath'] as String?,
        isOtherAccount: row['id'] == otherAccountId,
      );

      final balance = (row['balance'] as num).toDouble();

      if (account.id == otherAccountId && balance == 0) continue;

      list.add(
        AccountWithBalance(
          account: account,
          balance: balance,
        ),
      );
    }

    return list;
  }

  Future<Account?> getAccountFromId(int id) async {
    final db = await DatabaseHelper.instance.database;

    final result = await db.query(accountsTable,
        where: '${AccountFields.id} = ?', whereArgs: [id]);

    if (result.isNotEmpty) {
      return AccountMapper.fromJson(result.first);
    }

    return null;
  }

  Future<double> getTotalRebalanceOffset() async {
    final db = await DatabaseHelper.instance.database;

    final result = await db.rawQuery('''
      SELECT COALESCE(SUM(${AccountFields.rebalanceOffset}), 0.0) AS total
      FROM $accountsTable
    ''');

    final value = result.first['total'];
    return (value is num) ? value.toDouble() : 0.0;
  }

  Future<double> getRebalanceOffset(int accountId) async {
    final account = await getAccountFromId(accountId);
    return account?.rebalanceOffset ?? 0.0;
  }

  Future<bool> updateRebalanceOffset({
    required int accountId,
    required double rebalanceOffset,
  }) async {
    final db = await DatabaseHelper.instance.database;

    final updated = await db.update(
      accountsTable,
      {AccountFields.rebalanceOffset: rebalanceOffset},
      where: '${AccountFields.id} = ?',
      whereArgs: [accountId],
    );

    return updated > 0;
  }
}
