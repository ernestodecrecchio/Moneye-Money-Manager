import 'package:expense_tracker/Helper/double_helper.dart';
import 'package:expense_tracker/application/accounts/notifiers/queries/accounts_list_notifier.dart';
import 'package:expense_tracker/application/categories/notifiers/queries/categories_list_notifier.dart';
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
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: Constants.horizontalPadding),
                child: Column(
                  children: [
                    _buildRuleHeader(
                        context, ref, category, account, appLocalizations),
                    Divider(),
                    _buildLogicSection(context, appLocalizations),
                  ],
                ),
              ),
              TransactionList(
                title: appLocalizations.generatedTransactions,
                transactionsListParams: TransactionsListParams(
                  recurringId: rule.id,
                ),
                showListModeButton: false,
                showAccountLabel: true,
                topWidgetRef: ref,
              ),
              const SizedBox(height: 32),
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
          fontWeight: FontWeight.bold,
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

  Widget _buildRuleHeader(BuildContext context, WidgetRef ref, dynamic category,
      dynamic account, AppLocalizations appLocalizations) {
    final currentCurrency = ref.watch(currentCurrencyProvider);
    final currentCurrencyPosition =
        ref.watch(currentCurrencySymbolPositionProvider);

    return Padding(
      padding: const EdgeInsets.only(
        top: 12,
        bottom: 18,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconItem(
            backgroundColor: category?.color ?? context.appColors.textSecondary,
            shape: BoxShape.circle,
            iconPath: category?.iconPath,
            size: 56,
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  rule.title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.5,
                      ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: (category?.color as Color?)?.withOpacity(0.12) ??
                        context.appColors.textSecondary.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    category?.name ?? appLocalizations.other,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: category?.color ??
                              context.appColors.textSecondary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            spacing: 4,
            children: [
              Text(
                rule.amount.toStringAsFixedRoundedWithCurrency(
                  2,
                  currentCurrency,
                  currentCurrencyPosition,
                ),
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: rule.amount >= 0
                          ? context.appColors.income
                          : context.appColors.expense,
                    ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                spacing: 4,
                children: [
                  Icon(
                    Icons.account_balance_wallet_outlined,
                    size: 14,
                    color: context.appColors.textSecondary,
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
          ),
        ],
      ),
    );
  }

  Widget _buildLogicSection(
      BuildContext context, AppLocalizations appLocalizations) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            appLocalizations.recurrenceLogic,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: context.appColors.textSecondary,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context)
                  .colorScheme
                  .surfaceContainerHighest
                  .withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context).dividerColor.withOpacity(0.05),
              ),
            ),
            child: Column(
              children: [
                _buildLogicItem(
                  context,
                  Icons.repeat_rounded,
                  appLocalizations.frequency,
                  rule.getFrequencyDescription(appLocalizations),
                ),
                if (rule.endDate == null ||
                    rule.nextOccurrence.isBefore(rule.endDate!) ||
                    rule.nextOccurrence.isAtSameMomentAs(rule.endDate!)) ...[
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Divider(height: 1),
                  ),
                  _buildLogicItem(
                    context,
                    Icons.event_outlined,
                    appLocalizations.nextDate,
                    DateFormat('dd MMMM yyyy').format(rule.nextOccurrence),
                  ),
                ],
                if (rule.endDate != null) ...[
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Divider(height: 1),
                  ),
                  _buildLogicItem(
                    context,
                    Icons.event_busy_outlined,
                    appLocalizations.endDate,
                    DateFormat('dd MMMM yyyy').format(rule.endDate!),
                  ),
                ],
              ],
            ),
          ),
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
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
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
