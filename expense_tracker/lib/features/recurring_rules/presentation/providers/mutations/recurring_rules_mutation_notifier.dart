import 'package:expense_tracker/features/budgeting/presentation/providers/queries/budget_progress_notifier.dart';
import 'package:expense_tracker/features/recurring_rules/presentation/providers/queries/recurring_rules_list_notifier.dart';
import 'package:expense_tracker/features/recurring_rules/presentation/providers/recurring_rules_repository_provider.dart';
import 'package:expense_tracker/features/recurring_rules/domain/models/recurring_rule.dart';
import 'package:expense_tracker/features/recurring_rules/domain/repositories/recurring_rules_repository.dart';
import 'package:expense_tracker/features/transactions/presentation/providers/queries/transactions_list_notifier.dart';
import 'package:expense_tracker/features/transactions/presentation/providers/transactions_repository_provider.dart';
import 'package:expense_tracker/main.dart';
import 'package:expense_tracker/core/presentation/common/widgets/custom_snackbar.dart';
import 'package:expense_tracker/core/presentation/providers/app_localizations_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecurringRulesMutationNotifier extends AsyncNotifier<void> {
  RecurringRulesRepository get _repo =>
      ref.read(recurringRulesRepositoryProvider);

  @override
  Future<void> build() async {}

  Future<RecurringRule?> addRecurringRule(RecurringRule rule) async {
    RecurringRule? inserted;
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      inserted = await _repo.insertRecurringRule(rule: rule);

      // Trigger generation for the new rule
      final generatedCount = await ref
          .read(transactionsRepositoryProvider)
          .generateRecurringTransactionsUntil(DateTime.now());

      if (generatedCount > 0) {
        final appLocalizations = ref.read(appLocalizationsProvider);
        final snackbarMessage =
            appLocalizations.generatedTransactionsSnackbar(generatedCount);

        WidgetsBinding.instance.addPostFrameCallback((_) {
          final context = navigatorKey.currentContext;
          if (context != null) {
            CustomSnackBar.show(
              context,
              message: snackbarMessage,
            );
          }
        });
      }

      ref.invalidate(recurringRulesListProvider);
      ref.invalidate(transactionsListProvider);
      ref.invalidate(budgetProgressProvider);
    });

    return inserted;
  }

  Future<void> updateRecurringRule(
      RecurringRule original, RecurringRule modified) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await _repo.updateRecurringRule(original: original, modified: modified);

      // Trigger generation for the updated rule
      final generatedCount = await ref
          .read(transactionsRepositoryProvider)
          .generateRecurringTransactionsUntil(DateTime.now());

      if (generatedCount > 0) {
        final appLocalizations = ref.read(appLocalizationsProvider);
        final snackbarMessage =
            appLocalizations.generatedTransactionsSnackbar(generatedCount);

        WidgetsBinding.instance.addPostFrameCallback((_) {
          final context = navigatorKey.currentContext;
          if (context != null) {
            CustomSnackBar.show(
              context,
              message: snackbarMessage,
            );
          }
        });
      }

      ref.invalidate(recurringRulesListProvider);
      ref.invalidate(transactionsListProvider);
      ref.invalidate(budgetProgressProvider);
    });
  }

  Future<void> deleteRecurringRule(RecurringRule rule) async {
    state = AsyncLoading();

    state = await AsyncValue.guard(() async {
      final removedRulesCount = await _repo.deleteRecurringRule(rule: rule);

      if (removedRulesCount > 0) {
        ref.invalidate(recurringRulesListProvider);
        ref.invalidate(transactionsListProvider);
        ref.invalidate(budgetProgressProvider);
      }
    });
  }
}

final recurringRulesMutationProvider =
    AsyncNotifierProvider<RecurringRulesMutationNotifier, void>(
  RecurringRulesMutationNotifier.new,
);
