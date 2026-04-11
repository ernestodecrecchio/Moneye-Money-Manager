import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
class Transaction extends Equatable {
  final int? id;
  final String title;
  final String? description;
  final double amount;
  final DateTime date;
  final int? categoryId;
  final int? accountId;
  final bool includeInReports;
  final bool isHidden;
  final String? recurringId;
  bool get isGenerated => recurringId != null;
  final DateTime? originalDate;

  const Transaction({
    this.id,
    required this.title,
    this.description,
    required this.amount,
    required this.date,
    this.categoryId,
    this.accountId,
    this.includeInReports = true,
    this.isHidden = false,
    this.recurringId,
    this.originalDate,
  });

  Transaction copy({
    int? id,
    String? title,
    String? description,
    double? amount,
    DateTime? date,
    int? categoryId,
    int? accountId,
    bool? includeInReports,
    bool? isHidden,
    String? recurringId,
    DateTime? originalDate,
  }) {
    return Transaction(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      categoryId: categoryId ?? this.categoryId,
      accountId: accountId ?? this.accountId,
      includeInReports: includeInReports ?? this.includeInReports,
      isHidden: isHidden ?? this.isHidden,
      recurringId: recurringId ?? this.recurringId,
      originalDate: originalDate ?? this.originalDate,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        amount,
        date,
        categoryId,
        accountId,
        includeInReports,
        isHidden,
        recurringId,
        originalDate,
      ];

  @override
  String toString() {
    return 'Transaction [ID: $id - title: $title - amount: $amount - date: $date - includeInReports: $includeInReports - isHidden: $isHidden]';
  }
}
