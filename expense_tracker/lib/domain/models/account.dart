import 'package:expense_tracker/style.dart';
import 'package:flutter/material.dart';

const String accountsTable = 'accounts';

class AccountFields {
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

class Account {
  final int? id;
  final String name;
  final String? description;
  final int? colorValue;
  final String? iconPath;

  Color get color {
    return colorValue != null ? Color(colorValue!) : CustomColors.darkBlue;
  }

  const Account({
    this.id,
    required this.name,
    this.description,
    this.colorValue,
    this.iconPath,
  });

  Account copy({
    int? id,
    String? name,
    String? description,
    int? colorValue,
    String? iconPath,
  }) =>
      Account(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        colorValue: colorValue ?? this.colorValue,
        iconPath: iconPath ?? this.iconPath,
      );

  static Account fromJson(Map<String, Object?> json) => Account(
        id: json[AccountFields.id] as int?,
        name: json[AccountFields.name] as String,
        description: json[AccountFields.description] as String?,
        colorValue: json[AccountFields.colorValue] as int?,
        iconPath: json[AccountFields.iconPath] as String?,
      );

  Map<String, Object?> toJson() => {
        AccountFields.id: id,
        AccountFields.name: name,
        AccountFields.description: description,
        AccountFields.colorValue: colorValue,
        AccountFields.iconPath: iconPath,
      };
}
