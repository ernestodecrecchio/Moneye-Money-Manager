import 'package:expense_tracker/data/database/database_recurring_rule_helper.dart';
import 'package:expense_tracker/domain/models/recurring_rule.dart';
import 'package:expense_tracker/domain/repositories/recurring_rules_repository.dart';

class RecurringRulesRepositoryImpl implements RecurringRulesRepository {
  final dbHelper = DatabaseRecurringRuleHelper.instance;

  @override
  Future<List<RecurringRule>> getRecurringRules() async {
    return dbHelper.getRecurringRules();
  }

  @override
  Future<RecurringRule> insertRecurringRule({required RecurringRule rule}) async {
    return dbHelper.insertRecurringRule(rule: rule);
  }
}
