import 'package:expense_tracker/core/database/database_helper.dart';
import 'package:expense_tracker/core/database/database_types.dart';
import 'package:expense_tracker/features/budgeting/domain/models/budget.dart';
import 'package:expense_tracker/features/categories/data/database/database_category_helper.dart';
import 'package:sqflite/sqlite_api.dart';

const String budgetsTable = 'budgets';
const String budgetCategoriesTable = 'budget_categories';

class BudgetFields {
  static final List<String> values = [
    id,
    name,
    amount,
    periodType,
    startDay,
    startWeekday,
    customStartDate,
    customEndDate,
    rolloverMode,
    rolloverAmount,
    periodStart,
    createdAt,
    updatedAt,
  ];

  static const String id = '_id';
  static const String name = 'name';
  static const String amount = 'amount';
  static const String periodType = 'periodType';
  static const String startDay = 'startDay';
  static const String startWeekday = 'startWeekday';
  static const String customStartDate = 'customStartDate';
  static const String customEndDate = 'customEndDate';
  static const String rolloverMode = 'rolloverMode';
  static const String rolloverAmount = 'rolloverAmount';
  static const String periodStart = 'periodStart';
  static const String createdAt = 'createdAt';
  static const String updatedAt = 'updatedAt';
}

class BudgetCategoryFields {
  static const String budgetId = 'budgetId';
  static const String categoryId = 'categoryId';
}

class BudgetMapper {
  static Budget fromJson(Map<String, Object?> json, List<int> categoryIds) =>
      Budget(
        id: json[BudgetFields.id] as int?,
        name: json[BudgetFields.name] as String,
        amount: (json[BudgetFields.amount] as num).toDouble(),
        periodType: PeriodType.values.firstWhere(
          (e) => e.toString() == json[BudgetFields.periodType],
          orElse: () => PeriodType.monthly,
        ),
        startDay: json[BudgetFields.startDay] as int?,
        startWeekday: json[BudgetFields.startWeekday] as int?,
        customStartDate: json[BudgetFields.customStartDate] != null
            ? DateTime.parse(json[BudgetFields.customStartDate] as String)
            : null,
        customEndDate: json[BudgetFields.customEndDate] != null
            ? DateTime.parse(json[BudgetFields.customEndDate] as String)
            : null,
        rolloverMode: RolloverMode.values.firstWhere(
          (e) => e.toString() == json[BudgetFields.rolloverMode],
          orElse: () => RolloverMode.none,
        ),
        rolloverAmount:
            (json[BudgetFields.rolloverAmount] as num?)?.toDouble() ?? 0,
        periodStart: json[BudgetFields.periodStart] != null
            ? DateTime.parse(json[BudgetFields.periodStart] as String)
            : null,
        createdAt: DateTime.parse(json[BudgetFields.createdAt] as String),
        updatedAt: DateTime.parse(json[BudgetFields.updatedAt] as String),
        categoryIds: categoryIds,
      );

  static Map<String, Object?> toJson(Budget budget) => {
        BudgetFields.id: budget.id,
        BudgetFields.name: budget.name,
        BudgetFields.amount: budget.amount,
        BudgetFields.periodType: budget.periodType.toString(),
        BudgetFields.startDay: budget.startDay,
        BudgetFields.startWeekday: budget.startWeekday,
        BudgetFields.customStartDate: budget.customStartDate?.toIso8601String(),
        BudgetFields.customEndDate: budget.customEndDate?.toIso8601String(),
        BudgetFields.rolloverMode: budget.rolloverMode.toString(),
        BudgetFields.rolloverAmount: budget.rolloverAmount,
        BudgetFields.periodStart: budget.periodStart?.toIso8601String(),
        BudgetFields.createdAt: budget.createdAt.toIso8601String(),
        BudgetFields.updatedAt: budget.updatedAt.toIso8601String(),
      };
}

class DatabaseBudgetHelper {
  static final DatabaseBudgetHelper instance = DatabaseBudgetHelper._init();
  DatabaseBudgetHelper._init();

  static Future initializeTable(Database db) async {
    await db.execute('''
      CREATE TABLE $budgetsTable (
        ${BudgetFields.id} ${DatabaseTypes.idType},
        ${BudgetFields.name} ${DatabaseTypes.textType},
        ${BudgetFields.amount} ${DatabaseTypes.realType},
        ${BudgetFields.periodType} ${DatabaseTypes.textType},
        ${BudgetFields.startDay} ${DatabaseTypes.integerTypeNullable},
        ${BudgetFields.startWeekday} ${DatabaseTypes.integerTypeNullable},
        ${BudgetFields.customStartDate} ${DatabaseTypes.textTypeNullable},
        ${BudgetFields.customEndDate} ${DatabaseTypes.textTypeNullable},
        ${BudgetFields.rolloverMode} ${DatabaseTypes.textType},
        ${BudgetFields.rolloverAmount} ${DatabaseTypes.realType},
        ${BudgetFields.periodStart} ${DatabaseTypes.textTypeNullable},
        ${BudgetFields.createdAt} ${DatabaseTypes.textType},
        ${BudgetFields.updatedAt} ${DatabaseTypes.textType}
      )
    ''');

    await db.execute('''
      CREATE TABLE $budgetCategoriesTable (
        ${BudgetCategoryFields.budgetId} ${DatabaseTypes.integerType},
        ${BudgetCategoryFields.categoryId} ${DatabaseTypes.integerType},
        PRIMARY KEY (${BudgetCategoryFields.budgetId}, ${BudgetCategoryFields.categoryId}),
        FOREIGN KEY (${BudgetCategoryFields.budgetId}) REFERENCES $budgetsTable (${BudgetFields.id}) ON DELETE CASCADE,
        FOREIGN KEY (${BudgetCategoryFields.categoryId}) REFERENCES $categoriesTable (${CategoryFields.id}) ON DELETE CASCADE
      )
    ''');
  }

