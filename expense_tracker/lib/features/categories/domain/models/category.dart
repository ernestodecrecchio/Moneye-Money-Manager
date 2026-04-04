import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
class Category extends Equatable {
  final int? id;
  final String name;
  final String? description;
  final int? colorValue;
  final String? iconPath;

  const Category({
    this.id,
    required this.name,
    this.description,
    this.colorValue,
    this.iconPath,
  });

  Category copy({
    int? id,
    String? name,
    String? description,
    int? colorValue,
    String? iconPath,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      colorValue: colorValue ?? this.colorValue,
      iconPath: iconPath ?? this.iconPath,
    );
  }

  @override
  List<Object?> get props => [id, name, description, colorValue, iconPath];
}
