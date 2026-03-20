import 'package:expense_tracker/application/recurring_rules/notifiers/recurring_rules_repository_provider.dart';
import 'package:expense_tracker/domain/models/recurring_rule.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecurringRulesListNotifier extends AsyncNotifier<List<RecurringRule>> {
  @override
  Future<List<RecurringRule>> build() async {
    return ref.read(recurringRulesRepositoryProvider).getRecurringRules();
  }
}

final recurringRulesListProvider =
    AsyncNotifierProvider<RecurringRulesListNotifier, List<RecurringRule>>(
  RecurringRulesListNotifier.new,
);