  static void createTableV3toV4(Batch batch) {
    batch.execute('''
      CREATE TABLE $budgetsTable (
        ${BudgetFields.id} ${DatabaseTypes.idType},
        ${BudgetFields.name} ${DatabaseTypes.textType},
        ${BudgetFields.amount} ${DatabaseTypes.realType},
        ${BudgetFields.periodType} ${DatabaseTypes.textType},
        ${BudgetFields.startDay} ${DatabaseTypes.integerTypeNullable},
        ${BudgetFields.startWeekday} ${DatabaseTypes.integerTypeNullable},
        ${BudgetFields.customStartDate} ${DatabaseTypes.textTypeNullable},
        ${BudgetFields.customEndDate} ${DatabaseTypes.textTypeNullable},
        ${BudgetFields.rolloverMode} ${DatabaseTypes.textType},
        ${BudgetFields.rolloverAmount} ${DatabaseTypes.realType},
        ${BudgetFields.periodStart} ${DatabaseTypes.textTypeNullable},
        ${BudgetFields.createdAt} ${DatabaseTypes.textType},
        ${BudgetFields.updatedAt} ${DatabaseTypes.textType}
      )
    ''');

    batch.execute('''
      CREATE TABLE $budgetCategoriesTable (
        ${BudgetCategoryFields.budgetId} ${DatabaseTypes.integerType},
        ${BudgetCategoryFields.categoryId} ${DatabaseTypes.integerType},
        PRIMARY KEY (${BudgetCategoryFields.budgetId}, ${BudgetCategoryFields.categoryId}),
        FOREIGN KEY (${BudgetCategoryFields.budgetId}) REFERENCES $budgetsTable (${BudgetFields.id}) ON DELETE CASCADE,
        FOREIGN KEY (${BudgetCategoryFields.categoryId}) REFERENCES $categoriesTable (${CategoryFields.id}) ON DELETE CASCADE
      )
    ''');
  }

  Future<Budget> insertBudget({required Budget budget}) async {
    final db = await DatabaseHelper.instance.database;

    return await db.transaction((txn) async {
      final id = await txn.insert(budgetsTable, BudgetMapper.toJson(budget));

      for (final categoryId in budget.categoryIds) {
        await txn.insert(budgetCategoriesTable, {
          BudgetCategoryFields.budgetId: id,
          BudgetCategoryFields.categoryId: categoryId,
        });
      }

      return budget.copy(id: id);
    });
  }

  Future<bool> updateBudget({
    required Budget budgetToEdit,
    required Budget modifiedBudget,
  }) async {
    final db = await DatabaseHelper.instance.database;

    return await db.transaction((txn) async {
      final updateCount = await txn.update(
        budgetsTable,
        BudgetMapper.toJson(modifiedBudget),
        where: '${BudgetFields.id} = ?',
        whereArgs: [budgetToEdit.id],
      );

      if (updateCount > 0) {
        // Update categories
        await txn.delete(
          budgetCategoriesTable,
          where: '${BudgetCategoryFields.budgetId} = ?',
          whereArgs: [budgetToEdit.id],
        );

        for (final categoryId in modifiedBudget.categoryIds) {
          await txn.insert(budgetCategoriesTable, {
            BudgetCategoryFields.budgetId: budgetToEdit.id,
            BudgetCategoryFields.categoryId: categoryId,
          });
        }
        return true;
      }
      return false;
    });
  }

  Future<int> deleteBudget({required Budget budget}) async {
    final db = await DatabaseHelper.instance.database;
    // budget_categories will be deleted by CASCADE
    return await db.delete(
      budgetsTable,
      where: '${BudgetFields.id} = ?',
      whereArgs: [budget.id],
    );
  }

  Future<List<Budget>> getAllBudgets() async {
    final db = await DatabaseHelper.instance.database;

    final budgetsResult =
        await db.query(budgetsTable, orderBy: '${BudgetFields.name} ASC');

    List<Budget> budgets = [];
    for (final budgetJson in budgetsResult) {
      final budgetId = budgetJson[BudgetFields.id] as int;
      final categoriesResult = await db.query(
        budgetCategoriesTable,
        where: '${BudgetCategoryFields.budgetId} = ?',
        whereArgs: [budgetId],
      );

      final categoryIds = categoriesResult
          .map((c) => c[BudgetCategoryFields.categoryId] as int)
          .toList();

      budgets.add(BudgetMapper.fromJson(budgetJson, categoryIds));
    }

    return budgets;
  }

  Future<Budget?> getBudgetById(int id) async {
    final db = await DatabaseHelper.instance.database;

    final result = await db.query(
      budgetsTable,
      where: '${BudgetFields.id} = ?',
      whereArgs: [id],
    );

    if (result.isEmpty) return null;

    final categoriesResult = await db.query(
      budgetCategoriesTable,
      where: '${BudgetCategoryFields.budgetId} = ?',
      whereArgs: [id],
    );

    final categoryIds = categoriesResult
        .map((c) => c[BudgetCategoryFields.categoryId] as int)
        .toList();

    return BudgetMapper.fromJson(result.first, categoryIds);
  }
}
