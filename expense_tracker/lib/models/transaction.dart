const String transactionsTable = 'transactions';

class TransactionFields {
  static final List<String> values = [
    id,
    title,
    description,
    value,
    date,
    categoryId,
    accountId,
    includeInReports,
  ];

  static const String id = '_id'; // Default id column
  static const String title = 'title';
  static const String description = 'description';
  static const String value = 'value';
  static const String date = 'date';
  static const String categoryId = 'categoryId';
  static const String accountId = 'accountId';
  static const String includeInReports = 'includeInReports';
}

class Transaction {
  int? id;
  String title;
  String? description;
  double value;
  DateTime date;
  int? categoryId;
  int? accountId;
  bool includeInReports;

  Transaction(
      {this.id,
      required this.title,
      this.description,
      required this.value,
      required this.date,
      this.categoryId,
      this.accountId,
      this.includeInReports = true});

  Transaction copy({
    int? id,
    String? title,
    String? description,
    double? value,
    DateTime? date,
    int? categoryId,
    int? accountId,
    bool? includeInReports,
  }) =>
      Transaction(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        value: value ?? this.value,
        date: date ?? this.date,
        categoryId: categoryId ?? this.categoryId,
        accountId: accountId ?? this.accountId,
        includeInReports: includeInReports ?? this.includeInReports,
      );

  static Transaction fromJson(Map<String, Object?> json) => Transaction(
        id: json[TransactionFields.id] as int?,
        title: json[TransactionFields.title] as String,
        description: json[TransactionFields.description] as String?,
        value: json[TransactionFields.value] as double,
        date: DateTime.parse(json[TransactionFields.date] as String),
        categoryId: json[TransactionFields.categoryId] as int?,
        accountId: json[TransactionFields.accountId] as int?,
        includeInReports: json[TransactionFields.includeInReports] as bool,
      );

  Map<String, Object?> toJson() => {
        TransactionFields.id: id,
        TransactionFields.title: title,
        TransactionFields.description: description,
        TransactionFields.value: value,
        TransactionFields.date: date.toIso8601String(),
        TransactionFields.categoryId: categoryId,
        TransactionFields.accountId: accountId,
        TransactionFields.includeInReports: includeInReports
      };

  @override
  operator ==(other) => other is Transaction && other.id == id;

  @override
  int get hashCode => Object.hash(id, title, description, value, date,
      categoryId, accountId, includeInReports);

  @override
  String toString() {
    return 'Transaction [ID: $id - title: $title - value: $value - data: $date]';
  }
}
