import 'package:flutter/material.dart';

const String categoriesTable = 'categories';

class CategoryFields {
  static final List<String> values = [
    id,
    name,
    colorValue,
    iconPath,
  ];

  static const String id = '_id'; // Default id column
  static const String name = 'name';
  static const String colorValue = 'colorValue';
  static const String iconPath = 'iconPath';
}

class Category {
  int? id;
  String name;
  int colorValue;
  String? iconPath;

  Color get color {
    return Color(colorValue);
  }

  Category({
    this.id,
    required this.name,
    required this.colorValue,
    this.iconPath,
  });

  Category copy({
    int? id,
    String? name,
    int? colorValue,
    String? iconPath,
  }) =>
      Category(
        id: id ?? this.id,
        name: name ?? this.name,
        colorValue: colorValue ?? this.colorValue,
        iconPath: iconPath ?? this.iconPath,
      );

  static Category fromJson(Map<String, Object?> json) => Category(
        id: json[CategoryFields.id] as int?,
        name: json[CategoryFields.name] as String,
        colorValue: json[CategoryFields.colorValue] as int,
        iconPath: json[CategoryFields.iconPath] as String?,
      );

  Map<String, Object?> toJson() => {
        CategoryFields.id: id,
        CategoryFields.name: name,
        CategoryFields.colorValue: colorValue,
        CategoryFields.iconPath: iconPath,
      };

  @override
  operator ==(other) => other is Category && other.id == id;

  @override
  int get hashCode => Object.hash(id, name, colorValue, iconPath);
}
