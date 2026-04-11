import 'package:expense_tracker/features/accounts/presentation/providers/queries/accounts_list_notifier.dart';
import 'package:expense_tracker/features/categories/presentation/providers/queries/categories_list_notifier.dart';
import 'package:expense_tracker/core/presentation/providers/app_localizations_provider.dart';
import 'package:expense_tracker/core/presentation/providers/currency_provider.dart';
import 'package:expense_tracker/features/recurring_rules/presentation/providers/queries/recurring_rules_list_notifier.dart';
import 'package:expense_tracker/features/recurring_rules/presentation/providers/mutations/recurring_rules_mutation_notifier.dart';
import 'package:expense_tracker/features/recurring_rules/domain/models/recurring_rule.dart';
import 'package:expense_tracker/core/presentation/common/widgets/icon_item.dart';
import 'package:expense_tracker/features/transactions/presentation/pages/new_edit_transaction_flow/new_edit_transaction_page.dart';
import 'package:expense_tracker/features/recurring_rules/presentation/pages/recurring_rules_page/recurring_rule_detail_page.dart';
import 'package:expense_tracker/core/style/app_theme.dart';
import 'package:expense_tracker/core/style/style.dart';
import 'package:expense_tracker/core/utils/double_helper.dart';
import 'package:expense_tracker/core/presentation/common/extensions/category_extensions.dart';
import 'package:expense_tracker/features/recurring_rules/presentation/extensions/recurring_rule_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';

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

            final sortedRules = [...rules]..sort((a, b) {
                if (a.isEnded && !b.isEnded) return 1;
                if (!a.isEnded && b.isEnded) return -1;
                return a.nextOccurrence.compareTo(b.nextOccurrence);
              });

            return ListView.separated(
              itemCount: sortedRules.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final rule = sortedRules[index];
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

    final categories = ref.watch(categoriesListProvider).asData?.value ?? [];
    final category = categories.firstWhereOrNull(
      (element) => element.id == rule.categoryId,
    );

    final accounts = ref.watch(accountsListProvider).asData?.value ?? [];
    final account = accounts.firstWhereOrNull(
      (element) => element.id == rule.accountId,
    );

    final dateFormatter = DateFormat.yMd(appLocalizations.localeName);

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
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(
            RecurringRuleDetailPage.routeName,
            arguments: rule,
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 17),
          child: Opacity(
            opacity: rule.isEnded ? 0.5 : 1.0,
            child: Row(
              children: [
                IconItem(
                  backgroundColor:
                      category?.color ?? context.appColors.textSecondary,
                  shape: BoxShape.circle,
                  iconPath: category?.iconPath,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        rule.title,
                        maxLines: 2,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        rule.getFrequencyDescription(appLocalizations),
                        style: TextStyle(
                          fontSize: 12,
                          color: context.appColors.textSecondary,
                        ),
                      ),
                      Text(
                        rule.isEnded
                            ? appLocalizations
                                .endedOn(dateFormatter.format(rule.endDate!))
                            : '${appLocalizations.nextDate}: ${dateFormatter.format(rule.nextOccurrence)}',
                        style: TextStyle(
                          fontSize: 12,
                          color: context.appColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
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
                    if (account != null)
                      Text(
                        account.name,
                        style: TextStyle(
                          fontSize: 12,
                          color: context.appColors.textSecondary,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
