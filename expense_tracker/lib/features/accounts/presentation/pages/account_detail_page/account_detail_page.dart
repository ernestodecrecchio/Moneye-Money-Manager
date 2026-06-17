import 'package:intl/intl.dart';
import 'package:collection/collection.dart';
import 'package:expense_tracker/core/presentation/common/account_ui_extension.dart';
import 'package:expense_tracker/core/utils/date_time_helper.dart';
import 'package:expense_tracker/core/presentation/providers/app_localizations_provider.dart';
import 'package:expense_tracker/core/presentation/providers/currency_provider.dart';
import 'package:expense_tracker/core/utils/double_helper.dart';
import 'package:expense_tracker/features/transactions/presentation/providers/queries/total_balance_notifier.dart';
import 'package:expense_tracker/features/transactions/presentation/providers/queries/transactions_list_notifier.dart';
import 'package:expense_tracker/core/configuration/constants.dart';
import 'package:expense_tracker/l10n/app_localizations.dart';
import 'package:expense_tracker/features/accounts/domain/models/account.dart';
import 'package:expense_tracker/features/accounts/presentation/providers/queries/accounts_list_notifier.dart';
import 'package:expense_tracker/features/accounts/presentation/pages/account_detail_page/transaction_list/transaction_list.dart';
import 'package:expense_tracker/core/presentation/common/custom_modal_bottom_sheet.dart';
import 'package:expense_tracker/core/presentation/common/widgets/icon_item.dart';
import 'package:expense_tracker/core/presentation/common/widgets/safe_vector_graphic.dart';
import 'package:expense_tracker/features/transactions/presentation/pages/new_edit_transaction_flow/new_edit_transaction_page.dart';
import 'package:expense_tracker/features/accounts/presentation/pages/accounts_list_page/new_edit_account_page.dart';
import 'package:expense_tracker/features/accounts/presentation/pages/account_detail_page/account_rebalance_sheet.dart';
import 'package:expense_tracker/core/style/app_theme.dart';
import 'package:expense_tracker/core/style/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AccountDetailTransactionTypeMode { income, expense, all }

enum TransactionTimePeriod {
  day,
  week,
  month,
  year,
  custom,
}

class AccountDetailPage extends ConsumerStatefulWidget {
  static const routeName = '/accountDetailPage';

  final Account? account;

  const AccountDetailPage({super.key, this.account});

  @override
  ConsumerState<AccountDetailPage> createState() => _AccountDetailPageState();
}

