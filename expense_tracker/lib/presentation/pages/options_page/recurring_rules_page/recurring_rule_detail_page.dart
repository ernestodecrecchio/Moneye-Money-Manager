import 'package:expense_tracker/Helper/double_helper.dart';
import 'package:expense_tracker/application/accounts/notifiers/queries/accounts_list_notifier.dart';
import 'package:expense_tracker/application/categories/notifiers/queries/categories_list_notifier.dart';
import 'package:expense_tracker/application/recurring_rules/notifiers/queries/recurring_rules_list_notifier.dart';
import 'package:expense_tracker/application/common/notifiers/app_localizations_provider.dart';
import 'package:expense_tracker/application/common/notifiers/currency_provider.dart';
import 'package:expense_tracker/application/transactions/notifiers/queries/transactions_list_notifier.dart';
import 'package:expense_tracker/configuration/constants.dart';
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

    final rules = ref.watch(recurringRulesListProvider).asData?.value ?? [];
    final currentRule =
        rules.firstWhereOrNull((r) => r.id == rule.id) ?? rule;

    final categories = ref.watch(categoriesListProvider).asData?.value ?? [];
    final category =
        categories.firstWhereOrNull((c) => c.id == currentRule.categoryId);

    final accounts = ref.watch(accountsListProvider).asData?.value ?? [];
    final account = accounts.firstWhereOrNull((a) => a.id == currentRule.accountId);

    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations.ruleDetails),
        actions: [_buildEditAction(context, appLocalizations, currentRule)],
      ),
      body: SafeArea(
        minimum: EdgeInsets.only(top: 18),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 16,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: Constants.horizontalPadding),
                child: Column(
                  spacing: 12,
                  children: [
                    _buildRuleHeader(
                        context, ref, category, account, appLocalizations, currentRule),
                    Divider(),
                    _buildLogicSection(context, appLocalizations, currentRule),
                  ],
                ),
              ),
              TransactionList(
                title: appLocalizations.generatedTransactions,
                transactionsListParams: TransactionsListParams(
                  recurringId: currentRule.id,
                ),
                showListModeButton: false,
                showAccountLabel: true,
                topWidgetRef: ref,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEditAction(
      BuildContext context, AppLocalizations appLocalizations, RecurringRule currentRule) {
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
            recurringRule: currentRule,
          ),
        );
      },
    );
  }

  Widget _buildRuleHeader(BuildContext context, WidgetRef ref, dynamic category,
      dynamic account, AppLocalizations appLocalizations, RecurringRule currentRule) {
    final currentCurrency = ref.watch(currentCurrencyProvider);
    final currentCurrencyPosition =
        ref.watch(currentCurrencySymbolPositionProvider);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 12,
      children: [
        IconItem(
          backgroundColor: category?.color ?? context.appColors.textSecondary,
          shape: BoxShape.circle,
          iconPath: category?.iconPath,
          size: 56,
        ),
        Expanded(
          child: Text(
            currentRule.title,
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(fontWeight: FontWeight.bold),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          spacing: 4,
          children: [
            Text(
              currentRule.amount.toStringAsFixedRoundedWithCurrency(
                2,
                currentCurrency,
                currentCurrencyPosition,
              ),
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: currentRule.amount >= 0
                        ? context.appColors.income
                        : context.appColors.expense,
                  ),
            ),
            Text(
              account?.name ?? '',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: context.appColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLogicSection(
      BuildContext context, AppLocalizations appLocalizations, RecurringRule currentRule) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .surfaceContainerHighest
            .withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.05),
        ),
      ),
      child: Column(
        children: [
          _buildLogicItem(
            context,
            Icons.repeat_rounded,
            appLocalizations.frequency,
            currentRule.getFrequencyDescription(appLocalizations),
          ),
          if (currentRule.endDate == null ||
              currentRule.nextOccurrence.isBefore(currentRule.endDate!) ||
              currentRule.nextOccurrence.isAtSameMomentAs(currentRule.endDate!)) ...[
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Divider(height: 1),
            ),
            _buildLogicItem(
              context,
              Icons.event_outlined,
              appLocalizations.nextDate,
              DateFormat.yMMMMd(appLocalizations.localeName)
                  .format(currentRule.nextOccurrence),
            ),
          ],
          if (currentRule.endDate != null) ...[
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Divider(height: 1),
            ),
            _buildLogicItem(
              context,
              Icons.event_busy_outlined,
              appLocalizations.endDate,
              DateFormat.yMMMMd(appLocalizations.localeName)
                  .format(currentRule.endDate!),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLogicItem(
      BuildContext context, IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 20,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: context.appColors.textSecondary,
                  ),
            ),
            Text(
              value,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ],
    );
  }
}
