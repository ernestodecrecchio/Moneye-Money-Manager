import 'package:expense_tracker/features/recurring_rules/domain/models/recurring_rule.dart';
import 'package:expense_tracker/l10n/app_localizations.dart';

extension RecurringRuleUIExtension on RecurringRule {
  String getFrequencyDescription(AppLocalizations l10n) {
    switch (frequency) {
      case 'daily':
        return l10n.dailyInterval(frequencyInterval);
      case 'weekly':
        return l10n.weeklyInterval(frequencyInterval);
      case 'monthly':
        return l10n.monthlyInterval(frequencyInterval);
      case 'yearly':
        return l10n.yearlyInterval(frequencyInterval);
      default:
        return frequency;
    }
  }
}
