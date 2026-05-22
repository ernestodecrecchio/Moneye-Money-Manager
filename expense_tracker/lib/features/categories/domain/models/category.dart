import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
class Category extends Equatable {
  final int? id;
  final String name;
  final String? description;
  final int? colorValue;
  final String? iconPath;
  final bool isOtherCategory;

  const Category({
    this.id,
    required this.name,
    this.description,
    this.colorValue,
    this.iconPath,
    this.isOtherCategory = false,
  });

  Category copy({
    int? id,
    String? name,
    String? description,
    int? colorValue,
    String? iconPath,
    bool? isOtherCategory,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      colorValue: colorValue ?? this.colorValue,
      iconPath: iconPath ?? this.iconPath,
      isOtherCategory: isOtherCategory ?? this.isOtherCategory,
    );
  }

  @override
  List<Object?> get props =>
      [id, name, description, colorValue, iconPath, isOtherCategory];
}
