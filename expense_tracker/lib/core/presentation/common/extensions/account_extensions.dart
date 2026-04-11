import 'package:expense_tracker/features/accounts/domain/models/account.dart';
import 'package:flutter/material.dart';

extension AccountUIExtension on Account {
  Color get color => colorValue != null ? Color(colorValue!) : Colors.blueGrey;
  
  // IconData mapping if needed
}
