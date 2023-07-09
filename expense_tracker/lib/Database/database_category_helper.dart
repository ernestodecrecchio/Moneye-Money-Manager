import 'package:expense_tracker/Database/database_helper.dart';
import 'package:expense_tracker/models/category.dart';
import 'package:sqflite/sqlite_api.dart';

class DatabaseCategoryHelper {
  static final DatabaseCategoryHelper instance = DatabaseCategoryHelper._init();
  DatabaseCategoryHelper._init();

  static Future inizializeTable(Database db) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const textTypeNullable = 'TEXT';
    //const integerType = 'INTEGER NOT NULL';
    const integerTypeNullable = 'INTEGER';

    await db.execute('''
      CREATE TABLE $categoriesTable ( 
      ${CategoryFields.id} $idType, 
      ${CategoryFields.name} $textType,
      ${CategoryFields.description} $textTypeNullable,
      ${CategoryFields.colorValue} $integerTypeNullable,
      ${CategoryFields.iconPath} $textTypeNullable
      )
    ''');

    //  await insertDemoData(db);
  }

  static Future insertDemoData(Database db) async {
    final categoryList = [
      Category(
        id: 1,
        name: 'Payments and taxes',
        colorValue: 4278228616,
        iconPath: 'assets/icons/picker_icons/university.svg',
      ),
      Category(
        id: 2,
        name: 'Gifts',
        colorValue: 4280391411,
        iconPath: 'assets/icons/box.svg',
      ),
      Category(
        id: 3,
        name: 'Travels',
        colorValue: 4294940672,
        iconPath: 'assets/icons/travel.svg',
      ),
      Category(
        id: 4,
        name: 'Clothing',
        colorValue: 4294198070,
        iconPath: 'assets/icons/picker_icons/shirt.svg',
      ),
      Category(
        id: 5,
        name: 'Transportation',
        colorValue: 4282339765,
        iconPath: 'assets/icons/car.svg',
      ),
      Category(
        id: 6,
        name: 'Housing',
        colorValue: 4283215696,
        iconPath: 'assets/icons/house.svg',
      ),
      Category(
        id: 7,
        name: 'Entertainment',
        colorValue: 4293467747,
        iconPath: 'assets/icons/popcorn.svg',
      ),
      Category(
        id: 8,
        name: 'School',
        colorValue: 4293467747,
        iconPath: 'assets/icons/popcorn.svg',
      ),
      Category(
        id: 9,
        name: 'Dot',
        colorValue: 4293467747,
        iconPath: 'assets/icons/popcorn.svg',
      ),
      Category(
        id: 10,
        name: 'Jim',
        colorValue: 4293467747,
        iconPath: 'assets/icons/popcorn.svg',
      ),
      Category(
        id: 11,
        name: 'Car',
        colorValue: 4293467747,
        iconPath: 'assets/icons/popcorn.svg',
      ),
      Category(
        id: 12,
        name: 'Cat',
        colorValue: 4293467747,
        iconPath: 'assets/icons/popcorn.svg',
      ),
    ];

    categoryList.forEach((element) async {
      await db.insert(categoriesTable, element.toJson());
    });
  }

  Future<Category> insertCategory({required Category category}) async {
    final db = await DatabaseHelper.instance.database;

    final id = await db.insert(categoriesTable, category.toJson());

    return category.copy(id: id);
  }

  Future<bool> updateCategory(
      {required Category categoryToEdit,
      required Category modifiedCategory}) async {
    final db = await DatabaseHelper.instance.database;

    if (await db.update(categoriesTable, modifiedCategory.toJson(),
            where: '${CategoryFields.id} = ?', whereArgs: [categoryToEdit.id]) >
        0) {
      return true;
    }

    return false;
  }

  Future<int> deleteCategory({required Category category}) async {
    final db = await DatabaseHelper.instance.database;

    return db.delete(
      categoriesTable,
      where: '${CategoryFields.id} = ?',
      whereArgs: [category.id],
    );
  }

  static Future<Category> readCategory(int id) async {
    final db = await DatabaseHelper.instance.database;

    final maps = await db.query(
      categoriesTable,
      columns: CategoryFields.values,
      where: '${CategoryFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Category.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<Category>> readAllCategories() async {
    final db = await DatabaseHelper.instance.database;

    const orderBy = '${CategoryFields.name} ASC';

    final result = await db.query(categoriesTable, orderBy: orderBy);
    return result.map((json) => Category.fromJson(json)).toList();
  }

  Future<Category?> getCategoryFromId(int id) async {
    final db = await DatabaseHelper.instance.database;

    final result = await db.query(categoriesTable,
        where: '${CategoryFields.id} = ?', whereArgs: [id]);

    if (result.isNotEmpty) {
      return Category.fromJson(result.first);
    }

    return null;
  }
}
