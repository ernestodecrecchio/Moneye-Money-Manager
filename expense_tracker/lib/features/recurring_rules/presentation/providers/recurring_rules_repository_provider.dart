import 'package:expense_tracker/features/recurring_rules/domain/repositories/recurring_rules_repository.dart';
import 'package:expense_tracker/features/recurring_rules/data/repositories/recurring_rules_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final recurringRulesRepositoryProvider = Provider<RecurringRulesRepository>(
  (ref) => RecurringRulesRepositoryImpl(),
);
