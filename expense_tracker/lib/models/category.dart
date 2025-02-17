import 'package:expense_tracker/style.dart';
import 'package:flutter/material.dart';

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

class Category {
  int? id;
  String name;
  String? description;
  int? colorValue;
  String? iconPath;

  Color get color {
    return colorValue != null ? Color(colorValue!) : CustomColors.darkBlue;
  }

  Category({
    this.id,
    required this.name,
    this.description,
    required this.colorValue,
    this.iconPath,
  });

  Category copy({
    int? id,
    String? name,
    String? description,
    int? colorValue,
    String? iconPath,
  }) =>
      Category(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        colorValue: colorValue ?? this.colorValue,
        iconPath: iconPath ?? this.iconPath,
      );

  static Category fromJson(Map<String, Object?> json) => Category(
        id: json[CategoryFields.id] as int?,
        name: json[CategoryFields.name] as String,
        description: json[CategoryFields.description] as String?,
        colorValue: json[CategoryFields.colorValue] as int?,
        iconPath: json[CategoryFields.iconPath] as String?,
      );

  Map<String, Object?> toJson() => {
        CategoryFields.id: id,
        CategoryFields.name: name,
        CategoryFields.description: description,
        CategoryFields.colorValue: colorValue,
        CategoryFields.iconPath: iconPath,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Category &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          description == other.description &&
          colorValue == other.colorValue &&
          iconPath == other.iconPath;

  @override
  int get hashCode => Object.hash(id, name, description, colorValue, iconPath);
}
