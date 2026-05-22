import 'package:expense_tracker/features/accounts/domain/models/account.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/core/style/style.dart';

extension AccountUIExtension on Account {
  Color get color {
    return colorValue != null ? Color(colorValue!) : CustomColors.darkBlue;
  }
}
