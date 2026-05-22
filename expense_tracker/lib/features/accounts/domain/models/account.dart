import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
class Account extends Equatable {
  final int? id;
  final String name;
  final String? description;
  final double balance;
  final int? colorValue;
  final String? iconPath;
  final bool isOtherAccount;

  const Account({
    this.id,
    required this.name,
    this.description,
    this.balance = 0.0,
    this.colorValue,
    this.iconPath,
    this.isOtherAccount = false,
  });

  Account copy({
    int? id,
    String? name,
    String? description,
    double? balance,
    int? colorValue,
    String? iconPath,
    bool? isOtherAccount,
  }) {
    return Account(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      balance: balance ?? this.balance,
      colorValue: colorValue ?? this.colorValue,
      iconPath: iconPath ?? this.iconPath,
      isOtherAccount: isOtherAccount ?? this.isOtherAccount,
    );
  }

  @override
  List<Object?> get props =>
      [id, name, description, balance, colorValue, iconPath, isOtherAccount];
}
