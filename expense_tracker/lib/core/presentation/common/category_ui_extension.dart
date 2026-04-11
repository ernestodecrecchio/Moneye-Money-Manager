import 'package:expense_tracker/features/categories/domain/models/category.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/core/style/style.dart';

extension CategoryUIExtension on Category {
  Color get color {
    return colorValue != null ? Color(colorValue!) : CustomColors.darkBlue;
  }
}
