import 'package:expense_tracker/domain/models/recurring_rule.dart';

abstract class RecurringRulesRepository {
  Future<List<RecurringRule>> getRecurringRules();
  Future<RecurringRule> insertRecurringRule({required RecurringRule rule});
  Future<bool> updateRecurringRule(
      {required RecurringRule original, required RecurringRule modified});
  Future<int> deleteRecurringRule({required RecurringRule rule});
}
