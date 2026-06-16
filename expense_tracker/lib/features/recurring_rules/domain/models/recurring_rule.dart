import 'package:equatable/equatable.dart';

class RecurringRule extends Equatable {
  /// The unique identifier for this rule, represented as a UUID string.
  final String? id;
  final String title;
  final String? description;
  final double amount;
  final int? categoryId;
  final int? accountId;
  final bool includeInReports;
  final bool isHidden;
  final String frequency;
  final int frequencyInterval;
  final DateTime startDate;
  final DateTime? endDate;
  final DateTime? lastGeneratedDate;
  final bool isEnabled;

  const RecurringRule({
    this.id,
    required this.title,
    this.description,
    required this.amount,
    this.categoryId,
    this.accountId,
    this.includeInReports = true,
    this.isHidden = false,
    required this.frequency,
    required this.frequencyInterval,
    required this.startDate,
    this.endDate,
    this.lastGeneratedDate,
    this.isEnabled = true,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        amount,
        categoryId,
        accountId,
        includeInReports,
        isHidden,
        frequency,
        frequencyInterval,
        startDate,
        endDate,
        lastGeneratedDate,
        isEnabled,
      ];

  RecurringRule copy({
    String? id,
    String? title,
    String? description,
    double? amount,
    int? categoryId,
    int? accountId,
    bool? includeInReports,
    bool? isHidden,
    String? frequency,
    int? frequencyInterval,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? lastGeneratedDate,
    bool? isEnabled,
  }) =>
      RecurringRule(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        amount: amount ?? this.amount,
        categoryId: categoryId ?? this.categoryId,
        accountId: accountId ?? this.accountId,
        includeInReports: includeInReports ?? this.includeInReports,
        isHidden: isHidden ?? this.isHidden,
        frequency: frequency ?? this.frequency,
        frequencyInterval: frequencyInterval ?? this.frequencyInterval,
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate,
        lastGeneratedDate: lastGeneratedDate ?? this.lastGeneratedDate,
        isEnabled: isEnabled ?? this.isEnabled,
      );

  DateTime _getNextOccurrenceFrom(DateTime from) {
    final interval = frequencyInterval < 1 ? 1 : frequencyInterval;

    switch (frequency) {
      case 'daily':
        return from.add(Duration(days: interval));
      case 'weekly':
        return from.add(Duration(days: 7 * interval));
      case 'monthly':
        final nextMonth =
            DateTime(from.year, from.month + interval, from.day);
        if (nextMonth.month != (from.month + interval) % 12 &&
            nextMonth.month != 12) {
          return DateTime(from.year, from.month + interval + 1, 0);
        }
        return nextMonth;
      case 'yearly':
        return DateTime(from.year + interval, from.month, from.day);
      default:
        return from;
    }
  }

  DateTime get nextOccurrence {
    return lastGeneratedDate != null
        ? _getNextOccurrenceFrom(lastGeneratedDate!)
        : startDate;
  }

  bool get isEnded {
    if (endDate == null) return false;
    final normalizedNext =
        DateTime(nextOccurrence.year, nextOccurrence.month, nextOccurrence.day);
    final normalizedEnd =
        DateTime(endDate!.year, endDate!.month, endDate!.day);
    return normalizedNext.isAfter(normalizedEnd);
  }

  Iterable<DateTime> generateOccurrences({required DateTime until}) sync* {
    DateTime current = nextOccurrence;
    // Normalize until date to the end of the day to be inclusive
    final inclusiveUntil =
        DateTime(until.year, until.month, until.day, 23, 59, 59);

    while (current.isBefore(inclusiveUntil) ||
        current.isAtSameMomentAs(inclusiveUntil)) {
      if (endDate != null) {
        // Normalize comparison to the start of the day
        final normalizedCurrent =
            DateTime(current.year, current.month, current.day);
        final normalizedEndDate =
            DateTime(endDate!.year, endDate!.month, endDate!.day);
        if (normalizedCurrent.isAfter(normalizedEndDate)) break;
      }
      yield current;
      current = _getNextOccurrenceFrom(current);
    }
  }
}
