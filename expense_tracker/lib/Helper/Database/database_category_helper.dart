import 'package:expense_tracker/Helper/Database/database_helper.dart';
import 'package:expense_tracker/models/category.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqlite_api.dart';

class DatabaseCategoryHelper {
  static final DatabaseCategoryHelper instance = DatabaseCategoryHelper._init();
  DatabaseCategoryHelper._init();

  static Future inizializeTable(Database db) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const integerType = 'INTEGER NOT NULL';

    await db.execute('''
      CREATE TABLE $tableCategories ( 
      ${CategoryFields.id} $idType, 
      ${CategoryFields.name} $textType,
      ${CategoryFields.colorValue} $integerType,
      ${CategoryFields.iconData} $textType
      )
    ''');

    final dog = Category(
      name: 'Cane',
      colorValue: 4294951175,
      iconData: Icons.pets,
    );
    final shopping = Category(
      name: 'Shopping',
      colorValue: 4294951175,
      iconData: Icons.shopping_bag_rounded,
    );
    final car = Category(
      name: 'Auto',
      colorValue: 4294951175,
      iconData: Icons.car_crash,
    );
    final entertainment = Category(
      name: 'Intrattenimento',
      colorValue: 4294951175,
      iconData: Icons.camera_alt,
    );

    await db.insert(tableCategories, dog.toJson());
    await db.insert(tableCategories, shopping.toJson());
    await db.insert(tableCategories, car.toJson());
    await db.insert(tableCategories, entertainment.toJson());
  }

  Future<Category> insertCategory({required Category category}) async {
    final db = await DatabaseHelper.instance.database;

    final id = await db.insert(tableCategories, category.toJson());

    return category.copy(id: id);
  }

  Future<int> deleteCategory({required Category category}) async {
    final db = await DatabaseHelper.instance.database;

    return db.delete(
      tableCategories,
      where: '${CategoryFields.id} = ?',
      whereArgs: [category.id],
    );
  }

  static Future<Category> readCategory(int id) async {
    final db = await DatabaseHelper.instance.database;

    final maps = await db.query(
      tableCategories,
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

    final result = await db.query(tableCategories, orderBy: orderBy);
    return result.map((json) => Category.fromJson(json)).toList();
  }

  static Future<int> updateCategory(Category category) async {
    final db = await DatabaseHelper.instance.database;

    return db.update(
      tableCategories,
      category.toJson(),
      where: '${CategoryFields.id} = ?',
      whereArgs: [category.id],
    );
  }
}
