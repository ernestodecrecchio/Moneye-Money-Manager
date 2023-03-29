import 'package:expense_tracker/Helper/icon_data_helper.dart';
import 'package:flutter/material.dart';

const String accountsTable = 'accounts';

class AccountFields {
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

class Account {
  int? id;
  String name;
  int colorValue;
  IconData? iconData;

  Color get color {
    return Color(colorValue);
  }

  Icon get icon {
    return Icon(
      iconData,
      color: Colors.white,
    );
  }

  Account({
    this.id,
    required this.name,
    required this.colorValue,
    this.iconData,
  });

  Account copy({
    int? id,
    String? name,
    int? colorValue,
    IconData? iconData,
  }) =>
      Account(
        id: id ?? this.id,
        name: name ?? this.name,
        colorValue: colorValue ?? this.colorValue,
        iconData: iconData ?? this.iconData,
      );

  static Account fromJson(Map<String, Object?> json) => Account(
        id: json[AccountFields.id] as int?,
        name: json[AccountFields.name] as String,
        colorValue: json[AccountFields.colorValue] as int,
        iconData: json[AccountFields.iconData] != null
            ? fromJSONStringToIcon(json[AccountFields.iconData] as String)
            : null,
      );

  Map<String, Object?> toJson() => {
        AccountFields.id: id,
        AccountFields.name: name,
        AccountFields.colorValue: colorValue,
        AccountFields.iconData:
            iconData != null ? iconToJSONString(iconData!) : null,
      };
}
