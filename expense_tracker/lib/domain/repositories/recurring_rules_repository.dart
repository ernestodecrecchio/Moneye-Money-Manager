import 'package:expense_tracker/domain/models/recurring_rule.dart';

abstract class RecurringRulesRepository {
  Future<List<RecurringRule>> getRecurringRules();
  Future<RecurringRule> insertRecurringRule({required RecurringRule rule});
}
