const String transactionsTable = 'transactions';

class TransactionFields {
  static final List<String> values = [
    id,
    title,
    description,
    amount,
    date,
    categoryId,
    accountId,
    includeInReports,
    isHidden,
    recurringId,
    isGenerated,
    originalDate,
  ];

  static const String id = '_id'; // Default id column
  static const String title = 'title';
  static const String description = 'description';
  static const String amount = 'amount';
  static const String date = 'date';
  static const String categoryId = 'categoryId';
  static const String accountId = 'accountId';
  static const String includeInReports = 'includeInReports';
  static const String isHidden = 'isHidden';
  static const String recurringId = 'recurringId';
  static const String isGenerated = 'isGenerated';
  static const String originalDate = 'originalDate';
}

class Transaction {
  int? id;
  String title;
  String? description;
  double amount;
  DateTime date;
  int? categoryId;
  int? accountId;
  bool includeInReports;
  bool isHidden;
  int? recurringId;
  bool isGenerated;
  DateTime? originalDate;

  Transaction(
      {this.id,
      required this.title,
      this.description,
      required this.amount,
      required this.date,
      this.categoryId,
      this.accountId,
      this.includeInReports = true,
      this.isHidden = false,
      this.recurringId,
      this.isGenerated = false,
      this.originalDate});

  Transaction copy({
    int? id,
    String? title,
    String? description,
    double? amount,
    DateTime? date,
    int? categoryId,
    int? accountId,
    bool? includeInReports,
    bool? isHidden,
    int? recurringId,
    bool? isGenerated,
    DateTime? originalDate,
  }) =>
      Transaction(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        amount: amount ?? this.amount,
        date: date ?? this.date,
        categoryId: categoryId ?? this.categoryId,
        accountId: accountId ?? this.accountId,
        includeInReports: includeInReports ?? this.includeInReports,
        isHidden: isHidden ?? this.isHidden,
        recurringId: recurringId ?? this.recurringId,
        isGenerated: isGenerated ?? this.isGenerated,
        originalDate: originalDate ?? this.originalDate,
      );

  static Transaction fromJson(Map<String, Object?> json) => Transaction(
        id: json[TransactionFields.id] as int?,
        title: json[TransactionFields.title] as String,
        description: json[TransactionFields.description] as String?,
        amount: json[TransactionFields.amount] as double,
        date: DateTime.parse(json[TransactionFields.date] as String),
        categoryId: json[TransactionFields.categoryId] as int?,
        accountId: json[TransactionFields.accountId] as int?,
        includeInReports: (json[TransactionFields.includeInReports] as int) ==
            1, // cast to bool
        isHidden:
            (json[TransactionFields.isHidden] as int) == 1, // cast to bool
        recurringId: json[TransactionFields.recurringId] as int?,
        isGenerated: (json[TransactionFields.isGenerated] as int?) == 1,
        originalDate: json[TransactionFields.originalDate] != null 
            ? DateTime.parse(json[TransactionFields.originalDate] as String) 
            : null,
      );

  Map<String, Object?> toJson() => {
        TransactionFields.id: id,
        TransactionFields.title: title,
        TransactionFields.description: description,
        TransactionFields.amount: amount,
        TransactionFields.date: date.toIso8601String(),
        TransactionFields.categoryId: categoryId,
        TransactionFields.accountId: accountId,
        TransactionFields.includeInReports: includeInReports ? 1 : 0,
        TransactionFields.isHidden: isHidden ? 1 : 0,
        TransactionFields.recurringId: recurringId,
        TransactionFields.isGenerated: isGenerated ? 1 : 0,
        if (originalDate != null) TransactionFields.originalDate: originalDate!.toIso8601String(),
      };

  @override
  operator ==(other) => other is Transaction && other.id == id;

  @override
  int get hashCode => Object.hash(id, title, description, amount, date,
      categoryId, accountId, includeInReports, isHidden, recurringId, isGenerated, originalDate);

  @override
  String toString() {
    return 'Transaction [ID: $id - title: $title - amount: $amount - data: $date - includeInReports: $includeInReports - isHidden: $isHidden]';
  }
}
