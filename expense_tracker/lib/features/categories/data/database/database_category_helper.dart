import 'package:expense_tracker/core/database/database_helper.dart';
import 'package:expense_tracker/core/database/database_types.dart';
import 'package:expense_tracker/features/categories/domain/models/category.dart';
import 'package:sqflite/sqlite_api.dart';

const String categoriesTable = 'categories';

class CategoryFields {
  static final List<String> values = [
    id,
    name,
    description,
    colorValue,
    iconPath,
  ];

  static const String id = '_id'; // Default id column
  static const String name = 'name';
  static const String description = 'description';
  static const String colorValue = 'colorValue';
  static const String iconPath = 'iconPath';
}

class CategoryMapper {
  static Category fromJson(Map<String, Object?> json) => Category(
        id: json[CategoryFields.id] as int?,
        name: json[CategoryFields.name] as String,
        description: json[CategoryFields.description] as String?,
        colorValue: json[CategoryFields.colorValue] as int?,
        iconPath: json[CategoryFields.iconPath] as String?,
      );

  static Map<String, Object?> toJson(Category category) => {
        CategoryFields.id: category.id,
        CategoryFields.name: category.name,
        CategoryFields.description: category.description,
        CategoryFields.colorValue: category.colorValue,
        CategoryFields.iconPath: category.iconPath,
      };
}

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

    final id = await db.insert(categoriesTable, CategoryMapper.toJson(category));

    return category.copy(id: id);
  }

  Future<bool> updateCategory(
      {required Category categoryToEdit,
      required Category modifiedCategory}) async {
    final db = await DatabaseHelper.instance.database;

    if (await db.update(categoriesTable, CategoryMapper.toJson(modifiedCategory),
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

  Future<List<Category>> getAllCategories() async {
    final db = await DatabaseHelper.instance.database;

    const orderBy = '${CategoryFields.name} ASC';

    final result = await db.query(categoriesTable, orderBy: orderBy);
    return result.map((json) => CategoryMapper.fromJson(json)).toList();
  }

  Future<Category?> getCategoryById(int id) async {
    final dbInstance = await DatabaseHelper.instance.database;

    final result = await dbInstance.query(
      categoriesTable,
      where: '${CategoryFields.id} = ?',
      whereArgs: [id],
    );

    if (result.isNotEmpty) {
      return CategoryMapper.fromJson(result.first);
    }

    return null;
  }
}
