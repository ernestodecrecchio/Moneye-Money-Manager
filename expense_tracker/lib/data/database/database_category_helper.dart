import 'package:expense_tracker/data/database/database_helper.dart';
import 'package:expense_tracker/data/database/database_types.dart';
import 'package:expense_tracker/models/category.dart';
import 'package:sqflite/sqlite_api.dart';

class DatabaseCategoryHelper {
  static final DatabaseCategoryHelper instance = DatabaseCategoryHelper._init();
  DatabaseCategoryHelper._init();

  static Future inizializeTable(Database db) async {
    await db.execute('''
      CREATE TABLE $categoriesTable ( 
      ${CategoryFields.id} ${DatabaseTypes.idType},
      ${CategoryFields.name} ${DatabaseTypes.textType}, 
      ${CategoryFields.description} ${DatabaseTypes.textTypeNullable}, 
      ${CategoryFields.colorValue} ${DatabaseTypes.integerTypeNullable}, 
      ${CategoryFields.iconPath} ${DatabaseTypes.textTypeNullable}
      )
    ''');
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
