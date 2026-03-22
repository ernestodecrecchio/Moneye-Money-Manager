import 'package:expense_tracker/l10n/app_localizations.dart';

const String recurringRulesTable = 'recurring_rules';

class RecurringRuleFields {
  static final List<String> values = [
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
  ];

  static const String id = '_id';
  static const String title = 'title';
  static const String description = 'description';
  static const String amount = 'amount';
  static const String categoryId = 'categoryId';
  static const String accountId = 'accountId';
  static const String includeInReports = 'includeInReports';
  static const String isHidden = 'isHidden';
  static const String frequency = 'frequency';
  static const String frequencyInterval = 'frequencyInterval';
  static const String startDate = 'startDate';
  static const String endDate = 'endDate';
  static const String lastGeneratedDate = 'lastGeneratedDate';
}

class RecurringRule {
  /// The unique identifier for this rule, represented as a UUID string.
  ///
  /// Using a UUID (instead of a standard integer) ensures global uniqueness and
  /// data integrity across backups or future synchronization features.
  /// This allows associated transactions to safely maintain a historical link
  /// to this rule's ID even if the rule itself is deleted, preventing ID
  /// collisions if new rules are created or imported in the future.
  String? id;
  String title;
  String? description;
  double amount;
  int? categoryId;
  int? accountId;
  bool includeInReports;
  bool isHidden;
  String frequency;
  int frequencyInterval;
  DateTime startDate;
  DateTime? endDate;
  DateTime? lastGeneratedDate;

  RecurringRule({
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
  });

  static RecurringRule fromJson(Map<String, Object?> json) => RecurringRule(
        id: json[RecurringRuleFields.id]?.toString(),
        title: json[RecurringRuleFields.title] as String,
        description: json[RecurringRuleFields.description] as String?,
        amount: json[RecurringRuleFields.amount] as double,
        categoryId: json[RecurringRuleFields.categoryId] as int?,
        accountId: json[RecurringRuleFields.accountId] as int?,
        includeInReports:
            (json[RecurringRuleFields.includeInReports] as int) == 1,
        isHidden: (json[RecurringRuleFields.isHidden] as int) == 1,
        frequency: json[RecurringRuleFields.frequency] as String,
        frequencyInterval: json[RecurringRuleFields.frequencyInterval] as int,
        startDate:
            DateTime.parse(json[RecurringRuleFields.startDate] as String),
        endDate: json[RecurringRuleFields.endDate] != null
            ? DateTime.parse(json[RecurringRuleFields.endDate] as String)
            : null,
        lastGeneratedDate: json[RecurringRuleFields.lastGeneratedDate] != null
            ? DateTime.parse(json[RecurringRuleFields.lastGeneratedDate] as String)
            : null,
      );

  Map<String, Object?> toJson() => {
        RecurringRuleFields.id: id,
        RecurringRuleFields.title: title,
        RecurringRuleFields.description: description,
        RecurringRuleFields.amount: amount,
        RecurringRuleFields.categoryId: categoryId,
        RecurringRuleFields.accountId: accountId,
        RecurringRuleFields.includeInReports: includeInReports ? 1 : 0,
        RecurringRuleFields.isHidden: isHidden ? 1 : 0,
        RecurringRuleFields.frequency: frequency,
        RecurringRuleFields.frequencyInterval: frequencyInterval,
        RecurringRuleFields.startDate: startDate.toIso8601String(),
        if (endDate != null)
          RecurringRuleFields.endDate: endDate!.toIso8601String(),
        if (lastGeneratedDate != null)
          RecurringRuleFields.lastGeneratedDate:
              lastGeneratedDate!.toIso8601String(),
      };

  DateTime _getNextOccurrenceFrom(DateTime from) {
    switch (frequency) {
      case 'daily':
        return from.add(Duration(days: frequencyInterval));
      case 'weekly':
        return from.add(Duration(days: 7 * frequencyInterval));
      case 'monthly':
        final nextMonth =
            DateTime(from.year, from.month + frequencyInterval, from.day);
        if (nextMonth.month != (from.month + frequencyInterval) % 12 &&
            nextMonth.month != 12) {
          return DateTime(from.year, from.month + frequencyInterval + 1, 0);
        }
        return nextMonth;
      case 'yearly':
        return DateTime(from.year + frequencyInterval, from.month, from.day);
      default:
        return from;
    }
  }

  DateTime get nextOccurrence {
    return lastGeneratedDate != null
        ? _getNextOccurrenceFrom(lastGeneratedDate!)
        : startDate;
  }

  Iterable<DateTime> generateOccurrences({required DateTime until}) sync* {
    DateTime current = nextOccurrence;
    while (current.isBefore(until) || current.isAtSameMomentAs(until)) {
      if (endDate != null && current.isAfter(endDate!)) break;
      yield current;
      current = _getNextOccurrenceFrom(current);
    }
  }

  String getFrequencyDescription(AppLocalizations l10n) {
    if (frequencyInterval == 1) {
      switch (frequency) {
        case 'daily':
          return l10n.daily;
        case 'weekly':
          return l10n.weekly;
        case 'monthly':
          return l10n.monthly;
        case 'yearly':
          return l10n.yearly;
        default:
          return frequency;
      }
    } else {
      return '${l10n.interval} $frequencyInterval $frequency';
    }
  }
}
