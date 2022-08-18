import 'package:expense_tracker/models/category.dart';

const String tableTransactions = 'transactions';

class TransactionFields {
  static final List<String> values = [
    id,
    title,
    value,
    date,
    categoryId,
  ];

  static const String id = '_id'; // Default id column
  static const String title = 'title';
  static const String value = 'value';
  static const String date = 'date';
  static const String categoryId = 'categoryId';
}

class Transaction {
  int? id;
  String title;
  double value;
  DateTime date;
  int categoryId;

  Category get category {
    return Category(name: 'name', colorValue: 1);
  }

  Transaction({
    this.id,
    required this.title,
    required this.value,
    required this.date,
    required this.categoryId,
  });

  Transaction copy({
    int? id,
    String? title,
    double? value,
    DateTime? date,
    int? categoryId,
  }) =>
      Transaction(
        id: id ?? this.id,
        title: title ?? this.title,
        value: value ?? this.value,
        date: date ?? this.date,
        categoryId: categoryId ?? this.categoryId,
      );

  static Transaction fromJson(Map<String, Object?> json) => Transaction(
        id: json[TransactionFields.id] as int?,
        title: json[TransactionFields.title] as String,
        value: json[TransactionFields.value] as double,
        date: DateTime.parse(json[TransactionFields.date] as String),
        categoryId: json[TransactionFields.categoryId] as int,
      );

  Map<String, Object?> toJson() => {
        TransactionFields.id: id,
        TransactionFields.title: title,
        TransactionFields.value: value,
        TransactionFields.date: date.toIso8601String(),
        TransactionFields.categoryId: categoryId,
      };
}
