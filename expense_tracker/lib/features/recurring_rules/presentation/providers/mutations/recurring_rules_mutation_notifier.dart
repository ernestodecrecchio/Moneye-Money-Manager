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
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecurringRulesMutationNotifier extends AsyncNotifier<void> {
  RecurringRulesRepository get _repo =>
      ref.read(recurringRulesRepositoryProvider);

  @override
  Future<void> build() async {}

  Future<void> _generateDueTransactions() async {
    try {
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

      ref.invalidate(transactionsListProvider);
      ref.invalidate(budgetProgressProvider);
    } catch (error, stackTrace) {
      await FirebaseCrashlytics.instance.recordError(
        error,
        stackTrace,
        reason: 'generateRecurringTransactionsUntil failed',
        fatal: false,
      );
    }
  }

  Future<void> _refreshRulesList() async {
    ref.invalidate(recurringRulesListProvider);
    await ref.read(recurringRulesListProvider.future);
  }

  Future<RecurringRule?> addRecurringRule(RecurringRule rule) async {
    RecurringRule? inserted;
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      inserted = await _repo.insertRecurringRule(rule: rule);
      await _refreshRulesList();
    });

    if (state.hasError) {
      return null;
    }

    await _generateDueTransactions();
    return inserted;
  }

  Future<void> updateRecurringRule(
      RecurringRule original, RecurringRule modified) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await _repo.updateRecurringRule(original: original, modified: modified);
      await _refreshRulesList();
    });

    if (state.hasError) {
      return;
    }

    await _generateDueTransactions();
  }

  Future<void> deleteRecurringRule(RecurringRule rule) async {
    state = AsyncLoading();

    state = await AsyncValue.guard(() async {
      final removedRulesCount = await _repo.deleteRecurringRule(rule: rule);

      if (removedRulesCount > 0) {
        await _refreshRulesList();
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
