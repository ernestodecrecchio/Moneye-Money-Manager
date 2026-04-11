import 'package:expense_tracker/features/recurring_rules/presentation/providers/recurring_rules_repository_provider.dart';
import 'package:expense_tracker/features/recurring_rules/domain/models/recurring_rule.dart';
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
