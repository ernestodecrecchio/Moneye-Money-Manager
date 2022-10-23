import 'package:expense_tracker/Helper/icon_data_helper.dart';
import 'package:flutter/material.dart';

const String categoriesTable = 'categories';

class CategoryFields {
  static final List<String> values = [
    id,
    name,
    colorValue,
    iconData,
  ];

  static const String id = '_id'; // Default id column
  static const String name = 'name';
  static const String colorValue = 'colorValue';
  static const String iconData = 'iconData';
}

class Category {
  int? id;
  String name;
  int colorValue;
  IconData? iconData;

  Color get color {
    return Color(colorValue);
  }

  Icon get icon {
    return Icon(iconData);
  }

  Category({
    this.id,
    required this.name,
    required this.colorValue,
    this.iconData,
  });

  Category copy({
    int? id,
    String? name,
    int? colorValue,
    IconData? iconData,
  }) =>
      Category(
        id: id ?? this.id,
        name: name ?? this.name,
        colorValue: colorValue ?? this.colorValue,
        iconData: iconData ?? this.iconData,
      );

  static Category fromJson(Map<String, Object?> json) => Category(
        id: json[CategoryFields.id] as int?,
        name: json[CategoryFields.name] as String,
        colorValue: json[CategoryFields.colorValue] as int,
        iconData: fromJSONStringToIcon(json[CategoryFields.iconData] as String),
      );

  Map<String, Object?> toJson() => {
        CategoryFields.id: id,
        CategoryFields.name: name,
        CategoryFields.colorValue: colorValue,
        CategoryFields.iconData:
            iconData != null ? iconToJSONString(iconData!) : null,
      };
}
