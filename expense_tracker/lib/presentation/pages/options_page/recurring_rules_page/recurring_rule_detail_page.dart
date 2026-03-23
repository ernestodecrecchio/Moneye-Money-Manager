import 'package:expense_tracker/application/accounts/notifiers/queries/accounts_list_notifier.dart';
import 'package:expense_tracker/application/categories/notifiers/queries/categories_list_notifier.dart';
import 'package:expense_tracker/application/common/notifiers/app_localizations_provider.dart';
import 'package:expense_tracker/application/transactions/notifiers/queries/transactions_list_notifier.dart';
import 'package:expense_tracker/domain/models/recurring_rule.dart';
import 'package:expense_tracker/l10n/app_localizations.dart';
import 'package:expense_tracker/presentation/pages/account_detail_page/transaction_list/transaction_list.dart';
import 'package:expense_tracker/presentation/pages/common/widgets/icon_item.dart';
import 'package:expense_tracker/presentation/pages/new_edit_transaction_flow/new_edit_transaction_page.dart';
import 'package:expense_tracker/style/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';
import 'package:intl/intl.dart';

class RecurringRuleDetailPage extends ConsumerWidget {
  static const routeName = '/recurringRuleDetailPage';

  final RecurringRule rule;

  const RecurringRuleDetailPage({super.key, required this.rule});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocalizations = ref.watch(appLocalizationsProvider);

    final categories = ref.watch(categoriesListProvider).asData?.value ?? [];
    final category =
        categories.firstWhereOrNull((c) => c.id == rule.categoryId);

    final accounts = ref.watch(accountsListProvider).asData?.value ?? [];
    final account = accounts.firstWhereOrNull((a) => a.id == rule.accountId);

    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations.ruleDetails),
        actions: [_buildEditAction(context, appLocalizations)],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildRuleHeader(context, category, account, appLocalizations),
              const Divider(),
              TransactionList(
                title: appLocalizations.generatedTransactions,
                transactionsListParams: TransactionsListParams(
                  recurringId: rule.id,
                ),
                showListModeButton: false,
                topWidgetRef: ref,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEditAction(
      BuildContext context, AppLocalizations appLocalizations) {
    return TextButton(
      child: Text(
        appLocalizations.edit,
        style: TextStyle(
          color: Theme.of(context).appBarTheme.foregroundColor,
        ),
      ),
      onPressed: () async {
        Navigator.of(context).pushNamed(
          NewEditTransactionPage.routeName,
          arguments: NewEditTransactionPageScreenArguments(
            recurringRule: rule,
          ),
        );
      },
    );
  }

  Widget _buildRuleHeader(BuildContext context, dynamic category,
      dynamic account, dynamic appLocalizations) {
    return Padding(
      padding: const EdgeInsets.all(17.0),
      child: Row(
        children: [
          IconItem(
            backgroundColor: category?.color ?? context.appColors.textSecondary,
            shape: BoxShape.circle,
            iconPath: category?.iconPath,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  rule.title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  rule.getFrequencyDescription(appLocalizations),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: context.appColors.textSecondary,
                      ),
                ),
                if (rule.endDate == null ||
                    rule.nextOccurrence.isBefore(rule.endDate!) ||
                    rule.nextOccurrence.isAtSameMomentAs(rule.endDate!)) ...[
                  const SizedBox(height: 4),
                  Text(
                    '${appLocalizations.nextDate}: ${DateFormat('dd/MM/yyyy').format(rule.nextOccurrence)}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: context.appColors.textSecondary,
                        ),
                  ),
                ],
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                rule.amount
                    .toStringAsFixed(2), // Use formatting later if needed
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: rule.amount >= 0
                          ? context.appColors.income
                          : context.appColors.expense,
                    ),
              ),
              Text(
                account?.name ?? '',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: context.appColors.textSecondary,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
