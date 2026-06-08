import 'package:equatable/equatable.dart';
import 'package:expense_tracker/features/transactions/domain/models/transaction.dart';
import 'package:meta/meta.dart';

@immutable
class TransactionShortcut extends Equatable {
  final int? id;
  final String title;
  final String? description;
  final double amount;
  final int? categoryId;
  final int? accountId;
  final bool includeInReports;

  const TransactionShortcut({
    this.id,
    required this.title,
    this.description,
    required this.amount,
    this.categoryId,
    this.accountId,
    this.includeInReports = true,
  });

  TransactionShortcut copy({
    int? id,
    String? title,
    String? description,
    double? amount,
    int? categoryId,
    int? accountId,
    bool? includeInReports,
  }) {
    return TransactionShortcut(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      categoryId: categoryId ?? this.categoryId,
      accountId: accountId ?? this.accountId,
      includeInReports: includeInReports ?? this.includeInReports,
    );
  }

  Transaction toTransaction({DateTime? date}) {
    return Transaction(
      title: title,
      description: description,
      amount: amount,
      date: date ?? DateTime.now(),
      categoryId: categoryId,
      accountId: accountId,
      includeInReports: includeInReports,
      isHidden: false,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        amount,
        categoryId,
        accountId,
        includeInReports,
      ];
}
