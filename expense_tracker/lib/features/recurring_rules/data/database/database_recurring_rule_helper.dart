import 'package:expense_tracker/features/accounts/data/database/database_account_helper.dart';
import 'package:expense_tracker/features/categories/data/database/database_category_helper.dart';
import 'package:expense_tracker/core/database/database_helper.dart';
import 'package:expense_tracker/core/database/database_types.dart';
import 'package:expense_tracker/features/recurring_rules/domain/models/recurring_rule.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:uuid/uuid.dart';

const String recurringRulesTable = 'recurring_rules';

class RecurringRuleFields {
  static final List<String> values = [
    id,
    title,
    description,
    amount,
    categoryId,
    accountId,
    includeInReports,
    isHidden,
    frequency,
    frequencyInterval,
    startDate,
    endDate,
    lastGeneratedDate,
    isEnabled,
  ];

  static const String id = '_id';
  static const String title = 'title';
  static const String description = 'description';
  static const String amount = 'amount';
  static const String categoryId = 'categoryId';
  static const String accountId = 'accountId';
  static const String includeInReports = 'includeInReports';
  static const String isHidden = 'isHidden';
  static const String frequency = 'frequency';
  static const String frequencyInterval = 'frequencyInterval';
  static const String startDate = 'startDate';
  static const String endDate = 'endDate';
  static const String lastGeneratedDate = 'lastGeneratedDate';
  static const String isEnabled = 'isEnabled';
}

class RecurringRuleMapper {
  static RecurringRule fromJson(Map<String, Object?> json) => RecurringRule(
        id: json[RecurringRuleFields.id]?.toString(),
        title: json[RecurringRuleFields.title] as String,
        description: json[RecurringRuleFields.description] as String?,
        amount: (json[RecurringRuleFields.amount] as num).toDouble(),
        categoryId: json[RecurringRuleFields.categoryId] as int?,
        accountId: json[RecurringRuleFields.accountId] as int?,
        includeInReports:
            (json[RecurringRuleFields.includeInReports] as int) == 1,
        isHidden: (json[RecurringRuleFields.isHidden] as int) == 1,
        frequency: json[RecurringRuleFields.frequency] as String,
        frequencyInterval: json[RecurringRuleFields.frequencyInterval] as int,
        startDate:
            DateTime.parse(json[RecurringRuleFields.startDate] as String),
        endDate: json[RecurringRuleFields.endDate] != null
            ? DateTime.parse(json[RecurringRuleFields.endDate] as String)
            : null,
        lastGeneratedDate: json[RecurringRuleFields.lastGeneratedDate] != null
            ? DateTime.parse(
                json[RecurringRuleFields.lastGeneratedDate] as String)
            : null,
        isEnabled: json[RecurringRuleFields.isEnabled] == null
            ? true
            : (json[RecurringRuleFields.isEnabled] as int) == 1,
      );

  static Map<String, Object?> toJson(RecurringRule rule) => {
        RecurringRuleFields.id: rule.id,
        RecurringRuleFields.title: rule.title,
        RecurringRuleFields.description: rule.description,
        RecurringRuleFields.amount: rule.amount,
        RecurringRuleFields.categoryId: rule.categoryId,
        RecurringRuleFields.accountId: rule.accountId,
        RecurringRuleFields.includeInReports: rule.includeInReports ? 1 : 0,
        RecurringRuleFields.isHidden: rule.isHidden ? 1 : 0,
        RecurringRuleFields.frequency: rule.frequency,
        RecurringRuleFields.frequencyInterval: rule.frequencyInterval,
        RecurringRuleFields.startDate: rule.startDate.toIso8601String(),
        if (rule.endDate != null)
          RecurringRuleFields.endDate: rule.endDate!.toIso8601String(),
        if (rule.lastGeneratedDate != null)
          RecurringRuleFields.lastGeneratedDate:
              rule.lastGeneratedDate!.toIso8601String(),
        RecurringRuleFields.isEnabled: rule.isEnabled ? 1 : 0,
      };
}

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
    return result.map((json) => RecurringRuleMapper.fromJson(json)).toList();
  }

  Future<RecurringRule> insertRecurringRule({
    required RecurringRule rule,
  }) async {
    final db = await DatabaseHelper.instance.database;

    final id = rule.id ?? const Uuid().v4();
    final ruleWithId = rule.copy(id: id);
    await db.insert(recurringRulesTable, RecurringRuleMapper.toJson(ruleWithId));

    return ruleWithId;
  }

  Future<bool> updateRecurringRule({
    required RecurringRule original,
    required RecurringRule modified,
  }) async {
    final db = await DatabaseHelper.instance.database;
    final values = RecurringRuleMapper.toJson(modified);
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
