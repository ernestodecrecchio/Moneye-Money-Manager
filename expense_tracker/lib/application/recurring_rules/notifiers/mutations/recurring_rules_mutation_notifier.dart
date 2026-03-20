import 'package:expense_tracker/application/recurring_rules/notifiers/queries/recurring_rules_list_notifier.dart';
import 'package:expense_tracker/application/recurring_rules/notifiers/recurring_rules_repository_provider.dart';
import 'package:expense_tracker/domain/models/recurring_rule.dart';
import 'package:expense_tracker/domain/repositories/recurring_rules_repository.dart';
import 'package:expense_tracker/application/transactions/notifiers/queries/transactions_list_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecurringRulesMutationNotifier extends AsyncNotifier<void> {
  RecurringRulesRepository get _repo =>
      ref.read(recurringRulesRepositoryProvider);

  @override
  Future<void> build() async {}

  Future<RecurringRule> addRecurringRule(RecurringRule rule) async {
    late final RecurringRule inserted;
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      inserted = await _repo.insertRecurringRule(rule: rule);
      ref.invalidate(recurringRulesListProvider);
      ref.invalidate(transactionsListProvider);
    });

    return inserted;
  }

  Future<void> updateRecurringRule(
      RecurringRule original, RecurringRule modified) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await _repo.updateRecurringRule(original: original, modified: modified);
      ref.invalidate(recurringRulesListProvider);
      ref.invalidate(transactionsListProvider);
    });
  }

  Future<void> deleteRecurringRule(RecurringRule rule) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await _repo.deleteRecurringRule(rule: rule);
      ref.invalidate(recurringRulesListProvider);
      ref.invalidate(transactionsListProvider);
    });
  }
}

final recurringRulesMutationProvider =
    AsyncNotifierProvider<RecurringRulesMutationNotifier, void>(
  RecurringRulesMutationNotifier.new,
);
