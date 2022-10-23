const String accountsTable = 'accounts';

class AccountFields {
  static final List<String> values = [
    id,
    name,
  ];

  static const String id = '_id'; // Default id column
  static const String name = 'name';
}

class Account {
  int? id;
  String name;

  Account({
    this.id,
    required this.name,
  });

  Account copy({
    int? id,
    String? name,
  }) =>
      Account(
        id: id ?? this.id,
        name: name ?? this.name,
      );

  static Account fromJson(Map<String, Object?> json) => Account(
        id: json[AccountFields.id] as int?,
        name: json[AccountFields.name] as String,
      );

  Map<String, Object?> toJson() => {
        AccountFields.id: id,
        AccountFields.name: name,
      };
}
