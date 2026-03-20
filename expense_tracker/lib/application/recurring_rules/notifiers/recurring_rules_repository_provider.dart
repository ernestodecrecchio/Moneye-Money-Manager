import 'package:expense_tracker/domain/repositories/recurring_rules_repository.dart';
import 'package:expense_tracker/data/repositories/recurring_rules_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final recurringRulesRepositoryProvider = Provider<RecurringRulesRepository>(
  (ref) => RecurringRulesRepositoryImpl(),
);
