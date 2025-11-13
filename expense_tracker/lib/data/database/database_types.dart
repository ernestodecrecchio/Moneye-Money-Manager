class DatabaseTypes {
  DatabaseTypes._(); // Private constructor to prevent instantiation

  // ID
  static const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';

  // Integer
  static const integerType = 'INTEGER NOT NULL';
  static const integerTypeNullable = 'INTEGER';

  // Text
  static const textType = 'TEXT NOT NULL';
  static const textTypeNullable = 'TEXT';

  // Real
  static const realType = 'REAL NOT NULL';

  // Datetime
  static const dateTimeType = 'DATETIME NOT NULL';
}
