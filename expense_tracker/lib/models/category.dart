import 'dart:ui';

const String tableCategories = 'categories';

class CategoryFields {
  static final List<String> values = [
    id,
    name,
    colorValue,
  ];

  static const String id = '_id'; // Default id column
  static const String name = 'name';
  static const String colorValue = 'colorValue';
}

class Category {
  int? id;
  String name;
  final int colorValue;
  late final Color color;

  Category({
    this.id,
    required this.name,
    required this.colorValue,
  }) {
    color = Color(colorValue);
  }

  Category copy({
    int? id,
    String? name,
    int? colorValue,
  }) =>
      Category(
        id: id ?? this.id,
        name: name ?? this.name,
        colorValue: colorValue ?? this.colorValue,
      );

  static Category fromJson(Map<String, Object?> json) => Category(
        id: json[CategoryFields.id] as int?,
        name: json[CategoryFields.name] as String,
        colorValue: json[CategoryFields.colorValue] as int,
      );

  Map<String, Object?> toJson() => {
        CategoryFields.id: id,
        CategoryFields.name: name,
        CategoryFields.colorValue: colorValue,
      };
}
