const String tableTransactions = 'transactions';

class TransactionFields {
  static final List<String> values = [
    id,
    title,
    value,
    date,
  ];

  static const String id = '_id'; // Default id column
  static const String title = 'title';
  static const String value = 'value';
  static const String date = 'date';
}

class Transaction {
  int? id;
  String title;
  double value;
  DateTime date;

  Transaction({
    this.id,
    required this.title,
    required this.value,
    required this.date,
  });

  Transaction copy({
    int? id,
    String? title,
    double? value,
    DateTime? date,
  }) =>
      Transaction(
        id: id ?? this.id,
        title: title ?? this.title,
        value: value ?? this.value,
        date: date ?? this.date,
      );

  static Transaction fromJson(Map<String, Object?> json) => Transaction(
        id: json[TransactionFields.id] as int?,
        title: json[TransactionFields.title] as String,
        value: json[TransactionFields.value] as double,
        date: DateTime.parse(json[TransactionFields.date] as String),
      );

  Map<String, Object?> toJson() => {
        TransactionFields.id: id,
        TransactionFields.title: title,
        TransactionFields.value: value,
        TransactionFields.date: date.toIso8601String()
      };
}
