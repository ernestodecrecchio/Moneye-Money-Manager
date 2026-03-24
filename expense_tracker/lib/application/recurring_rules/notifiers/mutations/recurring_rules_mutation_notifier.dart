import 'package:expense_tracker/application/recurring_rules/notifiers/queries/recurring_rules_list_notifier.dart';
import 'package:expense_tracker/application/recurring_rules/notifiers/recurring_rules_repository_provider.dart';
import 'package:expense_tracker/domain/models/recurring_rule.dart';
import 'package:expense_tracker/domain/repositories/recurring_rules_repository.dart';
import 'package:expense_tracker/application/transactions/notifiers/queries/transactions_list_notifier.dart';
import 'package:expense_tracker/application/transactions/notifiers/transactions_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecurringRulesMutationNotifier extends AsyncNotifier<void> {
  RecurringRulesRepository get _repo =>
      ref.read(recurringRulesRepositoryProvider);

  @override
  Future<void> build() async {}

  Future<RecurringRule> addRecurringRule(RecurringRule rule) async {
    state = const AsyncLoading();

    try {
      final inserted = await _repo.insertRecurringRule(rule: rule);

      // Trigger generation for the new rule
      await ref
          .read(transactionsRepositoryProvider)
          .generateRecurringTransactionsUntil(DateTime.now());

      ref.invalidate(recurringRulesListProvider);
      ref.invalidate(transactionsListProvider);

      state = const AsyncData(null);
      return inserted;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  Future<void> updateRecurringRule(
      RecurringRule original, RecurringRule modified) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await _repo.updateRecurringRule(original: original, modified: modified);

      // Trigger generation for the updated rule
      await ref
          .read(transactionsRepositoryProvider)
          .generateRecurringTransactionsUntil(DateTime.now());

      ref.invalidate(recurringRulesListProvider);
      ref.invalidate(transactionsListProvider);
    });
  }

  Future<void> deleteRecurringRule(RecurringRule rule) async {
    state = AsyncLoading();

    state = await AsyncValue.guard(() async {
      final removedRulesCount = await _repo.deleteRecurringRule(rule: rule);

      if (removedRulesCount > 0) {
        ref.invalidate(recurringRulesListProvider);
        ref.invalidate(transactionsListProvider);
      }
    });
  }
}

final recurringRulesMutationProvider =
    AsyncNotifierProvider<RecurringRulesMutationNotifier, void>(
  RecurringRulesMutationNotifier.new,
);
