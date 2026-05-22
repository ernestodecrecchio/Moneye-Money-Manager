import 'package:expense_tracker/features/categories/domain/models/category.dart';
import 'package:flutter/material.dart';

extension CategoryUIExtension on Category {
  Color get color => colorValue != null ? Color(colorValue!) : Colors.grey;
  
  IconData get icon => iconPath != null ? _getIconData(iconPath!) : Icons.category;

  // Helper to map icon paths to IconData if needed, 
  // or handle SVG paths if the app uses them.
  // The original app seems to use iconPath as a String, likely for SVG or a known identifier.
  // For now, we just provide the color extension as that was the main source of errors.
}

IconData _getIconData(String path) {
  // Implementation depends on how the app stores icons.
  // If it's just a string descriptor, we might need a mapping.
  return Icons.category;
}
