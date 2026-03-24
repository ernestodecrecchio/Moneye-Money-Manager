import 'package:expense_tracker/data/database/database_helper.dart';
import 'package:expense_tracker/data/database/database_types.dart';
import 'package:expense_tracker/domain/models/account.dart';
import 'package:expense_tracker/domain/models/category.dart';
import 'package:expense_tracker/domain/models/recurring_rule.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:uuid/uuid.dart';

class DatabaseRecurringRuleHelper {
  static final DatabaseRecurringRuleHelper instance =
      DatabaseRecurringRuleHelper._init();
  DatabaseRecurringRuleHelper._init();

  static Future inizializeTable(Database db) async {
    await db.execute('''
    CREATE TABLE $recurringRulesTable (
      ${RecurringRuleFields.id} ${DatabaseTypes.textIdType},
      ${RecurringRuleFields.title} ${DatabaseTypes.textType},
      ${RecurringRuleFields.description} ${DatabaseTypes.textTypeNullable},
      ${RecurringRuleFields.amount} ${DatabaseTypes.realType},
      ${RecurringRuleFields.categoryId} ${DatabaseTypes.integerTypeNullable},
      ${RecurringRuleFields.accountId} ${DatabaseTypes.integerTypeNullable},
      ${RecurringRuleFields.includeInReports} ${DatabaseTypes.integerType} DEFAULT 1,
      ${RecurringRuleFields.isHidden} ${DatabaseTypes.integerType} DEFAULT 0,
      ${RecurringRuleFields.isEnabled} ${DatabaseTypes.integerType} DEFAULT 1,
      ${RecurringRuleFields.frequency} ${DatabaseTypes.textType},
      ${RecurringRuleFields.frequencyInterval} ${DatabaseTypes.integerType},
      ${RecurringRuleFields.startDate} ${DatabaseTypes.textType},
      ${RecurringRuleFields.endDate} ${DatabaseTypes.textTypeNullable},
      ${RecurringRuleFields.lastGeneratedDate} ${DatabaseTypes.textTypeNullable},
      FOREIGN KEY (${RecurringRuleFields.categoryId}) REFERENCES $categoriesTable (${CategoryFields.id}) ON DELETE SET NULL ON UPDATE NO ACTION,
      FOREIGN KEY (${RecurringRuleFields.accountId}) REFERENCES $accountsTable (${AccountFields.id}) ON DELETE CASCADE ON UPDATE NO ACTION
    )
    ''');
  }

  static void createTableV2toV3(Batch batch) {
    batch.execute('''
    CREATE TABLE $recurringRulesTable (
      ${RecurringRuleFields.id} ${DatabaseTypes.textIdType},
      ${RecurringRuleFields.title} ${DatabaseTypes.textType},
      ${RecurringRuleFields.description} ${DatabaseTypes.textTypeNullable},
      ${RecurringRuleFields.amount} ${DatabaseTypes.realType},
      ${RecurringRuleFields.categoryId} ${DatabaseTypes.integerTypeNullable},
      ${RecurringRuleFields.accountId} ${DatabaseTypes.integerTypeNullable},
      ${RecurringRuleFields.includeInReports} ${DatabaseTypes.integerType} DEFAULT 1,
      ${RecurringRuleFields.isHidden} ${DatabaseTypes.integerType} DEFAULT 0,
      ${RecurringRuleFields.isEnabled} ${DatabaseTypes.integerType} DEFAULT 1,
      ${RecurringRuleFields.frequency} ${DatabaseTypes.textType},
      ${RecurringRuleFields.frequencyInterval} ${DatabaseTypes.integerType},
      ${RecurringRuleFields.startDate} ${DatabaseTypes.textType},
      ${RecurringRuleFields.endDate} ${DatabaseTypes.textTypeNullable},
      ${RecurringRuleFields.lastGeneratedDate} ${DatabaseTypes.textTypeNullable},
      FOREIGN KEY (${RecurringRuleFields.categoryId}) REFERENCES $categoriesTable (${CategoryFields.id}) ON DELETE SET NULL ON UPDATE NO ACTION,
      FOREIGN KEY (${RecurringRuleFields.accountId}) REFERENCES $accountsTable (${AccountFields.id}) ON DELETE CASCADE ON UPDATE NO ACTION
    )
    ''');
  }

  Future<List<RecurringRule>> getRecurringRules() async {
    final db = await DatabaseHelper.instance.database;
    final result = await db.query(recurringRulesTable);
    return result.map((json) => RecurringRule.fromJson(json)).toList();
  }

  Future<RecurringRule> insertRecurringRule({
    required RecurringRule rule,
  }) async {
    final db = await DatabaseHelper.instance.database;

    rule.id ??= const Uuid().v4();
    await db.insert(recurringRulesTable, rule.toJson());

    return rule;
  }

  Future<bool> updateRecurringRule({
    required RecurringRule original,
    required RecurringRule modified,
  }) async {
    final db = await DatabaseHelper.instance.database;
    final values = modified.toJson();
    values.remove(RecurringRuleFields
        .id); // Remove id from values to avoid error while updating the recurring rule avoiding to update the id

    if (await db.update(recurringRulesTable, values,
            where: '${RecurringRuleFields.id} = ?', whereArgs: [original.id]) >
        0) {
      return true;
    }
    return false;
  }

  Future<int> deleteRecurringRule({required RecurringRule rule}) async {
    final db = await DatabaseHelper.instance.database;

    return await db.delete(
      recurringRulesTable,
      where: '${RecurringRuleFields.id} = ?',
      whereArgs: [rule.id],
    );
  }
}
