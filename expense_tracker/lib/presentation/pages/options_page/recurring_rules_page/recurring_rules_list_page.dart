import 'package:expense_tracker/application/common/notifiers/app_localizations_provider.dart';
import 'package:expense_tracker/application/common/notifiers/currency_provider.dart';
import 'package:expense_tracker/application/recurring_rules/notifiers/queries/recurring_rules_list_notifier.dart';
import 'package:expense_tracker/application/recurring_rules/notifiers/mutations/recurring_rules_mutation_notifier.dart';
import 'package:expense_tracker/domain/models/recurring_rule.dart';
import 'package:expense_tracker/presentation/pages/new_edit_transaction_flow/new_edit_transaction_page.dart';
import 'package:expense_tracker/style/app_theme.dart';
import 'package:expense_tracker/style/style.dart';
import 'package:expense_tracker/Helper/double_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

class RecurringRulesListPage extends ConsumerWidget {
  static const routeName = '/recurringRulesListPage';

  const RecurringRulesListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocalizations = ref.watch(appLocalizationsProvider);
    final recurringRulesAsync = ref.watch(recurringRulesListProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations.recurringTransactions),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(
            NewEditTransactionPage.routeName,
            arguments: NewEditTransactionPageScreenArguments(
              isRecurringPreset: true,
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: recurringRulesAsync.when(
          data: (rules) {
            if (rules.isEmpty) {
              return Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    appLocalizations.noTransactions,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              );
            }

            return ListView.separated(
              itemCount: rules.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final rule = rules[index];
                return _buildRuleCell(context, ref, rule);
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => Center(child: Text(error.toString())),
        ),
      ),
    );
  }

  Widget _buildRuleCell(
      BuildContext context, WidgetRef ref, RecurringRule rule) {
    final appLocalizations = ref.watch(appLocalizationsProvider);
    final currentCurrency = ref.watch(currentCurrencyProvider);
    final currentCurrencyPosition =
        ref.watch(currentCurrencySymbolPositionProvider);

    final dateFormatter = DateFormat('dd/MM/yyyy');
    final frequencyText =
        '${appLocalizations.interval} ${rule.frequencyInterval} ${rule.frequency}';

    return Slidable(
      key: ValueKey(rule.id),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (_) {
              ref
                  .read(recurringRulesMutationProvider.notifier)
                  .deleteRecurringRule(rule);
            },
            backgroundColor: CustomColors.swipeActionRed,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: appLocalizations.delete,
          ),
        ],
      ),
      child: ListTile(
        title: Text(
          rule.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
            '$frequencyText\nStart: ${dateFormatter.format(rule.startDate)}\nNext: ${dateFormatter.format(rule.nextOccurrence)}'),
        isThreeLine: true,
        trailing: Text(
          rule.amount.toStringAsFixedRoundedWithCurrency(
              2, currentCurrency, currentCurrencyPosition),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: rule.amount >= 0
                ? context.appColors.income
                : context.appColors.expense,
          ),
        ),
        onTap: () {
          Navigator.of(context).pushNamed(
            NewEditTransactionPage.routeName,
            arguments:
                NewEditTransactionPageScreenArguments(recurringRule: rule),
          );
        },
      ),
    );
  }
}