class _AccountDetailPageState extends ConsumerState<AccountDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  TransactionTimePeriod selectedTransactionTimePeriod =
      TransactionTimePeriod.month;

  DateTime startDate = currentMonthFirstDay(DateTime.now());
  DateTime endDate = currentMonthLastDay(DateTime.now());

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Account? referenceAccount;

    if (widget.account != null) {
      referenceAccount = ref.watch(accountsListProvider).maybeWhen(
            data: (accountsList) => accountsList.firstWhereOrNull(
                (element) => element.id == widget.account!.id),
            orElse: () => null,
          );
    }

    final appLocalizations = ref.watch(appLocalizationsProvider);
    final effectiveAccount = referenceAccount ?? widget.account;
    final showAccountActions =
        effectiveAccount != null && !effectiveAccount.isOtherAccount;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.account != null
            ? referenceAccount?.name ?? widget.account!.name
            : appLocalizations.allTransactions),
        actions: [
          if (showAccountActions)
            _buildAccountActions(context, appLocalizations),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(context),
      body: Column(
        children: [
          if (widget.account != null)
            _AccountBalanceHeader(account: referenceAccount ?? widget.account!),
          _buildTabBar(appLocalizations),
          DateBar(
            selectedTransactionTimePeriod: selectedTransactionTimePeriod,
            startDate: startDate,
            endDate: endDate,
            onTransactionTimePeriodChanged: (newTransactionTimePriod) {
              selectedTransactionTimePeriod = newTransactionTimePriod;

              final currentDate = DateTime.now();

              switch (selectedTransactionTimePeriod) {
                case TransactionTimePeriod.day:
                  startDate = currentDayInitialTime();
                  endDate = currentDayEndTime();
                case TransactionTimePeriod.week:
                  startDate = currentWeekFirstDay(currentDate);
                  endDate = currentWeekLastDay(currentDate);
                case TransactionTimePeriod.month:
                  startDate = currentMonthFirstDay(currentDate);
                  endDate = currentMonthLastDay(currentDate);
                case TransactionTimePeriod.year:
                  startDate = currentYearFirstDay(currentDate);
                  endDate = currentYearLastDay(currentDate);
                case TransactionTimePeriod.custom:
                  throw UnimplementedError();
              }

              setState(() {});
              Navigator.of(context).pop();
            },
            onLeftButtonPressed: () {
              switch (selectedTransactionTimePeriod) {
                case TransactionTimePeriod.day:
                  startDate = previousDay(startDate);
                  endDate = previousDay(endDate);

                  break;
                case TransactionTimePeriod.week:
                  startDate = previousWeekFirstDay(startDate);
                  endDate = previousWeekLastDay(endDate);

                  break;
                case TransactionTimePeriod.month:
                  startDate = previousMonthFirstDay(startDate);
                  endDate = previousMonthLastDay(endDate);

                  break;
                case TransactionTimePeriod.year:
                  startDate = previousYearFirstDay(startDate);
                  endDate = previousYearLastDay(endDate);

                  break;
                case TransactionTimePeriod.custom:
                  break;
              }

              setState(() {});
            },
            onRightButtonPressed: () {
              switch (selectedTransactionTimePeriod) {
                case TransactionTimePeriod.day:
                  startDate = nextDay(startDate);
                  endDate = nextDay(endDate);

                  break;
                case TransactionTimePeriod.week:
                  startDate = nextWeekFirstDay(startDate);
                  endDate = nextWeekLastDay(endDate);

                  break;
                case TransactionTimePeriod.month:
                  startDate = nextMonthFirstDay(startDate);
                  endDate = nextMonthLastDay(endDate);

                  break;
                case TransactionTimePeriod.year:
                  startDate = nextYearFirstDay(startDate);
                  endDate = nextYearLastDay(endDate);

                  break;
                case TransactionTimePeriod.custom:
                  break;
              }

              setState(() {});
            },
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                ScrollableTabView(
                  transactionType: AccountDetailTransactionTypeMode.income,
                  startDate: startDate,
                  endDate: endDate,
                  account: widget.account,
                ),
                ScrollableTabView(
                  transactionType: AccountDetailTransactionTypeMode.expense,
                  startDate: startDate,
                  endDate: endDate,
                  account: widget.account,
                ),
                ScrollableTabView(
                  transactionType: AccountDetailTransactionTypeMode.all,
                  startDate: startDate,
                  endDate: endDate,
                  account: widget.account,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountActions(
    BuildContext context,
    AppLocalizations appLocalizations,
  ) {
    return TextButton(
      onPressed: () async {
        final result = await Navigator.of(context).pushNamed(
          NewEditAccountPage.routeName,
          arguments: widget.account,
        );
        if (result == 'deleted' && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Text(
        appLocalizations.edit,
        style: TextStyle(
          color: Theme.of(context).appBarTheme.foregroundColor,
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => Navigator.pushNamed(
        context,
        NewEditTransactionPage.routeName,
        arguments: NewEditTransactionPageScreenArguments(
          account: widget.account?.id != null ? widget.account : null,
        ),
      ),
      child: const Icon(Icons.add),
    );
  }

  Widget _buildTabBar(AppLocalizations appLocalizations) {
    final colors = context.appColors;

    return Stack(
      fit: StackFit.passthrough,
      alignment: Alignment.bottomCenter,
      children: [
        TabBar(
          controller: _tabController,
          indicatorSize: TabBarIndicatorSize.tab,
          dividerColor: colors.divider.darken(0.05),
          dividerHeight: 2,
          tabs: [
            Tab(
              child: FittedBox(
                fit: BoxFit.contain,
                child: Text(
                  appLocalizations.incomes,
                ),
              ),
            ),
            Tab(
              child: FittedBox(
                fit: BoxFit.contain,
                child: Text(
                  appLocalizations.expenses,
                ),
              ),
            ),
            Tab(
              child: FittedBox(
                fit: BoxFit.contain,
                child: Text(
                  appLocalizations.balance,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class ScrollableTabView extends ConsumerWidget {
  final Account? account;
  final AccountDetailTransactionTypeMode transactionType;

  final DateTime startDate;
  final DateTime endDate;

  const ScrollableTabView({
    super.key,
    required this.transactionType,
    required this.startDate,
    required this.endDate,
    required this.account,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocalizations = ref.watch(appLocalizationsProvider);

    return SingleChildScrollView(
      child: TransactionList(
        title: appLocalizations.transactionList,
        transactionsListParams: TransactionsListParams(
          startDate: startDate,
          endDate: endDate,
          account: account,
          includeIncomes:
              transactionType == AccountDetailTransactionTypeMode.income,
          includeExpenses:
              transactionType == AccountDetailTransactionTypeMode.expense,
        ),
        showAccountLabel: false,
        topWidgetRef: ref,
      ),
    );
  }
}

class _AccountBalanceHeader extends ConsumerWidget {
  const _AccountBalanceHeader({required this.account});

  final Account account;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocalizations = ref.watch(appLocalizationsProvider);
    final currentCurrency = ref.watch(currentCurrencyProvider);
    final currentCurrencyPosition =
        ref.watch(currentCurrencySymbolPositionProvider);
    final colors = context.appColors;
    final textTheme = Theme.of(context).textTheme;
    final balanceParams = TotalBalanceParams(account: account);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        Constants.horizontalPadding,
        16,
        Constants.horizontalPadding,
        12,
      ),
      color: colors.surface,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconItem(
            backgroundColor: account.color,
            shape: BoxShape.rectangle,
            iconPath: account.iconPath,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  appLocalizations.totalBalance,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                ref.watch(totalBalanceProvider(balanceParams)).when(
                      data: (balance) => Text(
                        balance.toStringAsFixedRoundedWithCurrency(
                          2,
                          currentCurrency,
                          currentCurrencyPosition,
                        ),
                        style: textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      loading: () => const SizedBox(
                        height: 28,
                        width: 28,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      error: (_, __) => Text(
                        '—',
                        style: textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colors.textSecondary,
                        ),
                      ),
                    ),
                if (!account.isOtherAccount) ...[
                  const SizedBox(height: 8),
                  TextButton.icon(
                    onPressed: () =>
                        showAccountRebalanceSheet(context, account),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.compact,
                      alignment: Alignment.centerLeft,
                    ),
                    icon: Icon(
                      Icons.sync_alt_rounded,
                      size: 16,
                      color: colors.primary,
                    ),
                    label: Text(
                      appLocalizations.correctBalance,
                      style: textTheme.labelLarge?.copyWith(
                        color: colors.primary,
                      ),
                    ),
                  ),
                ],
                if (account.description?.isNotEmpty == true) ...[
                  const SizedBox(height: 6),
                  Text(
                    account.description!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.bodySmall?.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DateBar extends ConsumerWidget {
  final TransactionTimePeriod selectedTransactionTimePeriod;
  final DateTime startDate;
  final DateTime endDate;

  final Function(TransactionTimePeriod newTransactionTimePriod)
      onTransactionTimePeriodChanged;
  final Function() onLeftButtonPressed;
  final Function() onRightButtonPressed;

  const DateBar({
    super.key,
    required this.selectedTransactionTimePeriod,
    required this.startDate,
    required this.endDate,
    required this.onTransactionTimePeriodChanged,
    required this.onLeftButtonPressed,
    required this.onRightButtonPressed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocalizations = ref.watch(appLocalizationsProvider);

    final colors = context.appColors;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      width: double.infinity,
      color: colors.surface,
      child: Row(
        children: [
          SizedBox(
            width: (MediaQuery.of(context).size.width - 28) / 3,
            child: FilledButton(
              onPressed: () {
                showCustomModalBottomSheet(
                  context: context,
                  builder: ((context) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 17),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Text(
                                    appLocalizations.selectTimeInterval,
                                    style: textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  icon: const Icon(Icons.close),
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            child: ListView(
                              padding: modalSheetScrollPadding(context),
                              shrinkWrap: true,
                              children: [
                                ListTile(
                                  title: Text(appLocalizations.day),
                                  trailing: selectedTransactionTimePeriod ==
                                          TransactionTimePeriod.day
                                      ? SafeVectorGraphic(
                                          iconPath:
                                              'assets/icons/checkmark.svg',
                                          color: colors.primary,
                                        )
                                      : null,
                                  onTap: () => onTransactionTimePeriodChanged(
                                    TransactionTimePeriod.day,
                                  ),
                                ),
                                ListTile(
                                  title: Text(appLocalizations.week),
                                  trailing: selectedTransactionTimePeriod ==
                                          TransactionTimePeriod.week
                                      ? SafeVectorGraphic(
                                          iconPath:
                                              'assets/icons/checkmark.svg',
                                          color: colors.primary,
                                        )
                                      : null,
                                  onTap: () => onTransactionTimePeriodChanged(
                                    TransactionTimePeriod.week,
                                  ),
                                ),
                                ListTile(
                                  title: Text(appLocalizations.month),
                                  trailing: selectedTransactionTimePeriod ==
                                          TransactionTimePeriod.month
                                      ? SafeVectorGraphic(
                                          iconPath:
                                              'assets/icons/checkmark.svg',
                                          color: colors.primary,
                                        )
                                      : null,
                                  onTap: () => onTransactionTimePeriodChanged(
                                    TransactionTimePeriod.month,
                                  ),
                                ),
                                ListTile(
                                  title: Text(appLocalizations.year),
                                  trailing: selectedTransactionTimePeriod ==
                                          TransactionTimePeriod.year
                                      ? SafeVectorGraphic(
                                          iconPath:
                                              'assets/icons/checkmark.svg',
                                          color: colors.primary,
                                        )
                                      : null,
                                  onTap: () => onTransactionTimePeriodChanged(
                                    TransactionTimePeriod.year,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                );
              },
              style: FilledButton.styleFrom(
                backgroundColor: colors.primary,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        selectedTransactionTimePeriod ==
                                TransactionTimePeriod.day
                            ? appLocalizations.day
                            : selectedTransactionTimePeriod ==
                                    TransactionTimePeriod.week
                                ? appLocalizations.week
                                : selectedTransactionTimePeriod ==
                                        TransactionTimePeriod.month
                                    ? appLocalizations.month
                                    : selectedTransactionTimePeriod ==
                                            TransactionTimePeriod.year
                                        ? appLocalizations.year
                                        : 'Custom',
                        style: textTheme.bodyMedium?.copyWith(
                          color: colors.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const Icon(Icons.arrow_drop_down_rounded)
                ],
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  switch (selectedTransactionTimePeriod) {
                    TransactionTimePeriod.day => 
                      DateFormat.yMMMMd(appLocalizations.localeName).format(startDate),
                    TransactionTimePeriod.week =>
                      '${DateFormat.yMMMd(appLocalizations.localeName).format(startDate)} - ${DateFormat.yMMMd(appLocalizations.localeName).format(endDate)}',
                    TransactionTimePeriod.month => 
                      DateFormat.yMMMM(appLocalizations.localeName).format(startDate),
                    TransactionTimePeriod.year => 
                      DateFormat.y(appLocalizations.localeName).format(startDate),
                    TransactionTimePeriod.custom =>
                      '${startDate.day} ${startDate.month} - ${endDate.day} ${endDate.month}',
                  },
                  textAlign: TextAlign.end,
                  style: textTheme.bodySmall?.copyWith(
                    fontSize: 14,
                    color: colors.textSecondary,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          FilledButton(
            onPressed: onLeftButtonPressed,
            style: FilledButton.styleFrom(
              minimumSize: const Size(35, 35),
              elevation: 0,
              backgroundColor: colors.primary,
              padding: EdgeInsets.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Icon(Icons.chevron_left_rounded),
          ),
          const SizedBox(
            width: 8,
          ),
          FilledButton(
            onPressed: onRightButtonPressed,
            style: FilledButton.styleFrom(
              minimumSize: const Size(35, 35),
              elevation: 0,
              backgroundColor: colors.primary,
              padding: EdgeInsets.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Icon(Icons.chevron_right_rounded),
          ),
        ],
      ),
    );
  }
}
