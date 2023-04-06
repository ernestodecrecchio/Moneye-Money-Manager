import 'package:flutter/material.dart';

const String accountsTable = 'accounts';

class AccountFields {
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

class Account {
  int? id;
  String name;
  int colorValue;
  String? iconPath;

  Color get color {
    return Color(colorValue);
  }

  Account({
    this.id,
    required this.name,
    required this.colorValue,
    this.iconPath,
  });

  Account copy({
    int? id,
    String? name,
    int? colorValue,
    String? iconPath,
  }) =>
      Account(
        id: id ?? this.id,
        name: name ?? this.name,
        colorValue: colorValue ?? this.colorValue,
        iconPath: iconPath ?? this.iconPath,
      );

  static Account fromJson(Map<String, Object?> json) => Account(
        id: json[AccountFields.id] as int?,
        name: json[AccountFields.name] as String,
        colorValue: json[AccountFields.colorValue] as int,
        iconPath: json[AccountFields.iconPath] as String?,
      );

  Map<String, Object?> toJson() => {
        AccountFields.id: id,
        AccountFields.name: name,
        AccountFields.colorValue: colorValue,
        AccountFields.iconPath: iconPath,
      };

  @override
  operator ==(other) => other is Account && other.id == id;

  @override
  int get hashCode => Object.hash(id, name, colorValue, iconPath);
}
